import 'package:firebase_database/firebase_database.dart';
import 'package:get_it/get_it.dart';
import 'package:pegasus_tool/config/environment.dart';
import 'package:pegasus_tool/models/stake_history_model.dart';
import 'package:pegasus_tool/services/firebase_database_service.dart';

class StakeHistoryRepository {
  FirebaseDatabase firebaseDatabase =
      GetIt.I<FirebaseDatabaseService>().firebaseDatabase;

  Stream<List<StakeHistory>> getStakeHist(String stakeKeyHash) {
    List<StakeHistory> stakeHist = [];

    DatabaseReference historyRef = firebaseDatabase
        .ref()
        .child('${Environment.getEnvironment()}/stake_hist/$stakeKeyHash');

    historyRef.onChildAdded.forEach((event) {
      // stakeHist.add(StakeHistory.fromMap(event.snapshot.value as Map));
      stakeHist.add(StakeHistory.fromMap(
          {"epoch": event.snapshot.key, "rewards": event.snapshot.value}));
    });

    return historyRef.onValue.map((_) => stakeHist);
  }
}
