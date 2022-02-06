import 'package:da_sdoninja/app/controller/function_controller/cru_store_controller.dart';

class AddStoreController extends CrUStoreController {

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    super.getLastPosition();
    super. getLocation();
  }
}
