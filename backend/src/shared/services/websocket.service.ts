import { Server as HttpServer } from 'http';
import { Server, Socket } from 'socket.io';
import jwt from 'jsonwebtoken';
import { config } from '../../config/environment';
import { logger } from '../utils/logger';
import { JwtPayload } from '../middleware/auth.middleware';

interface AuthenticatedSocket extends Socket {
  user?: JwtPayload;
}

export class WebSocketService {
  private static io: Server;

  static initialize(httpServer: HttpServer): void {
    WebSocketService.io = new Server(httpServer, {
      cors: {
        origin: config.corsOrigins,
        methods: ['GET', 'POST'],
      },
      pingTimeout: 60000,
      pingInterval: 25000,
    });

    // Authentication middleware
    WebSocketService.io.use((socket: AuthenticatedSocket, next) => {
      const token = socket.handshake.auth.token as string;
      if (!token) {
        return next(new Error('Authentication required'));
      }

      try {
        const decoded = jwt.verify(token, config.jwtAccessSecret) as JwtPayload;
        socket.user = decoded;
        next();
      } catch {
        next(new Error('Invalid token'));
      }
    });

    WebSocketService.io.on('connection', (socket: AuthenticatedSocket) => {
      const user = socket.user;
      if (!user) return;

      logger.info(`WebSocket connected: ${user.userId} (${user.role})`);

      // Join user-specific room
      socket.join(`user:${user.userId}`);

      // Join role-based room
      socket.join(`role:${user.role}`);

      // Driver location updates
      if (user.role === 'driver') {
        socket.on('driver:location', (data: { lat: number; lng: number }) => {
          // Broadcast to riders tracking this driver
          socket.broadcast.emit('driver:location:update', {
            driverId: user.userId,
            lat: data.lat,
            lng: data.lng,
            timestamp: new Date().toISOString(),
          });
        });
      }

      // Ride status updates
      socket.on('ride:subscribe', (rideId: string) => {
        socket.join(`ride:${rideId}`);
      });

      socket.on('ride:unsubscribe', (rideId: string) => {
        socket.leave(`ride:${rideId}`);
      });

      socket.on('disconnect', () => {
        logger.info(`WebSocket disconnected: ${user.userId}`);
      });
    });
  }

  static getIO(): Server {
    if (!WebSocketService.io) {
      throw new Error('WebSocket not initialized');
    }
    return WebSocketService.io;
  }

  static emitToUser(userId: string, event: string, data: unknown): void {
    WebSocketService.io?.to(`user:${userId}`).emit(event, data);
  }

  static emitToRide(rideId: string, event: string, data: unknown): void {
    WebSocketService.io?.to(`ride:${rideId}`).emit(event, data);
  }

  static emitToRole(role: string, event: string, data: unknown): void {
    WebSocketService.io?.to(`role:${role}`).emit(event, data);
  }

  static emitToAll(event: string, data: unknown): void {
    WebSocketService.io?.emit(event, data);
  }
}
