import { Router } from 'express';
import { AdminController } from './admin.controller';
import { authenticate, authorize } from '../../shared/middleware/auth.middleware';

const router = Router();

router.use(authenticate);

// Super Admin routes
router.get('/users', authorize('super_admin', 'manager'), AdminController.getUsers);
router.post('/users/:userId/suspend', authorize('super_admin'), AdminController.suspendUser);
router.post('/users/:userId/activate', authorize('super_admin'), AdminController.activateUser);
router.post('/users/:userId/verify', authorize('super_admin', 'manager'), AdminController.verifyUser);
router.get('/analytics', authorize('super_admin'), AdminController.getAnalytics);

// Manager routes
router.get('/fleet', authorize('manager', 'super_admin'), AdminController.getFleetOverview);
router.get('/reports', authorize('manager', 'super_admin'), AdminController.getReports);

// Surge pricing
router.get('/surge-pricing', authorize('super_admin'), AdminController.getSurgePricingRules);
router.post('/surge-pricing', authorize('super_admin'), AdminController.createSurgePricingRule);
router.patch('/surge-pricing/:ruleId', authorize('super_admin'), AdminController.updateSurgePricingRule);

export { router as adminRoutes };
