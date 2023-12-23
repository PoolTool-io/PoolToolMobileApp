import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pegasus_tool/config/constants.dart';
import 'package:pegasus_tool/enums/sort_enum.dart';
import 'package:pegasus_tool/loading.dart';
import 'package:pegasus_tool/models/stake_pool_model.dart';
import 'package:pegasus_tool/repository/saturation_repository.dart';
import 'package:pegasus_tool/repository/stake_pools_repository.dart';
import 'package:pegasus_tool/screens/pools/pool_item.dart';
import 'package:pegasus_tool/services/epoch_service.dart';
import 'package:pegasus_tool/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'filter_dialog.dart';

class PoolsWidget extends StatefulWidget {
  const PoolsWidget({super.key});

  @override
  State<StatefulWidget> createState() {
    return PoolsWidgetState();
  }
}

class PoolsWidgetState extends State<PoolsWidget> {
  List<StakePool>? allPools;
  List<StakePool>? filteredPools;
  num? currentEpoch;

  TextEditingController searchController = TextEditingController();
  String search = "";

  bool? hideSaturated;
  bool? hideExpensive;
  bool? hideUnknown;
  bool? hideBlockless;
  bool? hideNotFromItn;
  bool? hideDisconnected;
  bool? hidePoolGroups;
  bool? hideNotChatReady;
  bool? hideRetiring;
  bool? hideRetired;

  Sort sort = Sort.rank;
  bool desc = false;

  StakePoolsRepository stakePoolsRepository = GetIt.I<StakePoolsRepository>();
  EpochService epochService = GetIt.I<EpochService>();

  StreamSubscription<List<StakePool>>? stakePoolsUpdatedSubscription;

  @override
  void initState() {
    super.initState();

    stakePoolsUpdatedSubscription = stakePoolsRepository
        .stakePoolsUpdatedStreamController.stream
        .asBroadcastStream()
        .listen((pools) => init());

    init();
  }

  void filterAndSortPools() {
    scheduleMicrotask(() {
      if (allPools != null) {
        List<StakePool> temp = [];
        for (StakePool pool in allPools!) {
          if (passFilters(pool)) {
            temp.add(pool);
          }
        }

        temp.sort(sortFunction);

        setState(() {
          filteredPools = temp;
        });
      }
    });
  }

  bool passFilters(StakePool pool) {
    if (hideUnknown == null ||
        hideUnknown! && (pool.t == null || pool.t == "")) {
      return false;
    }

    if (hideExpensive == null || hideExpensive! && feeTear(pool) > 1) {
      return false;
    }

    if (hideSaturated == null ||
        hideSaturated! &&
            pool.ls != null &&
            pool.ls! > GetIt.I<SaturationRepository>().saturationLevel) {
      return false;
    }

    if (hideBlockless == null || hideBlockless! && pool.l == 0) {
      return false;
    }

    if (hideNotFromItn == null || hideNotFromItn! && pool.i != true) {
      return false;
    }

    if (hideDisconnected == null || hideDisconnected! && pool.o == 0) {
      return false;
    }

    if (hidePoolGroups == null ||
        hidePoolGroups! && !(pool.g != null && pool.g!.isNotEmpty)) {
      return false;
    }

    if (hideRetiring == null ||
        hideRetiring! && (pool.retiredEpoch ?? 0) != 0) {
      return false;
    }

    if (hideRetired! && pool.d != null && pool.d!) {
      return false;
    }

    return search == ""
        ? true
        : ((pool.n?.toUpperCase() ?? "").contains(search) ||
            (pool.t?.toUpperCase() ?? "").contains(search) ||
            (search.length > 5 && pool.id!.toUpperCase().contains(search)));
  }

