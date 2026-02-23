import dotenv from 'dotenv';
import path from 'path';

dotenv.config({ path: path.resolve(__dirname, '../../.env') });

export interface EnvironmentConfig {
  nodeEnv: string;
  port: number;
  appVersion: string;

  // Database
  dbHost: string;
  dbPort: number;
  dbUser: string;
  dbPassword: string;
  dbName: string;
  dbPoolMin: number;
  dbPoolMax: number;
  dbSsl: boolean;

  // JWT
  jwtAccessSecret: string;
  jwtRefreshSecret: string;
  jwtAccessExpiresIn: string;
  jwtRefreshExpiresIn: string;

  // CORS
  corsOrigins: string[];

  // Rate Limiting
  rateLimitWindowMs: number;
  rateLimitMaxRequests: number;

  // Logging
  logLevel: string;

  // External Services
  sentryDsn?: string;
  redisUrl?: string;
}

function getEnvVar(key: string, defaultValue?: string): string {
  const value = process.env[key] ?? defaultValue;
  if (value === undefined) {
    throw new Error(`Missing required environment variable: ${key}`);
  }
  return value;
}

function getEnvInt(key: string, defaultValue: number): number {
  const value = process.env[key];
  return value ? parseInt(value, 10) : defaultValue;
}

function getEnvBool(key: string, defaultValue: boolean): boolean {
  const value = process.env[key];
  return value ? value === 'true' : defaultValue;
}

export const config: EnvironmentConfig = {
  nodeEnv: getEnvVar('NODE_ENV', 'development'),
  port: getEnvInt('PORT', 3000),
  appVersion: getEnvVar('APP_VERSION', '1.0.0'),

  // Database
  dbHost: getEnvVar('DB_HOST', 'localhost'),
  dbPort: getEnvInt('DB_PORT', 5432),
  dbUser: getEnvVar('DB_USER', 'zippy'),
  dbPassword: getEnvVar('DB_PASSWORD', 'zippy_secret'),
  dbName: getEnvVar('DB_NAME', 'zippy_ride'),
  dbPoolMin: getEnvInt('DB_POOL_MIN', 2),
  dbPoolMax: getEnvInt('DB_POOL_MAX', 20),
  dbSsl: getEnvBool('DB_SSL', false),

  // JWT
  jwtAccessSecret: getEnvVar('JWT_ACCESS_SECRET', 'dev-access-secret-change-in-production'),
  jwtRefreshSecret: getEnvVar('JWT_REFRESH_SECRET', 'dev-refresh-secret-change-in-production'),
  jwtAccessExpiresIn: getEnvVar('JWT_ACCESS_EXPIRES_IN', '15m'),
  jwtRefreshExpiresIn: getEnvVar('JWT_REFRESH_EXPIRES_IN', '7d'),

  // CORS
  corsOrigins: getEnvVar('CORS_ORIGINS', 'http://localhost:3000,http://localhost:8080').split(','),

  // Rate Limiting
  rateLimitWindowMs: getEnvInt('RATE_LIMIT_WINDOW_MS', 15 * 60 * 1000),
  rateLimitMaxRequests: getEnvInt('RATE_LIMIT_MAX_REQUESTS', 100),

  // Logging
  logLevel: getEnvVar('LOG_LEVEL', 'info'),

  // External Services
  sentryDsn: process.env.SENTRY_DSN,
  redisUrl: process.env.REDIS_URL,
};
