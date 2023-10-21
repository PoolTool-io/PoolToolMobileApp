import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pegasus_tool/loading.dart';
import 'package:pegasus_tool/models/chat_summary_model.dart';
import 'package:pegasus_tool/models/pool_stats.dart';
import 'package:pegasus_tool/models/stake_pool_model.dart';
import 'package:pegasus_tool/screens/pool/chat/room_summary_widget.dart';
import 'package:pegasus_tool/screens/pool/chat/room_type.dart';
import 'package:pegasus_tool/services/firebase_auth_service.dart';
import 'package:pegasus_tool/services/firebase_database_service.dart';
import 'package:pegasus_tool/utils.dart';

import '../pool_details.dart';

class ChatProxyWidget extends StatefulWidget {
  static List<String> onChatRooms = [];

  final PoolStats poolStats;
  final StakePool poolSummary;

  const ChatProxyWidget(
      {Key? key, required this.poolStats, required this.poolSummary})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ChatProxyWidgetState();
  }
}

class _ChatProxyWidgetState extends State<ChatProxyWidget> {
  dynamic poolStats;
  dynamic poolSummary;
  List<ChatRoomTemplate>? poolRoomTemplates;
  String? privateRoomId;
  num? activeUserDelegation;
  User? user;

  final FirebaseAuthService firebaseAuthService =
      GetIt.I<FirebaseAuthService>();
  final FirebaseDatabaseService firebaseDatabaseService =
      GetIt.I<FirebaseDatabaseService>();

  @override
  void initState() {
    super.initState();
    poolStats = widget.poolStats;
    poolSummary = widget.poolSummary;
    loadActiveDelegation();
    loadPoolRoomTemplates();
  }

  @override
  Widget build(BuildContext context) {
    return isPoolChatReady()
        ? (poolRoomTemplates != null &&
                activeUserDelegation != null &&
                privateRoomId != null
            ? chatSummaryWidgets()
            : const LoadingWidget())
        : notChatReadyWidget();
  }

  Widget chatSummaryWidgets() {
    List<Widget> roomSummaryWidgets = [];
    sortRoomTemplates();
    roomSummaryWidgets.add(chatRoomsTitle());
    roomSummaryWidgets.add(const SizedBox(height: 8));
    poolRoomTemplates?.forEach((roomTemplate) {
      roomSummaryWidgets.add(RoomSummaryWidget(
          poolId: widget.poolSummary.id!,
          roomTemplate: roomTemplate,
          roomId: roomTemplate.type == RoomType.private
              ? privateRoomId!
              : roomTemplate.id!,
          activeUserDelegation: activeUserDelegation!,
          currentUserId: user?.uid));
    });

    return Column(children: roomSummaryWidgets);
  }

  void sortRoomTemplates() {
    poolRoomTemplates?.sort((a, b) {
      if (a.type == RoomType.private) {
        return 0;
      } else if (a.type == RoomType.public) {
        return -1;
      } else {
        if (a.type == b.type) {
          return a.minActiveStake!.compareTo(b.minActiveStake!);
        } else {
          return 1;
        }
      }
    });
  }

