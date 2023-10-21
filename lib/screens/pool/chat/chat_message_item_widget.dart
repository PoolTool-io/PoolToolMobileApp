import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pegasus_tool/screens/pool/chat/chat_message.dart';
import 'package:pegasus_tool/services/local_database_service.dart';
import 'package:pegasus_tool/styles/theme_data.dart';
import 'package:pegasus_tool/utils.dart';

class ChatMessageItemWidget extends StatelessWidget {
  final ChatMessage message;
  final String userId;

  const ChatMessageItemWidget(
      {Key? key, required this.message, required this.userId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    LocalDatabaseService localDatabaseService = GetIt.I<LocalDatabaseService>();

    return FutureBuilder<String>(
        future: localDatabaseService.getNicknameForUserId(message.from),
        builder:
            (BuildContext context, AsyncSnapshot<String> nicknameSnapshot) {
          return Padding(
              padding: EdgeInsets.fromLTRB(
                  isUserMessage() ? 40 : 8, 8, isUserMessage() ? 8 : 40, 0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                        width: double.infinity,
                        child: Text(nicknameSnapshot.data ?? "",
                            textAlign: isUserMessage()
                                ? TextAlign.right
                                : TextAlign.left,
                            style: TextStyle(
                                color: Styles.INACTIVE_COLOR_DARK,
                                fontSize: 11))),
                    SizedBox(
                        width: double.infinity,
                        child: Card(
                            color:
                                isUserMessage() ? Colors.green : Colors.white,
                            child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Text(
                                        message.content,
                                        textAlign: isUserMessage()
                                            ? TextAlign.left
                                            : TextAlign.left,
                                        style: TextStyle(
                                            color: isUserMessage()
                                                ? Colors.white
                                                : Colors.black),
                                      ),
                                      Text(
                                          formatTimestampAgo(message.createdAt),
                                          textAlign: isUserMessage()
                                              ? TextAlign.left
                                              : TextAlign.right,
                                          style: TextStyle(
                                              color: isUserMessage()
                                                  ? Colors.white
                                                  : Styles.INACTIVE_COLOR_DARK,
                                              fontSize: 11))
                                    ]))))
                  ]));
        });
  }

  bool isUserMessage() => message.from == userId;
}
