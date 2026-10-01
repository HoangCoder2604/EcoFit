import { ApiProperty } from '@nestjs/swagger';
import { IsString, MinLength } from 'class-validator';

export class RefreshTokenDto {
  @ApiProperty({ description: 'Opaque refresh token nhận từ đăng nhập hoặc làm mới gần nhất' })
  @IsString()
  @MinLength(32)
  refreshToken!: string;
}
