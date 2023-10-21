import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mockito/mockito.dart';
import 'package:pegasus_tool/config/constants.dart';
import 'package:pegasus_tool/models/stake_pool_model.dart';
import 'package:pegasus_tool/services/hive_service.dart';

// Create a mock class for StakePool
class MockStakePool extends Mock implements StakePool {}

void main() {
  // Initialize Hive before running any tests
  setUpAll(() {
    // Use a temporary directory instead of application documents directory
    final tempDir = Directory.systemTemp;
    Hive.init(tempDir.path);
    // Register adapters here
    Hive.registerAdapter(StakePoolAdapter());
  });

  // Close all boxes after running all tests
  tearDownAll(() async {
    await Hive.close();
  });

  group('HiveService', () {
    late Box<StakePool> stakePools;
    late Box<StakePool> favouriteStakePools;
    late HiveService hiveService;

    // Open boxes before each test
    setUp(() async {
      stakePools = await Hive.openBox<StakePool>('stakePools');
      favouriteStakePools =
          await Hive.openBox<StakePool>('favouriteStakePools');
      hiveService = HiveService();
      hiveService.stakePools = await Hive.openBox<StakePool>('stakePools');
      hiveService.favouriteStakePools =
          await Hive.openBox<StakePool>('favouriteStakePools');
    });

    // Clear boxes after each test
    tearDown(() async {
      await stakePools.clear();
      await favouriteStakePools.clear();
    });

    test('addFeaturedPools test', () async {
      // Arrange
      final loveStakePool = MockStakePool();
      loveStakePool.id = Constants.LOVE_POOL_ID;
      await stakePools.put(Constants.LOVE_POOL_ID, loveStakePool);
      final pooltoolStakePool = MockStakePool();
      pooltoolStakePool.id = Constants.POOLTOOL_POOL_ID;
      await stakePools.put(Constants.POOLTOOL_POOL_ID, pooltoolStakePool);

      // Act
      hiveService.addFeaturedPools();

      // Assert
      expect(favouriteStakePools.containsKey(Constants.LOVE_POOL_ID), true);
      expect(favouriteStakePools.get(Constants.LOVE_POOL_ID),
          equals(loveStakePool));
      expect(favouriteStakePools.containsKey(Constants.POOLTOOL_POOL_ID), true);
      expect(favouriteStakePools.get(Constants.POOLTOOL_POOL_ID),
          equals(pooltoolStakePool));
    });

    test('addFavouritePool test', () async {
      // Arrange
      const poolId = 'testId';
      final stakePool = MockStakePool();

      // Add a stake pool to stake pool box
      await stakePools.put(poolId, stakePool);

      // Act
      hiveService.addFavouritePool(poolId);

      // Assert
      expect(favouriteStakePools.containsKey(poolId), true);
      expect(favouriteStakePools.get(poolId), equals(stakePool));
    });

    test('removeFavouritePool test', () async {
      // Arrange
      const poolId = 'testId';
      final stakePool = MockStakePool();

      // Add a stake pool to favouriteStakePools box
      await favouriteStakePools.put(poolId, stakePool);

      // Act
      hiveService.removeFavouritePool(poolId);

      // Assert
      expect(favouriteStakePools.containsKey(poolId), false);
    });

    test('clear test', () async {
      // Arrange
      const poolId = 'testId';
      final stakePool = MockStakePool();

      // Add a stake pool to both stakePools and favouriteStakePools box
      await stakePools.put(poolId, stakePool);
      await favouriteStakePools.put(poolId, stakePool);

      // Act
      await hiveService.clear();

      // Assert
      expect(stakePools.containsKey(poolId), false);
      expect(favouriteStakePools.containsKey(poolId), false);
    });
  });
}
