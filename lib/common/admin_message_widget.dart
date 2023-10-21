import 'dart:async';
import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:get_it/get_it.dart';
import 'package:pegasus_tool/services/firebase_database_service.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils.dart';

class AdminMessageWidget extends StatefulWidget {
  const AdminMessageWidget({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AdminMessageWidgetState();
  }
}

class _AdminMessageWidgetState extends State<AdminMessageWidget> {
  bool loading = true;
  String message = "";
  String title = "";

  late StreamSubscription<DatabaseEvent> messageSubscription;

  FirebaseDatabaseService firebaseDatabaseService =
      GetIt.I<FirebaseDatabaseService>();

  @override
  void initState() {
    super.initState();
    var ecosystemRef = firebaseDatabaseService.firebaseDatabase
        .ref()
        .child('${getEnvironment()}/admin_message');
    messageSubscription = ecosystemRef.onValue.listen((DatabaseEvent event) {
      setState(() {
        var value = event.snapshot.value as Map;
        title = value['title'] ?? "";
        message = value['message'] ?? "";

        loading = title == "" || message == "";
      });
    }, onError: (Object o) {
      log(o.toString());
    });
  }

  @override
  void dispose() {
    super.dispose();
    messageSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Container();
    } else {
      return Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
          child: Card(
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                Padding(
                    padding: const EdgeInsets.only(
                        top: 8.0, bottom: 0.0, left: 8.0, right: 0.0),
                    child: Row(children: [
                      Icon(Icons.chat_bubble_outline,
                          color: Theme.of(context).iconTheme.color, size: 24.0),
                      const SizedBox(width: 8),
                      Expanded(
                          child: Text(title,
                              style: TextStyle(
                                  fontSize: 18.0,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.color)))
                    ])),
                const Divider(),
                Padding(
                    padding:
                        const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8),
                    child: Linkify(
                      onOpen: _onOpen,
                      text: message,
                    ))
              ])));
    }
  }

  Future<void> _onOpen(LinkableElement link) async {
    if (await canLaunchUrl(Uri.parse(link.url))) {
      await launchUrl(Uri.parse(link.url));
    } else {
      debugPrint('Could not launch $link');
    }
  }
}
