import 'package:firebase_database/firebase_database.dart';
import 'package:get_it/get_it.dart';
import 'package:pegasus_tool/config/environment.dart';
import 'package:pegasus_tool/models/epoch_model.dart';
import 'package:pegasus_tool/services/firebase_database_service.dart';

class EpochRepository {
  FirebaseDatabase firebaseDatabase =
      GetIt.I<FirebaseDatabaseService>().firebaseDatabase;

  Stream<Epoch> getEpoch(num epoch) {
    final Query query = firebaseDatabase
        .ref()
        .child('${Environment.getEnvironment()}/epochs/$epoch');

    return query.onValue
        .map((event) => Epoch.fromMap(event.snapshot.value as Map));
  }
}
