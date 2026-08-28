import 'package:dio/dio.dart';
import 'package:tailor_app/core/network/api_endpoints.dart';
import 'package:tailor_app/core/storage/secure_storage_service.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required this.secureStorage,
    required this.client,
    required this.refreshClient,
  });

  final SecureStorageService secureStorage;
  final Dio client;
  final Dio refreshClient;
  Future<String?>? _refreshInProgress;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final accessToken = await secureStorage.readAccessToken();

    if (accessToken != null && accessToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final request = err.requestOptions;
    final shouldRefresh =
        err.response?.statusCode == 401 &&
        request.path != ApiEndpoints.refreshToken &&
        request.extra['retried_after_refresh'] != true;

    if (!shouldRefresh) {
      handler.next(err);
      return;
    }

    final accessToken = await _refreshAccessToken();
    if (accessToken == null) {
      handler.next(err);
      return;
    }

    request.headers['Authorization'] = 'Bearer $accessToken';
    request.extra['retried_after_refresh'] = true;

    try {
      handler.resolve(await client.fetch<dynamic>(request));
    } on DioException catch (retryError) {
      handler.next(retryError);
    }
  }

  Future<String?> _refreshAccessToken() {
    return _refreshInProgress ??= _performRefresh().whenComplete(
      () => _refreshInProgress = null,
    );
  }

  Future<String?> _performRefresh() async {
    final refreshToken = await secureStorage.readRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) return null;

    try {
      final response = await refreshClient.post<Map<String, dynamic>>(
        ApiEndpoints.refreshToken,
        data: {'refresh_token': refreshToken},
      );
      final data = response.data?['data'] as Map<String, dynamic>?;
      final tokens = data?['tokens'] as Map<String, dynamic>?;
      final access = tokens?['access_token'] as String?;
      final refresh = tokens?['refresh_token'] as String?;

      if (access == null || refresh == null) return null;

      await secureStorage.writeTokens(
        accessToken: access,
        refreshToken: refresh,
      );
      return access;
    } on DioException {
      await secureStorage.deleteAuthTokens();
      return null;
    }
  }
}
