import { ValidationPipe } from '@nestjs/common';
import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
    }),
  );
  await app.listen(3333);
}
function handle(signal) {
  console.log(
    `*^!@4=> Received event: ${signal}`,
  );
}
process.on('SIGHUP', handle);
process.on('SIGTERM', handle);
process.on('SIGINT', handle);

bootstrap();
