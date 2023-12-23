import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pegasus_tool/loading.dart';
import 'package:pegasus_tool/screens/pool/chat/chat_message.dart';
import 'package:pegasus_tool/services/firebase_auth_service.dart';
import 'package:pegasus_tool/services/firebase_database_service.dart';
import 'package:pegasus_tool/utils.dart';

import 'chat_message_item_widget.dart';

class ChatRoomWidget extends StatefulWidget {
  final String roomId;

  const ChatRoomWidget({super.key, required this.roomId});

  @override
  State<StatefulWidget> createState() {
    return _ChatRoomWidgetState();
  }
}

//TODO load only 10 messages at most then paginate!

class _ChatRoomWidgetState extends State<ChatRoomWidget> {
  bool loading = true;
  List<ChatMessage> messages = [];
  late String userId;
  StreamSubscription<DatabaseEvent>? messagesSubscription;
  final ScrollController _scrollController = ScrollController();
  TextEditingController messageController = TextEditingController();
  bool sendingMessage = false;
  late DatabaseReference roomReference;
  bool hasMessages = false;
  bool isEditable = false;

  final FirebaseDatabaseService firebaseDatabaseService =
      GetIt.I<FirebaseDatabaseService>();
  final FirebaseAuthService firebaseAuthService =
      GetIt.I<FirebaseAuthService>();

  @override
  void initState() {
    super.initState();
    roomReference = firebaseDatabaseService.firebaseDatabase
        .ref()
        .child("${getEnvironment()}/chat/rooms/${widget.roomId}")
        .ref;
    loadDataMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      loading
          ? const LoadingWidget()
          : hasMessages
              ? Flexible(child: buildListView())
              : emptyRoomMessage(),
      loading || !isEditable ? Container() : editTextWidget()
    ]);
  }

  void loadDataMessages() async {
    userId = firebaseAuthService.firebaseAuth.currentUser!.uid;
    hasMessages = (await roomReference.child("messages").limitToFirst(1).once())
            .snapshot
            .value !=
        null;
    var editable = (await roomReference.child("rules/write/$userId").once())
            .snapshot
            .value !=
        null;
    setState(() {
      isEditable = editable;
      if (!hasMessages) {
        loading = false;
      }
    });

    messagesSubscription = roomReference
        .child("messages")
        .orderByChild("createdAt")
        .onChildAdded
        .listen((DatabaseEvent event) async {
      var value = event.snapshot.value as Map;
      messages.add(
          ChatMessage(value["createdAt"], value["content"], value["from"]));
      setState(() {
        hasMessages = true;
        loading = false;
      });

      Timer(
        const Duration(milliseconds: 300),
        () => _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut),
      );
    });
  }

  @override
  void dispose() {
    messagesSubscription?.cancel();
    super.dispose();
  }

  Widget editTextWidget() {
    final Color subColor = Theme.of(context).textTheme.titleMedium!.color!;
    return Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(children: [
              Expanded(
                  child: TextField(
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.edit, color: subColor),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: subColor)),
                          labelStyle: Theme.of(context).textTheme.titleMedium,
                          labelText: "Type your message..."),
                      controller: messageController)),
              const SizedBox(width: 20),
              sendingMessage
                  ? const LoadingWidget()
                  : IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () => sendMessage(),
                      iconSize: 24,
                    )
            ])));
  }

  void sendMessage() {
    if (messageController.text.trim().isEmpty) {
      return;
    }
    var message = messageController.text.trim();
    setState(() {
      messageController.text = "";
      sendingMessage = true;
    });
    var now = DateTime.now().millisecondsSinceEpoch;
    var newMessageRef = roomReference.child("messages").push();
    newMessageRef.set(
        {"content": message, "from": userId, "createdAt": now}).then((value) {
      setState(() {
        sendingMessage = false;
      });
    });
  }

  Widget buildListView() {
    return ListView.builder(
        controller: _scrollController,
        itemCount: messages.length,
        itemBuilder: (BuildContext context, int index) {
          return ChatMessageItemWidget(
              message: messages[index], userId: userId);
        });
  }

  Widget emptyRoomMessage() {
    return const Expanded(
        child: Align(
            alignment: Alignment.center,
            child: Text("There are no messages in this room yet")));
  }
}
