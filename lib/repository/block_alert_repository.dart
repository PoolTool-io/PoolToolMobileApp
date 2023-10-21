import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:get_it/get_it.dart';
import 'package:pegasus_tool/config/environment.dart';
import 'package:pegasus_tool/models/block_alert_model.dart';
import 'package:pegasus_tool/models/stake_pool_model.dart';
import 'package:pegasus_tool/services/firebase_database_service.dart';
import 'package:pegasus_tool/services/firebase_messaging_service.dart';

class BlockAlertRepository implements Disposable {
  final StreamController<BlockAlert> _alertValueStreamController =
      StreamController<BlockAlert>.broadcast();
  final StreamController<BlockAlert> _alertDeletionStreamController =
      StreamController<BlockAlert>.broadcast();

  Stream<BlockAlert> get alertValueStream => _alertValueStreamController.stream;
  Stream<BlockAlert> get alertDeletionStream =>
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
        .child("block_production")
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
              .add(BlockAlert.fromMap(event.snapshot.value as Map));
        }
      });

      _alertValueSubscription = alertRef(poolId, token).onValue.listen((event) {
        if (event.snapshot.value != null) {
          _alertValueStreamController
              .add(BlockAlert.fromMap(event.snapshot.value as Map));
        } else {
          _alertValueStreamController.add(BlockAlert());
        }
      });
    } else {
      //TODO: Add some type of logging or crash analytics
    }
  }

  Future<void>? addAlert(StakePool pool) async {
    String? token = await firebaseMessagingService.getToken();

    if (token != null) {
      Map alert = BlockAlert(enabled: true).toMap();

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
