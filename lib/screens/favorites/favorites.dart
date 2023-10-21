import 'dart:math';

import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pegasus_tool/config/constants.dart';
import 'package:pegasus_tool/enums/sort_enum.dart';
import 'package:pegasus_tool/loading.dart';
import 'package:pegasus_tool/models/stake_pool_model.dart';
import 'package:pegasus_tool/repository/stake_pools_repository.dart';
import 'package:pegasus_tool/screens/pools/pool_item.dart';
import 'package:pegasus_tool/services/epoch_service.dart';
import 'package:pegasus_tool/services/hive_service.dart';
import 'package:pegasus_tool/services/navigator_service.dart';
import 'package:pegasus_tool/styles/theme_data.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class FavoritesWidget extends StatefulWidget {
  const FavoritesWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _FavoritesWidgetState();
  }
}

class _FavoritesWidgetState extends State<FavoritesWidget> with RouteAware {
  List<StakePool> favouritePools = [];
  dynamic featuredPool;
  num? currentEpoch;

  bool loading = true;

  Sort sort = Sort.rank;
  bool desc = false;

  StakePoolsRepository stakePoolsRepository = GetIt.I<StakePoolsRepository>();
  EpochService epochService = GetIt.I<EpochService>();
  NavigationService navigationService = GetIt.I<NavigationService>();
  HiveService hiveService = GetIt.I<HiveService>();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const LoadingWidget()
        : (favouritePools.isEmpty
            ? emptyFavoritesWidget(context)
            : listWidget(context));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    navigationService.routeObserver
        .subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void dispose() {
    navigationService.routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    loadFavorites();
  }

  void loadFavorites() async {
    currentEpoch = epochService.currentEpoch;

    favouritePools = hiveService.favouriteStakePools.values.toList();

    if (favouritePools.isEmpty) {
      setState(() {
        loading = false;
      });
    }

    // favouritePools = [];
    setState(() {
      loading = false;
      favouritePools.sort(sortFunction);
    });
  }

  // Reload favouritePools
  Future<void> refreshFavouritePools() async {
    setState(() {
      loading = true;
    });

    for (StakePool pool in favouritePools) {
      await stakePoolsRepository.getStakePool(pool.id!);
    }

    loadFavorites();
  }

