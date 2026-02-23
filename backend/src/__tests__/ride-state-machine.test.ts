import { RideStateMachine, RideStatus } from '../modules/rides/ride-state-machine';

describe('RideStateMachine', () => {
  describe('isValidTransition', () => {
    it('should allow requested -> accepted', () => {
      expect(RideStateMachine.isValidTransition('requested', 'accepted')).toBe(true);
    });

    it('should allow requested -> cancelled', () => {
      expect(RideStateMachine.isValidTransition('requested', 'cancelled')).toBe(true);
    });

    it('should allow accepted -> driver_en_route', () => {
      expect(RideStateMachine.isValidTransition('accepted', 'driver_en_route')).toBe(true);
    });

    it('should allow in_progress -> completed', () => {
      expect(RideStateMachine.isValidTransition('in_progress', 'completed')).toBe(true);
    });

    it('should NOT allow requested -> completed (skip states)', () => {
      expect(RideStateMachine.isValidTransition('requested', 'completed')).toBe(false);
    });

    it('should NOT allow completed -> cancelled', () => {
      expect(RideStateMachine.isValidTransition('completed', 'cancelled')).toBe(false);
    });

    it('should NOT allow cancelled -> anything', () => {
      expect(RideStateMachine.isValidTransition('cancelled', 'requested')).toBe(false);
      expect(RideStateMachine.isValidTransition('cancelled', 'accepted')).toBe(false);
    });
  });

  describe('canTransition', () => {
    it('should allow driver to accept a ride', () => {
      expect(RideStateMachine.canTransition('requested', 'accepted', 'driver')).toBe(true);
    });

    it('should NOT allow rider to accept a ride', () => {
      expect(RideStateMachine.canTransition('requested', 'accepted', 'rider')).toBe(false);
    });

    it('should allow rider to cancel a requested ride', () => {
      expect(RideStateMachine.canTransition('requested', 'cancelled', 'rider')).toBe(true);
    });

    it('should allow driver to complete a ride', () => {
      expect(RideStateMachine.canTransition('in_progress', 'completed', 'driver')).toBe(true);
    });

    it('should NOT allow rider to complete a ride', () => {
      expect(RideStateMachine.canTransition('in_progress', 'completed', 'rider')).toBe(false);
    });

    it('should allow super_admin to cancel any ride', () => {
      expect(RideStateMachine.canTransition('in_progress', 'cancelled', 'super_admin')).toBe(true);
    });

    it('should NOT allow rider to cancel in_progress ride', () => {
      expect(RideStateMachine.canTransition('in_progress', 'cancelled', 'rider')).toBe(false);
    });
  });

  describe('getValidNextStates', () => {
    it('should return valid next states for driver with requested ride', () => {
      const states = RideStateMachine.getValidNextStates('requested', 'driver');
      expect(states).toContain('accepted');
      expect(states).toContain('cancelled');
    });

    it('should return only cancel for rider with requested ride', () => {
      const states = RideStateMachine.getValidNextStates('requested', 'rider');
      expect(states).toEqual(['cancelled']);
    });

    it('should return empty array for completed ride', () => {
      const states = RideStateMachine.getValidNextStates('completed', 'driver');
      expect(states).toEqual([]);
    });
  });
});
