import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:get_it/get_it.dart';
import 'package:pegasus_tool/config/environment.dart';
import 'package:pegasus_tool/models/block_model.dart';
import 'package:pegasus_tool/services/firebase_database_service.dart';

class PoolBlocksNeRepository {
  List<Block> limitedPoolBlocks = [];
  List<Block> allPoolBlocks = [];

  FirebaseDatabase firebaseDatabase =
      GetIt.I<FirebaseDatabaseService>().firebaseDatabase;

  final StreamController<Block> _blockRemovedStreamController =
      StreamController<Block>.broadcast();
  Stream<Block> get blockRemovedStream => _blockRemovedStreamController.stream;

  Stream<List<Block>> getPoolBlocks(String poolId, int limitToLast) {
    limitedPoolBlocks.clear();

    final Query query = firebaseDatabase
        .ref()
        .child('${Environment.getEnvironment()}/pool_blocks_ne/$poolId')
        .orderByChild("block")
        .limitToLast(limitToLast);

    query.onChildAdded.forEach((event) {
      limitedPoolBlocks.add(Block.fromMap(event.snapshot.value as Map));
    });

    query.onChildRemoved.forEach((event) {
      Block blockToRemove = Block.fromMap(event.snapshot.value as Map);
      limitedPoolBlocks.remove(blockToRemove);
      _blockRemovedStreamController.add(blockToRemove);
    });

    return query.onValue.map((_) => limitedPoolBlocks);
  }

  Stream<List<Block>> getAllPoolBlocks(String poolId) {
    allPoolBlocks.clear();

    final Query query = firebaseDatabase
        .ref()
        .child('${Environment.getEnvironment()}/pool_blocks_ne/$poolId')
        .orderByChild("block");

    query.onChildAdded.forEach((event) {
      allPoolBlocks.add(Block.fromMap(event.snapshot.value as Map));
    });

    return query.onValue.map((_) => allPoolBlocks);
  }
}
