import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:path/path.dart';
import 'package:pegasus_tool/config/constants.dart';
import 'package:pegasus_tool/models/favourite_pool_model.dart';
import 'package:pegasus_tool/services/firebase_database_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import '../utils.dart';

class LocalDatabaseService {
  late Database database;

  FirebaseDatabaseService firebaseDatabaseService =
      GetIt.I<FirebaseDatabaseService>();

  LocalDatabaseService();

  Future<LocalDatabaseService> getInstance() async {
    database = await openDatabase(
        // Set the path to the database. Note: Using the `join` function from the
        // `path` package is best practice to ensure the path is correctly
        // constructed for each platform.
        join(await getDatabasesPath(), 'mainnet_local_database.db'),
        // When the database is first created, create a table to store dogs.
        onCreate: (db, version) async {
      db.execute("CREATE TABLE favorites(id TEXT PRIMARY KEY)");
      db.execute(
          "CREATE TABLE nicknames(userId TEXT PRIMARY KEY, nickname TEXT, createdAt INTEGER)");
    }, onUpgrade: (db, oldVersion, newVersion) async {
      var batch = db.batch();
      if (oldVersion == 1) {
        db.execute(
            "CREATE TABLE nicknames(userId TEXT PRIMARY KEY, nickname TEXT, createdAt INTEGER)");
      }
      await batch.commit();
    },
        // Set the version. This executes the onCreate function and provides a
        // path to perform database upgrades and downgrades.
        version: 2);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? addedDefaultPools =
        prefs.getBool(Constants.PREFS_ADDED_DEFAULT_POOLS);
    if (addedDefaultPools == null) {
      addFavouritePool(Constants.LOVE_POOL_ID);
      addFavouritePool(Constants.POOLTOOL_POOL_ID);

      prefs.setBool(Constants.PREFS_ADDED_DEFAULT_POOLS, true);
    }

    return this;
  }

  Map<String, String> inMemoryNicknames = {};

  Future<String> getNicknameForUserId(String userId) async {
    String? inMemoryNickname = inMemoryNicknames[userId];
    if (inMemoryNickname != null) {
      // debugPrint("getNicknameForUserId Found inmemory nickname: " + userId + " - " + inMemoryNickname);
      return inMemoryNickname;
    }

    String? remoteNickname;

    List<String> columnsToSelect = ["userId", "nickname", "createdAt"];
    String whereString = 'userId = ?';
    List<dynamic> whereArguments = [userId];
    List<Map> result = await database.query("nicknames",
        columns: columnsToSelect,
        where: whereString,
        whereArgs: whereArguments);

    if (result.isNotEmpty) {
      String nickname = result[0]["nickname"];

      // 1 week expiry
      if (result[0]["createdAt"] + 604800000 >
          DateTime.now().millisecondsSinceEpoch) {
        // debugPrint("getNicknameForUserId Found local nickname: " + userId + " - " + nickname);
        remoteNickname = nickname;
        inMemoryNicknames[userId] = nickname;
        return remoteNickname;
      } else {
        // debugPrint("getNicknameForUserId Found local nickname but it's out of date: " + userId + " - " + nickname);
      }
    }

    remoteNickname = (await firebaseDatabaseService.firebaseDatabase
            .ref()
            .child(getEnvironment())
            .child("users")
            .child("pubMeta")
            .child(userId)
            .child("nickname")
            .once()
            .catchError((err) {}))
        .snapshot
        .value as String?;

    remoteNickname ??= "user_${truncateId(userId)}";

    await database.insert(
      'nicknames',
      {
        "userId": userId,
        "nickname": remoteNickname,
        "createdAt": DateTime.now().millisecondsSinceEpoch
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    // debugPrint("getNicknameForUserId from remote: " + userId + " - " + remoteNickname);
    inMemoryNicknames[userId] = remoteNickname;
    return remoteNickname;
  }

  void addFavouritePool(String poolId) async {
    await database.insert(
      'favorites',
      FavouritePool(id: poolId).toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<FavouritePool>> getFavouritePools() async {
    final List<Map<String, dynamic>> maps = await database.query('favorites');
    return List.generate(maps.length, (i) {
      return FavouritePool(id: maps[i]['id']);
    });
  }

  isFavourite(String poolId) async {
    List<String> columnsToSelect = ["id"];
    String whereString = 'id = ?';
    List<dynamic> whereArguments = [poolId];
    List<dynamic> result = await database.query("favorites",
        columns: columnsToSelect,
        where: whereString,
        whereArgs: whereArguments);

    return result.isNotEmpty;
  }

  void removeFavouritePool(String poolId) async {
    database.delete("favorites", where: 'id = ?', whereArgs: [poolId]);
  }
}
