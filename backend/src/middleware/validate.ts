import { Request, Response, NextFunction } from 'express';

type ValidationRule = {
  field: string;
  required?: boolean;
  type?: string;
  minLength?: number;
  maxLength?: number;
  pattern?: RegExp;
  message?: string;
};

/** Simple request body validator middleware. */
export function validate(rules: ValidationRule[]) {
  return (req: Request, res: Response, next: NextFunction): void => {
    const errors: Record<string, string[]> = {};

    for (const rule of rules) {
      const value = req.body[rule.field];
      const fieldErrors: string[] = [];

      if (rule.required && (!value || (typeof value === 'string' && !value.trim()))) {
        fieldErrors.push(rule.message || `${rule.field} is required.`);
      }

      if (value && rule.type && typeof value !== rule.type) {
        fieldErrors.push(`${rule.field} must be a ${rule.type}.`);
      }

      if (value && rule.minLength && typeof value === 'string' && value.length < rule.minLength) {
        fieldErrors.push(`${rule.field} must be at least ${rule.minLength} characters.`);
      }

      if (value && rule.maxLength && typeof value === 'string' && value.length > rule.maxLength) {
        fieldErrors.push(`${rule.field} must be at most ${rule.maxLength} characters.`);
      }

      if (value && rule.pattern && typeof value === 'string' && !rule.pattern.test(value)) {
        fieldErrors.push(rule.message || `${rule.field} is invalid.`);
      }

      if (fieldErrors.length > 0) {
        errors[rule.field] = fieldErrors;
      }
    }

    if (Object.keys(errors).length > 0) {
      res.status(422).json({ message: 'Validation failed.', errors });
      return;
    }

    next();
  };
}
