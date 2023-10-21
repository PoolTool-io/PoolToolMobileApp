import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pegasus_tool/loading.dart';
import 'package:pegasus_tool/main.dart';
import 'package:pegasus_tool/models/ecosystem_model.dart';
import 'package:pegasus_tool/models/live_delegators_model.dart';
import 'package:pegasus_tool/models/pool_stats.dart';
import 'package:pegasus_tool/models/stake_model.dart';
import 'package:pegasus_tool/models/stake_pool_model.dart';
import 'package:pegasus_tool/network/delegators/delegators_client.dart';
import 'package:pegasus_tool/repository/ecosystem_repository.dart';
import 'package:pegasus_tool/repository/pool_stats_repository.dart';
import 'package:pegasus_tool/repository/stake_pools_repository.dart';
import 'package:pegasus_tool/screens/pool/forker_widget.dart';
import 'package:pegasus_tool/screens/pool/info/pool_info.dart';
import 'package:pegasus_tool/screens/pool/retiring_pool_widget.dart';
import 'package:pegasus_tool/screens/pool/rewards/pool_rewards_widget.dart';
import 'package:pegasus_tool/services/epoch_service.dart';
import 'package:pegasus_tool/services/hive_service.dart';
import 'package:pegasus_tool/utils.dart';
import 'package:url_launcher/url_launcher.dart';

import 'block_production/block_production_widget.dart';
import 'operation_widget.dart';
import 'saturation/saturation_widget.dart';

class PoolDetails extends StatefulWidget {
  final String poolId;

  const PoolDetails({Key? key, required this.poolId}) : super(key: key);

  @override
  PoolDetailsState createState() => PoolDetailsState();
}

class PoolDetailsState extends State<PoolDetails> {
  StakePool? poolSummary;
  PoolStats? poolStats;
  Ecosystem? ecosystem;
  num? currentEpoch;
  LiveDelegators? liveDelegators;

  bool isFavourite = false;

  EpochService epochService = GetIt.I<EpochService>();
  StakePoolsRepository stakePoolsRepository = GetIt.I<StakePoolsRepository>();
  PoolStatsRepository poolStatsRepository = GetIt.I<PoolStatsRepository>();
  EcosystemRepository ecosystemRepository = GetIt.I<EcosystemRepository>();
  HiveService hiveService = GetIt.I<HiveService>();

  StreamSubscription<num>? currentEpochSubscription;

  @override
  void initState() {
    super.initState();
    scheduleMicrotask(() {
      if (epochService.currentEpoch != null) {
        setState(() {
          currentEpoch = epochService.currentEpoch;
        });
      } else {
        currentEpochSubscription =
            epochService.currentEpochStream.listen((epoch) {
          setState(() {
            currentEpoch = epoch;
          });
        });
        epochService.getCurrentEpoch();
      }

      stakePoolsRepository.getStakePool(widget.poolId)?.then((stakePool) {
        setState(() {
          poolSummary = stakePool;
        });
      });

      poolStatsRepository.getPoolStats(widget.poolId)?.then((stats) {
        setState(() {
          poolStats = stats;
        });
      });

      ecosystemRepository.getEcosystem()?.then((ecosystemModel) {
        setState(() {
          ecosystem = ecosystemModel;
        });
      });

      DelegatorsClient delegatorsClient = DelegatorsClient(dio);
      delegatorsClient
          .getDelegators(widget.poolId, DateTime.now().millisecondsSinceEpoch)
          .then((value) {
        setState(() {
          liveDelegators = value;
        });
      });
    });
    setInitialFavouriteState();
  }

