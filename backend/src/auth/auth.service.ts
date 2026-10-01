import {
  BadRequestException,
  ConflictException,
  ForbiddenException,
  Injectable,
  ServiceUnavailableException,
  UnauthorizedException,
} from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { JwtService } from '@nestjs/jwt';
import { compare, hash } from 'bcryptjs';
import { createHash, randomBytes, randomInt, randomUUID } from 'node:crypto';
import { OAuth2Client } from 'google-auth-library';
import { PrismaService } from '../database/prisma.service';
import type { User } from '../generated/prisma/client';
import { AuthProvider, UserStatus } from '../generated/prisma/enums';
import { parseGoogleClientIds } from '../config/environment';
import type { ClientMetadata } from './auth.types';
import { LoginDto } from './dto/login.dto';
import { RegisterDto } from './dto/register.dto';
import { VerifyEmailDto } from './dto/verify-email.dto';
import { EmailVerificationService } from './email-verification.service';

type SafeUser = Pick<
  User,
  'id' | 'email' | 'displayName' | 'role' | 'emailVerifiedAt' | 'createdAt'
>;

@Injectable()
export class AuthService {
  private readonly google = new OAuth2Client();

  constructor(
    private readonly prisma: PrismaService,
    private readonly jwt: JwtService,
    private readonly config: ConfigService,
    private readonly emailVerification: EmailVerificationService,
  ) {}

  async register(input: RegisterDto, metadata: ClientMetadata) {
    const email = input.email.trim().toLowerCase();
    const existing = await this.prisma.user.findUnique({ where: { email }, select: { id: true } });
    if (existing) throw new ConflictException('Email đã được sử dụng');

    const passwordHash = await hash(
      input.password,
      this.config.get<number>('PASSWORD_BCRYPT_ROUNDS', 12),
    );
    let user: User;
    try {
      user = await this.prisma.user.create({
        data: { email, displayName: input.displayName.trim(), passwordHash },
      });
    } catch (error) {
      if (this.isUniqueConstraintError(error)) {
        throw new ConflictException('Email đã được sử dụng');
      }
      throw error;
    }

    return this.createEmailVerification(user);
  }

  async login(input: LoginDto, metadata: ClientMetadata) {
    const email = input.email.trim().toLowerCase();
    const user = await this.prisma.user.findUnique({ where: { email } });
    if (!user || !user.passwordHash || !(await compare(input.password, user.passwordHash))) {
      throw new UnauthorizedException('Email hoặc mật khẩu không đúng');
    }
    if (user.status !== UserStatus.ACTIVE) {
      throw new UnauthorizedException('Tài khoản hiện không hoạt động');
    }
    if (!user.emailVerifiedAt) {
      throw new ForbiddenException('Email chưa được xác minh. Vui lòng nhập mã đã gửi tới email.');
    }

    const updated = await this.prisma.user.update({
      where: { id: user.id },
      data: { lastLoginAt: new Date() },
    });
    return this.issueSession(updated, metadata);
  }

  async verifyEmail(input: VerifyEmailDto, metadata: ClientMetadata) {
    const email = input.email.trim().toLowerCase();
    const user = await this.prisma.user.findUnique({ where: { email } });
    if (!user) throw new BadRequestException('Mã xác minh không hợp lệ hoặc đã hết hạn');
    if (user.emailVerifiedAt) return this.issueSession(user, metadata);

    const verification = await this.prisma.emailVerification.findFirst({
      where: { userId: user.id, consumedAt: null },
      orderBy: { createdAt: 'desc' },
    });
    if (!verification || verification.expiresAt <= new Date() || verification.attempts >= 5) {
      throw new BadRequestException('Mã xác minh không hợp lệ hoặc đã hết hạn');
    }
    if (verification.codeHash !== this.verificationHash(user.id, input.code)) {
      await this.prisma.emailVerification.update({
        where: { id: verification.id },
        data: {
          attempts: { increment: 1 },
          ...(verification.attempts >= 4 ? { consumedAt: new Date() } : {}),
        },
      });
      throw new BadRequestException('Mã xác minh không hợp lệ hoặc đã hết hạn');
    }

    const verified = await this.prisma.$transaction(async (transaction) => {
      await transaction.emailVerification.update({
        where: { id: verification.id },
        data: { consumedAt: new Date() },
      });
      return transaction.user.update({
        where: { id: user.id },
        data: { emailVerifiedAt: new Date(), lastLoginAt: new Date() },
      });
    });
    return this.issueSession(verified, metadata);
  }

