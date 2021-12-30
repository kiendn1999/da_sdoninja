import 'package:da_sdoninja/app/data/model/demo/store_manage_model.dart';
import 'package:get/get.dart';

class ChangeStoreController extends GetxController {
  final RxInt _currentIndex = 0.obs;
  final Rx<StoreManageDemo> _storeSelected = StoreManageDemo().obs;

  int get currendIndex => _currentIndex.value;
  StoreManageDemo get storeSelected => _storeSelected.value;

  changeStore(int currendIndex, StoreManageDemo storeSelected) {
    _currentIndex.value = currendIndex;
    _storeSelected.value = storeSelected;
    Get.back();
  }
}
