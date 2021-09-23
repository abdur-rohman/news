import 'package:dio/dio.dart';
import 'package:news/helpers/dio_logging_interceptor.dart';

class DioApi {
  static const oneMinute = 60000;

  static Dio get dio {
    final dio = Dio();
    dio.options.baseUrl = 'http://siamuga.id/services/public/api/mugapay/v1/';
    dio.options.sendTimeout = oneMinute;
    dio.options.connectTimeout = oneMinute;
    dio.options.receiveTimeout = oneMinute;

    dio.interceptors.add(LoggingInterceptor());

    return dio;
  }
}
