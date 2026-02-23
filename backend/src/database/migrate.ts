import fs from 'fs';
import path from 'path';
import { DatabasePool } from './pool';
import { logger } from '../shared/utils/logger';

async function runMigrations(): Promise<void> {
  await DatabasePool.initialize();

  // Create migrations tracking table
  await DatabasePool.query(`
    CREATE TABLE IF NOT EXISTS _migrations (
      id SERIAL PRIMARY KEY,
      name VARCHAR(255) NOT NULL UNIQUE,
      executed_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
    )
  `);

  const migrationsDir = path.join(__dirname, 'migrations');
  const files = fs.readdirSync(migrationsDir)
    .filter((f) => f.endsWith('.sql'))
    .sort();

  const isRollback = process.argv.includes('rollback');

  if (isRollback) {
    logger.info('Rolling back last migration...');
    const result = await DatabasePool.query<{ name: string }>(
      'SELECT name FROM _migrations ORDER BY id DESC LIMIT 1',
    );
    if (result.rows.length > 0) {
      const lastMigration = result.rows[0].name;
      const rollbackFile = path.join(migrationsDir, lastMigration.replace('.sql', '_rollback.sql'));
      if (fs.existsSync(rollbackFile)) {
        const sql = fs.readFileSync(rollbackFile, 'utf-8');
        await DatabasePool.query(sql);
        await DatabasePool.query('DELETE FROM _migrations WHERE name = $1', [lastMigration]);
        logger.info(`Rolled back: ${lastMigration}`);
      } else {
        logger.warn(`No rollback file found for ${lastMigration}`);
      }
    }
  } else {
    for (const file of files) {
      if (file.includes('_rollback')) continue;

      const result = await DatabasePool.query(
        'SELECT 1 FROM _migrations WHERE name = $1',
        [file],
      );

      if (result.rows.length === 0) {
        logger.info(`Running migration: ${file}`);
        const sql = fs.readFileSync(path.join(migrationsDir, file), 'utf-8');
        await DatabasePool.query(sql);
        await DatabasePool.query(
          'INSERT INTO _migrations (name) VALUES ($1)',
          [file],
        );
        logger.info(`Completed: ${file}`);
      } else {
        logger.info(`Skipping (already applied): ${file}`);
      }
    }
  }

  await DatabasePool.shutdown();
  logger.info('Migration process complete');
}

runMigrations().catch((err) => {
  logger.error('Migration failed:', err);
  process.exit(1);
});
