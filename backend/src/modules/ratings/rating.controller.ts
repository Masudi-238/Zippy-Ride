import { Request, Response } from 'express';
import { RatingService } from './rating.service';
import { ApiResponse } from '../../shared/utils/api-response';

const ratingService = new RatingService();

export class RatingController {
  static async submit(req: Request, res: Response): Promise<void> {
    const { rideId, rating, comment } = req.body;
    const result = await ratingService.submitRating(req.user!.userId, rideId, rating, comment);
    ApiResponse.created(res, result);
  }

  static async getRideRatings(req: Request, res: Response): Promise<void> {
    const ratings = await ratingService.getRideRatings(req.params.rideId);
    ApiResponse.success(res, ratings);
  }
}
