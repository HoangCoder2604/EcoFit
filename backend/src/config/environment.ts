import * as Joi from 'joi';

const localJwtSecret = 'eco-fit-local-access-secret-change-before-production';

export const environmentSchema = Joi.object({
  NODE_ENV: Joi.string().valid('development', 'test', 'production').default('development'),
  PORT: Joi.number().port().default(3000),
  APP_NAME: Joi.string().trim().min(1).default('Eco Fit API'),
  APP_VERSION: Joi.string().trim().min(1).default('0.1.0'),
  CORS_ORIGINS: Joi.string().allow('').default('http://localhost:5173,http://127.0.0.1:8088'),
  SWAGGER_ENABLED: Joi.boolean().truthy('true').falsy('false').default(true),
  DATABASE_URL: Joi.string()
    .uri({ scheme: ['postgresql', 'postgres'] })
    .default('postgresql://ecofit:ecofit_dev_password@127.0.0.1:5433/ecofit?schema=public'),
  DIRECT_URL: Joi.string()
    .uri({ scheme: ['postgresql', 'postgres'] })
    .optional(),
  DATABASE_CONNECT_ON_START: Joi.boolean().truthy('true').falsy('false').default(true),
  DB_POOL_MAX: Joi.number().integer().min(1).max(100).default(10),
  DB_CONNECTION_TIMEOUT_MS: Joi.number().integer().min(100).default(5000),
  DB_IDLE_TIMEOUT_MS: Joi.number().integer().min(1000).default(30000),
  JWT_ACCESS_SECRET: Joi.when('NODE_ENV', {
    is: 'production',
    then: Joi.string().min(48).invalid(localJwtSecret).required(),
    otherwise: Joi.string().min(32).default(localJwtSecret),
  }),
  JWT_ACCESS_TTL_SECONDS: Joi.number().integer().min(60).max(86400).default(900),
  JWT_ISSUER: Joi.string().trim().min(1).default('eco-fit-api'),
  JWT_AUDIENCE: Joi.string().trim().min(1).default('eco-fit-app'),
  REFRESH_TOKEN_TTL_DAYS: Joi.number().integer().min(1).max(365).default(30),
  PASSWORD_BCRYPT_ROUNDS: Joi.number().integer().min(10).max(14).default(12),
  EMAIL_DELIVERY_MODE: Joi.when('NODE_ENV', {
    is: 'production',
    then: Joi.string().valid('smtp').required(),
    otherwise: Joi.string().valid('console', 'smtp').default('console'),
  }),
  EMAIL_VERIFICATION_TTL_MINUTES: Joi.number().integer().min(5).max(60).default(10),
  EMAIL_FROM: Joi.when('EMAIL_DELIVERY_MODE', {
    is: 'smtp',
    then: Joi.string().email().required(),
    otherwise: Joi.string().email().default('no-reply@ecofit.app'),
  }),
  SMTP_HOST: Joi.when('EMAIL_DELIVERY_MODE', { is: 'smtp', then: Joi.string().required() }),
  SMTP_PORT: Joi.when('EMAIL_DELIVERY_MODE', {
    is: 'smtp',
    then: Joi.number().port().required(),
    otherwise: Joi.number().port().default(587),
  }),
  SMTP_SECURE: Joi.boolean().truthy('true').falsy('false').default(false),
  SMTP_USER: Joi.when('EMAIL_DELIVERY_MODE', { is: 'smtp', then: Joi.string().required() }),
  SMTP_PASSWORD: Joi.when('EMAIL_DELIVERY_MODE', {
    is: 'smtp',
    then: Joi.string().min(1).required(),
  }),
  GOOGLE_CLIENT_IDS: Joi.when('NODE_ENV', {
    is: 'production',
    then: Joi.string().trim().min(10).required(),
    otherwise: Joi.string().allow('').default(''),
  }),
});

export function parseGoogleClientIds(value: string | undefined): string[] {
  return (value ?? '')
    .split(',')
    .map((clientId) => clientId.trim())
    .filter(Boolean);
}

export function parseCorsOrigins(value: string | undefined): string[] {
  return (value ?? '')
    .split(',')
    .map((origin) => origin.trim())
    .filter(Boolean);
}

export function isCorsOriginAllowed(
  origin: string | undefined,
  configuredOrigins: string[],
  allowLoopback: boolean,
): boolean {
  if (!origin || configuredOrigins.includes(origin)) return true;
  if (!allowLoopback) return false;

  try {
    const url = new URL(origin);
    const isHttp = url.protocol === 'http:' || url.protocol === 'https:';
    const isLoopback = ['localhost', '127.0.0.1', '::1', '[::1]'].includes(url.hostname);
    return isHttp && isLoopback;
  } catch {
    return false;
  }
}
