import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:get_it/get_it.dart';
import 'package:pegasus_tool/config/environment.dart';
import 'package:pegasus_tool/models/pool_update_model.dart';
import 'package:pegasus_tool/services/firebase_database_service.dart';

class PoolUpdatesRepository {
  List<PoolUpdate> lastThree = [];
  List<PoolUpdate> allPoolUpdates = [];
  List<PoolUpdate> favoritePoolUpdates = [];

  StreamController<PoolUpdate> poolUpdatesStreamController =
      StreamController<PoolUpdate>.broadcast();

  StreamController<PoolUpdate> favoritePoolUpdatesStreamController =
      StreamController<PoolUpdate>.broadcast();

  int endBeforeTime = 0;

  FirebaseDatabase firebaseDatabase =
      GetIt.I<FirebaseDatabaseService>().firebaseDatabase;

  late DatabaseReference dbReference;

  PoolUpdatesRepository() {
    dbReference = firebaseDatabase
        .ref()
        .child('${Environment.getEnvironment()}/all_pool_updates_blockfrost');
  }

  Stream<List<PoolUpdate>> getLast3() {
    lastThree.clear();
    Query query = dbReference.orderByChild('time').limitToLast(3);

    query.onChildAdded.forEach((event) {
      lastThree.add(PoolUpdate.fromMap(event.snapshot.value as Map));
    });

    query.onChildRemoved.forEach((event) {
      lastThree.remove(PoolUpdate.fromMap(event.snapshot.value as Map));
    });

    return query.onValue.map((_) => lastThree);
  }

  void getUpdatesForPoolId(String poolId) {
    Query query = dbReference.orderByChild('poolId').equalTo(poolId);

    query.onChildAdded.forEach((event) {
      favoritePoolUpdates.add(PoolUpdate.fromMap(event.snapshot.value as Map));
      favoritePoolUpdatesStreamController
          .add(PoolUpdate.fromMap(event.snapshot.value as Map));
    });

    query.get();
  }

  void getFirst() {
    Query query = dbReference.orderByChild('time').limitToLast(100);

    query.onChildAdded.forEach((event) {
      poolUpdatesStreamController
          .add(PoolUpdate.fromMap(event.snapshot.value as Map));
    });

    query.get();
  }

  void getNext() {
    final Query query = dbReference
        .orderByChild('time')
        .endBefore(endBeforeTime)
        .limitToLast(100);

    query.get();
  }
}
