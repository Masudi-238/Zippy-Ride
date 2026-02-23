import { Router, Request, Response } from 'express';
import jwt from 'jsonwebtoken';
import { jwtConfig } from '../config/jwt';
import { validate } from '../middleware/validate';
import { authenticate, AuthRequest } from '../middleware/auth';

const router = Router();

/** POST /api/auth/register */
router.post(
  '/register',
  validate([
    { field: 'full_name', required: true, minLength: 2 },
    { field: 'email', required: true, pattern: /^[^\s@]+@[^\s@]+\.[^\s@]+$/, message: 'Invalid email.' },
    { field: 'phone', required: true, minLength: 10 },
    { field: 'password', required: true, minLength: 8 },
    { field: 'role', required: true, pattern: /^(rider|driver|manager|admin)$/, message: 'Role must be rider, driver, manager, or admin.' },
  ]),
  async (req: Request, res: Response) => {
    try {
      const { full_name, email, phone, password, role } = req.body;
      // In production, hash password and insert into DB
      const userId = `usr_${Date.now()}`;
      const user = { id: userId, full_name, email, phone, role, is_verified: false, created_at: new Date().toISOString() };
      const accessToken = jwt.sign({ id: userId, email, role }, jwtConfig.secret, { expiresIn: jwtConfig.expiresIn });
      const refreshToken = jwt.sign({ id: userId }, jwtConfig.refreshSecret, { expiresIn: jwtConfig.refreshExpiresIn });
      res.status(201).json({ user, access_token: accessToken, refresh_token: refreshToken });
    } catch (err) {
      res.status(500).json({ message: 'Registration failed.' });
    }
  }
);

/** POST /api/auth/login */
router.post(
  '/login',
  validate([
    { field: 'email_or_phone', required: true },
    { field: 'password', required: true },
  ]),
  async (req: Request, res: Response) => {
    try {
      const { email_or_phone, password } = req.body;
      // In production, look up user and verify password hash
      const userId = `usr_${Date.now()}`;
      const role = 'rider'; // Determined by DB lookup
      const user = { id: userId, full_name: 'Test User', email: email_or_phone, phone: '+1234567890', role, is_verified: true, created_at: new Date().toISOString() };
      const accessToken = jwt.sign({ id: userId, email: email_or_phone, role }, jwtConfig.secret, { expiresIn: jwtConfig.expiresIn });
      const refreshToken = jwt.sign({ id: userId }, jwtConfig.refreshSecret, { expiresIn: jwtConfig.refreshExpiresIn });
      res.json({ user, access_token: accessToken, refresh_token: refreshToken });
    } catch (err) {
      res.status(500).json({ message: 'Login failed.' });
    }
  }
);

/** POST /api/auth/refresh */
router.post('/refresh', async (req: Request, res: Response) => {
  try {
    const { refresh_token } = req.body;
    if (!refresh_token) { res.status(400).json({ message: 'Refresh token required.' }); return; }
    const decoded = jwt.verify(refresh_token, jwtConfig.refreshSecret) as { id: string };
    const accessToken = jwt.sign({ id: decoded.id, email: '', role: 'rider' }, jwtConfig.secret, { expiresIn: jwtConfig.expiresIn });
    res.json({ access_token: accessToken });
  } catch { res.status(401).json({ message: 'Invalid refresh token.' }); }
});

/** POST /api/auth/logout */
router.post('/logout', authenticate, (_req: AuthRequest, res: Response) => {
  // In production, blacklist the token
  res.json({ message: 'Logged out successfully.' });
});

/** GET /api/auth/profile (alias for /api/users/profile) */
router.get('/profile', authenticate, (req: AuthRequest, res: Response) => {
  res.json({ user: { id: req.user!.id, full_name: 'Current User', email: req.user!.email, phone: '+1234567890', role: req.user!.role, is_verified: true, created_at: new Date().toISOString() } });
});

export default router;
