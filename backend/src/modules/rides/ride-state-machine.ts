/**
 * Ride State Machine
 *
 * Defines valid state transitions for rides:
 *
 * requested -> accepted -> driver_en_route -> arrived -> in_progress -> completed
 *     |           |            |                |           |
 *     v           v            v                v           v
 *  cancelled   cancelled   cancelled       cancelled    cancelled (with penalty)
 */

export type RideStatus =
  | 'requested'
  | 'accepted'
  | 'driver_en_route'
  | 'arrived'
  | 'in_progress'
  | 'completed'
  | 'cancelled';

const VALID_TRANSITIONS: Record<RideStatus, RideStatus[]> = {
  requested: ['accepted', 'cancelled'],
  accepted: ['driver_en_route', 'cancelled'],
  driver_en_route: ['arrived', 'cancelled'],
  arrived: ['in_progress', 'cancelled'],
  in_progress: ['completed', 'cancelled'],
  completed: [],
  cancelled: [],
};

const WHO_CAN_TRANSITION: Record<string, string[]> = {
  'requested->accepted': ['driver'],
  'requested->cancelled': ['rider', 'driver', 'manager', 'super_admin'],
  'accepted->driver_en_route': ['driver'],
  'accepted->cancelled': ['rider', 'driver', 'manager', 'super_admin'],
  'driver_en_route->arrived': ['driver'],
  'driver_en_route->cancelled': ['rider', 'driver', 'manager', 'super_admin'],
  'arrived->in_progress': ['driver'],
  'arrived->cancelled': ['rider', 'driver', 'manager', 'super_admin'],
  'in_progress->completed': ['driver'],
  'in_progress->cancelled': ['driver', 'manager', 'super_admin'],
};

export class RideStateMachine {
  /**
   * Check if a status transition is valid
   */
  static isValidTransition(currentStatus: RideStatus, newStatus: RideStatus): boolean {
    const validNext = VALID_TRANSITIONS[currentStatus];
    return validNext?.includes(newStatus) ?? false;
  }

  /**
   * Check if a user role can perform a transition
   */
  static canTransition(currentStatus: RideStatus, newStatus: RideStatus, userRole: string): boolean {
    if (!this.isValidTransition(currentStatus, newStatus)) {
      return false;
    }

    const key = `${currentStatus}->${newStatus}`;
    const allowedRoles = WHO_CAN_TRANSITION[key];

    if (!allowedRoles) return false;

    return allowedRoles.includes(userRole);
  }

  /**
   * Get valid next states for a given status and role
   */
  static getValidNextStates(currentStatus: RideStatus, userRole: string): RideStatus[] {
    const validNext = VALID_TRANSITIONS[currentStatus] ?? [];
    return validNext.filter((nextStatus) => {
      const key = `${currentStatus}->${nextStatus}`;
      const allowedRoles = WHO_CAN_TRANSITION[key];
      return allowedRoles?.includes(userRole) ?? false;
    });
  }
}
