import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:green_wheel/core/di/injection.dart';
import 'package:green_wheel/core/utils/app_string.dart';
import 'package:green_wheel/core/utils/local_storage.dart';
import 'package:green_wheel/core/services/api_service.dart';

final locator = GetIt.instance;

Future<void> setupLocator({Logger? logger}) async {
  // Register logger first
  locator.registerSingleton<Logger>(
    logger ??
        Logger(
          printer: PrettyPrinter(
            methodCount: 0,
            errorMethodCount: 5,
            lineLength: 80,
            colors: true,
            printEmojis: true,
          ),
        ),
  );

  // Register Dio with interceptors
  final dio = Dio()
    ..interceptors.add(
      LogInterceptor(
        request: true,
        responseBody: true,
        requestBody: true,
        requestHeader: true,
        responseHeader: true,
        error: true,
        logPrint: (object) => locator<Logger>().d(object),
      ),
    );

  locator.registerSingleton<Dio>(dio);

  // Register ApiService
  locator.registerSingleton<ApiService>(
    ApiService(
      locator<Dio>(),
      logger: locator<Logger>(),
      baseUrl: AppString.baseUrl,
    ),
  );

  // Register LocalStorage
  locator.registerSingleton<LocalStorage>(
    await LocalStorage.init(logger: locator<Logger>()),
  );

  await configureDependencies();
}
