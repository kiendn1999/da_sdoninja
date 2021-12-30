import 'package:da_sdoninja/app/data/model/demo/chat_model.dart';
import 'package:da_sdoninja/app/widgets/chat_list.dart';
import 'package:flutter/material.dart';

class PartnerChatScreen extends StatelessWidget {
  const PartnerChatScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChatList(chatList: chatDemoList);
  }
}