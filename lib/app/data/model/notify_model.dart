import 'package:tiengviet/tiengviet.dart';

import '../../constant/string/key_id.dart';

class NotifyModel {
  String? externalUserID;
  String? route;
  int? pageViewIndex;
  int? stageIndex;
  String? largeIcon;
  String? nameInHeading;
  String? nameInContent;
  String? contentVI;
  String? contentEng;


  NotifyModel({
    this.externalUserID,
    this.route,
    this.pageViewIndex=0,
    this.stageIndex=0,
    this.largeIcon,
    this.nameInHeading,
    this.nameInContent,
    this.contentVI,
    this.contentEng,
  });

  Map<String, dynamic> toMapActive() {
    return {
      "app_id": oneSignalAppID,
      "android_channel_id": notifyChannelKey,
      'include_external_user_ids': [externalUserID],
      "channel_for_external_user_ids": "push",
      'data': {"route": route, "pageview_index": pageViewIndex, "stage_index": stageIndex},
      'large_icon': largeIcon,
      'headings':{"en": TiengViet.parse(nameInHeading!), "vi": nameInHeading},
      "contents": {"en": "${TiengViet.parse(nameInContent!)} $contentEng", "vi": "$nameInContent $contentVI"},
    };
  }

  Map<String, dynamic> toMapPassive() {
    return {
      "app_id": oneSignalAppID,
      "android_channel_id": notifyChannelKey,
      'include_external_user_ids': [externalUserID],
      "channel_for_external_user_ids": "push",
      'data': {"route": route, "pageview_index": pageViewIndex, "stage_index": stageIndex},
      'large_icon': largeIcon,
      'headings':{"en": TiengViet.parse(nameInHeading!), "vi": nameInHeading},
      "contents": {"en": "$contentEng ${TiengViet.parse(nameInContent!)}", "vi": "$contentVI $nameInContent"},
    };
  }

}
