import 'package:dio/dio.dart';
import 'package:flutter_translate/flutter_translate.dart';

/// Constants for error messages with translation support
class ApiErrorMessages {
  static String get connectionTimeout => translate('connectionTimeout');
  static String get sendTimeout => translate('sendTimeout');
  static String get receiveTimeout => translate('receiveTimeout');
  static String get requestCancelled => translate('requestCancelled');
  static String get noInternetConnection => translate('noInternetConnection');
  static String get unexpectedError => translate('unexpectedError');
  static String get serverError => translate('serverError');
  static String get notFound => translate('notFound');
  static String get unauthorized => translate('unauthorized');
  static String get badRequest => translate('badRequest');
  static String get validationError => translate('validationError');
}

/// Abstract base class representing API failures
abstract class ApiFailure {
  final String message;
  final int? statusCode;
  final dynamic data;

  const ApiFailure({required this.message, this.statusCode, this.data});

  @override
  String toString() => 'ApiFailure(message: $message, statusCode: $statusCode)';
}

/// Represents server-related failures
class ServerFailure extends ApiFailure {
  ServerFailure({required super.message, super.statusCode, super.data});

  /// Creates a [ServerFailure] from a [DioException]
  factory ServerFailure.fromDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return ServerFailure(message: ApiErrorMessages.connectionTimeout);
      case DioExceptionType.sendTimeout:
        return ServerFailure(message: ApiErrorMessages.sendTimeout);
      case DioExceptionType.receiveTimeout:
        return ServerFailure(message: ApiErrorMessages.receiveTimeout);
      case DioExceptionType.badResponse:
        return ServerFailure.fromResponse(
          error.response?.statusCode,
          error.response?.data,
        );
      case DioExceptionType.cancel:
        return ServerFailure(message: ApiErrorMessages.requestCancelled);
      case DioExceptionType.unknown:
        if (error.message?.contains('SocketException') == true) {
          return ServerFailure(message: ApiErrorMessages.noInternetConnection);
        }
        return ServerFailure(message: ApiErrorMessages.unexpectedError);
      default:
        return ServerFailure(message: ApiErrorMessages.unexpectedError);
    }
  }

  /// Creates a [ServerFailure] from an HTTP response
  factory ServerFailure.fromResponse(int? statusCode, dynamic response) {
    final responseData = response is Map ? response : {};
    final message = responseData['message']?.toString() ?? '';

    switch (statusCode) {
      case 400:
        return ServerFailure(
          message: message.isNotEmpty ? message : ApiErrorMessages.badRequest,
          statusCode: statusCode,
          data: responseData,
        );
      case 401:
      case 403:
        return ServerFailure(
          message: message.isNotEmpty ? message : ApiErrorMessages.unauthorized,
          statusCode: statusCode,
          data: responseData,
        );
      case 404:
        return ServerFailure(
          message: message.isNotEmpty ? message : ApiErrorMessages.notFound,
          statusCode: statusCode,
          data: responseData,
        );
      case 422:
        return ServerFailure(
          message: message.isNotEmpty
              ? message
              : ApiErrorMessages.validationError,
          statusCode: statusCode,
          data: responseData,
        );
      case 500:
        return ServerFailure(
          message: ApiErrorMessages.serverError,
          statusCode: statusCode,
          data: responseData,
        );
      default:
        return ServerFailure(
          message: ApiErrorMessages.unexpectedError,
          statusCode: statusCode,
          data: responseData,
        );
    }
  }
}

/// Extension methods for DioException
extension DioExceptionExtension on DioException {
  /// Converts a DioException to a ServerFailure
  ServerFailure toServerFailure() => ServerFailure.fromDioError(this);
}
