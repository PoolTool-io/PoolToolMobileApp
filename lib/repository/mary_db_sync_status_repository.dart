import 'package:firebase_database/firebase_database.dart';
import 'package:get_it/get_it.dart';
import 'package:pegasus_tool/config/environment.dart';
import 'package:pegasus_tool/models/mary_db_sync_status_model.dart';
import 'package:pegasus_tool/services/firebase_database_service.dart';

class MaryDbSyncStatusRepository {
  late num saturationLevel;

  FirebaseDatabase firebaseDatabase =
      GetIt.I<FirebaseDatabaseService>().firebaseDatabase;

  Future<MaryDbSyncStatus> getMaryDbSyncStatus() async {
    final Query query = firebaseDatabase
        .ref()
        .child('${Environment.getEnvironment()}/mary_db_sync_status');

    return query.once().then((DatabaseEvent event) =>
        MaryDbSyncStatus.fromMap(event.snapshot.value as Map));
  }

  Stream<num> getCurrentEpoch() {
    final Query query = firebaseDatabase
        .ref()
        .child('${Environment.getEnvironment()}/mary_db_sync_status/epoch_no');

    return query.onValue.map((event) {
      return event.snapshot.value as num;
    });
  }
}
