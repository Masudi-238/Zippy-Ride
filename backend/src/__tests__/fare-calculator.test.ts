import { FareCalculatorService } from '../modules/rides/fare-calculator.service';

describe('FareCalculatorService', () => {
  describe('calculateFare', () => {
    it('should calculate economy fare correctly', () => {
      const result = FareCalculatorService.calculateFare(10, 20, 'economy', 1.0, 0);

      expect(result.baseFare).toBe(2.50);
      expect(result.distanceFare).toBe(12.00); // 10 * 1.20
      expect(result.timeFare).toBe(3.00); // 20 * 0.15
      expect(result.surgeMultiplier).toBe(1.0);
      expect(result.multiStopSurcharge).toBe(0);
      expect(result.estimatedFare).toBe(17.50); // 2.50 + 12.00 + 3.00
    });

    it('should apply surge multiplier', () => {
      const result = FareCalculatorService.calculateFare(10, 20, 'economy', 2.0, 0);

      expect(result.surgeMultiplier).toBe(2.0);
      expect(result.estimatedFare).toBe(35.00); // (2.50 + 12.00 + 3.00) * 2.0
    });

    it('should apply multi-stop surcharge', () => {
      const result = FareCalculatorService.calculateFare(10, 20, 'economy', 1.0, 2);

      expect(result.multiStopSurcharge).toBe(4.00); // 2 * 2.00
      expect(result.estimatedFare).toBe(21.50); // 2.50 + 12.00 + 3.00 + 4.00
    });

    it('should enforce minimum fare', () => {
      const result = FareCalculatorService.calculateFare(0.5, 2, 'economy', 1.0, 0);

      // Calculated: 2.50 + 0.60 + 0.30 = 3.40 < 5.00 minimum
      expect(result.estimatedFare).toBe(5.00);
    });

    it('should calculate premium fare correctly', () => {
      const result = FareCalculatorService.calculateFare(10, 20, 'premium', 1.0, 0);

      expect(result.baseFare).toBe(5.00);
      expect(result.distanceFare).toBe(25.00); // 10 * 2.50
      expect(result.timeFare).toBe(8.00); // 20 * 0.40
      expect(result.estimatedFare).toBe(38.00);
    });

    it('should calculate comfort fare correctly', () => {
      const result = FareCalculatorService.calculateFare(5, 15, 'comfort', 1.0, 0);

      expect(result.baseFare).toBe(3.50);
      expect(result.distanceFare).toBe(9.00); // 5 * 1.80
      expect(result.timeFare).toBe(3.75); // 15 * 0.25
      expect(result.estimatedFare).toBe(16.25);
    });

    it('should default to economy for unknown vehicle type', () => {
      const result = FareCalculatorService.calculateFare(10, 20, 'unknown', 1.0, 0);

      expect(result.baseFare).toBe(2.50);
    });
  });

  describe('estimateDistance', () => {
    it('should calculate distance between two points', () => {
      // New York to JFK Airport (roughly 20km)
      const distance = FareCalculatorService.estimateDistance(
        40.7128, -74.0060, // NYC
        40.6413, -73.7781, // JFK
      );

      expect(distance).toBeGreaterThan(15);
      expect(distance).toBeLessThan(30);
    });

    it('should return 0 for same point', () => {
      const distance = FareCalculatorService.estimateDistance(40.7128, -74.0060, 40.7128, -74.0060);
      expect(distance).toBe(0);
    });
  });

  describe('estimateDuration', () => {
    it('should estimate duration based on distance', () => {
      const duration = FareCalculatorService.estimateDuration(15); // 15km
      // At 30 km/h, 15km = 30 minutes
      expect(duration).toBe(30);
    });

    it('should return 0 for 0 distance', () => {
      const duration = FareCalculatorService.estimateDuration(0);
      expect(duration).toBe(0);
    });
  });
});