  @override
  Widget build(BuildContext context) {
    final Color subColor = Theme.of(context).textTheme.titleMedium!.color!;
    return Scaffold(
        body: Material(
            color: Theme.of(context).colorScheme.background,
            child: Column(children: [
              ListTile(
                  title: Row(children: [
                Expanded(
                    child: TextField(
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.search, color: subColor),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: subColor)),
                            labelStyle: Theme.of(context).textTheme.titleMedium,
                            labelText: "Search for pool name or ticker"),
                        controller: searchController)),
                const SizedBox(width: 20),
                Text(
                    "Showing ${filteredPools != null ? filteredPools!.length.toString() : "0"}\nout of ${allPools != null ? allPools!.length.toString() : "0"} pools",
                    style: TextStyle(
                      fontSize: 13.0,
                      fontStyle: FontStyle.italic,
                      color: subColor,
                    ))
              ])),
              (filteredPools != null && filteredPools!.isNotEmpty)
                  ? Row(
                      children: <Widget>[
                        Expanded(
                            child: InkWell(
                                onTap: () => setSort(Sort.rank),
                                child: Align(
                                    heightFactor: 3,
                                    alignment: Alignment.center,
                                    child: Text(
                                        "Rank${sortIndicator(Sort.rank)}",
                                        style: const TextStyle(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.bold))))),
                        /*isLandscape(context)
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
                                            fontWeight: FontWeight
                                                .bold))))) /* : Container()*/,
                        Expanded(
                            child: InkWell(
                                onTap: () => setSort(Sort.roi),
                                child: Align(
                                    heightFactor: 3,
                                    alignment: Alignment.center,
                                    child: Text("ROS${sortIndicator(Sort.roi)}",
                                        style: const TextStyle(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.bold))))),
                        /*isLandscape(context)
                        ? */
                        Expanded(
                            child: InkWell(
                                onTap: () => setSort(Sort.fee),
                                child: Align(
                                    heightFactor: 3,
                                    alignment: Alignment.center,
                                    child: Text("Fee${sortIndicator(Sort.fee)}",
                                        style: const TextStyle(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.bold))))),
                        Expanded(
                            child: InkWell(
                                onTap: () => setSort(Sort.stake),
                                child: Align(
                                    heightFactor: 3,
                                    alignment: Alignment.center,
                                    child: Text(
                                        "Live Stake (₳) ${sortIndicator(Sort.stake)}",
                                        style: const TextStyle(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.bold)))))
                      ],
                    )
                  : Container(),
              Flexible(
                child: filteredPools != null
                    ? filteredPools!.isNotEmpty
                        ? RefreshIndicator(
                            onRefresh: () {
                              setState(() {
                                filteredPools = null;
                              });

                              return Future.delayed(
                                  const Duration(milliseconds: 100), () {
                                // initPools(true);
                                refresh();
                              });
                            },
                            child: ListView.builder(
                              padding:
                                  const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 80),
                              itemCount: filteredPools!.length,
                              itemBuilder: (context, index) {
                                return PoolItemWidget(
                                    pool: filteredPools![index],
                                    currentEpoch: currentEpoch);
                              },
                            ),
                          )
                        : SizedBox(
                            height: 300,
                            child: Text(
                                "No results!\nTry adjusting your search and filter criteria.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 13.0,
                                    fontStyle: FontStyle.italic,
                                    color: subColor)))
                    : const LoadingWidget(),
              )
            ])),
        floatingActionButton: Visibility(
            visible: !isLandscape(context),
            child: FloatingActionButton(
                backgroundColor: Colors.green,
                child: const Icon(Icons.filter_list),
                onPressed: () {
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        return FilterDialog(
                            hideSaturated: hideSaturated,
                            hideUnknown: hideUnknown,
                            hideExpensive: hideExpensive,
                            hideBlockless: hideBlockless,
                            hideNotFromItn: hideNotFromItn,
                            hideDisconnected: hideDisconnected,
                            hidePoolGroups: hidePoolGroups,
                            hideRetiring: hideRetiring,
                            hideRetired: hideRetired,
                            onFilterChanged: (bool? hideUnknown,
                                bool? hideExpensive,
                                bool? hideSaturated,
                                bool? hideBlockless,
                                bool? hideNotFromItn,
                                bool? hideDisconnected,
                                bool? hidePoolGroups,
                                bool? hideRetiring,
                                bool? hideRetired) {
                              setState(() {
                                this.hideUnknown = hideUnknown;
                                this.hideExpensive = hideExpensive;
                                this.hideSaturated = hideSaturated;
                                this.hideBlockless = hideBlockless;
                                this.hideNotFromItn = hideNotFromItn;
                                this.hideDisconnected = hideDisconnected;
                                this.hidePoolGroups = hidePoolGroups;
                                this.hideRetiring = hideRetiring;
                                this.hideRetired = hideRetired;
                                persistFilers();
                                filterAndSortPools();
                              });
                            });
                      });
                })));
  }

  @override
  void dispose() {
    searchController.dispose();
    if (stakePoolsUpdatedSubscription != null) {
      stakePoolsUpdatedSubscription!.cancel();
    }
    super.dispose();
  }

  Future<void> initFilters() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    hideSaturated = prefs.getBool(Constants.PREFS_FILTER_SATURATED);
    hideExpensive = prefs.getBool(Constants.PREFS_FILTER_EXPENSIVE);
    hideUnknown = prefs.getBool(Constants.PREFS_FILTER_UNKNOWN);
    hideBlockless = prefs.getBool(Constants.PREFS_FILTER_BLOCKLESS);
    hideNotFromItn = prefs.getBool(Constants.PREFS_FILTER_NOT_FROM_ITN);
    hideDisconnected = prefs.getBool(Constants.PREFS_FILTER_DISCONNECTED);
    hidePoolGroups = prefs.getBool(Constants.PREFS_FILTER_POOL_GROUPS);
    hideRetiring = prefs.getBool(Constants.PREFS_FILTER_RETIRING);
    hideRetired = prefs.getBool(Constants.PREFS_FILTER_RETIRED);

    hideSaturated ??= false;
    hideExpensive ??= false;
    hideUnknown ??= false;
    hideBlockless ??= false;
    hideNotFromItn ??= false;
    hideDisconnected ??= false;
    hidePoolGroups ??= false;
    hideNotChatReady ??= false;
    hideRetiring ??= false;
    hideRetired ??= false;
  }

  void persistFilers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(Constants.PREFS_FILTER_SATURATED, hideSaturated!);
    prefs.setBool(Constants.PREFS_FILTER_EXPENSIVE, hideExpensive!);
    prefs.setBool(Constants.PREFS_FILTER_UNKNOWN, hideUnknown!);
    prefs.setBool(Constants.PREFS_FILTER_BLOCKLESS, hideBlockless!);
    prefs.setBool(Constants.PREFS_FILTER_NOT_FROM_ITN, hideNotFromItn!);
    prefs.setBool(Constants.PREFS_FILTER_DISCONNECTED, hideDisconnected!);
    prefs.setBool(Constants.PREFS_FILTER_POOL_GROUPS, hidePoolGroups!);
    prefs.setBool(Constants.PREFS_FILTER_CHAT_READY, hideNotChatReady!);
    prefs.setBool(Constants.PREFS_FILTER_RETIRING, hideRetiring!);
  }

  void init() async {
    await initFilters();
    initPools();
  }

  refresh() {
    stakePoolsRepository.getStakePools();
  }

  void initPools() async {
    List<StakePool>? pools;

    if (stakePoolsRepository.stakePoolList.isEmpty) {
      pools = await stakePoolsRepository.getStakePools();
    } else {
      pools = stakePoolsRepository.stakePoolList;
    }

    if (epochService.currentEpoch != null) {
      currentEpoch = epochService.currentEpoch;
    } else {
      epochService.currentEpochStream.listen((epoch) {
        currentEpoch = epoch;
      });
      epochService.getCurrentEpoch();
    }

    if (mounted) {
      setState(() {
        setupPoolsState(pools);
      });
    }
  }

  setupPoolsState(pools) {
    // List<StakePool> temp = [];
    //
    // pools?.forEach((pool) {
    //   bool retired =
    //       pool.retiredEpoch != null && pool.retiredEpoch! <= currentEpoch!;
    //   if (!retired && pool.x == false) {
    //     temp.add(pool);
    //   }
    // });
    //
    // allPools = temp;
    allPools = pools;

    filterAndSortPools();

    searchController.addListener(() {
      search = searchController.text.toUpperCase();
      filterAndSortPools();
    });
  }

  int sortFunction(a, b) {
    dynamic firstPool = desc ? a : b;
    dynamic secondPool = desc ? b : a;

    switch (sort) {
      case Sort.performance:
        int performanceSort = secondPool.p.compareTo(firstPool.p);
        if (performanceSort == 0) {
          return firstPool.r.compareTo(secondPool.r);
        }
        return performanceSort;
      case Sort.roi:
        return (secondPool.lros ?? 0).compareTo(firstPool.lros ?? 0);
      case Sort.stake:
        return (secondPool.ls ?? 0).compareTo(firstPool.ls ?? 0);
      case Sort.rank:
        return (secondPool.r ?? 9999).compareTo(firstPool.r ?? 9999);
      case Sort.fee:
        int feeSort = secondPool.fm.compareTo(firstPool.fm);
        if (feeSort == 0) {
          return (firstPool.r ?? 9999).compareTo(secondPool.r ?? 9999);
        }
        return feeSort;
      case Sort.blocks:
        if (secondPool.b == null || firstPool.b == null) {
          return -1;
        }
        return secondPool.l.compareTo(firstPool.l);
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
      filteredPools!.sort(sortFunction);
    });
  }
}
