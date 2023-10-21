import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pegasus_tool/common/block_list_header.dart';
import 'package:pegasus_tool/common/list_model.dart';
import 'package:pegasus_tool/loading.dart';
import 'package:pegasus_tool/models/block_model.dart';
import 'package:pegasus_tool/repository/blocks_repository.dart';
import 'package:pegasus_tool/screens/blocks/block_item.dart';
import 'package:pegasus_tool/screens/blocks/block_list.dart';
import 'package:pegasus_tool/services/epoch_service.dart';

class RecentBlocksWidget extends StatefulWidget {
  const RecentBlocksWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return RecentBlocksState();
  }
}

class RecentBlocksState extends State<RecentBlocksWidget> {
  StreamSubscription<Block>? blockAddedSubscription;
  StreamSubscription<Block>? blockRemovedSubscription;
  bool loading = true;
  int limitToLast = 4;

  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  ListModel<Block>? _list;

  String moreBlocksScreenTitle = "";
  // var blocksRef;

  BlocksRepository blocksRepository = GetIt.I<BlocksRepository>();

  EpochService epochService = GetIt.I<EpochService>();

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() {
    if (epochService.selectedEpoch != null) {
      moreBlocksScreenTitle = "Blocks in Epoch ${epochService.selectedEpoch!}";
      getBlocks(epochService.selectedEpoch!);
    }

    epochService.selectedEpochStream.listen((epoch) {
      moreBlocksScreenTitle = "Blocks in Epoch $epoch";
      getBlocks(epoch);
    });
  }

  void getBlocks(num epoch) {
    blockAddedSubscription?.cancel();
    blockRemovedSubscription?.cancel();

    _list ??= ListModel<Block>(
      listKey: _listKey,
      initialItems: [],
      removedItemBuilder: _buildRemovedItem,
    );

    for (int i = _list!.length - 1; i >= 0; i--) {
      _list!.removeAt(i);
    }

    blocksRepository.getBlocks(epoch, limitToLast);

    blockAddedSubscription = blocksRepository.blockAddedStream.listen((block) {
      if (mounted) {
        if (loading) {
          setState(() {
            loading = false;
          });
        }
        _insert(block);
      }
    }, onError: (Object o) {
      log(o.toString());
    });

    blockRemovedSubscription =
        blocksRepository.blockRemovedStream.listen((block) {
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
        const BlockListHeader(showLeader: true),
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
        animation: animation, block: _list![index], showLeader: true);
  }

  Widget _buildRemovedItem(
      dynamic block, BuildContext context, Animation<double> animation) {
    return BlockItemWidget(
        animation: animation, block: block, showLeader: true);
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
                        screenTitle: moreBlocksScreenTitle, showLeader: true)),
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
