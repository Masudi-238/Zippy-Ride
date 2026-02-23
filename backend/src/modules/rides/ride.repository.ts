import { DatabasePool } from '../../database/pool';

export interface RideRow {
  id: string;
  rider_id: string;
  driver_id: string | null;
  vehicle_id: string | null;
  status: string;
  pickup_lat: number;
  pickup_lng: number;
  pickup_address: string;
  dropoff_lat: number;
  dropoff_lng: number;
  dropoff_address: string;
  vehicle_type: string;
  estimated_fare: number | null;
  actual_fare: number | null;
  base_fare: number | null;
  distance_fare: number | null;
  time_fare: number | null;
  surge_multiplier: number;
  commission_amount: number | null;
  driver_payout: number | null;
  estimated_distance_km: number | null;
  actual_distance_km: number | null;
  estimated_duration_minutes: number | null;
  actual_duration_minutes: number | null;
  payment_method: string;
  payment_status: string;
  cancelled_by: string | null;
  cancellation_reason: string | null;
  accepted_at: Date | null;
  started_at: Date | null;
  completed_at: Date | null;
  cancelled_at: Date | null;
  created_at: Date;
  updated_at: Date;
  // Joined fields
  rider_first_name?: string;
  rider_last_name?: string;
  driver_first_name?: string;
  driver_last_name?: string;
}

export interface RideStopRow {
  id: string;
  ride_id: string;
  stop_order: number;
  lat: number;
  lng: number;
  address: string;
  arrived_at: Date | null;
  departed_at: Date | null;
}

export class RideRepository {
  async create(data: {
    riderId: string;
    pickupLat: number;
    pickupLng: number;
    pickupAddress: string;
    dropoffLat: number;
    dropoffLng: number;
    dropoffAddress: string;
    vehicleType: string;
    paymentMethod: string;
    estimatedFare: number;
    estimatedDistanceKm: number;
    estimatedDurationMinutes: number;
    baseFare: number;
    distanceFare: number;
    timeFare: number;
    surgeMultiplier: number;
  }): Promise<RideRow> {
    const result = await DatabasePool.query<RideRow>(
      `INSERT INTO rides (
        rider_id, pickup_lat, pickup_lng, pickup_address,
        dropoff_lat, dropoff_lng, dropoff_address,
        vehicle_type, payment_method, estimated_fare,
        estimated_distance_km, estimated_duration_minutes,
        base_fare, distance_fare, time_fare, surge_multiplier
      ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16)
      RETURNING *`,
      [
        data.riderId, data.pickupLat, data.pickupLng, data.pickupAddress,
        data.dropoffLat, data.dropoffLng, data.dropoffAddress,
        data.vehicleType, data.paymentMethod, data.estimatedFare,
        data.estimatedDistanceKm, data.estimatedDurationMinutes,
        data.baseFare, data.distanceFare, data.timeFare, data.surgeMultiplier,
      ],
    );
    return result.rows[0];
  }

  async addStops(rideId: string, stops: Array<{ lat: number; lng: number; address: string; order: number }>): Promise<void> {
    for (const stop of stops) {
      await DatabasePool.query(
        `INSERT INTO ride_stops (ride_id, stop_order, lat, lng, address)
         VALUES ($1, $2, $3, $4, $5)`,
        [rideId, stop.order, stop.lat, stop.lng, stop.address],
      );
    }
  }

  async findById(id: string): Promise<RideRow | null> {
    const result = await DatabasePool.query<RideRow>(
      `SELECT r.*,
        ru.first_name as rider_first_name, ru.last_name as rider_last_name,
        du.first_name as driver_first_name, du.last_name as driver_last_name
       FROM rides r
       JOIN users ru ON r.rider_id = ru.id
       LEFT JOIN users du ON r.driver_id = du.id
       WHERE r.id = $1 AND r.deleted_at IS NULL`,
      [id],
    );
    return result.rows[0] ?? null;
  }

  async findStopsByRideId(rideId: string): Promise<RideStopRow[]> {
    const result = await DatabasePool.query<RideStopRow>(
      'SELECT * FROM ride_stops WHERE ride_id = $1 ORDER BY stop_order',
      [rideId],
    );
    return result.rows;
  }

