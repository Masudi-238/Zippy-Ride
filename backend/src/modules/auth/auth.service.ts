import jwt from 'jsonwebtoken';
import bcrypt from 'bcryptjs';
import crypto from 'crypto';
import { config } from '../../config/environment';
import { AppError } from '../../shared/utils/app-error';
import { AuthRepository } from './auth.repository';
import { RegisterInput, LoginInput } from './auth.validation';
import { JwtPayload } from '../../shared/middleware/auth.middleware';

interface AuthTokens {
  accessToken: string;
  refreshToken: string;
  expiresIn: string;
}

interface AuthResponse {
  user: {
    id: string;
    email: string;
    firstName: string;
    lastName: string;
    phone: string;
    role: string;
    isVerified: boolean;
  };
  tokens: AuthTokens;
}

export class AuthService {
  private authRepository: AuthRepository;

  constructor() {
    this.authRepository = new AuthRepository();
  }

  async register(input: RegisterInput): Promise<AuthResponse> {
    // Check if user already exists
    const existingUser = await this.authRepository.findUserByEmail(input.email);
    if (existingUser) {
      throw AppError.conflict('A user with this email already exists');
    }

    const user = await this.authRepository.createUser(input);
    const tokens = await this.generateTokens(user.id, user.email, user.role_name);

    return {
      user: {
        id: user.id,
        email: user.email,
        firstName: user.first_name,
        lastName: user.last_name,
        phone: user.phone,
        role: user.role_name,
        isVerified: user.is_verified,
      },
      tokens,
    };
  }

  async login(input: LoginInput): Promise<AuthResponse> {
    const user = await this.authRepository.findUserByEmail(input.email);
    if (!user) {
      throw AppError.unauthorized('Invalid email or password');
    }

    if (!user.is_active) {
      throw AppError.forbidden('Account has been suspended');
    }

    const isPasswordValid = await bcrypt.compare(input.password, user.password_hash);
    if (!isPasswordValid) {
      throw AppError.unauthorized('Invalid email or password');
    }

    await this.authRepository.updateLastLogin(user.id);
    const tokens = await this.generateTokens(user.id, user.email, user.role_name);

    return {
      user: {
        id: user.id,
        email: user.email,
        firstName: user.first_name,
        lastName: user.last_name,
        phone: user.phone,
        role: user.role_name,
        isVerified: user.is_verified,
      },
      tokens,
    };
  }

  async refreshToken(refreshTokenValue: string): Promise<AuthTokens> {
    const tokenHash = crypto.createHash('sha256').update(refreshTokenValue).digest('hex');
    const storedToken = await this.authRepository.findRefreshToken(tokenHash);

    if (!storedToken) {
      throw AppError.unauthorized('Invalid refresh token');
    }

    if (storedToken.revoked_at) {
      // Token reuse detected - revoke all tokens for security
      await this.authRepository.revokeAllUserTokens(storedToken.user_id);
      throw AppError.unauthorized('Token has been revoked. Please login again');
    }

    if (new Date(storedToken.expires_at) < new Date()) {
      throw AppError.unauthorized('Refresh token has expired');
    }

    // Revoke old token
    await this.authRepository.revokeRefreshToken(tokenHash);

    // Get user info
    const user = await this.authRepository.findUserById(storedToken.user_id);
    if (!user || !user.is_active) {
      throw AppError.unauthorized('User not found or suspended');
    }

    return this.generateTokens(user.id, user.email, user.role_name);
  }

  async logout(userId: string): Promise<void> {
    await this.authRepository.revokeAllUserTokens(userId);
  }

  private async generateTokens(userId: string, email: string, role: string): Promise<AuthTokens> {
    const payload: JwtPayload = { userId, email, role };

    const accessToken = jwt.sign(payload, config.jwtAccessSecret, {
      expiresIn: config.jwtAccessExpiresIn as string,
    });

    const refreshToken = crypto.randomBytes(64).toString('hex');
    const refreshTokenHash = crypto.createHash('sha256').update(refreshToken).digest('hex');

    // Calculate expiry
    const refreshExpiresMs = this.parseExpiry(config.jwtRefreshExpiresIn);
    const expiresAt = new Date(Date.now() + refreshExpiresMs);

    await this.authRepository.saveRefreshToken(userId, refreshTokenHash, expiresAt);

    return {
      accessToken,
      refreshToken,
      expiresIn: config.jwtAccessExpiresIn,
    };
  }

  private parseExpiry(expiry: string): number {
    const match = expiry.match(/^(\d+)([smhd])$/);
    if (!match) return 7 * 24 * 60 * 60 * 1000; // default 7 days

    const value = parseInt(match[1], 10);
    const unit = match[2];

    switch (unit) {
      case 's': return value * 1000;
      case 'm': return value * 60 * 1000;
      case 'h': return value * 60 * 60 * 1000;
      case 'd': return value * 24 * 60 * 60 * 1000;
      default: return 7 * 24 * 60 * 60 * 1000;
    }
  }
}
