import { DatabasePool } from '../../database/pool';

const DEFAULT_COMMISSION_RATE = 0.20; // 20%

interface CommissionRow {
  id: string;
  ride_id: string;
  driver_id: string;
  ride_fare: number;
  commission_rate: number;
  commission_amount: number;
  driver_payout: number;
  created_at: Date;
}

export class CommissionService {
  async calculateAndSave(rideId: string, driverId: string, rideFare: number): Promise<CommissionRow> {
    const commissionRate = DEFAULT_COMMISSION_RATE;
    const commissionAmount = Math.round(rideFare * commissionRate * 100) / 100;
    const driverPayout = Math.round((rideFare - commissionAmount) * 100) / 100;

    const result = await DatabasePool.query<CommissionRow>(
      `INSERT INTO commissions (ride_id, driver_id, ride_fare, commission_rate, commission_amount, driver_payout)
       VALUES ($1, $2, $3, $4, $5, $6)
       RETURNING *`,
      [rideId, driverId, rideFare, commissionRate, commissionAmount, driverPayout],
    );

    // Update ride with commission info
    await DatabasePool.query(
      'UPDATE rides SET commission_amount = $1, driver_payout = $2 WHERE id = $3',
      [commissionAmount, driverPayout, rideId],
    );

    return result.rows[0];
  }

  async getDriverCommissions(driverId: string, page = 1, limit = 20): Promise<{ commissions: CommissionRow[]; total: number }> {
    const countResult = await DatabasePool.query<{ count: string }>(
      'SELECT COUNT(*) FROM commissions WHERE driver_id = $1',
      [driverId],
    );

    const result = await DatabasePool.query<CommissionRow>(
      `SELECT * FROM commissions WHERE driver_id = $1
       ORDER BY created_at DESC LIMIT $2 OFFSET $3`,
      [driverId, limit, (page - 1) * limit],
    );

    return {
      commissions: result.rows,
      total: parseInt(countResult.rows[0].count, 10),
    };
  }
}
