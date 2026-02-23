import { Router, Response } from 'express';
import { authenticate, authorize, AuthRequest } from '../middleware/auth';

const router = Router();

/** GET /api/driver/status */
router.get('/status', authenticate, authorize('driver'), (req: AuthRequest, res: Response) => {
  res.json({
    driver: {
      user_id: req.user!.id, is_online: true, rating: 4.95, total_trips: 142,
      total_earnings: 842.50, today_earnings: 124.80, online_minutes: 2060,
      documents: [
        { id: 'doc_1', name: "Driver's License", type: 'license', status: 'verified', verified_date: 'Oct 24', icon_name: 'badge' },
        { id: 'doc_2', name: 'Vehicle Insurance', type: 'insurance', status: 'verified', verified_date: 'Oct 25', icon_name: 'shield' },
        { id: 'doc_3', name: 'Background Check', type: 'background', status: 'pending', icon_name: 'person_search' },
        { id: 'doc_4', name: 'Vehicle Registration', type: 'registration', status: 'action_required', icon_name: 'minor_crash' },
      ],
    },
  });
});

/** PUT /api/driver/status */
router.put('/status', authenticate, authorize('driver'), (req: AuthRequest, res: Response) => {
  res.json({ message: 'Status updated.', is_online: req.body.is_online });
});

/** GET /api/driver/earnings */
router.get('/earnings', authenticate, authorize('driver'), (_req: AuthRequest, res: Response) => {
  res.json({
    weekly: [
      { day: 'Mon', amount: 92.50 }, { day: 'Tue', amount: 168.00 }, { day: 'Wed', amount: 245.80 },
      { day: 'Thu', amount: 110.00 }, { day: 'Fri', amount: 190.20 }, { day: 'Sat', amount: 24.00 }, { day: 'Sun', amount: 12.00 },
    ],
    total_week: 842.50, today_balance: 124.80, total_online_hours: 34.33, total_trips: 142, rating: 4.95,
  });
});

/** GET /api/driver/requests */
router.get('/requests', authenticate, authorize('driver'), (_req: AuthRequest, res: Response) => {
  res.json({
    request: {
      ride_id: 'ride_pending_1', estimated_earnings: 18.45, surge_multiplier: 1.5,
      pickup_address: 'The Ferry Building, Embarcadero', dropoff_address: 'Mission District, 24th St',
      pickup_distance: 1.2, pickup_minutes: 4, trip_distance: 8.2, trip_minutes: 15,
      timeout_seconds: 22, ride_type: 'Premier',
    },
  });
});

/** POST /api/driver/requests/:id/accept */
router.post('/requests/:id/accept', authenticate, authorize('driver'), (req: AuthRequest, res: Response) => {
  res.json({ message: 'Ride accepted.', ride_id: req.params.id });
});

/** POST /api/driver/requests/:id/decline */
router.post('/requests/:id/decline', authenticate, authorize('driver'), (req: AuthRequest, res: Response) => {
  res.json({ message: 'Ride declined.', ride_id: req.params.id });
});

/** GET /api/driver/verification */
router.get('/verification', authenticate, authorize('driver'), (req: AuthRequest, res: Response) => {
  res.json({
    verified_count: 2, total_count: 4,
    documents: [
      { id: 'doc_1', name: "Driver's License", type: 'license', status: 'verified', verified_date: 'Oct 24' },
      { id: 'doc_2', name: 'Vehicle Insurance', type: 'insurance', status: 'verified', verified_date: 'Oct 25' },
      { id: 'doc_3', name: 'Background Check', type: 'background', status: 'pending' },
      { id: 'doc_4', name: 'Vehicle Registration', type: 'registration', status: 'action_required' },
    ],
  });
});

/** POST /api/driver/documents */
router.post('/documents', authenticate, authorize('driver'), (req: AuthRequest, res: Response) => {
  res.json({ message: 'Document uploaded.', document_id: `doc_${Date.now()}` });
});

export default router;
