import { HttpModule } from '@nestjs/axios';
import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { TerminusModule } from '@nestjs/terminus';
import { LoggerModule } from 'nestjs-pino';
// import { PrismaService } from '../providers/prisma.service';
import { HealthController } from './health/health.controller';
// import { PrismaHealthIndicator } from './health/prisma.health.Indicator';

@Module({
  // providers: [PrismaHealthIndicator],
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
    }),
    TerminusModule,
    HttpModule.register({
      timeout: 5000,
      maxRedirects: 5,
    }),
    LoggerModule.forRoot({
      pinoHttp: {
        serializers: {
          req: (req) => {
            const { raw, ...others } = req;
            return {
              ...others,
              body: raw.body,
            };
          },
        },
        transport:
          process.env.NODE_ENV == 'local'
            ? {
                target: 'pino-pretty',
              }
            : undefined,
        timestamp: () => `,"time":"${new Date().toISOString()}"`,
      },
    }),
  ],
  controllers: [HealthController],
})
export class CommonModule {}
