import 'package:dio/dio.dart';

class NetworkException implements Exception {
  const NetworkException(
    this.message, {
    this.statusCode,
    this.code,
    this.errors = const {},
  });

  factory NetworkException.fromDio(DioException error) {
    final body = error.response?.data;
    final json = body is Map<String, dynamic> ? body : null;
    final rawErrors = json?['errors'];
    final errors = <String, List<String>>{};

    if (rawErrors is Map) {
      for (final entry in rawErrors.entries) {
        final value = entry.value;
        errors[entry.key.toString()] = value is List
            ? value.map((item) => item.toString()).toList()
            : [value.toString()];
      }
    }

    return NetworkException(
      json?['message'] as String? ??
          error.message ??
          'A network request failed.',
      statusCode: error.response?.statusCode,
      code: json?['code'] as String?,
      errors: errors,
    );
  }

  final String message;
  final int? statusCode;
  final String? code;
  final Map<String, List<String>> errors;

  @override
  String toString() => 'NetworkException($statusCode): $message';
}
