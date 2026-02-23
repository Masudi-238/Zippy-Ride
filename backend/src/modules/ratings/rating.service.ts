import { DatabasePool } from '../../database/pool';
import { AppError } from '../../shared/utils/app-error';

interface RatingRow {
  id: string;
  ride_id: string;
  rater_id: string;
  rated_id: string;
  rating: number;
  comment: string | null;
  created_at: Date;
}

export class RatingService {
  async submitRating(raterId: string, rideId: string, rating: number, comment?: string): Promise<RatingRow> {
    // Get ride to determine who to rate
    const rideResult = await DatabasePool.query<{ rider_id: string; driver_id: string; status: string }>(
      'SELECT rider_id, driver_id, status FROM rides WHERE id = $1',
      [rideId],
    );

    if (!rideResult.rows[0]) throw AppError.notFound('Ride not found');
    const ride = rideResult.rows[0];

    if (ride.status !== 'completed') {
      throw AppError.badRequest('Can only rate completed rides');
    }

    // Determine who is being rated
    let ratedId: string;
    if (raterId === ride.rider_id) {
      ratedId = ride.driver_id;
    } else if (raterId === ride.driver_id) {
      ratedId = ride.rider_id;
    } else {
      throw AppError.forbidden('You are not part of this ride');
    }

    // Check for existing rating
    const existing = await DatabasePool.query(
      'SELECT id FROM ratings WHERE ride_id = $1 AND rater_id = $2',
      [rideId, raterId],
    );
    if (existing.rows.length > 0) {
      throw AppError.conflict('You have already rated this ride');
    }

    const result = await DatabasePool.query<RatingRow>(
      `INSERT INTO ratings (ride_id, rater_id, rated_id, rating, comment)
       VALUES ($1, $2, $3, $4, $5) RETURNING *`,
      [rideId, raterId, ratedId, rating, comment],
    );

    // Update driver average rating if rated person is a driver
    await DatabasePool.query(
      `UPDATE driver_profiles SET average_rating = (
        SELECT AVG(rating) FROM ratings WHERE rated_id = $1
       ) WHERE user_id = $1`,
      [ratedId],
    );

    return result.rows[0];
  }

  async getRideRatings(rideId: string): Promise<RatingRow[]> {
    const result = await DatabasePool.query<RatingRow>(
      'SELECT * FROM ratings WHERE ride_id = $1',
      [rideId],
    );
    return result.rows;
  }
}
