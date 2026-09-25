import { Controller, Get } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { ApiOkResponse, ApiOperation, ApiTags } from '@nestjs/swagger';

@ApiTags('system')
@Controller()
export class AppController {
  constructor(private readonly config: ConfigService) {}

  @Get()
  @ApiOperation({ summary: 'Thông tin cơ bản của Eco Fit API' })
  @ApiOkResponse({ description: 'Backend đang sẵn sàng nhận yêu cầu.' })
  getInfo() {
    return {
      name: this.config.get<string>('APP_NAME', 'Eco Fit API'),
      version: this.config.get<string>('APP_VERSION', '0.1.0'),
      documentation: '/docs',
      health: '/api/v1/health',
    };
  }
}
