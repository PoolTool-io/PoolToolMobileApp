import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

Dio getDio() {
  var options = BaseOptions(
    baseUrl: 'https://api.pooltool.io/v0/',
  );
  Dio dio = Dio(options);
  dio.options.headers["X-API-KEY"] = "26969ceb-d2d0-46df-9813-852ed4bde2fe";
  dio.options.headers["Content-Type"] = "application/json";
  if (!kReleaseMode) {
    dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: true,
        error: true,
        compact: false));
  }
  return dio;
}
