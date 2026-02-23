import { Router } from 'express';
import { DriverController } from './driver.controller';
import { authenticate, authorize } from '../../shared/middleware/auth.middleware';
import { validate } from '../../shared/middleware/validate.middleware';
import { z } from 'zod';

const availabilitySchema = z.object({
  isAvailable: z.boolean(),
  lat: z.number().min(-90).max(90).optional(),
  lng: z.number().min(-180).max(180).optional(),
});

const uploadDocumentSchema = z.object({
  documentType: z.enum(['license', 'insurance', 'registration', 'background_check', 'identity']),
  documentUrl: z.string().url(),
});

const reviewDocumentSchema = z.object({
  status: z.enum(['approved', 'rejected']),
  rejectionReason: z.string().optional(),
});

const router = Router();

router.use(authenticate);

router.get('/profile', authorize('driver'), DriverController.getProfile);
router.patch('/availability', authorize('driver'), validate(availabilitySchema), DriverController.updateAvailability);
router.get('/earnings', authorize('driver'), DriverController.getEarnings);
router.get('/documents', authorize('driver'), DriverController.getDocuments);
router.post('/documents', authorize('driver'), validate(uploadDocumentSchema), DriverController.uploadDocument);
router.patch('/documents/:documentId/review', authorize('manager', 'super_admin'), validate(reviewDocumentSchema), DriverController.reviewDocument);

export { router as driverRoutes };
