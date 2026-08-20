import 'package:dio/dio.dart';

class NetworkException implements Exception {
  const NetworkException(this.message, {this.statusCode});

  factory NetworkException.fromDio(DioException error) {
    return NetworkException(
      error.message ?? 'A network request failed.',
      statusCode: error.response?.statusCode,
    );
  }

  final String message;
  final int? statusCode;

  @override
  String toString() => 'NetworkException($statusCode): $message';
}
