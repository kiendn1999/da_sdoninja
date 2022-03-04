import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class NavigateController extends GetxController {
  late PageController pageController;
  final _currentIndex = 0.obs;

  int get currentIndex => _currentIndex.value;

  set currentIndex(int currentIndex) {
    _currentIndex.value = currentIndex;
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    pageController = PageController(initialPage: 0);
  }

  
}

