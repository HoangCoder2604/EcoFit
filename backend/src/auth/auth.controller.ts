import { Body, Controller, Get, HttpCode, Ip, Post, Req, UseGuards } from '@nestjs/common';
import { ApiBearerAuth, ApiOperation, ApiTags } from '@nestjs/swagger';
import { Throttle } from '@nestjs/throttler';
import type { Request } from 'express';
import { AccessTokenGuard, type AuthenticatedRequest } from './access-token.guard';
import { AuthService } from './auth.service';
import { LoginDto } from './dto/login.dto';
import { RefreshTokenDto } from './dto/refresh-token.dto';
import { RegisterDto } from './dto/register.dto';
import { GoogleLoginDto } from './dto/google-login.dto';
import { ResendVerificationDto, VerifyEmailDto } from './dto/verify-email.dto';

@ApiTags('Authentication')
@Controller('auth')
export class AuthController {
  constructor(private readonly auth: AuthService) {}

  @Post('register')
  @Throttle({ default: { limit: 3, ttl: 60_000 } })
  @ApiOperation({ summary: 'Tạo tài khoản Eco Fit' })
  register(@Body() input: RegisterDto, @Req() request: Request, @Ip() ipAddress: string) {
    return this.auth.register(input, this.metadata(request, ipAddress));
  }

  @Post('login')
  @Throttle({ default: { limit: 5, ttl: 60_000 } })
  @HttpCode(200)
  @ApiOperation({ summary: 'Đăng nhập bằng email và mật khẩu' })
  login(@Body() input: LoginDto, @Req() request: Request, @Ip() ipAddress: string) {
    return this.auth.login(input, this.metadata(request, ipAddress));
  }

  @Post('email/verify')
  @Throttle({ default: { limit: 8, ttl: 60_000 } })
  @HttpCode(200)
  @ApiOperation({ summary: 'Xác minh email bằng mã dùng một lần' })
  verifyEmail(@Body() input: VerifyEmailDto, @Req() request: Request, @Ip() ipAddress: string) {
    return this.auth.verifyEmail(input, this.metadata(request, ipAddress));
  }

  @Post('email/resend')
  @Throttle({ default: { limit: 3, ttl: 60_000 } })
  @HttpCode(200)
  @ApiOperation({ summary: 'Gửi lại mã xác minh email' })
  resendVerification(@Body() input: ResendVerificationDto) {
    return this.auth.resendVerification(input.email);
  }

  @Post('google')
  @Throttle({ default: { limit: 10, ttl: 60_000 } })
  @HttpCode(200)
  @ApiOperation({ summary: 'Đăng nhập bằng Google ID token đã được backend kiểm chứng' })
  google(@Body() input: GoogleLoginDto, @Req() request: Request, @Ip() ipAddress: string) {
    return this.auth.googleLogin(input.idToken, this.metadata(request, ipAddress));
  }

  @Post('refresh')
  @Throttle({ default: { limit: 20, ttl: 60_000 } })
  @HttpCode(200)
  @ApiOperation({ summary: 'Xoay vòng refresh token và cấp access token mới' })
  refresh(@Body() input: RefreshTokenDto, @Req() request: Request, @Ip() ipAddress: string) {
    return this.auth.refresh(input.refreshToken, this.metadata(request, ipAddress));
  }

  @Post('logout')
  @HttpCode(200)
  @ApiOperation({ summary: 'Thu hồi refresh token hiện tại' })
  logout(@Body() input: RefreshTokenDto) {
    return this.auth.logout(input.refreshToken);
  }

  @Get('me')
  @UseGuards(AccessTokenGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Lấy người dùng từ access token' })
  me(@Req() request: AuthenticatedRequest) {
    return this.auth.getMe(request.user.sub);
  }

  private metadata(request: Request, ipAddress: string) {
    return {
      ipAddress,
      userAgent: request.headers['user-agent'],
    };
  }
}
