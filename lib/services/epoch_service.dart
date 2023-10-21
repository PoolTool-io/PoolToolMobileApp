import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:pegasus_tool/repository/mary_db_sync_status_repository.dart';

class EpochService implements Disposable {
  final StreamController<num> _currentEpochStreamController =
      StreamController<num>.broadcast();
  final StreamController<num> _selectedEpochStreamController =
      StreamController<num>.broadcast();

  Stream<num> get currentEpochStream => _currentEpochStreamController.stream;
  Stream<num> get selectedEpochStream => _selectedEpochStreamController.stream;

  late StreamSubscription<num> currentEpochSubscription;

  num? _currentEpoch;

  num? get currentEpoch => _currentEpoch;

  set currentEpoch(num? value) {
    _currentEpoch = value;
    _currentEpochStreamController.add(value!);
  }

  num? _selectedEpoch;

  num? get selectedEpoch => _selectedEpoch;

  set selectedEpoch(num? epoch) {
    _selectedEpoch = epoch!;
    _selectedEpochStreamController.add(epoch);
  }

  MaryDbSyncStatusRepository maryDbSyncStatusRepository =
      GetIt.I<MaryDbSyncStatusRepository>();

  EpochService() {
    getCurrentEpoch();
  }

  void getCurrentEpoch() {
    currentEpochSubscription =
        maryDbSyncStatusRepository.getCurrentEpoch().listen((epoch) {
      currentEpoch = epoch;
    });
  }

  @override
  FutureOr onDispose() {
    currentEpochSubscription.cancel();
  }
}
