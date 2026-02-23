import { Router, Response } from 'express';
import { authenticate, authorize, AuthRequest } from '../middleware/auth';

const router = Router();

/** GET /api/manager/fleet - Fleet dashboard data */
router.get('/fleet', authenticate, authorize('manager', 'admin'), (_req: AuthRequest, res: Response) => {
  res.json({
    stats: { online_drivers: 124, active_trips: 82, capacity_pct: 85, online_change_pct: 12 },
    recent_activity: [
      { driver_name: 'Alex M.', driver_id: 'ZP-829', avatar_url: null, status: 'en_route', pickup: 'SFO Intl Airport', dropoff: 'Union Square', fare: 24.50, time_ago: '2 min ago' },
      { driver_name: 'Sarah K.', driver_id: 'ZP-104', avatar_url: null, status: 'picking_up', pickup: 'Mission District', dropoff: 'Pier 39', fare: 18.20, time_ago: 'Just now' },
    ],
    map_markers: [
      { lat: 37.78, lng: -122.42, type: 'driver', status: 'active' },
      { lat: 37.77, lng: -122.40, type: 'cluster', count: 12 },
      { lat: 37.76, lng: -122.39, type: 'driver', status: 'busy' },
    ],
  });
});

/** GET /api/manager/reports - Reporting and commission data */
router.get('/reports', authenticate, authorize('manager', 'admin'), (_req: AuthRequest, res: Response) => {
  res.json({
    metrics: {
      today_revenue: 4250.00, today_revenue_change: 12.5,
      active_drivers: 124, active_drivers_change: 4,
      commission: 637.50, commission_change: -2,
    },
    commission_settings: {
      economy_rate: 15, premium_rate: 22,
      peak_pricing_enabled: false,
    },
    daily_breakdown: [
      { date: 'Oct 24, 2023', rides: 142, revenue: 2450.00, commission: 367.50 },
      { date: 'Oct 23, 2023', rides: 128, revenue: 1980.50, commission: 297.08 },
      { date: 'Oct 22, 2023', rides: 165, revenue: 3120.00, commission: 468.00 },
    ],
  });
});

/** PUT /api/manager/reports/commission - Update commission settings */
router.put('/reports/commission', authenticate, authorize('manager', 'admin'), (req: AuthRequest, res: Response) => {
  const { economy_rate, premium_rate, peak_pricing_enabled } = req.body;
  res.json({ message: 'Commission settings updated.', economy_rate, premium_rate, peak_pricing_enabled });
});

/** GET /api/manager/analytics - Analytics and payout data */
router.get('/analytics', authenticate, authorize('manager', 'admin'), (_req: AuthRequest, res: Response) => {
  res.json({
    summary: { total_revenue: 42850.20, revenue_change: 12.5, commission: 6427.50, commission_change: 10.2, available_payout: 4120.00 },
    fleet_performance: [
      { name: 'Premium Fleet', active_drivers: 12, revenue: 18420, commission_rate: 15, icon: 'electric_car', color: 'blue' },
      { name: 'Night Shift', active_drivers: 24, revenue: 14210, commission_rate: 12, icon: 'nightlight', color: 'orange' },
      { name: 'Airport Transit', active_drivers: 8, revenue: 10220, commission_rate: 18, icon: 'airport_shuttle', color: 'purple' },
    ],
  });
});

/** POST /api/manager/payout - Request payout */
router.post('/payout', authenticate, authorize('manager', 'admin'), (_req: AuthRequest, res: Response) => {
  res.json({ message: 'Payout requested. Processing in 1-3 business days.', payout_id: `pay_${Date.now()}`, amount: 4120.00 });
});

export default router;
