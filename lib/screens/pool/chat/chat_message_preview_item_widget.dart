import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pegasus_tool/screens/pool/chat/chat_message.dart';
import 'package:pegasus_tool/services/local_database_service.dart';
import 'package:pegasus_tool/styles/theme_data.dart';
import 'package:pegasus_tool/utils.dart';

class ChatMessagePreviewItemWidget extends StatelessWidget {
  final ChatMessage message;
  final String? userId;
  final bool isMessageBoardItem;

  const ChatMessagePreviewItemWidget(
      {Key? key,
      required this.message,
      this.userId,
      required this.isMessageBoardItem})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    LocalDatabaseService localDatabaseService = GetIt.I<LocalDatabaseService>();

    return FutureBuilder<String>(
        future: localDatabaseService.getNicknameForUserId(message.from),
        builder:
            (BuildContext context, AsyncSnapshot<String> nicknameSnapshot) {
          return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message.content,
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 4),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      senderLabel(nicknameSnapshot.data!),
                      timeStampLabel()
                    ]),
              ]);
        });
  }

  Text senderLabel(String? nickname) {
    return Text(nickname ?? "",
        textAlign: TextAlign.left,
        style: TextStyle(color: Styles.INACTIVE_COLOR_DARK, fontSize: 11));
  }

  Text timeStampLabel() {
    return Text(formatTimestampAgo(message.createdAt),
        textAlign: TextAlign.right,
        style: TextStyle(color: Styles.INACTIVE_COLOR_DARK, fontSize: 11));
  }

  bool isUserMessage() => message.from == userId;
}