  async resendVerification(rawEmail: string) {
    const email = rawEmail.trim().toLowerCase();
    const user = await this.prisma.user.findUnique({ where: { email } });
    if (!user || user.emailVerifiedAt) return { sent: true };
    return this.createEmailVerification(user);
  }

  async googleLogin(idToken: string, metadata: ClientMetadata) {
    const audiences = parseGoogleClientIds(this.config.get<string>('GOOGLE_CLIENT_IDS'));
    if (audiences.length === 0) {
      throw new ServiceUnavailableException('Đăng nhập Google chưa được cấu hình trên máy chủ');
    }

    let payload;
    try {
      const ticket = await this.google.verifyIdToken({ idToken, audience: audiences });
      payload = ticket.getPayload();
    } catch {
      throw new UnauthorizedException('Google ID token không hợp lệ');
    }
    if (!payload?.sub || !payload.email || payload.email_verified !== true) {
      throw new UnauthorizedException('Tài khoản Google chưa xác minh email');
    }

    const email = payload.email.trim().toLowerCase();
    const displayName = (payload.name || email.split('@')[0]).slice(0, 80);
    const now = new Date();
    const user = await this.prisma.$transaction(async (transaction) => {
      const identity = await transaction.authIdentity.findUnique({
        where: {
          provider_providerSubject: {
            provider: AuthProvider.GOOGLE,
            providerSubject: payload.sub!,
          },
        },
        include: { user: true },
      });
      if (identity) {
        return transaction.user.update({
          where: { id: identity.userId },
          data: { emailVerifiedAt: identity.user.emailVerifiedAt ?? now, lastLoginAt: now },
        });
      }

      const existing = await transaction.user.findUnique({ where: { email } });
      const linked = existing
        ? await transaction.user.update({
            where: { id: existing.id },
            data: { emailVerifiedAt: existing.emailVerifiedAt ?? now, lastLoginAt: now },
          })
        : await transaction.user.create({
            data: {
              email,
              displayName,
              passwordHash: null,
              emailVerifiedAt: now,
              lastLoginAt: now,
            },
          });
      await transaction.authIdentity.create({
        data: {
          userId: linked.id,
          provider: AuthProvider.GOOGLE,
          providerSubject: payload.sub!,
        },
      });
      return linked;
    });
    if (user.status !== UserStatus.ACTIVE) {
      throw new UnauthorizedException('Tài khoản hiện không hoạt động');
    }
    return this.issueSession(user, metadata);
  }

  async refresh(rawToken: string, metadata: ClientMetadata) {
    const tokenHash = this.hashToken(rawToken);
    const existing = await this.prisma.refreshSession.findUnique({
      where: { tokenHash },
      include: { user: true },
    });

    if (!existing) throw new UnauthorizedException('Refresh token không hợp lệ');
    if (existing.revokedAt) {
      await this.prisma.refreshSession.updateMany({
        where: { familyId: existing.familyId, revokedAt: null },
        data: { revokedAt: new Date() },
      });
      throw new UnauthorizedException('Refresh token đã được sử dụng lại');
    }
    if (existing.expiresAt <= new Date()) {
      throw new UnauthorizedException('Refresh token đã hết hạn');
    }
    if (existing.user.status !== UserStatus.ACTIVE) {
      throw new UnauthorizedException('Tài khoản hiện không hoạt động');
    }

    const next = this.createRefreshToken(existing.userId, existing.familyId, metadata);
    const rotated = await this.prisma.$transaction(async (transaction) => {
      const revoked = await transaction.refreshSession.updateMany({
        where: { id: existing.id, revokedAt: null },
        data: { revokedAt: new Date() },
      });
      if (revoked.count !== 1) return false;
      await transaction.refreshSession.create({ data: next.session });
      return true;
    });
    if (!rotated) throw new UnauthorizedException('Refresh token đã được sử dụng');

    return this.buildAuthResponse(existing.user, next.rawToken, next.session.expiresAt);
  }

