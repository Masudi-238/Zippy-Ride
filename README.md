# Zippy Ride

**Production-grade ride-sharing platform built for scale.**

Zippy Ride is a full-stack, venture-ready ride-sharing application designed to handle millions of users globally. The architecture follows clean architecture principles with a modular monolith backend that's ready to split into microservices, and a feature-based Flutter mobile application.

---

## Architecture Overview

```
zippy-ride/
├── backend/                    # Node.js/TypeScript API server
│   ├── src/
│   │   ├── config/             # Environment, Swagger config
│   │   ├── database/           # PostgreSQL pool, migrations, seeds
│   │   ├── modules/            # Feature modules (auth, rides, wallet, driver, admin, etc.)
│   │   ├── routes/             # API route aggregation
│   │   └── shared/             # Shared middleware, utils, services
│   ├── package.json
│   └── tsconfig.json
├── flutter_app/                # Flutter mobile application
│   ├── lib/
│   │   ├── core/               # Config, theme, routing, networking
│   │   └── features/           # Feature modules (auth, rider, driver, onboarding)
│   └── pubspec.yaml
├── .github/workflows/          # CI/CD pipeline
├── Dockerfile                  # Multi-stage production build
├── docker-compose.yml          # Full-stack local development
└── .env.example                # Environment configuration template
```

## Tech Stack

### Backend
- **Runtime:** Node.js 18+ with TypeScript
- **Framework:** Express.js with express-async-errors
- **Database:** PostgreSQL 16 with native `pg` driver
- **Authentication:** JWT (access + refresh tokens) with bcrypt password hashing
- **Real-time:** Socket.IO for WebSocket communication
- **Validation:** Zod schema validation
- **API Docs:** OpenAPI 3.0 (Swagger UI at `/api/docs`)
- **Logging:** Winston (structured JSON in production)
- **Security:** Helmet, CORS, rate limiting, RBAC middleware

### Frontend (Flutter)
- **State Management:** Riverpod
- **Routing:** GoRouter with role-based guards
- **Networking:** Dio with interceptors (auto token refresh)
- **Storage:** flutter_secure_storage for tokens
- **Theming:** Centralized Material 3 with dark/light mode
- **Architecture:** Clean Architecture with feature-based modules

### Infrastructure
- **Containerization:** Docker with multi-stage builds
- **CI/CD:** GitHub Actions
- **Database Migrations:** Custom SQL migration runner
- **Monitoring-ready:** Sentry, Prometheus/Grafana compatible logging

---

## Database Schema

15 normalized PostgreSQL tables with UUID primary keys, foreign key constraints, indexes, soft deletes, and audit columns:

| Table | Description |
|-------|-------------|
| `roles` | RBAC roles (rider, driver, manager, super_admin) |
| `users` | User accounts with role references |
| `refresh_tokens` | JWT refresh token management |
| `vehicles` | Driver vehicles with type classification |
| `driver_documents` | Document verification workflow |
| `driver_profiles` | Driver availability, location, stats |
| `rides` | Core ride records with full fare breakdown |
| `ride_stops` | Multi-stop support |
| `wallets` | User wallet balances |
| `transactions` | Wallet transaction ledger |
| `payments` | Ride payment records |
| `commissions` | Platform commission tracking |
| `ratings` | Ride ratings and reviews |
| `notifications` | Push notification records |
| `surge_pricing_rules` | Configurable surge pricing |
| `audit_logs` | System audit trail |

---

## API Endpoints

### Authentication (`/api/v1/auth`)
- `POST /register` - Register new user (rider/driver)
- `POST /login` - Login with email/password
- `POST /refresh` - Refresh access token
- `POST /logout` - Revoke all tokens
- `GET /me` - Get current user

### Rides (`/api/v1/rides`)
- `POST /` - Create ride request (rider)
- `GET /` - List rides (role-filtered)
- `GET /pending` - List pending rides (driver)
- `GET /:id` - Get ride details
- `POST /:id/accept` - Accept ride (driver)
- `POST /:id/status` - Update ride status
- `POST /:id/cancel` - Cancel ride
- `POST /:id/complete` - Complete ride (driver)

### Wallet (`/api/v1/wallet`)
- `GET /` - Get wallet balance
- `GET /transactions` - Transaction history
- `POST /topup` - Top up wallet

### Driver (`/api/v1/driver`)
- `GET /profile` - Driver profile
- `PATCH /availability` - Toggle online/offline
- `GET /earnings` - Earnings analytics
- `GET /documents` - List documents
- `POST /documents` - Upload document
- `PATCH /documents/:id/review` - Review document (manager/admin)

