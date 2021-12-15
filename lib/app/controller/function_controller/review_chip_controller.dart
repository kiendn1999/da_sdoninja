import 'package:da_sdoninja/app/controller/function_controller/navigate_controller.dart';
import 'package:flutter/cupertino.dart';

class ReviewChipController extends NavigateController {
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    super.currentIndex = 5;
    super.pageController = PageController(initialPage: 5);
  }
}
