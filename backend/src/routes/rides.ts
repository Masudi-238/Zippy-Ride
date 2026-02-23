import { Router, Response } from 'express';
import { authenticate, authorize, AuthRequest } from '../middleware/auth';

const router = Router();

/** POST /api/rides - Create a ride (rider only) */
router.post('/', authenticate, authorize('rider'), (req: AuthRequest, res: Response) => {
  const { type, pickup_address, dropoff_address, stops } = req.body;
  const ride = {
    id: `ride_${Date.now()}`,
    rider_id: req.user!.id,
    type: type || 'economy',
    status: 'pending',
    pickup: { latitude: 37.7749, longitude: -122.4194, address: pickup_address || 'Current Location' },
    dropoff: { latitude: 37.7849, longitude: -122.4094, address: dropoff_address || 'Destination' },
    stops: stops || [],
    estimated_price: type === 'luxury' ? 29.90 : type === 'xl' ? 18.25 : 12.50,
    created_at: new Date().toISOString(),
  };
  res.status(201).json({ ride });
});

/** GET /api/rides/estimate */
router.get('/estimate', authenticate, (req: AuthRequest, res: Response) => {
  res.json({
    estimates: [
      { type: 'economy', price: 12.50, eta_minutes: 3 },
      { type: 'xl', price: 18.25, eta_minutes: 6 },
      { type: 'luxury', price: 29.90, eta_minutes: 9 },
    ],
  });
});

/** GET /api/rides/history */
router.get('/history', authenticate, (req: AuthRequest, res: Response) => {
  res.json({
    rides: [
      { id: 'ride_1', rider_id: req.user!.id, type: 'economy', status: 'completed', pickup: { latitude: 37.62, longitude: -122.38, address: 'Terminal 2, SFO Airport' }, dropoff: { latitude: 37.79, longitude: -122.41, address: '123 Maple St, San Francisco' }, estimated_price: 14.50, final_price: 14.50, distance: 12.5, duration: 25, rating: null, created_at: '2023-10-24T14:30:00Z', completed_at: '2023-10-24T14:55:00Z' },
      { id: 'ride_2', rider_id: req.user!.id, type: 'xl', status: 'completed', pickup: { latitude: 37.79, longitude: -122.40, address: '88 Market St, Financial District' }, dropoff: { latitude: 37.76, longitude: -122.51, address: 'Ocean Beach, Great Hwy' }, estimated_price: 32.00, final_price: 32.00, distance: 8.2, duration: 20, rating: 4, created_at: '2023-10-21T08:15:00Z', completed_at: '2023-10-21T08:35:00Z' },
      { id: 'ride_3', rider_id: req.user!.id, type: 'economy', status: 'cancelled', pickup: { latitude: 37.78, longitude: -122.43, address: 'The Fillmore, Geary Blvd' }, dropoff: { latitude: 37.77, longitude: -122.42, address: 'Home' }, estimated_price: 8.00, created_at: '2023-10-19T23:45:00Z' },
    ],
  });
});

/** POST /api/rides/cancel */
router.post('/cancel', authenticate, (req: AuthRequest, res: Response) => {
  res.json({ message: 'Ride cancelled successfully.', ride_id: req.body.ride_id });
});

/** POST /api/rides/rate */
router.post('/rate', authenticate, (req: AuthRequest, res: Response) => {
  res.json({ message: 'Rating submitted.', ride_id: req.body.ride_id, rating: req.body.rating });
});

export default router;
