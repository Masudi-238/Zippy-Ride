import { DatabasePool } from '../../database/pool';
import { AppError } from '../../shared/utils/app-error';

interface UserListRow {
  id: string;
  email: string;
  phone: string;
  first_name: string;
  last_name: string;
  role_name: string;
  is_verified: boolean;
  is_active: boolean;
  created_at: Date;
  last_login_at: Date | null;
}

interface AnalyticsData {
  totalUsers: number;
  totalRiders: number;
  totalDrivers: number;
  totalRides: number;
  completedRides: number;
  cancelledRides: number;
  totalRevenue: number;
  totalCommission: number;
  activeDrivers: number;
  averageRating: number;
}

interface FleetData {
  totalDrivers: number;
  activeDrivers: number;
  totalVehicles: number;
  pendingDocuments: number;
  driverPerformance: Array<{
    driver_id: string;
    first_name: string;
    last_name: string;
    total_rides: number;
    average_rating: number;
    total_earnings: number;
    is_available: boolean;
  }>;
}

export class AdminService {
  async getUsers(page = 1, limit = 20, role?: string, search?: string): Promise<{ users: UserListRow[]; total: number }> {
    const params: unknown[] = [];
    let where = 'WHERE u.deleted_at IS NULL';

    if (role) {
      params.push(role);
      where += ` AND r.name = $${params.length}`;
    }

    if (search) {
      params.push(`%${search}%`);
      where += ` AND (u.first_name ILIKE $${params.length} OR u.last_name ILIKE $${params.length} OR u.email ILIKE $${params.length})`;
    }

    const countResult = await DatabasePool.query<{ count: string }>(
      `SELECT COUNT(*) FROM users u JOIN roles r ON u.role_id = r.id ${where}`,
      params,
    );

    params.push(limit, (page - 1) * limit);
    const result = await DatabasePool.query<UserListRow>(
      `SELECT u.id, u.email, u.phone, u.first_name, u.last_name, r.name as role_name,
              u.is_verified, u.is_active, u.created_at, u.last_login_at
       FROM users u
       JOIN roles r ON u.role_id = r.id
       ${where}
       ORDER BY u.created_at DESC
       LIMIT $${params.length - 1} OFFSET $${params.length}`,
      params,
    );

    return { users: result.rows, total: parseInt(countResult.rows[0].count, 10) };
  }

  async suspendUser(userId: string): Promise<void> {
    const result = await DatabasePool.query(
      'UPDATE users SET is_active = FALSE WHERE id = $1 AND deleted_at IS NULL',
      [userId],
    );
    if (result.rowCount === 0) throw AppError.notFound('User not found');
  }

  async activateUser(userId: string): Promise<void> {
    const result = await DatabasePool.query(
      'UPDATE users SET is_active = TRUE WHERE id = $1 AND deleted_at IS NULL',
      [userId],
    );
    if (result.rowCount === 0) throw AppError.notFound('User not found');
  }

  async verifyUser(userId: string): Promise<void> {
    await DatabasePool.query(
      'UPDATE users SET is_verified = TRUE, email_verified_at = NOW() WHERE id = $1',
      [userId],
    );
  }

  async getAnalytics(): Promise<AnalyticsData> {
    const [usersResult, ridesResult, revenueResult, driversResult, ratingResult] = await Promise.all([
      DatabasePool.query<{ total: string; riders: string; drivers: string }>(`
        SELECT
          COUNT(*) as total,
          COUNT(*) FILTER (WHERE r.name = 'rider') as riders,
          COUNT(*) FILTER (WHERE r.name = 'driver') as drivers
        FROM users u JOIN roles r ON u.role_id = r.id WHERE u.deleted_at IS NULL
      `),
      DatabasePool.query<{ total: string; completed: string; cancelled: string }>(`
        SELECT
          COUNT(*) as total,
          COUNT(*) FILTER (WHERE status = 'completed') as completed,
          COUNT(*) FILTER (WHERE status = 'cancelled') as cancelled
        FROM rides WHERE deleted_at IS NULL
      `),
      DatabasePool.query<{ total_revenue: string; total_commission: string }>(`
        SELECT
          COALESCE(SUM(ride_fare), 0) as total_revenue,
          COALESCE(SUM(commission_amount), 0) as total_commission
        FROM commissions
      `),
      DatabasePool.query<{ active: string }>(`
        SELECT COUNT(*) as active FROM driver_profiles WHERE is_available = TRUE
      `),
      DatabasePool.query<{ avg_rating: string }>(`
        SELECT COALESCE(AVG(rating), 0) as avg_rating FROM ratings
      `),
    ]);

    return {
      totalUsers: parseInt(usersResult.rows[0].total, 10),
      totalRiders: parseInt(usersResult.rows[0].riders, 10),
      totalDrivers: parseInt(usersResult.rows[0].drivers, 10),
      totalRides: parseInt(ridesResult.rows[0].total, 10),
      completedRides: parseInt(ridesResult.rows[0].completed, 10),
      cancelledRides: parseInt(ridesResult.rows[0].cancelled, 10),
      totalRevenue: parseFloat(revenueResult.rows[0].total_revenue),
      totalCommission: parseFloat(revenueResult.rows[0].total_commission),
      activeDrivers: parseInt(driversResult.rows[0].active, 10),
      averageRating: parseFloat(ratingResult.rows[0].avg_rating),
    };
  }

