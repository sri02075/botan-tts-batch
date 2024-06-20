import { Logger, Module } from '@nestjs/common';
import { DevtoolsModule } from '@nestjs/devtools-integration';
import { CommonModule } from './common/common.module';

@Module({
  imports: [
    DevtoolsModule.registerAsync({
      useFactory: async () => {
        const logger = new Logger('DevTools');
        const port = await (await import('get-port')).default();
        logger.log(`InternalModule DevTools listening on port ${port}`);
        return {
          http: process.env.NODE_ENV !== 'production',
          port,
        };
      },
    }),
    CommonModule,
  ],
})
export class InternalModule {}
