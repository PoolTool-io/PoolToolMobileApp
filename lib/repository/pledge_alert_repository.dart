import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:get_it/get_it.dart';
import 'package:pegasus_tool/config/environment.dart';
import 'package:pegasus_tool/models/pledge_alert_model.dart';
import 'package:pegasus_tool/models/stake_pool_model.dart';
import 'package:pegasus_tool/services/firebase_database_service.dart';
import 'package:pegasus_tool/services/firebase_messaging_service.dart';

class PledgeAlertRepository implements Disposable {
  final StreamController<PledgeAlert> _alertValueStreamController =
      StreamController<PledgeAlert>.broadcast();
  final StreamController<PledgeAlert> _alertDeletionStreamController =
      StreamController<PledgeAlert>.broadcast();

  Stream<PledgeAlert> get alertValueStream =>
      _alertValueStreamController.stream;
  Stream<PledgeAlert> get alertDeletionStream =>
      _alertDeletionStreamController.stream;

  StreamSubscription? _alertValueSubscription;
  StreamSubscription? _alertDeletionSubscription;

  final FirebaseDatabase _firebaseDatabase =
      GetIt.I<FirebaseDatabaseService>().firebaseDatabase;

  FirebaseMessagingService firebaseMessagingService =
      GetIt.I<FirebaseMessagingService>();

  DatabaseReference alertRef(String poolId, String token) {
    return _firebaseDatabase
        .ref()
        .child(Environment.getEnvironment())
        .child("legacy_alerts")
        .child(poolId)
        .child("pledge")
        .child(token);
  }

  void initAlert(String poolId) async {
    String? token = await firebaseMessagingService.getToken();

    if (token != null) {
      alertRef(poolId, token).keepSynced(true);

      _alertDeletionSubscription =
          alertRef(poolId, token).onChildRemoved.listen((event) {
        if (event.snapshot.value != null) {
          _alertDeletionStreamController
              .add(PledgeAlert.fromMap(event.snapshot.value as Map));
        }
      });

      _alertValueSubscription = alertRef(poolId, token).onValue.listen((event) {
        if (event.snapshot.value != null) {
          _alertValueStreamController
              .add(PledgeAlert.fromMap(event.snapshot.value as Map));
        } else {
          _alertValueStreamController.add(PledgeAlert());
        }
      });
    } else {
      //TODO: Add some type of logging or crash analytics
    }
  }

  Future<void>? addAlert(StakePool pool) async {
    String? token = await firebaseMessagingService.getToken();

    if (token != null) {
      Map alert = PledgeAlert(enabled: true).toMap();

      return alertRef(pool.id!, token).set(alert);
    }
  }

  Future<void> deleteAlert(String poolId) async {
    String? token = await firebaseMessagingService.getToken();

    if (token != null) {
      return alertRef(poolId, token).remove();
    }
  }

  @override
  FutureOr onDispose() {
    _alertDeletionSubscription?.cancel();
    _alertValueSubscription?.cancel();
  }
}
