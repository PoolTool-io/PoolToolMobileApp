import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pegasus_tool/common/list_model.dart';
import 'package:pegasus_tool/config/constants.dart';
import 'package:pegasus_tool/loading.dart';
import 'package:pegasus_tool/models/favourite_pool_model.dart';
import 'package:pegasus_tool/models/pool_update_model.dart';
import 'package:pegasus_tool/repository/pool_updates_repository.dart';
import 'package:pegasus_tool/services/local_database_service.dart';
import 'package:pegasus_tool/styles/theme_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'all_pool_update_item.dart';

class AllPoolUpdatesWidget extends StatefulWidget {
  const AllPoolUpdatesWidget({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AllPoolUpdatesWidgetState();
  }
}

class _AllPoolUpdatesWidgetState extends State<AllPoolUpdatesWidget> {
  bool loading = true;
  bool loadingMore = false;
  bool hasError = false;
  late bool showFavorites;
  late List<FavouritePool> favoritePools;

  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  late final ListModel<PoolUpdate> _list;

  PoolUpdatesRepository poolUpdatesRepository =
      GetIt.I<PoolUpdatesRepository>();

  StreamSubscription<PoolUpdate>? poolUpdateStreamSubscription;
  StreamSubscription<PoolUpdate>? morePoolUpdateStreamSubscription;

  final int nextPageThreshold = 20;

  @override
  void initState() {
    super.initState();

    _list = ListModel<PoolUpdate>(
      listKey: _listKey,
      initialItems: [],
      removedItemBuilder: _buildRemovedItem,
    );

    init();
  }

  @override
  void dispose() {
    super.dispose();
    poolUpdateStreamSubscription?.cancel();
    morePoolUpdateStreamSubscription?.cancel();
  }

  void init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    showFavorites =
        prefs.getBool(Constants.PREFS_SHOW_FAVORITE_POOL_UPDATES) ?? false;

    LocalDatabaseService database =
        await GetIt.I<LocalDatabaseService>().getInstance();
    favoritePools = await database.getFavouritePools();

    for (int i = _list.length - 1; i >= 0; i--) {
      _list.removeAt(i);
    }

    if (showFavorites) {
      poolUpdateStreamSubscription = poolUpdatesRepository
          .favoritePoolUpdatesStreamController.stream
          .asBroadcastStream()
          .listen((element) {
        if (mounted) {
          if (loading) {
            setState(() {
              loading = false;
            });
          }

          _insertInOrder(element);
        }
      });

      for (var favoritePool in favoritePools) {
        poolUpdatesRepository.getUpdatesForPoolId(favoritePool.id);
      }
    } else {
      poolUpdateStreamSubscription = poolUpdatesRepository
          .poolUpdatesStreamController.stream
          .asBroadcastStream()
          .listen((poolUpdate) {
        if (mounted) {
          if (loading) {
            setState(() {
              loading = false;
            });
          }

          _insert(poolUpdate);

          if (poolUpdatesRepository.endBeforeTime == 0) {
            poolUpdatesRepository.endBeforeTime = poolUpdate.time!;
          } else {
            poolUpdatesRepository.endBeforeTime =
                poolUpdate.time! < poolUpdatesRepository.endBeforeTime
                    ? poolUpdate.time!
                    : poolUpdatesRepository.endBeforeTime;
          }
        }
      });

      poolUpdatesRepository.getFirst();
    }
  }

  void loadMore() {
    if (!loadingMore) {
      loadingMore = true;

      morePoolUpdateStreamSubscription = poolUpdatesRepository
          .poolUpdatesStreamController.stream
          .asBroadcastStream()
          .listen((nextUpdate) {
        if (mounted) {
          if (loadingMore) {
            setState(() {
              loadingMore = false;
            });
          }

          if (poolUpdatesRepository.endBeforeTime == 0) {
            poolUpdatesRepository.endBeforeTime = nextUpdate.time!;
          } else {
            poolUpdatesRepository.endBeforeTime =
                nextUpdate.time! < poolUpdatesRepository.endBeforeTime
                    ? nextUpdate.time!
                    : poolUpdatesRepository.endBeforeTime;
          }

          _insertInOrder(nextUpdate);
        }
      });

      poolUpdatesRepository.getNext();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Scaffold(
            appBar: AppBar(title: const Text("Stake Pool Updates")),
            body: Material(
                color: Theme.of(context).colorScheme.background,
                child: loading
                    ? const LoadingWidget()
                    : Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: Column(
                            children: [getList(), getFilterWidget()])))));
  }

  Widget getList() {
    return Expanded(
      child: RefreshIndicator(
          onRefresh: () {
            setState(() {
              loading = true;
            });

            return Future.delayed(const Duration(milliseconds: 100), () {
              init();
            });
          },
          child: AnimatedList(
              key: _listKey,
              initialItemCount: _list.length,
              itemBuilder: _buildItem)),
    );
  }

  void _insert(PoolUpdate poolUpdate) {
    _list.insert(0, poolUpdate);
    // poolUpdatesRepository.allPoolUpdates = _list.items;
  }

  void _insertInOrder(PoolUpdate poolUpdate) {
    _list.insertInOrder(poolUpdate, (a, b) => b.time!.compareTo(a.time!));
    // poolUpdatesRepository.allPoolUpdates = _list.items;
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

    return AllPoolUpdateItem(
        animation: animation,
        update: _list[index],
        updateIndex: index,
        lastIndex: _list.length - 1);
  }

  Widget _buildRemovedItem(
      PoolUpdate update, BuildContext context, Animation<double> animation) {
    return AllPoolUpdateItem(
        animation: animation,
        update: update,
        updateIndex: -1,
        lastIndex: _list.length - 1);
  }

  Widget getFilterWidget() {
    return SwitchListTile(
        title: const Text("Favorites", style: TextStyle(fontSize: 12)),
        value: showFavorites,
        inactiveTrackColor: Styles.INACTIVE_COLOR_DARK,
        secondary:
            Icon(Icons.filter_list, color: Theme.of(context).iconTheme.color),
        activeColor: Theme.of(context).colorScheme.secondary,
        onChanged: (newValue) async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          setState(() {
            prefs.setBool(Constants.PREFS_SHOW_FAVORITE_POOL_UPDATES, newValue);
            showFavorites = newValue;
            loading = true;
            init();
          });
        });
  }
}
