import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pegasus_tool/loading.dart';
import 'package:pegasus_tool/services/firebase_database_service.dart';
import 'package:pegasus_tool/utils.dart';

import 'chat_proxy_widget.dart';
import 'chat_room_widget.dart';

class ChatRoomScreen extends StatefulWidget {
  //Either poolId or poolSummary is populated (poolId from notification)

  final String poolId;
  final dynamic poolSummary;
  final String roomId;

  const ChatRoomScreen(
      {super.key,
      this.poolSummary,
      required this.poolId,
      required this.roomId});

  @override
  ChatRoomScreenState createState() => ChatRoomScreenState();
}

class ChatRoomScreenState extends State<ChatRoomScreen> {
  late String roomId;
  bool loading = true;
  dynamic poolSummary;

  final FirebaseDatabaseService firebaseDatabaseService =
      GetIt.I<FirebaseDatabaseService>();

  @override
  void initState() {
    super.initState();
    roomId = widget.roomId;
    ChatProxyWidget.onChatRooms.add(widget.roomId);
    if (widget.poolSummary != null) {
      poolSummary = widget.poolSummary;
      loading = false;
    } else {
      loadPool();
    }
  }

  @override
  void dispose() {
    ChatProxyWidget.onChatRooms.remove(widget.roomId);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: DefaultTabController(
            length: 2,
            child: Scaffold(
                backgroundColor: Theme.of(context).colorScheme.background,
                appBar: AppBar(
                    title: AutoSizeText(
                        "Chat with ${poolSummary != null ? getPoolName(poolSummary['id'], poolSummary) : widget.poolId}",
                        maxLines: 1),
                    centerTitle: true),
                body: loading
                    ? const LoadingWidget()
                    : ChatRoomWidget(roomId: roomId))));
  }

  void loadPool() async {
    firebaseDatabaseService.firebaseDatabase
        .ref()
        .child('${getEnvironment()}/stake_pools/${widget.poolId}')
        .once()
        .then((DatabaseEvent event) {
      setState(() {
        poolSummary = event.snapshot.value;
        loading = false;
      });
    }, onError: (Object o) {});
  }
}
