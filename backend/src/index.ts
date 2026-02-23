import 'express-async-errors';
import { createServer } from 'http';
import { app } from './app';
import { config } from './config/environment';
import { logger } from './shared/utils/logger';
import { DatabasePool } from './database/pool';
import { WebSocketService } from './shared/services/websocket.service';

async function bootstrap(): Promise<void> {
  // Initialize database connection
  await DatabasePool.initialize();
  logger.info('Database connection established');

  const httpServer = createServer(app);

  // Initialize WebSocket
  WebSocketService.initialize(httpServer);
  logger.info('WebSocket server initialized');

  httpServer.listen(config.port, () => {
    logger.info(`Zippy Ride API server running on port ${config.port}`);
    logger.info(`Environment: ${config.nodeEnv}`);
    logger.info(`API Docs: http://localhost:${config.port}/api/docs`);
  });

  // Graceful shutdown
  const shutdown = async (signal: string) => {
    logger.info(`${signal} received. Starting graceful shutdown...`);
    httpServer.close(async () => {
      await DatabasePool.shutdown();
      logger.info('Server shut down gracefully');
      process.exit(0);
    });

    setTimeout(() => {
      logger.error('Forced shutdown due to timeout');
      process.exit(1);
    }, 10000);
  };

  process.on('SIGTERM', () => shutdown('SIGTERM'));
  process.on('SIGINT', () => shutdown('SIGINT'));

  process.on('unhandledRejection', (reason) => {
    logger.error('Unhandled Rejection:', reason);
  });

  process.on('uncaughtException', (error) => {
    logger.error('Uncaught Exception:', error);
    process.exit(1);
  });
}

bootstrap().catch((error) => {
  logger.error('Failed to start server:', error);
  process.exit(1);
});
