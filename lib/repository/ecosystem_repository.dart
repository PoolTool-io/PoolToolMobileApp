import 'package:firebase_database/firebase_database.dart';
import 'package:get_it/get_it.dart';
import 'package:pegasus_tool/config/environment.dart';
import 'package:pegasus_tool/models/ecosystem_model.dart';
import 'package:pegasus_tool/services/firebase_database_service.dart';

class EcosystemRepository {
  FirebaseDatabase firebaseDatabase =
      GetIt.I<FirebaseDatabaseService>().firebaseDatabase;

  Future<Ecosystem?>? getEcosystem() async {
    DatabaseEvent ecosystemRef = await firebaseDatabase
        .ref()
        .child('${Environment.getEnvironment()}/ecosystem')
        .once();

    if (ecosystemRef.snapshot.value != null) {
      return Ecosystem.fromMap(ecosystemRef.snapshot.value as Map);
    }
    return null;
  }
}
