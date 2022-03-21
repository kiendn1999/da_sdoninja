import 'package:dio/dio.dart';

import 'end_points/api_endpoints.dart';
import 'exceptions/api_exceptions.dart';

class DioClient {
  //Get
  static Future<dynamic> get({required String url, Map<String, dynamic>? queryParameters, Options? options, CancelToken? cancelToken, ProgressCallback? onReceiverProgress}) async {
    try {
      final Response response =
          await Dio().get(ApiPoints.baseUrl + url, queryParameters: queryParameters, options: options, cancelToken: cancelToken, onReceiveProgress: onReceiverProgress);
      print("response get: $response");
      return response.data;
    } catch (e) {
      print("error get: $e");
      if (e is DioError) {
        if (e.response?.statusCode == 404) {
          throw ServiceException(statusCode: 404, message: "Http status error 404");
        } else {
          throw ServiceException(statusCode: 404, message: DioErrorUtil.handleError(e));
        }
      } else {
        rethrow;
      }
    }
  }

  //Post
  static Future<dynamic> post(
      {required String url,
      required dynamic data,
      Map<String, dynamic>? queryParameters,
      Options? options,
      CancelToken? cancelToken,
      ProgressCallback? onSendProgress,
      ProgressCallback? onReceiveProgress}) async {
    try {
      final Response response =
          await Dio().post(ApiPoints.baseUrl + url, data: data, options: options, cancelToken: cancelToken, onSendProgress: onSendProgress, onReceiveProgress: onReceiveProgress);
      return response.data;
    } catch (e) {
      print("error post: $e");
      if (e is DioError) {
        if (e.response?.statusCode != 200) {
          throw NetworkException(statusCode: 400, message: "Http status error [400]");
        }
      } else {
        throw e;
      }
    }
  }
}
