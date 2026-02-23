import { Request, Response } from 'express';
import { AdminService } from './admin.service';
import { SurgePricingService } from '../rides/surge-pricing.service';
import { ApiResponse, buildPaginationMeta } from '../../shared/utils/api-response';

const adminService = new AdminService();

export class AdminController {
  static async getUsers(req: Request, res: Response): Promise<void> {
    const { page = 1, limit = 20, role, search } = req.query as {
      page?: number; limit?: number; role?: string; search?: string;
    };
    const { users, total } = await adminService.getUsers(Number(page), Number(limit), role, search);
    ApiResponse.paginated(res, users, buildPaginationMeta(Number(page), Number(limit), total));
  }

  static async suspendUser(req: Request, res: Response): Promise<void> {
    await adminService.suspendUser(req.params.userId);
    ApiResponse.success(res, { message: 'User suspended' });
  }

  static async activateUser(req: Request, res: Response): Promise<void> {
    await adminService.activateUser(req.params.userId);
    ApiResponse.success(res, { message: 'User activated' });
  }

  static async verifyUser(req: Request, res: Response): Promise<void> {
    await adminService.verifyUser(req.params.userId);
    ApiResponse.success(res, { message: 'User verified' });
  }

  static async getAnalytics(req: Request, res: Response): Promise<void> {
    const analytics = await adminService.getAnalytics();
    ApiResponse.success(res, analytics);
  }

  static async getFleetOverview(req: Request, res: Response): Promise<void> {
    const { page = 1, limit = 20 } = req.query as { page?: number; limit?: number };
    const fleet = await adminService.getFleetOverview(Number(page), Number(limit));
    ApiResponse.success(res, fleet);
  }

  static async getReports(req: Request, res: Response): Promise<void> {
    const { type, startDate, endDate, format } = req.query as {
      type: 'rides' | 'earnings' | 'drivers';
      startDate?: string;
      endDate?: string;
      format?: string;
    };

    const data = await adminService.generateReport(type, startDate, endDate);

    if (format === 'csv') {
      if (data.length === 0) {
        res.setHeader('Content-Type', 'text/csv');
        res.send('No data');
        return;
      }
      const headers = Object.keys(data[0] as object).join(',');
      const rows = data.map((row) =>
        Object.values(row as object).map((v) => `"${v}"`).join(','),
      );
      const csv = [headers, ...rows].join('\n');
      res.setHeader('Content-Type', 'text/csv');
      res.setHeader('Content-Disposition', `attachment; filename=${type}_report.csv`);
      res.send(csv);
      return;
    }

    ApiResponse.success(res, data);
  }

  // Surge Pricing
  static async getSurgePricingRules(_req: Request, res: Response): Promise<void> {
    const rules = await SurgePricingService.getRules();
    ApiResponse.success(res, rules);
  }

  static async createSurgePricingRule(req: Request, res: Response): Promise<void> {
    const rule = await SurgePricingService.createRule({
      ...req.body,
      createdBy: req.user!.userId,
    });
    ApiResponse.created(res, rule);
  }

  static async updateSurgePricingRule(req: Request, res: Response): Promise<void> {
    const rule = await SurgePricingService.updateRule(req.params.ruleId, req.body);
    ApiResponse.success(res, rule);
  }
}
