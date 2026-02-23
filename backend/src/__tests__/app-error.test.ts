import { AppError } from '../shared/utils/app-error';

describe('AppError', () => {
  it('should create a bad request error', () => {
    const error = AppError.badRequest('Invalid input');
    expect(error.statusCode).toBe(400);
    expect(error.code).toBe('BAD_REQUEST');
    expect(error.message).toBe('Invalid input');
    expect(error.isOperational).toBe(true);
  });

  it('should create an unauthorized error', () => {
    const error = AppError.unauthorized();
    expect(error.statusCode).toBe(401);
    expect(error.code).toBe('UNAUTHORIZED');
  });

  it('should create a forbidden error', () => {
    const error = AppError.forbidden();
    expect(error.statusCode).toBe(403);
    expect(error.code).toBe('FORBIDDEN');
  });

  it('should create a not found error', () => {
    const error = AppError.notFound('User not found');
    expect(error.statusCode).toBe(404);
    expect(error.code).toBe('NOT_FOUND');
    expect(error.message).toBe('User not found');
  });

  it('should create a conflict error', () => {
    const error = AppError.conflict('Already exists');
    expect(error.statusCode).toBe(409);
    expect(error.code).toBe('CONFLICT');
  });

  it('should create a too many requests error', () => {
    const error = AppError.tooManyRequests();
    expect(error.statusCode).toBe(429);
    expect(error.code).toBe('TOO_MANY_REQUESTS');
  });

  it('should create an internal error (non-operational)', () => {
    const error = AppError.internal();
    expect(error.statusCode).toBe(500);
    expect(error.code).toBe('INTERNAL_ERROR');
    expect(error.isOperational).toBe(false);
  });

  it('should include validation errors', () => {
    const validationErrors = [{ field: 'email', message: 'Invalid' }];
    const error = AppError.badRequest('Validation failed', validationErrors);
    expect(error.errors).toEqual(validationErrors);
  });

  it('should be an instance of Error', () => {
    const error = AppError.notFound();
    expect(error).toBeInstanceOf(Error);
    expect(error).toBeInstanceOf(AppError);
  });
});
