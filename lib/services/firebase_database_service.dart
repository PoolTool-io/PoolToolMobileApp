import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get_it/get_it.dart';
import 'package:pegasus_tool/services/firebase_app_service.dart';

class FirebaseDatabaseService {
  late FirebaseDatabase firebaseDatabase;

  FirebaseDatabaseService() {
    FirebaseApp firebaseApp = GetIt.I<FirebaseAppService>().firebaseApp;
    firebaseDatabase = FirebaseDatabase.instanceFor(app: firebaseApp);
    firebaseDatabase.setPersistenceEnabled(true);
    firebaseDatabase.setPersistenceCacheSizeBytes(10000000);
  }
}
