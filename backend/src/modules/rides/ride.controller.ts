import { Request, Response } from 'express';
import { RideService } from './ride.service';
import { ApiResponse, buildPaginationMeta } from '../../shared/utils/api-response';
import { RideStatus } from './ride-state-machine';

const rideService = new RideService();

export class RideController {
  static async create(req: Request, res: Response): Promise<void> {
    const ride = await rideService.createRide(req.user!.userId, req.body);
    ApiResponse.created(res, ride);
  }

  static async getById(req: Request, res: Response): Promise<void> {
    const { ride, stops } = await rideService.getRide(
      req.params.id,
      req.user!.userId,
      req.user!.role,
    );
    ApiResponse.success(res, { ride, stops });
  }

  static async list(req: Request, res: Response): Promise<void> {
    const { page = 1, limit = 20, status } = req.query as { page?: number; limit?: number; status?: string };
    const { rides, total } = await rideService.getRides(
      req.user!.userId,
      req.user!.role,
      Number(page),
      Number(limit),
      status,
    );
    ApiResponse.paginated(res, rides, buildPaginationMeta(Number(page), Number(limit), total));
  }

  static async accept(req: Request, res: Response): Promise<void> {
    const ride = await rideService.acceptRide(req.params.id, req.user!.userId);
    ApiResponse.success(res, ride);
  }

  static async updateStatus(req: Request, res: Response): Promise<void> {
    const { status, reason } = req.body;
    const ride = await rideService.updateRideStatus(
      req.params.id,
      status as RideStatus,
      req.user!.userId,
      req.user!.role,
      reason,
    );
    ApiResponse.success(res, ride);
  }

  static async cancel(req: Request, res: Response): Promise<void> {
    const ride = await rideService.updateRideStatus(
      req.params.id,
      'cancelled',
      req.user!.userId,
      req.user!.role,
      req.body.reason,
    );
    ApiResponse.success(res, ride);
  }

  static async complete(req: Request, res: Response): Promise<void> {
    const ride = await rideService.updateRideStatus(
      req.params.id,
      'completed',
      req.user!.userId,
      req.user!.role,
    );
    ApiResponse.success(res, ride);
  }

  static async pending(req: Request, res: Response): Promise<void> {
    const { page = 1, limit = 20 } = req.query as { page?: number; limit?: number };
    const { rides, total } = await rideService.getPendingRides(Number(page), Number(limit));
    ApiResponse.paginated(res, rides, buildPaginationMeta(Number(page), Number(limit), total));
  }
}
