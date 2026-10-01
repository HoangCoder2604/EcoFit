import { IsEmail, IsString, Length, MaxLength } from 'class-validator';

export class VerifyEmailDto {
  @IsEmail()
  @MaxLength(254)
  email!: string;

  @IsString()
  @Length(6, 6)
  code!: string;
}

export class ResendVerificationDto {
  @IsEmail()
  @MaxLength(254)
  email!: string;
}
