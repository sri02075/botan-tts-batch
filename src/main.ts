import {
	INestApplication,
	NestApplicationOptions,
	ValidationPipe,
  } from '@nestjs/common';
  import { NestFactory } from '@nestjs/core';
  import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';
  import { Handler, json, urlencoded } from 'express';
  import basicAuth from 'express-basic-auth';
  import { Logger, LoggerErrorInterceptor } from 'nestjs-pino';
  import { AdminModule } from './admin.module';
  import { InternalModule } from './internal.module';
import { UserModule } from './user.module';
  
type SwaggerOptions = {
	title: string;
	description: string;
	version: string;
};
  
function buildSwagger(app: INestApplication, options: SwaggerOptions) {
	const config = new DocumentBuilder()
	  .setTitle(options.title)
	  .setDescription(options.description)
	  .setVersion(options.version)
	  .addBearerAuth()
	  .build();
	const document = SwaggerModule.createDocument(app, config);
	return document;
}
  
async function appFactory(module: any, options?: NestApplicationOptions) {
	const app = await NestFactory.create(module, {
	  ...options,
	});
	app.enableCors();
	app.useGlobalPipes(
	  new ValidationPipe({
			transform: true,
			whitelist: true,
			transformOptions: {
				enableImplicitConversion: true,
			},
	  }),
	);
	app.use(json({ limit: '50mb' }));
	app.use(urlencoded({ extended: true, limit: '50mb' }));
	app.useGlobalInterceptors(new LoggerErrorInterceptor());
	app.useLogger(app.get(Logger));
	app.use(
	  '*/api-docs',
	  basicAuth({
			authorizeAsync: true,
			authorizer: (user, password, authorize) =>
				authorize(
					null,
					user == process.env.SWAGGER_USER_ID &&
						password == process.env.SWAGGER_USER_PASSWORD,
				),
			challenge: true,
	  }),
	);
	return app;
}
  
async function bootstrap() {
	const mode = process.env.SERVICE_MODE;
	switch (mode) {
		case 'admin':
			return bootstrapAdmin();
		case 'user':
			return bootstrapUser();
			// case 'internal':
			//   return bootstrapInternal();
		default:
			throw new Error('Unknown mode');
	}
}
  
async function bootstrapAdmin() {
	const app = await appFactory(AdminModule, { snapshot: true });
	process.env.ADMIN_GLOBAL_PREFIX &&
	  app.setGlobalPrefix(process.env.ADMIN_GLOBAL_PREFIX);
  
	if (['develop', 'local'].includes(process.env.NODE_ENV || '')) {
	  const document = buildSwagger(app, {
			title: 'Apartment Service - Admin',
			description: 'The apartment service api documentation for admin',
			version: '1.0',
	  });
	  SwaggerModule.setup(
			process.env.ADMIN_GLOBAL_PREFIX
				? `${process.env.ADMIN_GLOBAL_PREFIX}/api-docs`
				: 'api-docs',
			app,
			document,
	  );
	}
  
	await app.listen(process.env.ADMIN_HTTP_PORT ?? 3000);
	return app;
}
  
async function bootstrapUser() {
	const app = await appFactory(UserModule, { snapshot: true });
	process.env.USER_GLOBAL_PREFIX &&
	  app.setGlobalPrefix(process.env.USER_GLOBAL_PREFIX);
  
	if (['develop', 'local'].includes(process.env.NODE_ENV || '')) {
	  const document = buildSwagger(app, {
			title: 'Apartment Service - User',
			description: 'The apartment service api documentation for user',
			version: '1.0',
	  });
	  SwaggerModule.setup(
			process.env.USER_GLOBAL_PREFIX
				? `${process.env.USER_GLOBAL_PREFIX}/api-docs`
				: 'api-docs',
			app,
			document,
	  );
	}
  
	await app.listen(process.env.USER_HTTP_PORT ?? 3001);
	return app;
}
  
//   async function bootstrapInternal() {
// 	const app = await appFactory(InternalModule, { snapshot: true });
  
// 	if (['develop', 'local'].includes(process.env.NODE_ENV || '')) {
// 	  const document = buildSwagger(app, {
// 		title: 'Apartment Service - Internal',
// 		description: 'The apartment service api documentation for internal',
// 		version: '1.0',
// 	  });
// 	  SwaggerModule.setup(
// 		process.env.INTERNAL_GLOBAL_PREFIX
// 		  ? `${process.env.INTERNAL_GLOBAL_PREFIX}/api-docs`
// 		  : 'api-docs',
// 		app,
// 		document,
// 	  );
// 	}
  
// 	await app.listen(process.env.INTERNAL_HTTP_PORT ?? 3002);
//   }
  
bootstrap();

// Nest Js 람다 핸들러 함수
export const handler: Handler = async (event: any, context) => {
	const app = await bootstrap();
	const handler = app.getHttpAdapter().getInstance();
	return handler(event, context);
}
  