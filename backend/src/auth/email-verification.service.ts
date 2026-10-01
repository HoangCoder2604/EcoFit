import { Injectable, Logger, ServiceUnavailableException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { createTransport, type Transporter } from 'nodemailer';

@Injectable()
export class EmailVerificationService {
  private readonly logger = new Logger(EmailVerificationService.name);
  private readonly transporter?: Transporter;

  constructor(private readonly config: ConfigService) {
    if (this.config.get<string>('EMAIL_DELIVERY_MODE', 'console') === 'smtp') {
      this.transporter = createTransport({
        host: this.config.getOrThrow<string>('SMTP_HOST'),
        port: this.config.getOrThrow<number>('SMTP_PORT'),
        secure: this.config.get<boolean>('SMTP_SECURE', false),
        auth: {
          user: this.config.getOrThrow<string>('SMTP_USER'),
          pass: this.config.getOrThrow<string>('SMTP_PASSWORD'),
        },
      });
    }
  }

  async sendCode(email: string, code: string): Promise<void> {
    if (!this.transporter) {
      this.logger.log(`[LOCAL ONLY] Mã xác minh cho ${email}: ${code}`);
      return;
    }
    try {
      await this.transporter.sendMail({
        from: this.config.getOrThrow<string>('EMAIL_FROM'),
        to: email,
        subject: 'Mã xác minh tài khoản Eco Fit',
        text: `Mã xác minh Eco Fit của bạn là ${code}. Mã có hiệu lực trong 10 phút.`,
        html: `<p>Mã xác minh Eco Fit của bạn:</p><p style="font-size:28px;font-weight:700;letter-spacing:6px">${code}</p><p>Mã có hiệu lực trong 10 phút. Nếu bạn không yêu cầu, hãy bỏ qua email này.</p>`,
      });
    } catch {
      throw new ServiceUnavailableException('Chưa thể gửi email xác minh. Vui lòng thử lại.');
    }
  }

  developmentCode(code: string): string | undefined {
    return this.config.get<string>('NODE_ENV') === 'production' || this.transporter
      ? undefined
      : code;
  }
}
