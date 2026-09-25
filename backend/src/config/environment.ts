import * as Joi from 'joi';

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
});

export function parseCorsOrigins(value: string | undefined): string[] {
  return (value ?? '')
    .split(',')
    .map((origin) => origin.trim())
    .filter(Boolean);
}
