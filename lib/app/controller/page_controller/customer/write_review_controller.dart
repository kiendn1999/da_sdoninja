import 'package:get/get.dart';

class WriteReviewController extends GetxController {
  final RxString _satisfactionLevel = "very_good".tr.obs;

  String get satisfactionLevel => _satisfactionLevel.value;

   setSatisfactionLevel(double rating) {
    switch (rating.toInt()) {
      case 1:
        _satisfactionLevel.value="very_bad".tr;
        break;
      case 2:
       _satisfactionLevel.value="bad".tr;
        break;
          case 3:
       _satisfactionLevel.value="normal".tr;
        break;
          case 4:
       _satisfactionLevel.value="good".tr;
        break;
           case 5:
       _satisfactionLevel.value="very_good".tr;
        break;
      default:
    }
  }
}
