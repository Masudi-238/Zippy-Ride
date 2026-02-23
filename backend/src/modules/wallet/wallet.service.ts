import { DatabasePool } from '../../database/pool';
import { AppError } from '../../shared/utils/app-error';

interface WalletRow {
  id: string;
  user_id: string;
  balance: number;
  currency: string;
  is_active: boolean;
}

interface TransactionRow {
  id: string;
  wallet_id: string;
  ride_id: string | null;
  type: string;
  amount: number;
  balance_before: number;
  balance_after: number;
  description: string | null;
  status: string;
  created_at: Date;
}

export class WalletService {
  async getWallet(userId: string): Promise<WalletRow> {
    const result = await DatabasePool.query<WalletRow>(
      'SELECT * FROM wallets WHERE user_id = $1 AND is_active = TRUE',
      [userId],
    );
    if (!result.rows[0]) {
      throw AppError.notFound('Wallet not found');
    }
    return result.rows[0];
  }

  async getTransactions(userId: string, page = 1, limit = 20): Promise<{ transactions: TransactionRow[]; total: number }> {
    const wallet = await this.getWallet(userId);

    const countResult = await DatabasePool.query<{ count: string }>(
      'SELECT COUNT(*) FROM transactions WHERE wallet_id = $1',
      [wallet.id],
    );

    const result = await DatabasePool.query<TransactionRow>(
      `SELECT * FROM transactions WHERE wallet_id = $1
       ORDER BY created_at DESC LIMIT $2 OFFSET $3`,
      [wallet.id, limit, (page - 1) * limit],
    );

    return {
      transactions: result.rows,
      total: parseInt(countResult.rows[0].count, 10),
    };
  }

  async topUp(userId: string, amount: number): Promise<TransactionRow> {
    if (amount <= 0) {
      throw AppError.badRequest('Amount must be positive');
    }

    return DatabasePool.transaction(async (client) => {
      // Lock wallet row
      const walletResult = await client.query<WalletRow>(
        'SELECT * FROM wallets WHERE user_id = $1 FOR UPDATE',
        [userId],
      );

      if (!walletResult.rows[0]) {
        throw AppError.notFound('Wallet not found');
      }

      const wallet = walletResult.rows[0];
      const balanceBefore = Number(wallet.balance);
      const balanceAfter = balanceBefore + amount;

      // Update balance
      await client.query(
        'UPDATE wallets SET balance = $1 WHERE id = $2',
        [balanceAfter, wallet.id],
      );

      // Create transaction record
      const txResult = await client.query<TransactionRow>(
        `INSERT INTO transactions (wallet_id, type, amount, balance_before, balance_after, description, status)
         VALUES ($1, 'topup', $2, $3, $4, 'Wallet top-up', 'completed')
         RETURNING *`,
        [wallet.id, amount, balanceBefore, balanceAfter],
      );

      return txResult.rows[0];
    });
  }

  async processRidePayment(riderId: string, driverId: string, rideId: string, amount: number): Promise<void> {
    await DatabasePool.transaction(async (client) => {
      // Debit rider wallet
      const riderWalletResult = await client.query<WalletRow>(
        'SELECT * FROM wallets WHERE user_id = $1 FOR UPDATE',
        [riderId],
      );

      if (!riderWalletResult.rows[0]) {
        throw AppError.notFound('Rider wallet not found');
      }

      const riderWallet = riderWalletResult.rows[0];
      const riderBalanceBefore = Number(riderWallet.balance);

      if (riderBalanceBefore < amount) {
        throw AppError.badRequest('Insufficient wallet balance');
      }

      const riderBalanceAfter = riderBalanceBefore - amount;

      await client.query(
        'UPDATE wallets SET balance = $1 WHERE id = $2',
        [riderBalanceAfter, riderWallet.id],
      );

      await client.query(
        `INSERT INTO transactions (wallet_id, ride_id, type, amount, balance_before, balance_after, description, status)
         VALUES ($1, $2, 'ride_payment', $3, $4, $5, 'Ride payment', 'completed')`,
        [riderWallet.id, rideId, -amount, riderBalanceBefore, riderBalanceAfter],
      );

      // Credit driver wallet (minus commission - handled by CommissionService)
      const driverWalletResult = await client.query<WalletRow>(
        'SELECT * FROM wallets WHERE user_id = $1 FOR UPDATE',
        [driverId],
      );

      if (driverWalletResult.rows[0]) {
        const driverWallet = driverWalletResult.rows[0];
        const driverBalanceBefore = Number(driverWallet.balance);
        const driverPayout = amount * 0.80; // 80% to driver (20% commission)
        const driverBalanceAfter = driverBalanceBefore + driverPayout;

        await client.query(
          'UPDATE wallets SET balance = $1 WHERE id = $2',
          [driverBalanceAfter, driverWallet.id],
        );

        await client.query(
          `INSERT INTO transactions (wallet_id, ride_id, type, amount, balance_before, balance_after, description, status)
           VALUES ($1, $2, 'ride_earning', $3, $4, $5, 'Ride earning', 'completed')`,
          [driverWallet.id, rideId, driverPayout, driverBalanceBefore, driverBalanceAfter],
        );
      }

      // Create payment record
      await client.query(
        `INSERT INTO payments (ride_id, payer_id, amount, method, status, processed_at)
         VALUES ($1, $2, $3, 'wallet', 'completed', NOW())`,
        [rideId, riderId, amount],
      );
    });
  }
}
