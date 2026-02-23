import { Response } from 'express';

export interface PaginationMeta {
  page: number;
  limit: number;
  total: number;
  totalPages: number;
}

export class ApiResponse {
  static success<T>(res: Response, data: T, statusCode = 200): Response {
    return res.status(statusCode).json({
      success: true,
      data,
    });
  }

  static created<T>(res: Response, data: T): Response {
    return ApiResponse.success(res, data, 201);
  }

  static paginated<T>(res: Response, data: T[], pagination: PaginationMeta): Response {
    return res.status(200).json({
      success: true,
      data,
      pagination,
    });
  }

  static error(res: Response, message: string, statusCode = 500, code?: string, errors?: unknown[]): Response {
    return res.status(statusCode).json({
      success: false,
      message,
      code: code ?? 'INTERNAL_ERROR',
      errors,
    });
  }

  static noContent(res: Response): Response {
    return res.status(204).send();
  }
}

export function buildPaginationMeta(page: number, limit: number, total: number): PaginationMeta {
  return {
    page,
    limit,
    total,
    totalPages: Math.ceil(total / limit),
  };
}
