import { Request, Response } from 'express';
import { AuthService } from './auth.service';
import { ApiResponse } from '../../shared/utils/api-response';

const authService = new AuthService();

export class AuthController {
  static async register(req: Request, res: Response): Promise<void> {
    const result = await authService.register(req.body);
    ApiResponse.created(res, result);
  }

  static async login(req: Request, res: Response): Promise<void> {
    const result = await authService.login(req.body);
    ApiResponse.success(res, result);
  }

  static async refreshToken(req: Request, res: Response): Promise<void> {
    const { refreshToken } = req.body;
    const tokens = await authService.refreshToken(refreshToken);
    ApiResponse.success(res, tokens);
  }

  static async logout(req: Request, res: Response): Promise<void> {
    await authService.logout(req.user!.userId);
    ApiResponse.success(res, { message: 'Logged out successfully' });
  }

  static async me(req: Request, res: Response): Promise<void> {
    ApiResponse.success(res, { user: req.user });
  }
}
