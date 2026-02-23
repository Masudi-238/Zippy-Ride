import { AppError } from '../../shared/utils/app-error';
import { WebSocketService } from '../../shared/services/websocket.service';
import { RideRepository, RideRow } from './ride.repository';
import { CreateRideInput } from './ride.validation';
import { FareCalculatorService } from './fare-calculator.service';
import { SurgePricingService } from './surge-pricing.service';
import { RideStateMachine, RideStatus } from './ride-state-machine';
import { WalletService } from '../wallet/wallet.service';
import { CommissionService } from '../wallet/commission.service';

export class RideService {
  private rideRepository: RideRepository;
  private walletService: WalletService;
  private commissionService: CommissionService;

  constructor() {
    this.rideRepository = new RideRepository();
    this.walletService = new WalletService();
    this.commissionService = new CommissionService();
  }

  async createRide(riderId: string, input: CreateRideInput): Promise<RideRow> {
    // Calculate distance and duration estimates
    const distanceKm = FareCalculatorService.estimateDistance(
      input.pickupLat, input.pickupLng,
      input.dropoffLat, input.dropoffLng,
    );
    const durationMinutes = FareCalculatorService.estimateDuration(distanceKm);

    // Get surge multiplier
    const surgeMultiplier = await SurgePricingService.getSurgeMultiplier(
      input.pickupLat, input.pickupLng,
    );

    // Calculate fare
    const fareBreakdown = FareCalculatorService.calculateFare(
      distanceKm,
      durationMinutes,
      input.vehicleType,
      surgeMultiplier,
      input.stops?.length ?? 0,
    );

    // Create ride
    const ride = await this.rideRepository.create({
      riderId,
      pickupLat: input.pickupLat,
      pickupLng: input.pickupLng,
      pickupAddress: input.pickupAddress,
      dropoffLat: input.dropoffLat,
      dropoffLng: input.dropoffLng,
      dropoffAddress: input.dropoffAddress,
      vehicleType: input.vehicleType,
      paymentMethod: input.paymentMethod,
      estimatedFare: fareBreakdown.estimatedFare,
      estimatedDistanceKm: distanceKm,
      estimatedDurationMinutes: durationMinutes,
      baseFare: fareBreakdown.baseFare,
      distanceFare: fareBreakdown.distanceFare,
      timeFare: fareBreakdown.timeFare,
      surgeMultiplier,
    });

    // Add stops if any
    if (input.stops && input.stops.length > 0) {
      await this.rideRepository.addStops(ride.id, input.stops);
    }

    // Notify available drivers via WebSocket
    try {
      WebSocketService.emitToRole('driver', 'ride:new', {
        rideId: ride.id,
        pickup: { lat: input.pickupLat, lng: input.pickupLng, address: input.pickupAddress },
        dropoff: { lat: input.dropoffLat, lng: input.dropoffLng, address: input.dropoffAddress },
        vehicleType: input.vehicleType,
        estimatedFare: fareBreakdown.estimatedFare,
      });
    } catch {
      // WebSocket not available in test
    }

    return ride;
  }

  async getRide(rideId: string, userId: string, userRole: string): Promise<{
    ride: RideRow;
    stops: unknown[];
  }> {
    const ride = await this.rideRepository.findById(rideId);
    if (!ride) {
      throw AppError.notFound('Ride not found');
    }

    // Access control
    if (userRole === 'rider' && ride.rider_id !== userId) {
      throw AppError.forbidden('You can only view your own rides');
    }
    if (userRole === 'driver' && ride.driver_id !== userId) {
      throw AppError.forbidden('You can only view rides assigned to you');
    }

    const stops = await this.rideRepository.findStopsByRideId(rideId);

    return { ride, stops };
  }

  async getRides(userId: string, userRole: string, page: number, limit: number, status?: string) {
    switch (userRole) {
      case 'rider':
        return this.rideRepository.findByRider(userId, status, page, limit);
      case 'driver':
        return this.rideRepository.findByDriver(userId, status, page, limit);
      case 'manager':
      case 'super_admin':
        return this.rideRepository.findAllRides(page, limit, status);
      default:
        throw AppError.forbidden('Invalid role');
    }
  }

  async acceptRide(rideId: string, driverId: string): Promise<RideRow> {
    const ride = await this.rideRepository.findById(rideId);
    if (!ride) throw AppError.notFound('Ride not found');

    if (!RideStateMachine.canTransition(ride.status as RideStatus, 'accepted', 'driver')) {
      throw AppError.badRequest(`Cannot accept ride in status: ${ride.status}`);
    }

    const updated = await this.rideRepository.updateStatus(rideId, 'accepted', {
      driver_id: driverId,
      accepted_at: new Date(),
    });

    // Notify rider
    try {
      WebSocketService.emitToUser(ride.rider_id, 'ride:accepted', {
        rideId,
        driverId,
      });
      WebSocketService.emitToRide(rideId, 'ride:status', { rideId, status: 'accepted' });
    } catch {
      // WebSocket not available
    }

    return updated!;
  }

  async updateRideStatus(
    rideId: string,
    newStatus: RideStatus,
    userId: string,
    userRole: string,
    reason?: string,
  ): Promise<RideRow> {
    const ride = await this.rideRepository.findById(rideId);
    if (!ride) throw AppError.notFound('Ride not found');

    if (!RideStateMachine.canTransition(ride.status as RideStatus, newStatus, userRole)) {
      throw AppError.badRequest(
        `Cannot transition from '${ride.status}' to '${newStatus}' as ${userRole}`,
      );
    }

    const additionalFields: Record<string, unknown> = {};

    switch (newStatus) {
      case 'in_progress':
        additionalFields.started_at = new Date();
        break;
      case 'completed':
        additionalFields.completed_at = new Date();
        additionalFields.actual_fare = ride.estimated_fare;
        additionalFields.actual_distance_km = ride.estimated_distance_km;
        additionalFields.payment_status = 'completed';

        // Process payment
        if (ride.payment_method === 'wallet' && ride.estimated_fare) {
          await this.walletService.processRidePayment(
            ride.rider_id,
            ride.driver_id!,
            ride.id,
            Number(ride.estimated_fare),
          );
        }

        // Calculate commission
        if (ride.driver_id && ride.estimated_fare) {
          await this.commissionService.calculateAndSave(
            ride.id,
            ride.driver_id,
            Number(ride.estimated_fare),
          );
        }
        break;
      case 'cancelled':
        additionalFields.cancelled_at = new Date();
        additionalFields.cancelled_by = userId;
        additionalFields.cancellation_reason = reason;
        break;
    }

    const updated = await this.rideRepository.updateStatus(rideId, newStatus, additionalFields);

    // WebSocket notification
    try {
      WebSocketService.emitToRide(rideId, 'ride:status', { rideId, status: newStatus });
      if (ride.rider_id) {
        WebSocketService.emitToUser(ride.rider_id, 'ride:status', { rideId, status: newStatus });
      }
      if (ride.driver_id) {
        WebSocketService.emitToUser(ride.driver_id, 'ride:status', { rideId, status: newStatus });
      }
    } catch {
      // WebSocket not available
    }

    return updated!;
  }

  async getPendingRides(page: number, limit: number) {
    return this.rideRepository.findPendingRides(page, limit);
  }
}
