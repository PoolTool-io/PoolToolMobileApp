import 'package:firebase_database/firebase_database.dart';
import 'package:get_it/get_it.dart';
import 'package:pegasus_tool/config/environment.dart';
import 'package:pegasus_tool/models/recent_block_model.dart';
import 'package:pegasus_tool/services/firebase_database_service.dart';

class RecentBlockRepository {
  FirebaseDatabase firebaseDatabase =
      GetIt.I<FirebaseDatabaseService>().firebaseDatabase;

  Stream<RecentBlock> getRecentBlock() {
    final Query query = firebaseDatabase
        .ref()
        .child('${Environment.getEnvironment()}/recent_block');

    return query.onValue
        .map((event) => RecentBlock.fromMap(event.snapshot.value as Map));
  }
}
