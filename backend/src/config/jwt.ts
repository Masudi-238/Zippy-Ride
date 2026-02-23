export const jwtConfig = {
  secret: process.env.JWT_SECRET || 'zippy-ride-secret-key-change-in-production',
  refreshSecret: process.env.JWT_REFRESH_SECRET || 'zippy-ride-refresh-secret-change-in-production',
  expiresIn: '1h',
  refreshExpiresIn: '7d',
};
