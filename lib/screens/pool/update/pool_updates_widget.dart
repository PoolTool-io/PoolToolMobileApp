import 'dart:async';
import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pegasus_tool/common/list_model.dart';
import 'package:pegasus_tool/loading.dart';
import 'package:pegasus_tool/screens/pool/update/pool_update_item.dart';
import 'package:pegasus_tool/services/firebase_database_service.dart';
import 'package:pegasus_tool/utils.dart';

class PoolUpdatesWidget extends StatefulWidget {
  final String poolId;

  const PoolUpdatesWidget({super.key, required this.poolId});

  @override
  State<StatefulWidget> createState() {
    return _PoolUpdatesWidgetState();
  }
}

class _PoolUpdatesWidgetState extends State<PoolUpdatesWidget> {
  late StreamSubscription<DatabaseEvent> updateAddedSubscription;
  bool loading = true;

  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  late ListModel<dynamic> _list;

  final FirebaseDatabaseService firebaseDatabaseService =
      GetIt.I<FirebaseDatabaseService>();

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    var updateRef = firebaseDatabaseService.firebaseDatabase
        .ref()
        .child('${getEnvironment()}/pool_updates_blockfrost/${widget.poolId}')
        .orderByChild('time');

    _list = ListModel<dynamic>(
      listKey: _listKey,
      initialItems: [],
      removedItemBuilder: _buildRemovedItem,
    );

    updateAddedSubscription =
        updateRef.onChildAdded.listen((DatabaseEvent event) {
      if (mounted) {
        if (loading) {
          setState(() {
            loading = false;
          });
        }
        _insert(event.snapshot.value);
      }
    }, onError: (Object o) {
      log(o.toString());
    });
  }

  @override
  void dispose() {
    super.dispose();
    updateAddedSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const LoadingWidget();
    } else {
      return Card(
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
            const Padding(
                padding: EdgeInsets.only(
                    top: 8.0, bottom: 0.0, left: 8.0, right: 0.0),
                child: Row(children: [
                  Icon(
                    Icons.update,
                    size: 24.0,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                      child: Text("Updates", style: TextStyle(fontSize: 18.0)))
                ])),
            const Divider(),
            Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Column(children: <Widget>[getList()]))
          ]));
    }
  }

  Widget getList() {
    return AnimatedList(
        key: _listKey,
        initialItemCount: _list.length,
        itemBuilder: _buildItem,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true);
  }

  void _insert(dynamic block) {
    _list.insert(0, block);
  }

  Widget _buildItem(
      BuildContext context, int index, Animation<double> animation) {
    return PoolUpdateItem(
      animation: animation,
      update: _list[index],
      updateIndex: index,
    );
  }

  Widget _buildRemovedItem(
      dynamic update, BuildContext context, Animation<double> animation) {
    return PoolUpdateItem(
        animation: animation, update: update, updateIndex: -1);
  }
}
