import { Controller, Get } from '@nestjs/common';
import { ApiTags } from '@nestjs/swagger';
import {
  HealthCheck,
  HealthCheckService,
  HttpHealthIndicator,
} from '@nestjs/terminus';
// import { PrismaHealthIndicator } from './prisma.health.Indicator';

@ApiTags('common')
@Controller('common')
export class HealthController {
  constructor(
    private health: HealthCheckService,
    private http: HttpHealthIndicator,
    // private prisma: PrismaHealthIndicator,
  ) {}

  /**
   * 서버에 대한 헬스 체크를 수행합니다.
   */
  @Get('health/ping')
  @HealthCheck()
  check() {
    const mode = process.env.SERVICE_MODE;
    const healthCheckAdmin = () =>
      this.http.pingCheck(
        'device-service-admin',
        `http://localhost:${process.env.ADMIN_HTTP_PORT}${
          process.env.ADMIN_GLOBAL_PREFIX
            ? `/${process.env.ADMIN_GLOBAL_PREFIX}`
            : '' 
        }/common/health/pong`,
      );
    const healthCheckUser = () =>
      this.http.pingCheck(
        'device-service-user',
        `http://localhost:${process.env.USER_HTTP_PORT}${
          process.env.USER_GLOBAL_PREFIX
            ? `/${process.env.USER_GLOBAL_PREFIX}`
            : ''
        }/common/health/pong`,
      );
    const healthCheckInternal = () =>
      this.http.pingCheck(
        'device-service-internal',
        `http://localhost:${process.env.INTERNAL_HTTP_PORT}/common/health/pong`,
      );
    // const healthCheckPrisma = () => this.prisma.isHealthy('prisma');

    if (mode === 'admin') {
      return this.health.check([healthCheckAdmin]);
    } else if (mode === 'user') {
      return this.health.check([healthCheckUser]);
    } else if (mode === 'internal') {
      return this.health.check([healthCheckInternal]);
    } else if (mode === 'all-api') {
      return this.health.check([
        healthCheckAdmin,
        healthCheckUser,
        healthCheckInternal,
      ]);
    } else {
      return this.health.check([]);
    }
  }

  /**
   * 헬스 체크에 대한 응답을 수행합니다.
   */
  @Get('health/pong')
  pong() {
    return {
      status: 'OK',
    };
  }
}
