import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pegasus_tool/common/block_list_header.dart';
import 'package:pegasus_tool/common/list_model.dart';
import 'package:pegasus_tool/loading.dart';
import 'package:pegasus_tool/models/block_model.dart';
import 'package:pegasus_tool/repository/pool_blocks_ne_repository.dart';
import 'package:pegasus_tool/screens/blocks/block_item.dart';
import 'package:pegasus_tool/screens/blocks/block_list.dart';

class PoolRecentBlocksWidget extends StatefulWidget {
  final String moreBlocksScreenTitle;
  final String poolId;

  const PoolRecentBlocksWidget(
      {Key? key, required this.moreBlocksScreenTitle, required this.poolId})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return PoolRecentBlocksState();
  }
}

class PoolRecentBlocksState extends State<PoolRecentBlocksWidget> {
  StreamSubscription<List<Block>>? blockAddedSubscription;
  StreamSubscription<Block>? blockRemovedSubscription;
  bool loading = true;

  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  ListModel<dynamic>? _list;

  int limitToLast = 4;

  PoolBlocksNeRepository poolBlocksNeRepository =
      GetIt.I<PoolBlocksNeRepository>();

  @override
  void initState() {
    super.initState();
    getPoolBlocks();
    // setBlocksRef(widget.blocksRef, widget.moreBlocksScreenTitle);
  }

  void getPoolBlocks() {
    blockAddedSubscription?.cancel();
    blockRemovedSubscription?.cancel();

    _list ??= ListModel<dynamic>(
      listKey: _listKey,
      initialItems: [],
      removedItemBuilder: _buildRemovedItem,
    );
    for (int i = _list!.length - 1; i >= 0; i--) {
      _list!.removeAt(i);
    }

    blockAddedSubscription = poolBlocksNeRepository
        .getPoolBlocks(widget.poolId, limitToLast)
        .listen((poolBlocks) {
      if (mounted) {
        if (loading) {
          setState(() {
            loading = false;
          });
        }
        for (var poolBlock in poolBlocks) {
          _insert(poolBlock);
        }
      }
    }, onError: (Object o) {
      log(o.toString());
    });

    blockRemovedSubscription =
        poolBlocksNeRepository.blockRemovedStream.listen((poolBlock) {
      if (mounted) {
        _remove();
      }
    }, onError: (Object o) {
      log(o.toString());
    });
  }

  @override
  void dispose() {
    super.dispose();
    blockAddedSubscription?.cancel();
    blockRemovedSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const LoadingWidget();
    } else {
      return Column(children: <Widget>[
        const BlockListHeader(showLeader: false),
        getList(),
        getMoreButton(),
      ]);
    }
  }

  Widget getList() {
    return AnimatedList(
        key: _listKey,
        initialItemCount: _list!.length,
        itemBuilder: _buildItem,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true);
  }

  void _insert(dynamic block) {
    _list!.insert(0, block);
  }

  void _remove() {
    _list!.removeAt(_list!.length - 1);
  }

  Widget _buildItem(
      BuildContext context, int index, Animation<double> animation) {
    return BlockItemWidget(
        animation: animation, block: _list![index], showLeader: false);
  }

  Widget _buildRemovedItem(
      dynamic block, BuildContext context, Animation<double> animation) {
    return BlockItemWidget(
        animation: animation, block: block, showLeader: false);
  }

  Widget getMoreButton() {
    return SizedBox(
        height: 48,
        child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BlockList(
                        screenTitle: widget.moreBlocksScreenTitle,
                        showLeader: false,
                        poolId: widget.poolId)),
              );
            },
            child: const Card(
                child: InkWell(
                    child: Align(
                        alignment: Alignment.center,
                        child: Text("More...",
                            style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold)))))));
  }
}
