import { Pool, PoolClient, QueryResult } from 'pg';
import { config } from '../config/environment';
import { logger } from '../shared/utils/logger';

let pool: Pool;

export class DatabasePool {
  static async initialize(): Promise<void> {
    pool = new Pool({
      host: config.dbHost,
      port: config.dbPort,
      user: config.dbUser,
      password: config.dbPassword,
      database: config.dbName,
      min: config.dbPoolMin,
      max: config.dbPoolMax,
      ssl: config.dbSsl ? { rejectUnauthorized: false } : undefined,
      idleTimeoutMillis: 30000,
      connectionTimeoutMillis: 5000,
    });

    pool.on('error', (err) => {
      logger.error('Unexpected database pool error:', err);
    });

    // Test connection
    const client = await pool.connect();
    client.release();
    logger.info('Database pool initialized');
  }

  static getPool(): Pool {
    if (!pool) {
      throw new Error('Database pool not initialized. Call initialize() first.');
    }
    return pool;
  }

  static async query<T = Record<string, unknown>>(
    text: string,
    params?: unknown[],
  ): Promise<QueryResult<T>> {
    const start = Date.now();
    const result = await pool.query<T>(text, params);
    const duration = Date.now() - start;

    if (duration > 1000) {
      logger.warn(`Slow query (${duration}ms): ${text.substring(0, 100)}`);
    }

    return result;
  }

  static async getClient(): Promise<PoolClient> {
    return pool.connect();
  }

  static async transaction<T>(
    callback: (client: PoolClient) => Promise<T>,
  ): Promise<T> {
    const client = await pool.connect();
    try {
      await client.query('BEGIN');
      const result = await callback(client);
      await client.query('COMMIT');
      return result;
    } catch (error) {
      await client.query('ROLLBACK');
      throw error;
    } finally {
      client.release();
    }
  }

  static async shutdown(): Promise<void> {
    if (pool) {
      await pool.end();
      logger.info('Database pool shut down');
    }
  }
}
