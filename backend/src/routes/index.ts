import { Router } from 'express';
import { authRoutes } from '../modules/auth/auth.routes';
import { rideRoutes } from '../modules/rides/ride.routes';
import { walletRoutes } from '../modules/wallet/wallet.routes';
import { driverRoutes } from '../modules/driver/driver.routes';
import { adminRoutes } from '../modules/admin/admin.routes';
import { ratingRoutes } from '../modules/ratings/rating.routes';
import { notificationRoutes } from '../modules/notifications/notification.routes';

const apiRouter = Router();

// API v1 routes
const v1Router = Router();

v1Router.use('/auth', authRoutes);
v1Router.use('/rides', rideRoutes);
v1Router.use('/wallet', walletRoutes);
v1Router.use('/driver', driverRoutes);
v1Router.use('/admin', adminRoutes);
v1Router.use('/ratings', ratingRoutes);
v1Router.use('/notifications', notificationRoutes);

apiRouter.use('/v1', v1Router);

export { apiRouter };