### Admin (`/api/v1/admin`)
- `GET /users` - List all users
- `POST /users/:id/suspend` - Suspend user
- `POST /users/:id/activate` - Activate user
- `GET /analytics` - Platform analytics
- `GET /fleet` - Fleet overview (manager)
- `GET /reports` - Export reports (JSON/CSV)
- `GET /surge-pricing` - Surge pricing rules
- `POST /surge-pricing` - Create rule
- `PATCH /surge-pricing/:id` - Update rule

### Ratings (`/api/v1/ratings`)
- `POST /` - Submit rating
- `GET /ride/:id` - Get ride ratings

### Notifications (`/api/v1/notifications`)
- `GET /` - List notifications
- `POST /read-all` - Mark all as read
- `POST /:id/read` - Mark one as read

---

## Business Logic

### Fare Calculation Engine
- Base fare by vehicle type (economy, comfort, premium, xl)
- Distance-based pricing (Haversine formula for distance estimation)
- Time-based pricing
- Multi-stop surcharge
- Surge multiplier
- Minimum fare enforcement

### Ride State Machine
```
requested -> accepted -> driver_en_route -> arrived -> in_progress -> completed
    |           |            |                |           |
    v           v            v                v           v
 cancelled   cancelled   cancelled       cancelled    cancelled
```
Role-based transition permissions enforced at every step.

### Surge Pricing Algorithm
- Demand-based: counts ride requests in geographic radius
- Configurable rules with thresholds and multipliers
- Time-windowed activation (valid_from/valid_until)
- Geo-zone support (JSONB)

### Commission System
- Configurable commission rate (default 20%)
- Automatic calculation on ride completion
- Driver payout tracking
- Full audit trail

---

## Getting Started

### Prerequisites
- Node.js 18+
- PostgreSQL 16+
- Flutter 3.10+ (for mobile app)

### Quick Start with Docker
```bash
# Clone the repository
git clone https://github.com/Masudi-238/Zippy-Ride.git
cd Zippy-Ride

# Copy environment config
cp .env.example .env

# Start all services
docker-compose up -d

# Run migrations
cd backend && npm run migrate

# Seed test data
npm run seed
```

### Manual Setup
```bash
# Backend
cd backend
cp .env.example .env    # Edit with your database credentials
npm install
npm run migrate
npm run seed
npm run dev             # Starts on http://localhost:3000

# Flutter App
cd flutter_app
flutter pub get
flutter run
```

### API Documentation
Once the backend is running, visit: `http://localhost:3000/api/docs`

### Test Accounts (after seeding)
| Role | Email | Password |
|------|-------|----------|
| Super Admin | admin@zippyride.com | Password123! |
| Manager | manager@zippyride.com | Password123! |
| Driver | driver@zippyride.com | Password123! |
| Rider | rider@zippyride.com | Password123! |

---

## Running Tests

```bash
cd backend
npm test                # Run all tests with coverage
npm run test:watch      # Watch mode
npm run typecheck       # TypeScript type checking
npm run lint            # ESLint
```

---

## Security Features

- JWT access + refresh token rotation
- Bcrypt password hashing (12 rounds)
- Token reuse detection (revokes all tokens on reuse)
- Role-based access control on every endpoint
- Request validation with Zod schemas
- Rate limiting (global + auth-specific)
- Helmet security headers
- CORS configuration
- SQL parameterized queries (injection prevention)
- Soft deletes (data recovery)
- Audit logging

---

## Production Readiness

- Docker multi-stage builds (minimal production image)
- Health check endpoint (`/health`)
- Graceful shutdown handling (SIGTERM/SIGINT)
- Structured JSON logging (production)
- Slow query detection and logging
- Database connection pooling with configurable limits
- Environment-based configuration
- CI/CD pipeline (GitHub Actions)
- Sentry-compatible error tracking
- Prometheus/Grafana-compatible metrics ready

---

## Microservices Migration Path

The modular monolith is designed for easy decomposition:

| Current Module | Future Microservice |
|---------------|-------------------|
| `modules/auth` | Auth Service |
| `modules/rides` | Ride Service |
| `modules/wallet` + `modules/payments` | Payment Service |
| `modules/notifications` | Notification Service |
| `modules/admin` | Analytics Service |

Each module has its own repository, service, controller, and validation layers - making extraction straightforward.

---

## License

MIT
