import 'package:da_sdoninja/app/controller/function_controller/conversation_controller.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_instance/src/extension_instance.dart';

class ConversationBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ConversationController>(() { 
      return ConversationController();
    });
  }
}