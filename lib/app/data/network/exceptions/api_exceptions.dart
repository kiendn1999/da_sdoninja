import 'package:dio/dio.dart';

class NetworkException implements Exception {
  String message;
  int statusCode;
  NetworkException({required this.message, required this.statusCode});
}

class ServiceException implements Exception {
  String message;
  int statusCode;
  ServiceException({required this.message, required this.statusCode});
}

class AuthException extends NetworkException {
  AuthException({message, status})
      : super(message: message, statusCode: status);
}

class DioErrorUtil {
  static String handleError(DioError error) {
    String errorDescription = "";
    if (error is DioError) {
      switch (error.type) {
        case DioErrorType.cancel:
          errorDescription = "Request to API server was cancelled";
          break;
        case DioErrorType.connectTimeout:
          errorDescription = "Connection timeout with API server";
          break;
        case DioErrorType.other:
          errorDescription =
              "Connection to API server failed due to internet connection";
          break;
        case DioErrorType.receiveTimeout:
          errorDescription = "Receive timeout in connection with API server";
          break;
        case DioErrorType.sendTimeout:
          errorDescription = "Send timeout in connection with API server";
          break;
        case DioErrorType.response:
          errorDescription = "Receive timeout in connection with API server";
          break;
      }
    } else {
      errorDescription = "Unexpected error occurred";
    }
    return errorDescription;
  }
}
