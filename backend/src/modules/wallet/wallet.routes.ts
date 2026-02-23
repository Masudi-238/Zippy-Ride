import { Router } from 'express';
import { WalletController } from './wallet.controller';
import { authenticate } from '../../shared/middleware/auth.middleware';
import { validate } from '../../shared/middleware/validate.middleware';
import { z } from 'zod';

const topUpSchema = z.object({
  amount: z.number().positive('Amount must be positive').max(10000, 'Maximum top-up is $10,000'),
});

const router = Router();

router.use(authenticate);

router.get('/', WalletController.getWallet);
router.get('/transactions', WalletController.getTransactions);
router.post('/topup', validate(topUpSchema), WalletController.topUp);

export { router as walletRoutes };
