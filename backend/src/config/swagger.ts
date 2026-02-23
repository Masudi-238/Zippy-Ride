export const swaggerDocument = {
  openapi: '3.0.3',
  info: {
    title: 'Zippy Ride API',
    description: 'Production-grade ride-sharing platform API',
    version: '1.0.0',
    contact: {
      name: 'Zippy Ride Engineering',
      email: 'engineering@zippyride.com',
    },
    license: {
      name: 'MIT',
    },
  },
  servers: [
    {
      url: '/api/v1',
      description: 'API v1',
    },
  ],
  components: {
    securitySchemes: {
      bearerAuth: {
        type: 'http',
        scheme: 'bearer',
        bearerFormat: 'JWT',
      },
    },
    schemas: {
      Error: {
        type: 'object',
        properties: {
          success: { type: 'boolean', example: false },
          message: { type: 'string' },
          code: { type: 'string' },
          errors: { type: 'array', items: { type: 'object' } },
        },
      },
      PaginatedResponse: {
        type: 'object',
        properties: {
          success: { type: 'boolean', example: true },
          data: { type: 'array', items: {} },
          pagination: {
            type: 'object',
            properties: {
              page: { type: 'integer' },
              limit: { type: 'integer' },
              total: { type: 'integer' },
              totalPages: { type: 'integer' },
            },
          },
        },
      },
      User: {
        type: 'object',
        properties: {
          id: { type: 'string', format: 'uuid' },
          email: { type: 'string', format: 'email' },
          phone: { type: 'string' },
          firstName: { type: 'string' },
          lastName: { type: 'string' },
          role: { type: 'string', enum: ['rider', 'driver', 'manager', 'super_admin'] },
          isVerified: { type: 'boolean' },
          isActive: { type: 'boolean' },
          createdAt: { type: 'string', format: 'date-time' },
        },
      },
      Ride: {
        type: 'object',
        properties: {
          id: { type: 'string', format: 'uuid' },
          riderId: { type: 'string', format: 'uuid' },
          driverId: { type: 'string', format: 'uuid' },
          status: {
            type: 'string',
            enum: ['requested', 'accepted', 'driver_en_route', 'arrived', 'in_progress', 'completed', 'cancelled'],
          },
          pickupLat: { type: 'number' },
          pickupLng: { type: 'number' },
          pickupAddress: { type: 'string' },
          dropoffLat: { type: 'number' },
          dropoffLng: { type: 'number' },
          dropoffAddress: { type: 'string' },
          estimatedFare: { type: 'number' },
          actualFare: { type: 'number' },
          distanceKm: { type: 'number' },
          durationMinutes: { type: 'number' },
          surgeMultiplier: { type: 'number' },
          createdAt: { type: 'string', format: 'date-time' },
        },
      },
      LoginRequest: {
        type: 'object',
        required: ['email', 'password'],
        properties: {
          email: { type: 'string', format: 'email' },
          password: { type: 'string', minLength: 8 },
        },
      },
      RegisterRequest: {
        type: 'object',
        required: ['email', 'password', 'firstName', 'lastName', 'phone'],
        properties: {
          email: { type: 'string', format: 'email' },
          password: { type: 'string', minLength: 8 },
          firstName: { type: 'string' },
          lastName: { type: 'string' },
          phone: { type: 'string' },
          role: { type: 'string', enum: ['rider', 'driver'] },
        },
      },
      CreateRideRequest: {
        type: 'object',
        required: ['pickupLat', 'pickupLng', 'pickupAddress', 'dropoffLat', 'dropoffLng', 'dropoffAddress'],
        properties: {
          pickupLat: { type: 'number' },
          pickupLng: { type: 'number' },
          pickupAddress: { type: 'string' },
          dropoffLat: { type: 'number' },
          dropoffLng: { type: 'number' },
          dropoffAddress: { type: 'string' },
          stops: {
            type: 'array',
            items: {
              type: 'object',
              properties: {
                lat: { type: 'number' },
                lng: { type: 'number' },
                address: { type: 'string' },
                order: { type: 'integer' },
              },
            },
          },
          vehicleType: { type: 'string', enum: ['economy', 'comfort', 'premium', 'xl'] },
          paymentMethod: { type: 'string', enum: ['wallet', 'cash', 'card'] },
        },
      },
    },
  },
  paths: {
    '/auth/register': {
      post: {
        tags: ['Authentication'],
        summary: 'Register a new user',
        requestBody: {
          required: true,
          content: {
            'application/json': {
              schema: { $ref: '#/components/schemas/RegisterRequest' },
            },
          },
        },
        responses: {
          '201': { description: 'User registered successfully' },
          '400': { description: 'Validation error' },
          '409': { description: 'Email already exists' },
        },
      },
    },
    '/auth/login': {
      post: {
        tags: ['Authentication'],
        summary: 'Login user',
        requestBody: {
          required: true,
          content: {
            'application/json': {
              schema: { $ref: '#/components/schemas/LoginRequest' },
            },
          },
        },
        responses: {
          '200': { description: 'Login successful' },
          '401': { description: 'Invalid credentials' },
        },
      },
    },
    '/auth/refresh': {
      post: {
        tags: ['Authentication'],
        summary: 'Refresh access token',
        security: [{ bearerAuth: [] }],
        responses: {
          '200': { description: 'Token refreshed' },
          '401': { description: 'Invalid refresh token' },
        },
      },
    },
    '/rides': {
      post: {
        tags: ['Rides'],
        summary: 'Create a new ride request',
        security: [{ bearerAuth: [] }],
        requestBody: {
          required: true,
          content: {
            'application/json': {
              schema: { $ref: '#/components/schemas/CreateRideRequest' },
            },
          },
        },
        responses: {
          '201': { description: 'Ride created' },
          '400': { description: 'Validation error' },
        },
      },
      get: {
        tags: ['Rides'],
        summary: 'List rides (filtered by role)',
        security: [{ bearerAuth: [] }],
        parameters: [
          { name: 'page', in: 'query', schema: { type: 'integer', default: 1 } },
          { name: 'limit', in: 'query', schema: { type: 'integer', default: 20 } },
          { name: 'status', in: 'query', schema: { type: 'string' } },
        ],
        responses: {
          '200': {
            description: 'List of rides',
            content: {
              'application/json': {
                schema: { $ref: '#/components/schemas/PaginatedResponse' },
              },
            },
          },
        },
      },
    },
    '/rides/{id}': {
      get: {
        tags: ['Rides'],
        summary: 'Get ride details',
        security: [{ bearerAuth: [] }],
        parameters: [
          { name: 'id', in: 'path', required: true, schema: { type: 'string', format: 'uuid' } },
        ],
        responses: {
          '200': { description: 'Ride details' },
          '404': { description: 'Ride not found' },
        },
      },
    },
    '/rides/{id}/accept': {
      post: {
        tags: ['Rides'],
        summary: 'Accept a ride (driver only)',
        security: [{ bearerAuth: [] }],
        parameters: [
          { name: 'id', in: 'path', required: true, schema: { type: 'string', format: 'uuid' } },
        ],
        responses: {
          '200': { description: 'Ride accepted' },
          '400': { description: 'Cannot accept ride' },
        },
      },
    },
    '/rides/{id}/cancel': {
      post: {
        tags: ['Rides'],
        summary: 'Cancel a ride',
        security: [{ bearerAuth: [] }],
        parameters: [
          { name: 'id', in: 'path', required: true, schema: { type: 'string', format: 'uuid' } },
        ],
        requestBody: {
          content: {
            'application/json': {
              schema: {
                type: 'object',
                properties: {
                  reason: { type: 'string' },
                },
              },
            },
          },
        },
        responses: {
          '200': { description: 'Ride cancelled' },
        },
      },
    },
    '/rides/{id}/complete': {
      post: {
        tags: ['Rides'],
        summary: 'Complete a ride (driver only)',
        security: [{ bearerAuth: [] }],
        parameters: [
          { name: 'id', in: 'path', required: true, schema: { type: 'string', format: 'uuid' } },
        ],
        responses: {
          '200': { description: 'Ride completed' },
        },
      },
    },
    '/users/me': {
      get: {
        tags: ['Users'],
        summary: 'Get current user profile',
        security: [{ bearerAuth: [] }],
        responses: {
          '200': { description: 'User profile' },
        },
      },
      patch: {
        tags: ['Users'],
        summary: 'Update current user profile',
        security: [{ bearerAuth: [] }],
        responses: {
          '200': { description: 'Profile updated' },
        },
      },
    },
    '/wallet': {
      get: {
        tags: ['Wallet'],
        summary: 'Get wallet balance and transactions',
        security: [{ bearerAuth: [] }],
        responses: {
          '200': { description: 'Wallet info' },
        },
      },
    },
    '/wallet/topup': {
      post: {
        tags: ['Wallet'],
        summary: 'Top up wallet',
        security: [{ bearerAuth: [] }],
        requestBody: {
          required: true,
          content: {
            'application/json': {
              schema: {
                type: 'object',
                required: ['amount'],
                properties: {
                  amount: { type: 'number', minimum: 1 },
                },
              },
            },
          },
        },
        responses: {
          '200': { description: 'Top up successful' },
        },
      },
    },
    '/admin/users': {
      get: {
        tags: ['Admin'],
        summary: 'List all users (admin only)',
        security: [{ bearerAuth: [] }],
        parameters: [
          { name: 'page', in: 'query', schema: { type: 'integer' } },
          { name: 'limit', in: 'query', schema: { type: 'integer' } },
          { name: 'role', in: 'query', schema: { type: 'string' } },
          { name: 'search', in: 'query', schema: { type: 'string' } },
        ],
        responses: {
          '200': { description: 'List of users' },
          '403': { description: 'Forbidden' },
        },
      },
    },
    '/admin/analytics': {
      get: {
        tags: ['Admin'],
        summary: 'Get platform analytics (admin only)',
        security: [{ bearerAuth: [] }],
        responses: {
          '200': { description: 'Analytics data' },
          '403': { description: 'Forbidden' },
        },
      },
    },
    '/admin/surge-pricing': {
      get: {
        tags: ['Admin'],
        summary: 'Get surge pricing rules',
        security: [{ bearerAuth: [] }],
        responses: {
          '200': { description: 'Surge pricing rules' },
        },
      },
      post: {
        tags: ['Admin'],
        summary: 'Create surge pricing rule',
        security: [{ bearerAuth: [] }],
        requestBody: {
          required: true,
          content: {
            'application/json': {
              schema: {
                type: 'object',
                required: ['name', 'multiplier', 'demandThreshold'],
                properties: {
                  name: { type: 'string' },
                  multiplier: { type: 'number', minimum: 1 },
                  demandThreshold: { type: 'integer' },
                  isActive: { type: 'boolean' },
                },
              },
            },
          },
        },
        responses: {
          '201': { description: 'Rule created' },
        },
      },
    },
    '/driver/availability': {
      patch: {
        tags: ['Driver'],
        summary: 'Toggle driver availability',
        security: [{ bearerAuth: [] }],
        requestBody: {
          required: true,
          content: {
            'application/json': {
              schema: {
                type: 'object',
                properties: {
                  isAvailable: { type: 'boolean' },
                  lat: { type: 'number' },
                  lng: { type: 'number' },
                },
              },
            },
          },
        },
        responses: {
          '200': { description: 'Availability updated' },
        },
      },
    },
    '/driver/earnings': {
      get: {
        tags: ['Driver'],
        summary: 'Get driver earnings',
        security: [{ bearerAuth: [] }],
        parameters: [
          { name: 'period', in: 'query', schema: { type: 'string', enum: ['daily', 'weekly', 'monthly'] } },
        ],
        responses: {
          '200': { description: 'Earnings data' },
        },
      },
    },
    '/driver/documents': {
      post: {
        tags: ['Driver'],
        summary: 'Upload driver document',
        security: [{ bearerAuth: [] }],
        responses: {
          '201': { description: 'Document uploaded' },
        },
      },
      get: {
        tags: ['Driver'],
        summary: 'Get driver documents',
        security: [{ bearerAuth: [] }],
        responses: {
          '200': { description: 'Driver documents' },
        },
      },
    },
    '/ratings': {
      post: {
        tags: ['Ratings'],
        summary: 'Submit a rating',
        security: [{ bearerAuth: [] }],
        requestBody: {
          required: true,
          content: {
            'application/json': {
              schema: {
                type: 'object',
                required: ['rideId', 'rating'],
                properties: {
                  rideId: { type: 'string', format: 'uuid' },
                  rating: { type: 'integer', minimum: 1, maximum: 5 },
                  comment: { type: 'string' },
                },
              },
            },
          },
        },
        responses: {
          '201': { description: 'Rating submitted' },
        },
      },
    },
    '/notifications': {
      get: {
        tags: ['Notifications'],
        summary: 'Get user notifications',
        security: [{ bearerAuth: [] }],
        parameters: [
          { name: 'page', in: 'query', schema: { type: 'integer' } },
          { name: 'limit', in: 'query', schema: { type: 'integer' } },
          { name: 'unreadOnly', in: 'query', schema: { type: 'boolean' } },
        ],
        responses: {
          '200': { description: 'Notifications list' },
        },
      },
    },
    '/manager/fleet': {
      get: {
        tags: ['Manager'],
        summary: 'Get fleet overview',
        security: [{ bearerAuth: [] }],
        responses: {
          '200': { description: 'Fleet data' },
        },
      },
    },
    '/manager/reports': {
      get: {
        tags: ['Manager'],
        summary: 'Get reports (CSV export ready)',
        security: [{ bearerAuth: [] }],
        parameters: [
          { name: 'type', in: 'query', schema: { type: 'string', enum: ['rides', 'earnings', 'drivers'] } },
          { name: 'startDate', in: 'query', schema: { type: 'string', format: 'date' } },
          { name: 'endDate', in: 'query', schema: { type: 'string', format: 'date' } },
          { name: 'format', in: 'query', schema: { type: 'string', enum: ['json', 'csv'] } },
        ],
        responses: {
          '200': { description: 'Report data' },
        },
      },
    },
  },
};
