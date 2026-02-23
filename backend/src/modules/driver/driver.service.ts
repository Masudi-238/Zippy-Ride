import { DatabasePool } from '../../database/pool';
import { AppError } from '../../shared/utils/app-error';

interface DriverProfileRow {
  id: string;
  user_id: string;
  is_available: boolean;
  current_lat: number | null;
  current_lng: number | null;
  average_rating: number;
  total_rides: number;
  total_earnings: number;
  location_updated_at: Date | null;
}

interface DriverDocumentRow {
  id: string;
  driver_id: string;
  document_type: string;
  document_url: string;
  status: string;
  reviewed_by: string | null;
  rejection_reason: string | null;
  expires_at: Date | null;
  created_at: Date;
}

interface EarningsData {
  totalEarnings: number;
  totalRides: number;
  totalCommission: number;
  netEarnings: number;
  periodBreakdown: Array<{
    date: string;
    rides: number;
    earnings: number;
  }>;
}

export class DriverService {
  async getProfile(userId: string): Promise<DriverProfileRow> {
    const result = await DatabasePool.query<DriverProfileRow>(
      'SELECT * FROM driver_profiles WHERE user_id = $1',
      [userId],
    );
    if (!result.rows[0]) throw AppError.notFound('Driver profile not found');
    return result.rows[0];
  }

  async updateAvailability(userId: string, isAvailable: boolean, lat?: number, lng?: number): Promise<DriverProfileRow> {
    const setClauses = ['is_available = $2'];
    const params: unknown[] = [userId, isAvailable];
    let idx = 3;

    if (lat !== undefined && lng !== undefined) {
      setClauses.push(`current_lat = $${idx++}`, `current_lng = $${idx++}`, `location_updated_at = NOW()`);
      params.push(lat, lng);
    }

    const result = await DatabasePool.query<DriverProfileRow>(
      `UPDATE driver_profiles SET ${setClauses.join(', ')} WHERE user_id = $1 RETURNING *`,
      params,
    );

    if (!result.rows[0]) throw AppError.notFound('Driver profile not found');
    return result.rows[0];
  }

  async updateLocation(userId: string, lat: number, lng: number): Promise<void> {
    await DatabasePool.query(
      'UPDATE driver_profiles SET current_lat = $1, current_lng = $2, location_updated_at = NOW() WHERE user_id = $3',
      [lat, lng, userId],
    );
  }

  async getEarnings(userId: string, period: 'daily' | 'weekly' | 'monthly' = 'weekly'): Promise<EarningsData> {
    let interval: string;
    let dateFormat: string;

    switch (period) {
      case 'daily':
        interval = '7 days';
        dateFormat = 'YYYY-MM-DD';
        break;
      case 'weekly':
        interval = '4 weeks';
        dateFormat = 'IYYY-IW';
        break;
      case 'monthly':
        interval = '12 months';
        dateFormat = 'YYYY-MM';
        break;
    }

    // Total earnings
    const totalsResult = await DatabasePool.query<{
      total_earnings: string;
      total_rides: string;
      total_commission: string;
    }>(
      `SELECT
        COALESCE(SUM(c.driver_payout), 0) as total_earnings,
        COUNT(c.id) as total_rides,
        COALESCE(SUM(c.commission_amount), 0) as total_commission
       FROM commissions c
       WHERE c.driver_id = $1`,
      [userId],
    );

    const totals = totalsResult.rows[0];

    // Period breakdown
    const breakdownResult = await DatabasePool.query<{
      period_label: string;
      rides: string;
      earnings: string;
    }>(
      `SELECT
        TO_CHAR(c.created_at, $2) as period_label,
        COUNT(*) as rides,
        COALESCE(SUM(c.driver_payout), 0) as earnings
       FROM commissions c
       WHERE c.driver_id = $1 AND c.created_at > NOW() - INTERVAL '${interval}'
       GROUP BY period_label
       ORDER BY period_label DESC`,
      [userId, dateFormat],
    );

    return {
      totalEarnings: parseFloat(totals.total_earnings),
      totalRides: parseInt(totals.total_rides, 10),
      totalCommission: parseFloat(totals.total_commission),
      netEarnings: parseFloat(totals.total_earnings),
      periodBreakdown: breakdownResult.rows.map((r) => ({
        date: r.period_label,
        rides: parseInt(r.rides, 10),
        earnings: parseFloat(r.earnings),
      })),
    };
  }

  async getDocuments(userId: string): Promise<DriverDocumentRow[]> {
    const result = await DatabasePool.query<DriverDocumentRow>(
      'SELECT * FROM driver_documents WHERE driver_id = $1 ORDER BY created_at DESC',
      [userId],
    );
    return result.rows;
  }

  async uploadDocument(userId: string, documentType: string, documentUrl: string): Promise<DriverDocumentRow> {
    const result = await DatabasePool.query<DriverDocumentRow>(
      `INSERT INTO driver_documents (driver_id, document_type, document_url)
       VALUES ($1, $2, $3) RETURNING *`,
      [userId, documentType, documentUrl],
    );
    return result.rows[0];
  }

  async reviewDocument(documentId: string, reviewerId: string, status: 'approved' | 'rejected', rejectionReason?: string): Promise<DriverDocumentRow> {
    const result = await DatabasePool.query<DriverDocumentRow>(
      `UPDATE driver_documents
       SET status = $1, reviewed_by = $2, reviewed_at = NOW(), rejection_reason = $3
       WHERE id = $4 RETURNING *`,
      [status, reviewerId, rejectionReason ?? null, documentId],
    );
    if (!result.rows[0]) throw AppError.notFound('Document not found');
    return result.rows[0];
  }
}