  @override
  void dispose() {
    currentEpochSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var isLoading = poolSummary == null ||
        poolStats == null ||
        currentEpoch == null ||
        ecosystem == null;
    if (!isLoading) {
      if (poolStats?.stake == null) {
        poolStats!.stake = [
          Stake(epoch: currentEpoch.toString(), amount: poolSummary?.ls),
          Stake(epoch: (currentEpoch! + 1).toString(), amount: poolSummary?.ls)
        ];
      }
    }
    return Material(
      child: DefaultTabController(
        length: 5,
        child: Scaffold(
            appBar: AppBar(
              title: AutoSizeText(getPoolName(widget.poolId, poolSummary),
                  maxLines: 1),
              actions: getAppBarActions(),
              centerTitle: true,
              bottom: TabBar(
                indicatorColor: Theme.of(context).colorScheme.secondary,
                tabs: const [
                  Tab(icon: Icon(Icons.info)),
                  Tab(icon: Icon(Icons.people)),
                  Tab(icon: Icon(Icons.insert_chart)),
                  Tab(icon: Icon(Icons.monetization_on)),
                  Tab(icon: Icon(Icons.settings)),
                ],
              ),
            ),
            body: TabBarView(children: [
              /**
               * TAB -INFO
               */
              isLoading
                  ? const LoadingWidget()
                  : SingleChildScrollView(
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(children: <Widget>[
                            (poolSummary?.forker ?? false)
                                ? const ForkerWidget()
                                : Container(),
                            ((poolSummary?.retiredEpoch != null &&
                                    poolSummary!.retiredEpoch! > currentEpoch!))
                                ? RetiringPoolWidget(
                                    retiredEpoch: poolSummary?.retiredEpoch)
                                : Container(),
                            PoolInfo(
                                poolStats: poolStats!,
                                poolSummary: poolSummary!),
                            const SizedBox(height: 8.0),
                            // ChatProxyWidget(
                            //     poolStats: poolStats!,
                            //     poolSummary: poolSummary!),
                            // const SizedBox(height: 80)
                          ]))),
              /**
               * TAB - Saturation
               */
              isLoading
                  ? const LoadingWidget()
                  : SaturationWidget(
                      stake: poolStats!.stake!,
                      poolSummary: poolSummary!,
                      delegators: liveDelegators,
                      currentEpoch: currentEpoch!),
              /**
               * TAB - BLOCKS
               */
              isLoading
                  ? const LoadingWidget()
                  : BlockProductionWidget(
                      pool: poolSummary!,
                      poolStats: poolStats!,
                      currentEpoch: currentEpoch!,
                      ecosystem: ecosystem!),
              /**
               * TAB - ROS and Pool Rewards
               */
              isLoading
                  ? const LoadingWidget()
                  : PoolRewards(
                      poolStats: poolStats!,
                      poolSummary: poolSummary!,
                      currentEpoch: currentEpoch!),
              /**
               * TAB - OPERATIONS
               */
              isLoading
                  ? const LoadingWidget()
                  : OperationWidget(
                      poolSummary: poolSummary!, poolStats: poolStats!)
            ]),
            floatingActionButton: FloatingActionButton(
                backgroundColor: Colors.green,
                child: Icon(isFavourite ? Icons.star : Icons.star_border),
                onPressed: () {
                  toggleFavourite();
                })),
      ),
    );
  }

  List<IconButton> getAppBarActions() {
    return poolStats != null && poolStats?.homePage != null
        ? [
            IconButton(
                icon: const Icon(Icons.home),
                tooltip: 'homePage',
                onPressed: () {
                  openHomePage();
                })
          ]
        : [];
  }

  openHomePage() async {
    Uri url = Uri.parse(poolStats!.homePage!);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void setInitialFavouriteState() async {
    StakePool? stakePool = hiveService.favouriteStakePools.get(widget.poolId);

    setState(() {
      isFavourite = stakePool != null;
    });
  }

  void toggleFavourite() async {
    if (isFavourite) {
      hiveService.removeFavouritePool(widget.poolId);
    } else {
      hiveService.addFavouritePool(widget.poolId);
    }
    setState(() {
      isFavourite = !isFavourite;
    });
  }
}