  Widget emptyFavoritesWidget(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: const Center(
            child: Text("You don't have any favourite pools!",
                textAlign: TextAlign.center)));
  }

  Widget listWidget(BuildContext context) {
    return Column(children: [
      featuredPool != null ? getFeaturedPoolWidget(context) : getListHeader(),
      Flexible(
        child: loading
            ? const LoadingWidget()
            : RefreshIndicator(
                onRefresh: () {
                  return Future.delayed(const Duration(milliseconds: 100), () {
                    refreshFavouritePools();
                  });
                },
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 80),
                  itemCount: favouritePools.length,
                  itemBuilder: (context, index) {
                    return PoolItemWidget(
                        pool: favouritePools[index],
                        currentEpoch: currentEpoch!);
                  },
                ),
              ),
      )
    ]);
  }

  Widget getListHeader() {
    return Row(
      children: <Widget>[
        Expanded(
            child: InkWell(
                onTap: () => setSort(Sort.rank),
                child: Align(
                    heightFactor: 3,
                    alignment: Alignment.center,
                    child: Text("Rank${sortIndicator(Sort.rank)}",
                        style: const TextStyle(
                            fontSize: 12.0, fontWeight: FontWeight.bold))))),
        /* isLandscape(context)
            ? */
        Expanded(
            child: InkWell(
                onTap: () => setSort(Sort.blocks),
                child: Align(
                    heightFactor: 3,
                    alignment: Alignment.center,
                    child: Text(
                        "Epoch / Total Blocks${sortIndicator(Sort.blocks)}",
                        style: const TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold))))) /*: Container()*/,
        Expanded(
            child: InkWell(
                onTap: () => setSort(Sort.roi),
                child: Align(
                    heightFactor: 3,
                    alignment: Alignment.center,
                    child: Text("ROS${sortIndicator(Sort.roi)}",
                        style: const TextStyle(
                            fontSize: 12.0, fontWeight: FontWeight.bold))))),
        Expanded(
            child: InkWell(
                onTap: () => setSort(Sort.fee),
                child: Align(
                    heightFactor: 3,
                    alignment: Alignment.center,
                    child: Text("Fee${sortIndicator(Sort.fee)}",
                        style: const TextStyle(
                            fontSize: 12.0, fontWeight: FontWeight.bold))))),
        Expanded(
            child: InkWell(
                onTap: () => setSort(Sort.stake),
                child: Align(
                    heightFactor: 3,
                    alignment: Alignment.center,
                    child: Text("Live Stake (₳)${sortIndicator(Sort.stake)}",
                        style: const TextStyle(
                            fontSize: 12.0, fontWeight: FontWeight.bold)))))
      ],
    );
  }

  Widget getFeaturedPoolWidget(BuildContext context) {
    return Column(children: [
      ExpandablePanel(
        header: Padding(
            padding: const EdgeInsets.only(
                top: 16.0, bottom: 0.0, left: 0.0, right: 0.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.star,
                      size: 12, color: Styles.INACTIVE_COLOR),
                  const SizedBox(width: 8),
                  Text("FEATURED POOL: ${featuredPool['ticker']}",
                      style: TextStyle(color: Styles.INACTIVE_COLOR_DARK)),
                  const SizedBox(width: 8),
                  const Icon(Icons.star,
                      size: 12, color: Styles.INACTIVE_COLOR),
                ])),
        collapsed: getListHeader(),
        expanded: Column(children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                LinearPercentIndicator(
                  barRadius: const Radius.circular(150.0),
                  width: MediaQuery.of(context).size.width - 50,
                  animation: false,
                  lineHeight: 20.0,
                  percent: min(featuredPool['ls'] / 5000000000000, 1.0),
                  center:
                      Text("Stake: ${featuredPool['liveStakeFormatted']} / 5M"),
                  progressColor: Styles.SUCCESS_COLOR,
                )
              ]),
          Padding(
              padding: const EdgeInsets.only(
                  top: 16.0, bottom: 0.0, left: 8.0, right: 8.0),
              child: Text(featuredPool['intro'])),
          const SizedBox(height: 8),
          Padding(
              padding: const EdgeInsets.only(
                  top: 0.0, bottom: 0.0, left: 8.0, right: 8.0),
              child: Text(
                  "This pool is recommended by the community through the \"Stake Pool Bootstrap Channel\". Experienced operators have monitored their node and can recommend taking a chance on these smaller pools. Our goal is to get them to 5M ADA for a few epochs so they can get launched.\n\n"
                  "Pegasus supports this effort because our goal as a community is to have 1000 independent and geographically diverse pools to achieve a healthy decentralization. Please join us in supporting pool operators with small stake that want to try to establish themselves. Please note that Pegasus wishes to remain an independent source of raw data for the community and as such has no influence on which pools are featured or how long they are featured and receives no compensation.",
                  style: TextStyle(
                      fontSize: 11.0,
                      fontStyle: FontStyle.italic,
                      color: Styles.INACTIVE_COLOR_DARK))),
          getListHeader(),
          PoolItemWidget(pool: featuredPool),
        ]),
      )
    ]);
  }

  int sortFunction(StakePool a, StakePool b) {
    StakePool firstPool = desc ? a : b;
    StakePool secondPool = desc ? b : a;

    switch (sort) {
      case Sort.performance:
        int performanceSort = secondPool.p!.compareTo(firstPool.p!);
        if (performanceSort == 0) {
          return firstPool.r!.compareTo(secondPool.r!);
        }
        return performanceSort;
      case Sort.roi:
        return secondPool.lros!.compareTo(firstPool.lros!);
      case Sort.stake:
        return (secondPool.ls ?? 0).compareTo(firstPool.ls ?? 0);
      case Sort.rank:
        return (secondPool.r ?? 9999).compareTo(firstPool.r ?? 9999);
      case Sort.fee:
        int feeSort = secondPool.fm!.compareTo(firstPool.fm!);
        if (feeSort == 0) {
          return (firstPool.r ?? 9999).compareTo(secondPool.r ?? 9999);
        }
        return feeSort;
      case Sort.blocks:
        if (secondPool.b == null || firstPool.b == null) {
          return -1;
        }
        return secondPool.l!.compareTo(firstPool.l!);
    }
  }

  String sortIndicator(Sort sort) {
    if (this.sort == sort) {
      return " ${desc ? Constants.ARROW_DOWN : Constants.ARROW_UP}";
    } else {
      return "";
    }
  }

  setSort(Sort sort) {
    setState(() {
      this.sort = sort;
      desc = !desc;
      favouritePools.sort(sortFunction);
    });
  }
}
