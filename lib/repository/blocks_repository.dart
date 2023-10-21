import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:get_it/get_it.dart';
import 'package:pegasus_tool/config/environment.dart';
import 'package:pegasus_tool/models/block_model.dart';
import 'package:pegasus_tool/services/firebase_database_service.dart';

class BlocksRepository implements Disposable {
  FirebaseDatabase firebaseDatabase =
      GetIt.I<FirebaseDatabaseService>().firebaseDatabase;

  final StreamController<Block> _blockRemovedStreamController =
      StreamController<Block>.broadcast();
  Stream<Block> get blockRemovedStream => _blockRemovedStreamController.stream;

  final StreamController<Block> _blockAddedStreamController =
      StreamController<Block>.broadcast();
  Stream<Block> get blockAddedStream => _blockAddedStreamController.stream;

  StreamSubscription<DatabaseEvent>? getBlocksSubscription;
  StreamSubscription<DatabaseEvent>? lastBlocksSubscription;
  StreamSubscription<DatabaseEvent>? nextBlocksSubscription;

  final StreamController<Block> _blocksStreamController =
      StreamController<Block>.broadcast();
  Stream<Block> get blocksStream => _blocksStreamController.stream;

  final StreamController<Block> _nextBlocksStreamController =
      StreamController<Block>.broadcast();
  Stream<Block> get nextBlocksStream => _nextBlocksStreamController.stream;

  int endBeforeBlock = 0;

  getBlocks(num epoch, int limitToLast) {
    final Query query = firebaseDatabase
        .ref()
        .child('${Environment.getEnvironment()}/blocks/$epoch')
        .orderByChild("block")
        .limitToLast(limitToLast);

    query.onChildAdded.forEach((event) {
      _blockAddedStreamController
          .add(Block.fromMap(event.snapshot.value as Map));
    });

    query.onChildRemoved.forEach((event) {
      _blockRemovedStreamController
          .add(Block.fromMap(event.snapshot.value as Map));
    });

    getBlocksSubscription = query.onValue.listen((event) {});
  }

  void getLastBlocks(num epoch) {
    final Query query = firebaseDatabase
        .ref()
        .child('${Environment.getEnvironment()}/blocks/$epoch')
        .orderByChild("block")
        .limitToLast(100);

    query.onChildAdded.forEach((event) {
      Block blockToAdd = Block.fromMap(event.snapshot.value as Map);

      if (endBeforeBlock == 0) {
        endBeforeBlock = blockToAdd.block as int;
      } else {
        endBeforeBlock = blockToAdd.block! < endBeforeBlock
            ? blockToAdd.block as int
            : endBeforeBlock;
        _blocksStreamController.add(blockToAdd);
      }
    });

    lastBlocksSubscription = query.onValue.listen((event) {});
  }

  void getNextBlocks(num epoch) {
    final Query query = firebaseDatabase
        .ref()
        .child('${Environment.getEnvironment()}/blocks/$epoch')
        .orderByChild("block")
        .endBefore(endBeforeBlock)
        .limitToLast(100);

    query.onChildAdded.forEach((event) {
      Block blockToAdd = Block.fromMap(event.snapshot.value as Map);

      if (endBeforeBlock == 0) {
        endBeforeBlock = blockToAdd.block as int;
      } else {
        endBeforeBlock = blockToAdd.block! < endBeforeBlock
            ? blockToAdd.block as int
            : endBeforeBlock;
        _blocksStreamController.add(blockToAdd);
      }

      _nextBlocksStreamController
          .add(Block.fromMap(event.snapshot.value as Map));
    });

    nextBlocksSubscription = query.onValue.listen((event) {});
  }

  @override
  FutureOr onDispose() {
    getBlocksSubscription?.cancel();
    lastBlocksSubscription?.cancel();
    nextBlocksSubscription?.cancel();
  }
}
