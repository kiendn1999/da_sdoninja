import 'package:da_sdoninja/app/controller/function_controller/text_chip_controller.dart';
import 'package:da_sdoninja/app/data/repository/user_info.dart';

class CustomerOrderController extends TextChipController {

   void getOrdersOfAllStageOfStore() {
    super.getOrdersOfAllStage(UserCurrentInfo.userID, 'customer_id');
  }
}
