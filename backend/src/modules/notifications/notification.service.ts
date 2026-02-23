import { DatabasePool } from '../../database/pool';
import { WebSocketService } from '../../shared/services/websocket.service';

interface NotificationRow {
  id: string;
  user_id: string;
  title: string;
  body: string;
  type: string;
  data: Record<string, unknown>;
  is_read: boolean;
  read_at: Date | null;
  created_at: Date;
}

export class NotificationService {
  async getNotifications(userId: string, page = 1, limit = 20, unreadOnly = false): Promise<{ notifications: NotificationRow[]; total: number }> {
    const params: unknown[] = [userId];
    let where = 'WHERE user_id = $1';
    if (unreadOnly) {
      where += ' AND is_read = FALSE';
    }

    const countResult = await DatabasePool.query<{ count: string }>(
      `SELECT COUNT(*) FROM notifications ${where}`, params,
    );

    params.push(limit, (page - 1) * limit);
    const result = await DatabasePool.query<NotificationRow>(
      `SELECT * FROM notifications ${where}
       ORDER BY created_at DESC LIMIT $2 OFFSET $3`,
      params,
    );

    return {
      notifications: result.rows,
      total: parseInt(countResult.rows[0].count, 10),
    };
  }

  async markAsRead(notificationId: string, userId: string): Promise<void> {
    await DatabasePool.query(
      'UPDATE notifications SET is_read = TRUE, read_at = NOW() WHERE id = $1 AND user_id = $2',
      [notificationId, userId],
    );
  }

  async markAllAsRead(userId: string): Promise<void> {
    await DatabasePool.query(
      'UPDATE notifications SET is_read = TRUE, read_at = NOW() WHERE user_id = $1 AND is_read = FALSE',
      [userId],
    );
  }

  static async create(userId: string, title: string, body: string, type: string, data?: Record<string, unknown>): Promise<NotificationRow> {
    const result = await DatabasePool.query<NotificationRow>(
      `INSERT INTO notifications (user_id, title, body, type, data)
       VALUES ($1, $2, $3, $4, $5) RETURNING *`,
      [userId, title, body, type, JSON.stringify(data ?? {})],
    );

    // Push via WebSocket
    try {
      WebSocketService.emitToUser(userId, 'notification:new', result.rows[0]);
    } catch {
      // WebSocket not available
    }

    return result.rows[0];
  }
}
