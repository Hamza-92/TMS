import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tailor_app/core/constants/app_config.dart';
import 'package:tailor_app/core/network/auth_interceptor.dart';
import 'package:tailor_app/core/storage/secure_storage_service.dart';

class ApiClient {
  ApiClient(SecureStorageService secureStorage)
    : dio = Dio(
        BaseOptions(
          baseUrl: AppConfig.apiBaseUrl,
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
          headers: const {'Accept': 'application/json'},
        ),
      )..interceptors.add(AuthInterceptor(secureStorage));

  final Dio dio;
}

final apiClientProvider = Provider<ApiClient>(
  (ref) => ApiClient(ref.watch(secureStorageProvider)),
);
