/// Base class for all API exceptions in Zippy Ride.
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  const ApiException({
    required this.message,
    this.statusCode,
    this.data,
  });

  @override
  String toString() => 'ApiException($statusCode): $message';
}

/// Thrown when authentication fails (401)
class UnauthorizedException extends ApiException {
  const UnauthorizedException({
    super.message = 'Authentication required. Please log in again.',
    super.statusCode = 401,
  });
}

/// Thrown when the server returns a 403
class ForbiddenException extends ApiException {
  const ForbiddenException({
    super.message = 'You do not have permission to perform this action.',
    super.statusCode = 403,
  });
}

/// Thrown when a resource is not found (404)
class NotFoundException extends ApiException {
  const NotFoundException({
    super.message = 'The requested resource was not found.',
    super.statusCode = 404,
  });
}

/// Thrown when the server returns a validation error (422)
class ValidationException extends ApiException {
  final Map<String, List<String>>? errors;

  const ValidationException({
    super.message = 'Validation failed. Please check your input.',
    super.statusCode = 422,
    this.errors,
  });
}

/// Thrown when the server encounters an internal error (500)
class ServerException extends ApiException {
  const ServerException({
    super.message = 'Something went wrong. Please try again later.',
    super.statusCode = 500,
  });
}

/// Thrown when a network error occurs
class NetworkException extends ApiException {
  const NetworkException({
    super.message = 'No internet connection. Please check your network.',
    super.statusCode,
  });
}

/// Thrown when a request times out
class TimeoutException extends ApiException {
  const TimeoutException({
    super.message = 'Request timed out. Please try again.',
    super.statusCode,
  });
}
