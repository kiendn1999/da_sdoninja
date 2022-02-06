import 'package:da_sdoninja/app/controller/function_controller/text_chip_controller.dart';

class PartnerOrderController extends TextChipController {
  void getOrdersOfAllStageOfStore(String? currentStoreID) {
    super.getOrdersOfAllStage(currentStoreID, 'store_id');
  }
}
