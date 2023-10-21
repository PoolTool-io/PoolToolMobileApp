import 'package:firebase_database/firebase_database.dart';
import 'package:get_it/get_it.dart';
import 'package:pegasus_tool/config/environment.dart';
import 'package:pegasus_tool/services/firebase_database_service.dart';

class SaturationRepository {
  late num saturationLevel;

  FirebaseDatabase firebaseDatabase =
      GetIt.I<FirebaseDatabaseService>().firebaseDatabase;

  Future<SaturationRepository> init() async {
    saturationLevel = (await firebaseDatabase
            .ref()
            .child('${Environment.getEnvironment()}/ecosystem/saturation')
            .once())
        .snapshot
        .value as num;

    return this;
  }
}
