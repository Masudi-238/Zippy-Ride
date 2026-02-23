import { Request, Response } from 'express';
import { DriverService } from './driver.service';
import { ApiResponse } from '../../shared/utils/api-response';

const driverService = new DriverService();

export class DriverController {
  static async getProfile(req: Request, res: Response): Promise<void> {
    const profile = await driverService.getProfile(req.user!.userId);
    ApiResponse.success(res, profile);
  }

  static async updateAvailability(req: Request, res: Response): Promise<void> {
    const { isAvailable, lat, lng } = req.body;
    const profile = await driverService.updateAvailability(req.user!.userId, isAvailable, lat, lng);
    ApiResponse.success(res, profile);
  }

  static async getEarnings(req: Request, res: Response): Promise<void> {
    const period = (req.query.period as 'daily' | 'weekly' | 'monthly') || 'weekly';
    const earnings = await driverService.getEarnings(req.user!.userId, period);
    ApiResponse.success(res, earnings);
  }

  static async getDocuments(req: Request, res: Response): Promise<void> {
    const documents = await driverService.getDocuments(req.user!.userId);
    ApiResponse.success(res, documents);
  }

  static async uploadDocument(req: Request, res: Response): Promise<void> {
    const { documentType, documentUrl } = req.body;
    const document = await driverService.uploadDocument(req.user!.userId, documentType, documentUrl);
    ApiResponse.created(res, document);
  }

  static async reviewDocument(req: Request, res: Response): Promise<void> {
    const { status, rejectionReason } = req.body;
    const document = await driverService.reviewDocument(
      req.params.documentId, req.user!.userId, status, rejectionReason,
    );
    ApiResponse.success(res, document);
  }
}
