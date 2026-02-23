import winston from 'winston';
import { config } from '../../config/environment';

const { combine, timestamp, errors, json, colorize, simple } = winston.format;

const devFormat = combine(
  colorize(),
  timestamp({ format: 'HH:mm:ss' }),
  errors({ stack: true }),
  simple(),
);

const prodFormat = combine(
  timestamp(),
  errors({ stack: true }),
  json(),
);

export const logger = winston.createLogger({
  level: config.logLevel,
  format: config.nodeEnv === 'production' ? prodFormat : devFormat,
  defaultMeta: { service: 'zippy-ride-api' },
  transports: [
    new winston.transports.Console(),
  ],
});

// Add file transport in production
if (config.nodeEnv === 'production') {
  logger.add(new winston.transports.File({ filename: 'logs/error.log', level: 'error' }));
  logger.add(new winston.transports.File({ filename: 'logs/combined.log' }));
}
