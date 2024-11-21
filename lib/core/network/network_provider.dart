import 'package:dio/dio.dart';
import 'package:enpal_monitor/core/constants/app_config.dart';
import 'package:enpal_monitor/core/network/api_error.dart';
import 'package:flutter/material.dart';

import 'app_interceptor.dart';

class NetworkProvider {
  late Dio dio;

  NetworkProvider({String? baseUrl}) {
    dio = Dio(BaseOptions(
      baseUrl: baseUrl ?? AppConfig.baseUrl,
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
    ));

    dio.interceptors.add(AppInterceptor());
  }

  NetworkProvider.test(this.dio);

  Future<Response> call(
    String path,
    RequestMethod method, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParams,
    data,
    FormData? formData,
    GlobalKey<ScaffoldState>? scaffoldKey,
    Function(int, int, GlobalKey<ScaffoldState>)? trackProgress,
  }) async {
    Response response;
    var params = queryParams ?? {};
    if (params.keys.contains('searchTerm') ?? false) {
      params['searchTerm'] = Uri.encodeQueryComponent(params['searchTerm']);
    }

    try {
      switch (method) {
        case RequestMethod.post:
          response = await dio.post(
            path,
            data: data,
            options: Options(headers: headers),
          );
          break;

        case RequestMethod.postFormData:
          response = await dio.post(path, data: formData, onSendProgress: (sent, total) {
            if (trackProgress != null) {
              trackProgress(sent, total, scaffoldKey!);
            }
          }, options: Options(headers: headers));
          break;
        case RequestMethod.get:
          response = await dio.get(path, queryParameters: params, options: Options(headers: headers));
          break;
        case RequestMethod.put:
          response = await dio.put(path, data: data);
          break;
        case RequestMethod.delete:
          response = await dio.delete(
            path,
            queryParameters: params,
            data: data,
          );
          break;
        case RequestMethod.upload:
          response = await dio.post(path, data: formData, queryParameters: params, onSendProgress: (sent, total) {});
          break;
      }
      return response;
    } on DioException catch (error) {
      var apiError = ApiError.fromDio(error);

      return Future.error(apiError.errorDescription ?? 'An error occurred while performing this action.');
    }
  }

  FormData getFormData(Map<String, dynamic> map) {
    var formData = FormData.fromMap(map);
    return formData;
  }
}

enum RequestMethod { post, get, put, delete, upload, postFormData }
