import { Request, Response } from 'express';
import { WalletService } from './wallet.service';
import { ApiResponse, buildPaginationMeta } from '../../shared/utils/api-response';

const walletService = new WalletService();

export class WalletController {
  static async getWallet(req: Request, res: Response): Promise<void> {
    const wallet = await walletService.getWallet(req.user!.userId);
    const { transactions, total } = await walletService.getTransactions(req.user!.userId, 1, 10);
    ApiResponse.success(res, { wallet, recentTransactions: transactions, totalTransactions: total });
  }

  static async getTransactions(req: Request, res: Response): Promise<void> {
    const { page = 1, limit = 20 } = req.query as { page?: number; limit?: number };
    const { transactions, total } = await walletService.getTransactions(
      req.user!.userId, Number(page), Number(limit),
    );
    ApiResponse.paginated(res, transactions, buildPaginationMeta(Number(page), Number(limit), total));
  }

  static async topUp(req: Request, res: Response): Promise<void> {
    const { amount } = req.body;
    const transaction = await walletService.topUp(req.user!.userId, Number(amount));
    ApiResponse.success(res, transaction);
  }
}
