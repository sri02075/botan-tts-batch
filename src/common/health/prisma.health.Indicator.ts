// import { Injectable } from '@nestjs/common';
// import {
//   HealthCheckError,
//   HealthIndicator,
//   HealthIndicatorResult,
// } from '@nestjs/terminus';
// import { PrismaClient } from '@prisma/client';
// import { PrismaService } from 'src/providers/prisma.service';

// @Injectable()
// export class PrismaHealthIndicator extends HealthIndicator {
//   private readOnlyPrisma: PrismaClient;
//   constructor(private prismaService: PrismaService) {
//     super();
//     this.readOnlyPrisma = this.prismaService.readOnlyPrisma;
//   }

//   async isHealthy(key: string): Promise<HealthIndicatorResult> {
//     try {
//       await this.readOnlyPrisma.$queryRaw`SELECT 1`;

//       return this.getStatus(key, true);
//     } catch (e) {
//       throw new HealthCheckError('Prisma check failed', e);
//     }
//   }
// }
