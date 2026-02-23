import bcrypt from 'bcryptjs';
import { DatabasePool } from './pool';
import { logger } from '../shared/utils/logger';

async function seed(): Promise<void> {
  await DatabasePool.initialize();

  logger.info('Seeding database...');

  // Get role IDs
  const rolesResult = await DatabasePool.query<{ id: string; name: string }>(
    'SELECT id, name FROM roles',
  );
  const roles = new Map(rolesResult.rows.map((r) => [r.name, r.id]));

  const passwordHash = await bcrypt.hash('Password123!', 12);

  // Create super admin
  await DatabasePool.query(`
    INSERT INTO users (email, phone, password_hash, first_name, last_name, role_id, is_verified, is_active, email_verified_at)
    VALUES ($1, $2, $3, $4, $5, $6, TRUE, TRUE, NOW())
    ON CONFLICT (email) DO NOTHING
  `, ['admin@zippyride.com', '+1000000001', passwordHash, 'Super', 'Admin', roles.get('super_admin')]);

  // Create manager
  await DatabasePool.query(`
    INSERT INTO users (email, phone, password_hash, first_name, last_name, role_id, is_verified, is_active, email_verified_at)
    VALUES ($1, $2, $3, $4, $5, $6, TRUE, TRUE, NOW())
    ON CONFLICT (email) DO NOTHING
  `, ['manager@zippyride.com', '+1000000002', passwordHash, 'Fleet', 'Manager', roles.get('manager')]);

  // Create test driver
  const driverResult = await DatabasePool.query<{ id: string }>(`
    INSERT INTO users (email, phone, password_hash, first_name, last_name, role_id, is_verified, is_active, email_verified_at)
    VALUES ($1, $2, $3, $4, $5, $6, TRUE, TRUE, NOW())
    ON CONFLICT (email) DO UPDATE SET email = EXCLUDED.email
    RETURNING id
  `, ['driver@zippyride.com', '+1000000003', passwordHash, 'Test', 'Driver', roles.get('driver')]);

  if (driverResult.rows.length > 0) {
    const driverId = driverResult.rows[0].id;

    // Create driver profile
    await DatabasePool.query(`
      INSERT INTO driver_profiles (user_id, is_available, current_lat, current_lng)
      VALUES ($1, TRUE, 40.7128, -74.0060)
      ON CONFLICT (user_id) DO NOTHING
    `, [driverId]);

    // Create vehicle
    await DatabasePool.query(`
      INSERT INTO vehicles (driver_id, make, model, year, color, license_plate, vehicle_type, capacity)
      VALUES ($1, 'Toyota', 'Camry', 2023, 'Black', 'ZR-1234', 'comfort', 4)
      ON CONFLICT (license_plate) DO NOTHING
    `, [driverId]);

    // Create wallet for driver
    await DatabasePool.query(`
      INSERT INTO wallets (user_id, balance, currency)
      VALUES ($1, 150.00, 'USD')
      ON CONFLICT (user_id) DO NOTHING
    `, [driverId]);
  }

  // Create test rider
  const riderResult = await DatabasePool.query<{ id: string }>(`
    INSERT INTO users (email, phone, password_hash, first_name, last_name, role_id, is_verified, is_active, email_verified_at)
    VALUES ($1, $2, $3, $4, $5, $6, TRUE, TRUE, NOW())
    ON CONFLICT (email) DO UPDATE SET email = EXCLUDED.email
    RETURNING id
  `, ['rider@zippyride.com', '+1000000004', passwordHash, 'Test', 'Rider', roles.get('rider')]);

  if (riderResult.rows.length > 0) {
    const riderId = riderResult.rows[0].id;

    // Create wallet for rider
    await DatabasePool.query(`
      INSERT INTO wallets (user_id, balance, currency)
      VALUES ($1, 500.00, 'USD')
      ON CONFLICT (user_id) DO NOTHING
    `, [riderId]);
  }

  // Create surge pricing rules
  await DatabasePool.query(`
    INSERT INTO surge_pricing_rules (name, description, multiplier, demand_threshold, is_active)
    VALUES
      ('Low Surge', 'Light demand increase', 1.25, 10, TRUE),
      ('Medium Surge', 'Moderate demand increase', 1.50, 20, TRUE),
      ('High Surge', 'High demand peak', 2.00, 35, TRUE),
      ('Extreme Surge', 'Extreme demand event', 3.00, 50, FALSE)
    ON CONFLICT DO NOTHING
  `);

  logger.info('Seeding complete');
  await DatabasePool.shutdown();
}

seed().catch((err) => {
  logger.error('Seeding failed:', err);
  process.exit(1);
});
