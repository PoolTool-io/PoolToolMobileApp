import 'package:firebase_database/firebase_database.dart';
import 'package:get_it/get_it.dart';
import 'package:pegasus_tool/config/environment.dart';
import 'package:pegasus_tool/models/pool_stats.dart';
import 'package:pegasus_tool/services/firebase_database_service.dart';

class PoolStatsRepository {
  FirebaseDatabase firebaseDatabase =
      GetIt.I<FirebaseDatabaseService>().firebaseDatabase;

  Future<PoolStats?>? getPoolStats(String poolId) async {
    DatabaseEvent poolStatsRef = await firebaseDatabase
        .ref()
        .child('${Environment.getEnvironment()}/pool_stats/$poolId')
        .once();

    if (poolStatsRef.snapshot.value != null) {
      return PoolStats.fromMap(poolStatsRef.snapshot.value as Map);
    }
    return null;
  }
}
