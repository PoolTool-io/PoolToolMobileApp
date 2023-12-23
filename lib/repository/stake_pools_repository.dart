import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:get_it/get_it.dart';
import 'package:pegasus_tool/config/constants.dart';
import 'package:pegasus_tool/config/environment.dart';
import 'package:pegasus_tool/models/favourite_pool_model.dart';
import 'package:pegasus_tool/models/stake_pool_model.dart';
import 'package:pegasus_tool/services/firebase_database_service.dart';
import 'package:pegasus_tool/services/hive_service.dart';
import 'package:pegasus_tool/services/local_database_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StakePoolsRepository {
  FirebaseDatabaseService firebaseDatabaseService =
      GetIt.I<FirebaseDatabaseService>();
  HiveService hiveService = GetIt.I<HiveService>();

  List<StakePool> stakePoolList = [];

  StreamController<List<StakePool>> stakePoolsUpdatedStreamController =
      StreamController<List<StakePool>>.broadcast();

  StakePoolsRepository() {
    getStakePools();
    setupFeaturedPools();
  }

  Future<StakePool?>? getStakePool(String poolId) async {
    DatabaseEvent remotePool = await firebaseDatabaseService.firebaseDatabase
        .ref()
        .child('${Environment.getEnvironment()}/stake_pools/$poolId')
        .once();

    if (remotePool.snapshot.value != null) {
      StakePool stakePool = StakePool.fromMap(remotePool.snapshot.value as Map);
      if (hiveService.favouriteStakePools.containsKey(stakePool.id)) {
        hiveService.favouriteStakePools.put(stakePool.id, stakePool);
      }
      return stakePool;
    }
    return null;
  }

  Future<List<StakePool>?>? getStakePools() async {
    List<StakePool> list = [];

    final stakePoolsQuery = firebaseDatabaseService.firebaseDatabase
        .ref()
        .child('${Environment.getEnvironment()}/stake_pools')
        .orderByChild("r");

    stakePoolsQuery.onChildAdded.forEach((event) {
      StakePool stakePool = StakePool.fromMap(event.snapshot.value as Map);

      list.add(stakePool);
      hiveService.stakePools.put(stakePool.id, stakePool);

      // Check if pool is a favourite and update it
      if (hiveService.favouriteStakePools.containsKey(stakePool.id)) {
        hiveService.favouriteStakePools.put(stakePool.id, stakePool);
      }
    });

    stakePoolsQuery.keepSynced(true);
    await stakePoolsQuery.once();

    stakePoolList = list;

    stakePoolsUpdatedStreamController.add(stakePoolList);

    return stakePoolList;
  }

  void setupFeaturedPools() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool removedFeatured =
        prefs.getBool(Constants.PREFS_REMOVED_FEATURED_POOL) ?? false;
    bool migratedFavourites =
        prefs.getBool(Constants.PREFS_MIGRATED_FAVOURITES) ?? false;

    // Check if user ever removed featured pools
    if (removedFeatured == false && hiveService.favouriteStakePools.isEmpty) {
      hiveService.addFeaturedPools();
      prefs.setBool(Constants.PREFS_REMOVED_FEATURED_POOL, true);
    }

    // Migrate favourites from old database if needed
    LocalDatabaseService database =
        await GetIt.I<LocalDatabaseService>().getInstance();
    List<FavouritePool> oldFavoritePools = await database.getFavouritePools();
    if (migratedFavourites == false && oldFavoritePools.isNotEmpty) {
      for (FavouritePool favouritePool in oldFavoritePools) {
        hiveService.addFavouritePool(favouritePool.id);
        database.removeFavouritePool(favouritePool.id);
      }
      prefs.setBool(Constants.PREFS_MIGRATED_FAVOURITES, true);
    }
  }
}
