import { DatabasePool } from '../../database/pool';
import { logger } from '../../shared/utils/logger';

interface SurgeRule {
  id: string;
  name: string;
  multiplier: number;
  demand_threshold: number;
  supply_threshold: number | null;
  is_active: boolean;
}

/**
 * Surge Pricing Algorithm
 *
 * Determines the surge multiplier based on:
 * - Current demand (number of ride requests in area)
 * - Available supply (number of online drivers in area)
 * - Active surge pricing rules
 * - Time-based factors (peak hours)
 */
export class SurgePricingService {
  /**
   * Calculate current surge multiplier for a given area
   */
  static async getSurgeMultiplier(
    lat: number,
    lng: number,
    radiusKm = 5,
  ): Promise<number> {
    try {
      // Count recent ride requests in area (last 15 minutes)
      const demandResult = await DatabasePool.query<{ count: string }>(
        `SELECT COUNT(*) FROM rides
         WHERE status IN ('requested', 'accepted')
         AND pickup_lat BETWEEN $1 AND $2
         AND pickup_lng BETWEEN $3 AND $4
         AND created_at > NOW() - INTERVAL '15 minutes'`,
        [
          lat - (radiusKm / 111), lat + (radiusKm / 111),
          lng - (radiusKm / (111 * Math.cos(lat * Math.PI / 180))),
          lng + (radiusKm / (111 * Math.cos(lat * Math.PI / 180))),
        ],
      );

      const demand = parseInt(demandResult.rows[0].count, 10);

      // Get active surge rules sorted by threshold descending
      const rulesResult = await DatabasePool.query<SurgeRule>(
        `SELECT * FROM surge_pricing_rules
         WHERE is_active = TRUE
         AND (valid_from IS NULL OR valid_from <= NOW())
         AND (valid_until IS NULL OR valid_until >= NOW())
         ORDER BY demand_threshold DESC`,
      );

      // Find the highest matching rule
      for (const rule of rulesResult.rows) {
        if (demand >= rule.demand_threshold) {
          logger.info(`Surge pricing applied: ${rule.name} (${rule.multiplier}x) for demand=${demand}`);
          return rule.multiplier;
        }
      }

      return 1.0; // No surge
    } catch (error) {
      logger.error('Error calculating surge multiplier:', error);
      return 1.0; // Default to no surge on error
    }
  }

  /**
   * Get all surge pricing rules
   */
  static async getRules(): Promise<SurgeRule[]> {
    const result = await DatabasePool.query<SurgeRule>(
      'SELECT * FROM surge_pricing_rules ORDER BY demand_threshold ASC',
    );
    return result.rows;
  }

  /**
   * Create a new surge pricing rule
   */
  static async createRule(data: {
    name: string;
    description?: string;
    multiplier: number;
    demandThreshold: number;
    supplyThreshold?: number;
    isActive?: boolean;
    createdBy?: string;
  }): Promise<SurgeRule> {
    const result = await DatabasePool.query<SurgeRule>(
      `INSERT INTO surge_pricing_rules (name, description, multiplier, demand_threshold, supply_threshold, is_active, created_by)
       VALUES ($1, $2, $3, $4, $5, $6, $7)
       RETURNING *`,
      [data.name, data.description, data.multiplier, data.demandThreshold, data.supplyThreshold, data.isActive ?? true, data.createdBy],
    );
    return result.rows[0];
  }

  /**
   * Update a surge pricing rule
   */
  static async updateRule(id: string, data: Partial<{
    name: string;
    multiplier: number;
    demandThreshold: number;
    isActive: boolean;
  }>): Promise<SurgeRule | null> {
    const setClauses: string[] = [];
    const params: unknown[] = [id];
    let idx = 2;

    if (data.name !== undefined) { setClauses.push(`name = $${idx++}`); params.push(data.name); }
    if (data.multiplier !== undefined) { setClauses.push(`multiplier = $${idx++}`); params.push(data.multiplier); }
    if (data.demandThreshold !== undefined) { setClauses.push(`demand_threshold = $${idx++}`); params.push(data.demandThreshold); }
    if (data.isActive !== undefined) { setClauses.push(`is_active = $${idx++}`); params.push(data.isActive); }

    if (setClauses.length === 0) return null;

    const result = await DatabasePool.query<SurgeRule>(
      `UPDATE surge_pricing_rules SET ${setClauses.join(', ')} WHERE id = $1 RETURNING *`,
      params,
    );
    return result.rows[0] ?? null;
  }
}
