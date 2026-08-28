import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tailor_app/core/constants/app_config.dart';
import 'package:tailor_app/core/network/auth_interceptor.dart';
import 'package:tailor_app/core/storage/secure_storage_service.dart';

class ApiClient {
  ApiClient(SecureStorageService secureStorage) {
    final options = BaseOptions(
      baseUrl: AppConfig.apiBaseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: const {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );

    dio = Dio(options);
    dio.interceptors.add(
      AuthInterceptor(
        secureStorage: secureStorage,
        client: dio,
        refreshClient: Dio(options),
      ),
    );
  }

  late final Dio dio;
}

final apiClientProvider = Provider<ApiClient>(
  (ref) => ApiClient(ref.watch(secureStorageProvider)),
);
