import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class ApiError {
  int? errorType = 0;
  Object? errorDescription;

  ApiError({this.errorDescription});

  ApiError.fromDio(Object dioError) {
    _handleError(dioError);
  }

  void _handleError(Object error) {
    if (error is DioException) {
      final dioError = error; // as DioError;
      switch (dioError.type) {
        case DioExceptionType.badCertificate:
          errorDescription = 'Bad Certificate';
          break;
        case DioExceptionType.connectionError:
          errorDescription = 'Connection Error';
          break;
        case DioExceptionType.cancel:
          errorDescription = 'Request canceled';
          break;
        case DioExceptionType.connectionTimeout:
          errorDescription = 'Connection timeout';
          break;
        case DioExceptionType.receiveTimeout:
          errorDescription = 'Receiving timeout';
          break;
        case DioExceptionType.sendTimeout:
          errorDescription = 'Sending time out';
          break;
        case DioExceptionType.unknown:
          errorDescription = 'Unknown error';
          break;
        case DioExceptionType.badResponse:
          errorType = dioError.response?.statusCode;
          errorDescription = dioError.response.toString();
          Logger().e('Dio Error', error: dioError);
          break;
      }
    } else {
      errorDescription = 'Something went wrong, please try again...';
    }
  }

  @override
  String toString() => '$errorDescription';
}
