import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pegasus_tool/common/list_model.dart';
import 'package:pegasus_tool/loading.dart';
import 'package:pegasus_tool/models/pool_update_model.dart';
import 'package:pegasus_tool/repository/pool_updates_repository.dart';
import 'package:pegasus_tool/screens/pool/update/all_pool_update_item.dart';
import 'package:pegasus_tool/screens/pool/update/all_pool_updates_widget.dart';

class RecentPoolUpdatesWidget extends StatefulWidget {
  const RecentPoolUpdatesWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _RecentPoolUpdatesWidgetState();
  }
}

class _RecentPoolUpdatesWidgetState extends State<RecentPoolUpdatesWidget> {
  late StreamSubscription<List<PoolUpdate>> updateAddedSubscription;
  bool loading = true;

  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  late ListModel<dynamic> _list;

  PoolUpdatesRepository poolUpdatesRepository =
      GetIt.I<PoolUpdatesRepository>();

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    _list = ListModel<dynamic>(
      listKey: _listKey,
      initialItems: [],
      removedItemBuilder: _buildRemovedItem,
    );

    updateAddedSubscription =
        poolUpdatesRepository.getLast3().listen((updates) {
      if (mounted) {
        if (loading) {
          setState(() {
            loading = false;
          });
        }
        for (var element in updates) {
          _insert(element);
        }
      }
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
            Padding(
                padding: const EdgeInsets.only(
                    top: 8.0, bottom: 0.0, left: 8.0, right: 0.0),
                child: Row(children: const [
                  Icon(
                    Icons.update,
                    size: 24.0,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                      child: Text("Pool Updates",
                          style: TextStyle(fontSize: 18.0)))
                ])),
            const Divider(),
            Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Column(children: <Widget>[
                  getList(),
                  SizedBox(
                      width: double.infinity,
                      child: TextButton(
                          onPressed: () {
                            updateAddedSubscription.cancel();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const AllPoolUpdatesWidget()),
                            );
                          },
                          child: Text(
                            "More...",
                            style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).colorScheme.secondary),
                          ))),
                ]))
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
    return AllPoolUpdateItem(
      animation: animation,
      update: _list[index],
      updateIndex: index,
      lastIndex: _list.length - 1,
    );
  }

  Widget _buildRemovedItem(
      dynamic update, BuildContext context, Animation<double> animation) {
    return AllPoolUpdateItem(
        animation: animation,
        update: update,
        updateIndex: -1,
        lastIndex: _list.length - 1);
  }
}
