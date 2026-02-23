# ===========================================
# Zippy Ride Backend - Production Dockerfile
# ===========================================
# Multi-stage build for minimal production image

# Stage 1: Build
FROM node:18-alpine AS builder

WORKDIR /app

# Copy package files
COPY backend/package.json backend/package-lock.json* ./

# Install dependencies
RUN npm ci --only=production && \
    cp -R node_modules prod_node_modules && \
    npm ci

# Copy source
COPY backend/ .

# Build TypeScript
RUN npm run build

# Stage 2: Production
FROM node:18-alpine AS production

# Add non-root user
RUN addgroup -g 1001 -S appgroup && \
    adduser -S appuser -u 1001 -G appgroup

WORKDIR /app

# Copy production dependencies and built files
COPY --from=builder /app/prod_node_modules ./node_modules
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/package.json ./

# Create logs directory
RUN mkdir -p logs && chown -R appuser:appgroup /app

USER appuser

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:3000/health || exit 1

EXPOSE 3000

ENV NODE_ENV=production

CMD ["node", "dist/index.js"]
