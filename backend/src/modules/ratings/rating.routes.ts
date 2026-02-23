import { Router } from 'express';
import { RatingController } from './rating.controller';
import { authenticate } from '../../shared/middleware/auth.middleware';
import { validate } from '../../shared/middleware/validate.middleware';
import { z } from 'zod';

const submitRatingSchema = z.object({
  rideId: z.string().uuid(),
  rating: z.number().int().min(1).max(5),
  comment: z.string().max(500).optional(),
});

const router = Router();

router.use(authenticate);

router.post('/', validate(submitRatingSchema), RatingController.submit);
router.get('/ride/:rideId', RatingController.getRideRatings);

export { router as ratingRoutes };
