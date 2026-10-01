import type { UserRole } from '../generated/prisma/enums';

export interface AccessTokenPayload {
  sub: string;
  email: string;
  role: UserRole;
}

export interface AuthenticatedUser extends AccessTokenPayload {}

export interface ClientMetadata {
  ipAddress?: string;
  userAgent?: string;
}
