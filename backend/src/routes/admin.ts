import { Router, Response } from 'express';
import { authenticate, authorize, AuthRequest } from '../middleware/auth';

const router = Router();

/** GET /api/admin/dashboard - Super admin control panel */
router.get('/dashboard', authenticate, authorize('admin'), (_req: AuthRequest, res: Response) => {
  res.json({
    metrics: {
      total_riders: 124500, riders_change: 12,
      active_drivers: 8230, drivers_change: 5,
      daily_revenue: 42800, revenue_change: -2,
      total_trips: 15200, trips_change: 8,
    },
    surge_control: {
      zone: 'Downtown Core', multiplier: 1.5, status: 'active',
      message: 'Demand is high in Downtown. AI recalibration successful.',
    },
    alerts: [
      { id: 'alert_1', severity: 'critical', title: 'Server Latency: East Zone', message: 'Response times increased by 250ms in Brooklyn sector.', time_ago: '2m ago', icon: 'warning' },
      { id: 'alert_2', severity: 'warning', title: 'Suspicious Activity', message: 'Multi-account login attempt detected from IP: 192.168.1.1', time_ago: '14m ago', icon: 'shield_person' },
      { id: 'alert_3', severity: 'info', title: 'Payouts Completed', message: 'Weekly driver payouts have been successfully processed.', time_ago: '45m ago', icon: 'check_circle' },
    ],
  });
});

/** GET /api/admin/verification-queue - Driver verification queue */
router.get('/verification-queue', authenticate, authorize('admin'), (_req: AuthRequest, res: Response) => {
  res.json({
    pending_count: 128,
    queue: [
      {
        application_id: 'ZP-8829-BS', user_id: 'usr_1',
        name: 'Marcus Sterling', location: 'Berlin, Germany', phone: '+49 152 4920 182',
        join_date: 'Oct 24, 2023', flag: 'Low Res ID',
        documents: { license_front: 'url', license_back: 'url' },
        vehicle: { model: 'Tesla Model 3', plate: 'B-ZY-2023', images: [] },
        background: { criminal: 'cleared', driving_offense: '1 minor (2019)' },
      },
    ],
  });
});

/** POST /api/admin/verification-queue/:id/approve */
router.post('/verification-queue/:id/approve', authenticate, authorize('admin'), (req: AuthRequest, res: Response) => {
  res.json({ message: 'Driver approved.', application_id: req.params.id });
});

/** POST /api/admin/verification-queue/:id/reject */
router.post('/verification-queue/:id/reject', authenticate, authorize('admin'), (req: AuthRequest, res: Response) => {
  res.json({ message: 'Driver rejected.', application_id: req.params.id, reason: req.body.reason });
});

/** PUT /api/admin/surge-control - Update AI surge settings */
router.put('/surge-control', authenticate, authorize('admin'), (req: AuthRequest, res: Response) => {
  res.json({ message: 'Surge settings updated.', zone: req.body.zone, multiplier: req.body.multiplier });
});

/** GET /api/admin/users - List all users with role filtering */
router.get('/users', authenticate, authorize('admin'), (_req: AuthRequest, res: Response) => {
  res.json({ users: [], total: 0, page: 1 });
});

/** PUT /api/admin/users/:id/role - Change user role */
router.put('/users/:id/role', authenticate, authorize('admin'), (req: AuthRequest, res: Response) => {
  res.json({ message: 'User role updated.', user_id: req.params.id, new_role: req.body.role });
});

export default router;
