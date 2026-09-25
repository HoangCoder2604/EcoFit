import 'dotenv/config';
import { defineConfig } from 'prisma/config';

const localUrl =
  'postgresql://ecofit:ecofit_dev_password@127.0.0.1:5433/ecofit?schema=public';

export default defineConfig({
  schema: 'prisma/schema.prisma',
  migrations: {
    path: 'prisma/migrations',
  },
  datasource: {
    // Migration và Studio ưu tiên direct connection. Runtime dùng DATABASE_URL.
    url: process.env.DIRECT_URL ?? process.env.DATABASE_URL ?? localUrl,
  },
});
