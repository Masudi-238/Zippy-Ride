import { DatabasePool } from '../../database/pool';
import { v4 as uuidv4 } from 'uuid';
import bcrypt from 'bcryptjs';

export interface UserRow {
  id: string;
  email: string;
  phone: string;
  password_hash: string;
  first_name: string;
  last_name: string;
  avatar_url: string | null;
  role_id: string;
  role_name: string;
  is_verified: boolean;
  is_active: boolean;
  created_at: Date;
}

export class AuthRepository {
  async findUserByEmail(email: string): Promise<UserRow | null> {
    const result = await DatabasePool.query<UserRow>(
      `SELECT u.*, r.name as role_name
       FROM users u
       JOIN roles r ON u.role_id = r.id
       WHERE u.email = $1 AND u.deleted_at IS NULL`,
      [email],
    );
    return result.rows[0] ?? null;
  }

  async findUserById(id: string): Promise<UserRow | null> {
    const result = await DatabasePool.query<UserRow>(
      `SELECT u.*, r.name as role_name
       FROM users u
       JOIN roles r ON u.role_id = r.id
       WHERE u.id = $1 AND u.deleted_at IS NULL`,
      [id],
    );
    return result.rows[0] ?? null;
  }

  async createUser(data: {
    email: string;
    password: string;
    firstName: string;
    lastName: string;
    phone: string;
    role: string;
  }): Promise<UserRow> {
    const passwordHash = await bcrypt.hash(data.password, 12);

    // Get role ID
    const roleResult = await DatabasePool.query<{ id: string }>(
      'SELECT id FROM roles WHERE name = $1',
      [data.role],
    );

    if (roleResult.rows.length === 0) {
      throw new Error(`Role '${data.role}' not found`);
    }

    const result = await DatabasePool.query<UserRow>(
      `INSERT INTO users (email, phone, password_hash, first_name, last_name, role_id)
       VALUES ($1, $2, $3, $4, $5, $6)
       RETURNING *`,
      [data.email, data.phone, passwordHash, data.firstName, data.lastName, roleResult.rows[0].id],
    );

    // Create wallet for new user
    await DatabasePool.query(
      'INSERT INTO wallets (user_id, balance, currency) VALUES ($1, 0.00, $2)',
      [result.rows[0].id, 'USD'],
    );

    // If driver, create driver profile
    if (data.role === 'driver') {
      await DatabasePool.query(
        'INSERT INTO driver_profiles (user_id) VALUES ($1)',
        [result.rows[0].id],
      );
    }

    // Fetch with role name
    return (await this.findUserById(result.rows[0].id))!;
  }

  async saveRefreshToken(userId: string, tokenHash: string, expiresAt: Date): Promise<void> {
    await DatabasePool.query(
      `INSERT INTO refresh_tokens (user_id, token_hash, expires_at)
       VALUES ($1, $2, $3)`,
      [userId, tokenHash, expiresAt],
    );
  }

  async findRefreshToken(tokenHash: string): Promise<{ id: string; user_id: string; expires_at: Date; revoked_at: Date | null } | null> {
    const result = await DatabasePool.query<{ id: string; user_id: string; expires_at: Date; revoked_at: Date | null }>(
      `SELECT id, user_id, expires_at, revoked_at
       FROM refresh_tokens
       WHERE token_hash = $1`,
      [tokenHash],
    );
    return result.rows[0] ?? null;
  }

  async revokeRefreshToken(tokenHash: string): Promise<void> {
    await DatabasePool.query(
      'UPDATE refresh_tokens SET revoked_at = NOW() WHERE token_hash = $1',
      [tokenHash],
    );
  }

  async revokeAllUserTokens(userId: string): Promise<void> {
    await DatabasePool.query(
      'UPDATE refresh_tokens SET revoked_at = NOW() WHERE user_id = $1 AND revoked_at IS NULL',
      [userId],
    );
  }

  async updateLastLogin(userId: string): Promise<void> {
    await DatabasePool.query(
      'UPDATE users SET last_login_at = NOW() WHERE id = $1',
      [userId],
    );
  }
}
