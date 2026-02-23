import { Router, Response } from 'express';
import { authenticate, AuthRequest } from '../middleware/auth';

const router = Router();

/** GET /api/wallet */
router.get('/', authenticate, (req: AuthRequest, res: Response) => {
  res.json({
    wallet: { id: `wal_${req.user!.id}`, user_id: req.user!.id, balance: 1240.50, currency: 'USD', is_active: true },
    transactions: [
      { id: 'txn_1', type: 'debit', amount: 12.40, description: 'Ride Payment #ZR-882', reference_id: 'ride_882', created_at: '2024-03-24T14:45:00Z' },
      { id: 'txn_2', type: 'credit', amount: 500.00, description: 'Top Up from Bank', created_at: '2024-03-23T10:15:00Z' },
      { id: 'txn_3', type: 'reward', amount: 25.00, description: 'Weekly Bonus Reward', created_at: '2024-03-22T18:00:00Z' },
      { id: 'txn_4', type: 'debit', amount: 18.25, description: 'Ride Payment #ZR-712', reference_id: 'ride_712', created_at: '2024-03-21T11:30:00Z' },
    ],
  });
});

/** POST /api/wallet/top-up */
router.post('/top-up', authenticate, (req: AuthRequest, res: Response) => {
  const { amount } = req.body;
  res.json({ message: 'Top-up successful.', new_balance: 1240.50 + (amount || 0), transaction_id: `txn_${Date.now()}` });
});

/** POST /api/wallet/transfer */
router.post('/transfer', authenticate, (req: AuthRequest, res: Response) => {
  res.json({ message: 'Transfer successful.', transaction_id: `txn_${Date.now()}` });
});

/** POST /api/wallet/withdraw */
router.post('/withdraw', authenticate, (req: AuthRequest, res: Response) => {
  res.json({ message: 'Withdrawal initiated. Processing in 1-3 business days.', transaction_id: `txn_${Date.now()}` });
});

/** GET /api/wallet/transactions */
router.get('/transactions', authenticate, (req: AuthRequest, res: Response) => {
  res.json({ transactions: [], page: 1, total: 0 });
});

export default router;
