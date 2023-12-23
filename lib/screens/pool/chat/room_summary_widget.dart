import 'dart:async';
import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/painting/text_style.dart' as paint;
import 'package:get_it/get_it.dart';
import 'package:pegasus_tool/models/chat_summary_model.dart';
import 'package:pegasus_tool/screens/pool/chat/chat_message.dart';
import 'package:pegasus_tool/services/firebase_database_service.dart';
import 'package:pegasus_tool/services/firebase_messaging_service.dart';
import 'package:pegasus_tool/styles/theme_data.dart';
import 'package:pegasus_tool/utils.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import 'chat_message_preview_item_widget.dart';
import 'chat_proxy_widget.dart';
import 'chat_room_screen.dart';

class RoomSummaryWidget extends StatefulWidget {
  final ChatRoomTemplate roomTemplate;
  //We can't use roomTemplate's roomId as it's different when it's a private pool
  final String roomId;
  final num activeUserDelegation;
  final String? currentUserId;
  final String poolId;

  const RoomSummaryWidget({
    super.key,
    required this.poolId,
    required this.roomTemplate,
    required this.roomId,
    required this.activeUserDelegation,
    this.currentUserId,
  });

  @override
  State<StatefulWidget> createState() {
    return _RoomSummaryWidgetState();
  }
}

class _RoomSummaryWidgetState extends State<RoomSummaryWidget> {
  StreamSubscription<DatabaseEvent>? lastMessageSubscription;
  StreamSubscription? alertValueSubscription;
  StreamSubscription? alertDeletionSubscription;
  ChatMessage? lastMessage;
  dynamic alert;

  final FirebaseDatabaseService firebaseDatabaseService =
      GetIt.I<FirebaseDatabaseService>();
  final FirebaseMessagingService firebaseMessagingService =
      GetIt.I<FirebaseMessagingService>();

  @override
  void initState() {
    ChatProxyWidget.onChatRooms.add(widget.roomId);
    if (lastMessageSubscription == null) {
      lastMessageSubscription = firebaseDatabaseService.firebaseDatabase
          .ref()
          .child(getEnvironment())
          .child("chat")
          .child("rooms")
          .child(widget.roomId)
          .child("messages")
          .orderByChild("createdAt")
          .limitToLast(1)
          .onChildAdded
          .listen((DatabaseEvent event) {
        if (mounted) {
          setState(() {
            var value = event.snapshot.value as Map;
            lastMessage = ChatMessage(
                value['createdAt'], value['content'], value['from']);
          });
        }
      }, onError: (Object o) {
        debugPrint(o.toString());
      });
      super.initState();
    }
    initAlert();
  }

