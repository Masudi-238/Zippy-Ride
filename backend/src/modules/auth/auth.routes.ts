import { Router } from 'express';
import { AuthController } from './auth.controller';
import { validate } from '../../shared/middleware/validate.middleware';
import { authenticate } from '../../shared/middleware/auth.middleware';
import { authRateLimiter } from '../../shared/middleware/rate-limiter.middleware';
import { registerSchema, loginSchema, refreshTokenSchema } from './auth.validation';

const router = Router();

router.post('/register', authRateLimiter, validate(registerSchema), AuthController.register);
router.post('/login', authRateLimiter, validate(loginSchema), AuthController.login);
router.post('/refresh', validate(refreshTokenSchema), AuthController.refreshToken);
router.post('/logout', authenticate, AuthController.logout);
router.get('/me', authenticate, AuthController.me);

export { router as authRoutes };
