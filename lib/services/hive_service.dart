import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pegasus_tool/config/constants.dart';
import 'package:pegasus_tool/models/stake_pool_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HiveService implements Disposable {
  late Box<StakePool> stakePools;
  late Box<StakePool> favouriteStakePools;

  Future<HiveService> init() async {
    await Hive.initFlutter();

    // Register Adapters
    Hive.registerAdapter(StakePoolAdapter());

    stakePools = await Hive.openBox<StakePool>('stakePools');
    favouriteStakePools = await Hive.openBox<StakePool>('favouriteStakePools');

    return this;
  }

  void addFeaturedPools() {
    addFavouritePool(Constants.LOVE_POOL_ID);
    addFavouritePool(Constants.POOLTOOL_POOL_ID);
  }

  void addFavouritePool(String poolId) async {
    StakePool? stakePool = stakePools.get(poolId);
    if (stakePool != null) {
      favouriteStakePools.put(poolId, stakePool);
    }
  }

  void removeFavouritePool(String poolId) async {
    if (poolId == Constants.LOVE_POOL_ID ||
        poolId == Constants.POOLTOOL_POOL_ID) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool(Constants.PREFS_REMOVED_FEATURED_POOL, true);
    }
    favouriteStakePools.delete(poolId);
  }

  Future<void> clear() async {
    await stakePools.clear();
    await favouriteStakePools.clear();
  }

  @override
  FutureOr onDispose() {
    stakePools.close();
  }
}
