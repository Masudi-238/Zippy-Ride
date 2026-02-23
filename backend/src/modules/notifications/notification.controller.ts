import { Request, Response } from 'express';
import { NotificationService } from './notification.service';
import { ApiResponse, buildPaginationMeta } from '../../shared/utils/api-response';

const notificationService = new NotificationService();

export class NotificationController {
  static async list(req: Request, res: Response): Promise<void> {
    const { page = 1, limit = 20, unreadOnly } = req.query as {
      page?: number; limit?: number; unreadOnly?: string;
    };
    const { notifications, total } = await notificationService.getNotifications(
      req.user!.userId, Number(page), Number(limit), unreadOnly === 'true',
    );
    ApiResponse.paginated(res, notifications, buildPaginationMeta(Number(page), Number(limit), total));
  }

  static async markAsRead(req: Request, res: Response): Promise<void> {
    await notificationService.markAsRead(req.params.id, req.user!.userId);
    ApiResponse.success(res, { message: 'Notification marked as read' });
  }

  static async markAllAsRead(req: Request, res: Response): Promise<void> {
    await notificationService.markAllAsRead(req.user!.userId);
    ApiResponse.success(res, { message: 'All notifications marked as read' });
  }
}
