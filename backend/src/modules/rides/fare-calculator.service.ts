/**
 * Fare Calculation Engine
 *
 * Calculates ride fares based on:
 * - Base fare (varies by vehicle type)
 * - Distance-based pricing (per km)
 * - Time-based pricing (per minute)
 * - Surge multiplier
 * - Multi-stop surcharge
 */

export interface FareBreakdown {
  baseFare: number;
  distanceFare: number;
  timeFare: number;
  surgeMultiplier: number;
  multiStopSurcharge: number;
  estimatedFare: number;
}

interface VehiclePricing {
  baseFare: number;
  perKm: number;
  perMinute: number;
  minimumFare: number;
}

const VEHICLE_PRICING: Record<string, VehiclePricing> = {
  economy: {
    baseFare: 2.50,
    perKm: 1.20,
    perMinute: 0.15,
    minimumFare: 5.00,
  },
  comfort: {
    baseFare: 3.50,
    perKm: 1.80,
    perMinute: 0.25,
    minimumFare: 8.00,
  },
  premium: {
    baseFare: 5.00,
    perKm: 2.50,
    perMinute: 0.40,
    minimumFare: 12.00,
  },
  xl: {
    baseFare: 4.00,
    perKm: 2.00,
    perMinute: 0.30,
    minimumFare: 10.00,
  },
};

const MULTI_STOP_SURCHARGE = 2.00; // per additional stop

export class FareCalculatorService {
  /**
   * Calculate fare estimate for a ride
   */
  static calculateFare(
    distanceKm: number,
    durationMinutes: number,
    vehicleType: string,
    surgeMultiplier = 1.0,
    numberOfStops = 0,
  ): FareBreakdown {
    const pricing = VEHICLE_PRICING[vehicleType] ?? VEHICLE_PRICING.economy;

    const baseFare = pricing.baseFare;
    const distanceFare = Math.round(distanceKm * pricing.perKm * 100) / 100;
    const timeFare = Math.round(durationMinutes * pricing.perMinute * 100) / 100;
    const multiStopSurcharge = numberOfStops * MULTI_STOP_SURCHARGE;

    const subtotal = baseFare + distanceFare + timeFare + multiStopSurcharge;
    const surgedTotal = Math.round(subtotal * surgeMultiplier * 100) / 100;
    const estimatedFare = Math.max(surgedTotal, pricing.minimumFare);

    return {
      baseFare,
      distanceFare,
      timeFare,
      surgeMultiplier,
      multiStopSurcharge,
      estimatedFare,
    };
  }

  /**
   * Estimate distance between two coordinates using Haversine formula
   */
  static estimateDistance(
    lat1: number, lng1: number,
    lat2: number, lng2: number,
  ): number {
    const R = 6371; // Earth radius in km
    const dLat = this.toRad(lat2 - lat1);
    const dLng = this.toRad(lng2 - lng1);
    const a =
      Math.sin(dLat / 2) * Math.sin(dLat / 2) +
      Math.cos(this.toRad(lat1)) * Math.cos(this.toRad(lat2)) *
      Math.sin(dLng / 2) * Math.sin(dLng / 2);
    const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    const straightLine = R * c;

    // Apply road factor (roads are ~1.3x longer than straight line)
    return Math.round(straightLine * 1.3 * 100) / 100;
  }

  /**
   * Estimate duration based on distance (rough estimate)
   */
  static estimateDuration(distanceKm: number): number {
    // Assume average speed of 30 km/h in urban areas
    const avgSpeedKmh = 30;
    return Math.round((distanceKm / avgSpeedKmh) * 60);
  }

  private static toRad(deg: number): number {
    return deg * (Math.PI / 180);
  }
}
