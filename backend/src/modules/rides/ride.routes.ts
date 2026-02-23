import { Router } from 'express';
import { RideController } from './ride.controller';
import { authenticate, authorize } from '../../shared/middleware/auth.middleware';
import { validate } from '../../shared/middleware/validate.middleware';
import { createRideSchema, updateRideStatusSchema } from './ride.validation';

const router = Router();

// All ride routes require authentication
router.use(authenticate);

router.post('/', authorize('rider'), validate(createRideSchema), RideController.create);
router.get('/', RideController.list);
router.get('/pending', authorize('driver'), RideController.pending);
router.get('/:id', RideController.getById);
router.post('/:id/accept', authorize('driver'), RideController.accept);
router.post('/:id/status', validate(updateRideStatusSchema), RideController.updateStatus);
router.post('/:id/cancel', RideController.cancel);
router.post('/:id/complete', authorize('driver'), RideController.complete);

export { router as rideRoutes };