  async logout(rawToken: string): Promise<{ loggedOut: true }> {
    await this.prisma.refreshSession.updateMany({
      where: { tokenHash: this.hashToken(rawToken), revokedAt: null },
      data: { revokedAt: new Date() },
    });
    return { loggedOut: true };
  }

  async getMe(userId: string): Promise<SafeUser> {
    const user = await this.prisma.user.findUnique({ where: { id: userId } });
    if (!user || user.status !== UserStatus.ACTIVE) {
      throw new UnauthorizedException('Tài khoản hiện không hoạt động');
    }
    return this.toSafeUser(user);
  }

  private async issueSession(user: User, metadata: ClientMetadata) {
    const refresh = this.createRefreshToken(user.id, randomUUID(), metadata);
    await this.prisma.refreshSession.create({ data: refresh.session });
    return this.buildAuthResponse(user, refresh.rawToken, refresh.session.expiresAt);
  }

  private async createEmailVerification(user: User) {
    const code = randomInt(100000, 1000000).toString();
    const expiresAt = new Date(
      Date.now() + this.config.get<number>('EMAIL_VERIFICATION_TTL_MINUTES', 10) * 60_000,
    );
    await this.prisma.$transaction(async (transaction) => {
      await transaction.emailVerification.updateMany({
        where: { userId: user.id, consumedAt: null },
        data: { consumedAt: new Date() },
      });
      await transaction.emailVerification.create({
        data: { userId: user.id, codeHash: this.verificationHash(user.id, code), expiresAt },
      });
    });
    await this.emailVerification.sendCode(user.email, code);
    return {
      verificationRequired: true,
      email: user.email,
      expiresAt,
      developmentCode: this.emailVerification.developmentCode(code),
    };
  }

  private verificationHash(userId: string, code: string): string {
    return this.hashToken(`${userId}:${code}`);
  }

  private async buildAuthResponse(user: User, refreshToken: string, refreshTokenExpiresAt: Date) {
    const expiresIn = this.config.get<number>('JWT_ACCESS_TTL_SECONDS', 900);
    const accessToken = await this.jwt.signAsync(
      { sub: user.id, email: user.email, role: user.role },
      {
        secret: this.config.getOrThrow<string>('JWT_ACCESS_SECRET'),
        expiresIn,
        issuer: this.config.get<string>('JWT_ISSUER', 'eco-fit-api'),
        audience: this.config.get<string>('JWT_AUDIENCE', 'eco-fit-app'),
      },
    );

    return {
      tokenType: 'Bearer',
      accessToken,
      accessTokenExpiresIn: expiresIn,
      refreshToken,
      refreshTokenExpiresAt,
      user: this.toSafeUser(user),
    };
  }

  private createRefreshToken(userId: string, familyId: string, metadata: ClientMetadata) {
    const rawToken = randomBytes(48).toString('base64url');
    const expiresAt = new Date();
    expiresAt.setUTCDate(
      expiresAt.getUTCDate() + this.config.get<number>('REFRESH_TOKEN_TTL_DAYS', 30),
    );
    return {
      rawToken,
      session: {
        userId,
        familyId,
        tokenHash: this.hashToken(rawToken),
        userAgent: metadata.userAgent?.slice(0, 512),
        ipAddress: metadata.ipAddress?.slice(0, 64),
        expiresAt,
      },
    };
  }

  private hashToken(value: string): string {
    return createHash('sha256').update(value).digest('hex');
  }

  private isUniqueConstraintError(error: unknown): boolean {
    return (
      typeof error === 'object' &&
      error !== null &&
      'code' in error &&
      (error as { code?: unknown }).code === 'P2002'
    );
  }

  private toSafeUser(user: User): SafeUser {
    return {
      id: user.id,
      email: user.email,
      displayName: user.displayName,
      role: user.role,
      emailVerifiedAt: user.emailVerifiedAt,
      createdAt: user.createdAt,
    };
  }
}
