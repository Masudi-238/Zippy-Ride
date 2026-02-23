import { z } from 'zod';

export const createRideSchema = z.object({
  pickupLat: z.number().min(-90).max(90),
  pickupLng: z.number().min(-180).max(180),
  pickupAddress: z.string().min(1),
  dropoffLat: z.number().min(-90).max(90),
  dropoffLng: z.number().min(-180).max(180),
  dropoffAddress: z.string().min(1),
  vehicleType: z.enum(['economy', 'comfort', 'premium', 'xl']).default('economy'),
  paymentMethod: z.enum(['wallet', 'cash', 'card']).default('wallet'),
  stops: z.array(z.object({
    lat: z.number().min(-90).max(90),
    lng: z.number().min(-180).max(180),
    address: z.string().min(1),
    order: z.number().int().min(1),
  })).optional(),
});

export const updateRideStatusSchema = z.object({
  status: z.enum(['accepted', 'driver_en_route', 'arrived', 'in_progress', 'completed', 'cancelled']),
  reason: z.string().optional(),
});

export const rideQuerySchema = z.object({
  page: z.coerce.number().int().min(1).default(1),
  limit: z.coerce.number().int().min(1).max(100).default(20),
  status: z.string().optional(),
});

export type CreateRideInput = z.infer<typeof createRideSchema>;
export type UpdateRideStatusInput = z.infer<typeof updateRideStatusSchema>;