  @override
  void dispose() {
    ChatProxyWidget.onChatRooms.remove(widget.roomId);
    alertDeletionSubscription?.cancel();
    alertValueSubscription?.cancel();
    lastMessageSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
          Padding(
              padding: const EdgeInsets.only(top: 8, left: 8),
              child: Row(children: [
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text(widget.roomTemplate.name!,
                          style: const TextStyle(fontSize: 18.0)),
                      Text(widget.roomTemplate.description!,
                          style: const TextStyle(
                              fontSize: 11, color: Styles.DIVIDER_COLOR))
                    ])),
                !isRoomAccessible()
                    ? Container()
                    : Switch(
                        value: alert != null,
                        activeColor: Theme.of(context).colorScheme.secondary,
                        inactiveTrackColor: Theme.of(context).disabledColor,
                        onChanged: (newValue) {
                          if (newValue == true) {
                            showAlertDialog(context);
                            addAlert();
                          } else {
                            deleteAlert();
                          }
                        }),
                !isRoomAccessible()
                    ? Container()
                    : InkWell(
                        onTap: () => {showAlertDialog(context)},
                        child: Icon(
                          alert != null
                              ? Icons.notifications_active_sharp
                              : Icons.notifications_none_outlined,
                          size: 24.0,
                        )),
                const SizedBox(width: 8),
              ])),
          const Divider(),
          Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
              child: isRoomAccessible()
                  ? roomPreviewWidget()
                  : delegationProgressWidget()),
          isRoomAccessible() ? enterButton() : Container()
        ]));
  }

  bool isRoomAccessible() {
    return widget.activeUserDelegation >= widget.roomTemplate.minActiveStake!;
  }

  Widget delegationProgressWidget() {
    var delegationProgress = widget.roomTemplate.minActiveStake! > 0
        ? widget.activeUserDelegation /
            widget.roomTemplate.minActiveStake!.toDouble()
        : 0.0;

    return Column(children: [
      const Text("Delegate enough to this pool to unlock this room!",
          textAlign: TextAlign.center, style: TextStyle(fontSize: 11)),
      const SizedBox(height: 8),
      LinearPercentIndicator(
        barRadius: const Radius.circular(150.0),
        width: MediaQuery.of(context).size.width - 40,
        animation: true,
        animateFromLastPercent: false,
        lineHeight: 24.0,
        percent: min(delegationProgress, 1.0),
        center: Text(
            "Your Active Delegation - ₳${formatLovelaces(widget.activeUserDelegation)} / ₳${formatLovelaces(widget.roomTemplate.minActiveStake)}",
            style: const paint.TextStyle(
                color: Styles.LIVE_SATURATION_LEVEL_TEXT_COLOR,
                fontSize: 11,
                fontWeight: FontWeight.bold)),
        progressColor: Styles.SUCCESS_COLOR2,
        backgroundColor: Styles.LIVE_SATURATION_LEVEL_BACKGROUND_COLOR,
      )
    ]);
  }

  Widget roomPreviewWidget() {
    if (lastMessage == null) {
      return const Align(
          alignment: Alignment.center,
          child: Text("There are no messages in this room yet.",
              textAlign: TextAlign.center, style: TextStyle(fontSize: 11)));
    } else {
      return Column(children: [
        ChatMessagePreviewItemWidget(
            message: lastMessage!,
            userId: widget.currentUserId,
            isMessageBoardItem: false),
      ]);
    }
  }

  void initAlert() async {
    DatabaseReference alertRef = firebaseDatabaseService.firebaseDatabase
        .ref()
        .child(getEnvironment())
        .child("chat")
        .child("rooms")
        .child(widget.roomId)
        .child("notifications")
        .child("mobile")
        .child(widget.currentUserId!);
    alertRef.keepSynced(true);
    alertDeletionSubscription = alertRef.onChildRemoved.listen(updateAlert);
    alertValueSubscription = alertRef.onValue.listen(updateAlert);
  }

  void updateAlert(DatabaseEvent event) {
    setState(() {
      alert = event.snapshot.value;
    });
  }

  void addAlert() async {
    String? token = await firebaseMessagingService.firebaseMessaging.getToken();

    firebaseDatabaseService.firebaseDatabase
        .ref()
        .child(getEnvironment())
        .child("chat")
        .child("rooms")
        .child(widget.roomId)
        .child("notifications")
        .child("mobile")
        .child(widget.currentUserId!)
        .set(token)
        .catchError((err) {
      showErrorToast("An error occurred. Please try again!$err");
    });
  }

  void deleteAlert() async {
    firebaseDatabaseService.firebaseDatabase
        .ref()
        .child(getEnvironment())
        .child("chat")
        .child("rooms")
        .child(widget.roomId)
        .child("notifications")
        .child("mobile")
        .child(widget.currentUserId!)
        .remove();
  }

  void showAlertDialog(BuildContext context) => showInfoDialog(
      context,
      "New Message Alert",
      "You will receive a notification when a new message is posted in this room.");

  Widget enterButton() {
    return SizedBox(
        width: double.infinity,
        child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
            child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChatRoomScreen(
                            roomId: widget.roomId, poolId: widget.poolId)),
                  );
                },
                icon: const Icon(Icons.exit_to_app, color: Colors.white),
                label: const Text("Enter"))));
  }
}
