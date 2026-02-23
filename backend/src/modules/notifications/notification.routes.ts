import { Router } from 'express';
import { NotificationController } from './notification.controller';
import { authenticate } from '../../shared/middleware/auth.middleware';

const router = Router();

router.use(authenticate);

router.get('/', NotificationController.list);
router.post('/read-all', NotificationController.markAllAsRead);
router.post('/:id/read', NotificationController.markAsRead);

export { router as notificationRoutes };
