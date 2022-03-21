import 'package:da_sdoninja/app/constant/string/key_id.dart';
import 'package:da_sdoninja/app/widgets/snackbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

import '../dio_client.dart';

class NotifyApiService {
  static const String _sendNotify = "notifications";


  Future<dynamic> pushNotify(Map<String, dynamic> params) async {
    try {
      await DioClient.post(
          url: _sendNotify,
          data: params,
          options: Options(contentType: Headers.jsonContentType, headers: {"Authorization": "Basic $restAPIKey"}));
    } catch (e) {
      EasyLoading.dismiss();
      snackBar(message: "submit_request_failed".tr);
      throw e;
    }
  }

  static final NotifyApiService _notifyApiService = NotifyApiService._();

  factory NotifyApiService() {
    return _notifyApiService;
  }

  NotifyApiService._();
}
