import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pegasus_tool/common/block_list_header.dart';
import 'package:pegasus_tool/common/list_model.dart';
import 'package:pegasus_tool/loading.dart';
import 'package:pegasus_tool/models/block_model.dart';
import 'package:pegasus_tool/repository/blocks_repository.dart';
import 'package:pegasus_tool/repository/pool_blocks_ne_repository.dart';
import 'package:pegasus_tool/screens/blocks/block_item.dart';
import 'package:pegasus_tool/services/epoch_service.dart';

class BlockList extends StatefulWidget {
  final bool showLeader;
  final String screenTitle;
  final String? poolId;

  const BlockList(
      {Key? key,
      required this.screenTitle,
      required this.showLeader,
      this.poolId})
      : super(key: key);

  @override
  BlockListState createState() => BlockListState();
}

class BlockListState extends State<BlockList> {
  var loading = true;

  StreamSubscription<List<Block>>? poolBlocksSubscription;
  StreamSubscription<Block>? blocksSubscription;
  StreamSubscription<Block>? moreBlocksSubscription;
  StreamSubscription<num>? selectedEpochSubscription;

  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  late ListModel<Block> _list;

  BlocksRepository blocksRepository = GetIt.I<BlocksRepository>();
  PoolBlocksNeRepository poolBlocksNeRepository =
      GetIt.I<PoolBlocksNeRepository>();
  EpochService epochService = GetIt.I<EpochService>();

  bool loadingMore = false;

  final int nextPageThreshold = 20;
  bool hasError = false;

  @override
  void initState() {
    super.initState();

    _list = ListModel<Block>(
      listKey: _listKey,
      initialItems: [],
      removedItemBuilder: _buildRemovedItem,
    );

    if (widget.poolId == null) {
      if (epochService.selectedEpoch != null) {
        getBlocks(epochService.selectedEpoch!);
      }

      selectedEpochSubscription =
          epochService.selectedEpochStream.listen((epoch) {
        getBlocks(epoch);
      });
    } else {
      getPoolBlocks(widget.poolId!);
    }
  }

  void getPoolBlocks(String poolId) {
    poolBlocksSubscription =
        poolBlocksNeRepository.getPoolBlocks(poolId, 200).listen((poolBlocks) {
      if (loading) {
        setState(() {
          loading = false;
        });
      }
      for (var poolBlock in poolBlocks) {
        _insert(poolBlock);
      }
    }, onError: (Object o) {
      log(o.toString());
    });
  }

  void getBlocks(num epoch) {
    blocksSubscription = blocksRepository.blocksStream.listen((block) {
      if (loading) {
        setState(() {
          loading = false;
        });
      }
      _insertInOrder(block);
    }, onError: (Object o) {
      log(o.toString());
    });
    blocksRepository.getLastBlocks(epoch);
  }

  void loadMore() {
    if (!loadingMore) {
      loadingMore = true;

      moreBlocksSubscription =
          blocksRepository.nextBlocksStream.listen((block) {
        if (mounted) {
          if (loadingMore) {
            setState(() {
              loadingMore = false;
            });
          }
        }
      }, onError: (Object o) {
        log(o.toString());
      });
      blocksRepository.getNextBlocks(epochService.selectedEpoch!);
    }
  }

  @override
  void dispose() {
    super.dispose();
    poolBlocksSubscription?.cancel();
    blocksSubscription?.cancel();
    moreBlocksSubscription?.cancel();
    selectedEpochSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Scaffold(
            appBar: AppBar(title: Text(widget.screenTitle)),
            body: Material(
                color: Theme.of(context).colorScheme.background,
                child: loading
                    ? const LoadingWidget()
                    : Column(children: <Widget>[
                        BlockListHeader(showLeader: widget.poolId == null),
                        getList()
                      ]))));
  }

  Widget getList() {
    return Expanded(
        child: AnimatedList(
            key: _listKey,
            initialItemCount: _list.length,
            itemBuilder: _buildItem));
  }

  void _insertInOrder(Block block) {
    _list.insertInOrder(block, (a, b) => b.block!.compareTo(a.block!));
  }

  void _insert(dynamic block) {
    _list.insert(0, block);
  }

  Widget _buildItem(
      BuildContext context, int index, Animation<double> animation) {
    if (index == _list.length - nextPageThreshold) {
      loadMore();
    }
    if (index == _list.length) {
      if (hasError) {
        return Center(
            child: InkWell(
          onTap: () {
            loadMore();
          },
          child: const Padding(
            padding: EdgeInsets.all(16),
            child: Text('Error while loading pool updates, tap to try again.'),
          ),
        ));
      } else if (loadingMore) {
        return Center(
            child: Padding(
          padding: const EdgeInsets.all(18),
          child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primary,
              backgroundColor: Theme.of(context).colorScheme.secondary),
        ));
      }
    }
    return BlockItemWidget(
        animation: animation,
        block: _list[index],
        showLeader: widget.showLeader);
  }

  Widget _buildRemovedItem(
      dynamic block, BuildContext context, Animation<double> animation) {
    return BlockItemWidget(
        animation: animation, block: block, showLeader: widget.showLeader);
  }
}