  async findByRider(riderId: string, status?: string, page = 1, limit = 20): Promise<{ rides: RideRow[]; total: number }> {
    const params: unknown[] = [riderId];
    let where = 'WHERE r.rider_id = $1 AND r.deleted_at IS NULL';

    if (status) {
      params.push(status);
      where += ` AND r.status = $${params.length}`;
    }

    const countResult = await DatabasePool.query<{ count: string }>(
      `SELECT COUNT(*) FROM rides r ${where}`, params,
    );

    params.push(limit, (page - 1) * limit);
    const result = await DatabasePool.query<RideRow>(
      `SELECT r.*,
        du.first_name as driver_first_name, du.last_name as driver_last_name
       FROM rides r
       LEFT JOIN users du ON r.driver_id = du.id
       ${where}
       ORDER BY r.created_at DESC
       LIMIT $${params.length - 1} OFFSET $${params.length}`,
      params,
    );

    return { rides: result.rows, total: parseInt(countResult.rows[0].count, 10) };
  }

  async findByDriver(driverId: string, status?: string, page = 1, limit = 20): Promise<{ rides: RideRow[]; total: number }> {
    const params: unknown[] = [driverId];
    let where = 'WHERE r.driver_id = $1 AND r.deleted_at IS NULL';

    if (status) {
      params.push(status);
      where += ` AND r.status = $${params.length}`;
    }

    const countResult = await DatabasePool.query<{ count: string }>(
      `SELECT COUNT(*) FROM rides r ${where}`, params,
    );

    params.push(limit, (page - 1) * limit);
    const result = await DatabasePool.query<RideRow>(
      `SELECT r.*,
        ru.first_name as rider_first_name, ru.last_name as rider_last_name
       FROM rides r
       JOIN users ru ON r.rider_id = ru.id
       ${where}
       ORDER BY r.created_at DESC
       LIMIT $${params.length - 1} OFFSET $${params.length}`,
      params,
    );

    return { rides: result.rows, total: parseInt(countResult.rows[0].count, 10) };
  }

  async findPendingRides(page = 1, limit = 20): Promise<{ rides: RideRow[]; total: number }> {
    const countResult = await DatabasePool.query<{ count: string }>(
      "SELECT COUNT(*) FROM rides WHERE status = 'requested' AND deleted_at IS NULL",
    );

    const result = await DatabasePool.query<RideRow>(
      `SELECT r.*,
        ru.first_name as rider_first_name, ru.last_name as rider_last_name
       FROM rides r
       JOIN users ru ON r.rider_id = ru.id
       WHERE r.status = 'requested' AND r.deleted_at IS NULL
       ORDER BY r.created_at ASC
       LIMIT $1 OFFSET $2`,
      [limit, (page - 1) * limit],
    );

    return { rides: result.rows, total: parseInt(countResult.rows[0].count, 10) };
  }

  async updateStatus(id: string, status: string, additionalFields?: Record<string, unknown>): Promise<RideRow | null> {
    let setClauses = ['status = $2'];
    const params: unknown[] = [id, status];
    let paramIndex = 3;

    if (additionalFields) {
      for (const [key, value] of Object.entries(additionalFields)) {
        setClauses.push(`${key} = $${paramIndex}`);
        params.push(value);
        paramIndex++;
      }
    }

    const result = await DatabasePool.query<RideRow>(
      `UPDATE rides SET ${setClauses.join(', ')} WHERE id = $1 RETURNING *`,
      params,
    );
    return result.rows[0] ?? null;
  }

  async findAllRides(page = 1, limit = 20, status?: string): Promise<{ rides: RideRow[]; total: number }> {
    const params: unknown[] = [];
    let where = 'WHERE r.deleted_at IS NULL';

    if (status) {
      params.push(status);
      where += ` AND r.status = $${params.length}`;
    }

    const countResult = await DatabasePool.query<{ count: string }>(
      `SELECT COUNT(*) FROM rides r ${where}`, params,
    );

    params.push(limit, (page - 1) * limit);
    const result = await DatabasePool.query<RideRow>(
      `SELECT r.*,
        ru.first_name as rider_first_name, ru.last_name as rider_last_name,
        du.first_name as driver_first_name, du.last_name as driver_last_name
       FROM rides r
       JOIN users ru ON r.rider_id = ru.id
       LEFT JOIN users du ON r.driver_id = du.id
       ${where}
       ORDER BY r.created_at DESC
       LIMIT $${params.length - 1} OFFSET $${params.length}`,
      params,
    );

    return { rides: result.rows, total: parseInt(countResult.rows[0].count, 10) };
  }
}
