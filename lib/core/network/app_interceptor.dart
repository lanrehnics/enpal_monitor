import 'package:dio/dio.dart';

class AppInterceptor extends Interceptor {
  AppInterceptor();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    handler.next(options);
  }
}

@override
void onResponse(Response response, ResponseInterceptorHandler handler) async {
  if (response.statusCode != null) {
    handler.next(response);
  }
}
