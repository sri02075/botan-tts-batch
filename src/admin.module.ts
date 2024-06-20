// import { AuthModule } from '@eyevacs4/nestjs-authorization';
import { Logger, Module } from '@nestjs/common';
import { DevtoolsModule } from '@nestjs/devtools-integration';
// import { readFileSync } from 'fs';
// import { resolve } from 'path';
import { CommonModule } from './common/common.module';

@Module({
  imports: [
    // DevtoolsModule.registerAsync({
    //   useFactory: async () => {
    //     const logger = new Logger('DevTools');
    //     const port = await (await import('get-port')).default();
    //     logger.log(`InternalModule DevTools listening on port ${port}`);
    //     return {
    //       http: process.env.NODE_ENV !== 'production',
    //       port,
    //     };
    //   },
    // }),
    // AuthModule.forKeys({
    //   admin: readFileSync(
    //     resolve(
    //       __dirname,
    //       `../${process.env.FS_ROOT_PATH || '.'}/public.admin.key`,
    //     ),
    //     {
    //       encoding: 'utf-8',
    //     },
    //   ),
    // }),
    CommonModule,
  ],
})
export class AdminModule {}