  async getFleetOverview(page = 1, limit = 20): Promise<FleetData> {
    const [statsResult, performanceResult, pendingDocsResult] = await Promise.all([
      DatabasePool.query<{ total_drivers: string; active_drivers: string; total_vehicles: string }>(`
        SELECT
          (SELECT COUNT(*) FROM driver_profiles) as total_drivers,
          (SELECT COUNT(*) FROM driver_profiles WHERE is_available = TRUE) as active_drivers,
          (SELECT COUNT(*) FROM vehicles WHERE deleted_at IS NULL) as total_vehicles
      `),
      DatabasePool.query<{
        driver_id: string; first_name: string; last_name: string;
        total_rides: string; average_rating: string; total_earnings: string; is_available: boolean;
      }>(`
        SELECT dp.user_id as driver_id, u.first_name, u.last_name,
               dp.total_rides::text, dp.average_rating::text, dp.total_earnings::text, dp.is_available
        FROM driver_profiles dp
        JOIN users u ON dp.user_id = u.id
        ORDER BY dp.total_rides DESC
        LIMIT $1 OFFSET $2
      `, [limit, (page - 1) * limit]),
      DatabasePool.query<{ count: string }>(`
        SELECT COUNT(*) FROM driver_documents WHERE status = 'pending'
      `),
    ]);

    const stats = statsResult.rows[0];

    return {
      totalDrivers: parseInt(stats.total_drivers, 10),
      activeDrivers: parseInt(stats.active_drivers, 10),
      totalVehicles: parseInt(stats.total_vehicles, 10),
      pendingDocuments: parseInt(pendingDocsResult.rows[0].count, 10),
      driverPerformance: performanceResult.rows.map((r) => ({
        driver_id: r.driver_id,
        first_name: r.first_name,
        last_name: r.last_name,
        total_rides: parseInt(r.total_rides, 10),
        average_rating: parseFloat(r.average_rating),
        total_earnings: parseFloat(r.total_earnings),
        is_available: r.is_available,
      })),
    };
  }

  async generateReport(type: 'rides' | 'earnings' | 'drivers', startDate?: string, endDate?: string): Promise<unknown[]> {
    let query: string;
    const params: unknown[] = [];

    const dateFilter = startDate && endDate
      ? `AND created_at BETWEEN $${params.length + 1} AND $${params.length + 2}`
      : '';
    if (startDate && endDate) {
      params.push(startDate, endDate);
    }

    switch (type) {
      case 'rides':
        query = `
          SELECT r.id, r.status, r.pickup_address, r.dropoff_address,
                 r.estimated_fare, r.actual_fare, r.vehicle_type,
                 r.payment_method, r.payment_status,
                 ru.first_name || ' ' || ru.last_name as rider_name,
                 du.first_name || ' ' || du.last_name as driver_name,
                 r.created_at, r.completed_at
          FROM rides r
          JOIN users ru ON r.rider_id = ru.id
          LEFT JOIN users du ON r.driver_id = du.id
          WHERE r.deleted_at IS NULL ${dateFilter}
          ORDER BY r.created_at DESC
        `;
        break;
      case 'earnings':
        query = `
          SELECT c.ride_id, c.ride_fare, c.commission_rate, c.commission_amount,
                 c.driver_payout, u.first_name || ' ' || u.last_name as driver_name,
                 c.created_at
          FROM commissions c
          JOIN users u ON c.driver_id = u.id
          WHERE 1=1 ${dateFilter.replace('created_at', 'c.created_at')}
          ORDER BY c.created_at DESC
        `;
        break;
      case 'drivers':
        query = `
          SELECT u.id, u.first_name, u.last_name, u.email, u.phone,
                 dp.is_available, dp.average_rating, dp.total_rides, dp.total_earnings,
                 v.make || ' ' || v.model as vehicle, v.license_plate,
                 u.created_at
          FROM users u
          JOIN driver_profiles dp ON u.id = dp.user_id
          LEFT JOIN vehicles v ON u.id = v.driver_id AND v.is_active = TRUE
          WHERE u.deleted_at IS NULL ${dateFilter.replace('created_at', 'u.created_at')}
          ORDER BY dp.total_rides DESC
        `;
        break;
      default:
        throw AppError.badRequest('Invalid report type');
    }

    const result = await DatabasePool.query(query, params);
    return result.rows;
  }
}