  Widget notChatReadyWidget() {
    return Column(children: [
      chatRoomsTitle(),
      const SizedBox(height: 16),
      const Text(
          "This pool operator is not yet ready to chat via PoolTool.\nYou can tap on some chat ready pools below or to see all the pools that are ready to chat with you go to the pools list and use the \"Chat Ready\" filter.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 11)),
      const SizedBox(height: 16),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Column(children: [
          InkWell(
              onTap: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PoolDetails(
                                poolId:
                                    "95c4956f7a137f7fe9c72f2e831e6038744b6307d00143b2447e6443",
                              )),
                    )
                  },
              child: const Image(
                  height: 45, image: AssetImage('assets/love_logo.png'))),
          const SizedBox(height: 8),
          const Text("LOVE",
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold))
        ]),
        const SizedBox(width: 32),
        Column(children: [
          InkWell(
              onTap: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PoolDetails(
                                poolId:
                                    "bbbe8bd9d3942563c7cf02e2d605516fb8376e3a49689d9b028cc2ab",
                              )),
                    )
                  },
              child: const Image(
                  height: 45, image: AssetImage('assets/pegasus_logo.png'))),
          const SizedBox(height: 8),
          const Text("PEGA",
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold))
        ]),
      ]),
    ]);
  }

  Row chatRoomsTitle() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const [
          Text("----------------"),
          Text("Chat Rooms"),
          Text("----------------"),
        ]);
  }

  // }

  bool isPoolChatReady() {
    return poolSummary.c == true;
  }

  void loadActiveDelegation() async {
    user = firebaseAuthService.firebaseAuth.currentUser;
    if (user != null) {
      firebaseDatabaseService.firebaseDatabase
          .ref()
          .child(getEnvironment())
          .child("users")
          .child("pubMeta")
          .child(user!.uid)
          .child("activeDelegations")
          .child(widget.poolSummary.id!)
          .once()
          .then((DatabaseEvent event) {
        if (event.snapshot.value != null) {
          num totalActiveUserDelegation = 0;
          (event.snapshot.value as Map).forEach((stakeKey, amount) {
            totalActiveUserDelegation = totalActiveUserDelegation + amount;
          });
          setState(() {
            activeUserDelegation = totalActiveUserDelegation;
          });
        } else {
          setState(() {
            activeUserDelegation = 0;
          });
        }
      }, onError: (Object o) {
        debugPrint(o.toString());
        setState(() {
          activeUserDelegation = 0;
        });
      });
    } else {
      setState(() {
        activeUserDelegation = 0;
      });
    }
  }

  void loadPoolRoomTemplates() async {
    DatabaseEvent? userChatRooms;

    if (user != null) {
      userChatRooms = await firebaseDatabaseService.firebaseDatabase
          .ref()
          .child(getEnvironment())
          .child("users")
          .child("privMeta")
          .child(user!.uid)
          .child("myChatRooms")
          .child("pools")
          .child(poolSummary.id)
          .once()
          .catchError((err) {
        debugPrint("Error fetching private pool: $err");
      });
    }

    firebaseDatabaseService.firebaseDatabase
        .ref()
        .child(getEnvironment())
        .child("chat")
        .child("ready_pools")
        .child(widget.poolSummary.id!)
        .once()
        .then((DatabaseEvent event) {
      if (event.snapshot.value != null) {
        List<ChatRoomTemplate> templates = [];
        (event.snapshot.value as Map).forEach((roomId, roomTemplate) {
          templates.add(ChatRoomTemplate(
              id: roomId,
              name: roomTemplate['name'],
              description: roomTemplate['description'],
              type: RoomType.values.firstWhere((e) =>
                  e.toString() ==
                  "RoomType.${roomTemplate['type'].toLowerCase()}"),
              minActiveStake: roomTemplate['conditions']['minActiveStake']));

          if (roomTemplate['type'].toLowerCase() == "private" &&
              userChatRooms?.snapshot.value != null) {
            privateRoomId = (userChatRooms?.snapshot.value as Map)
                .keys
                .firstWhere(
                    (k) =>
                        (userChatRooms?.snapshot.value as Map)[k] == 'PRIVATE',
                    orElse: () => null);
          }
        });
        setState(() {
          privateRoomId = privateRoomId ?? "";
          poolRoomTemplates = templates;
        });
      } else {
        setState(() {
          privateRoomId = privateRoomId ?? "";
          poolRoomTemplates = [];
        });
      }
    }, onError: (Object o) {
      debugPrint(o.toString());
      setState(() {
        privateRoomId = privateRoomId ?? "";
        poolRoomTemplates = [];
      });
    });
  }
}
