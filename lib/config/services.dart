import 'package:get_it/get_it.dart';
import 'package:pegasus_tool/repository/block_alert_repository.dart';
import 'package:pegasus_tool/repository/blocks_repository.dart';
import 'package:pegasus_tool/repository/ecosystem_repository.dart';
import 'package:pegasus_tool/repository/epoch_repository.dart';
import 'package:pegasus_tool/repository/fee_alert_repository.dart';
import 'package:pegasus_tool/repository/mary_db_sync_status_repository.dart';
import 'package:pegasus_tool/repository/my_addresses_repository.dart';
import 'package:pegasus_tool/repository/pledge_alert_repository.dart';
import 'package:pegasus_tool/repository/pool_blocks_ne_repository.dart';
import 'package:pegasus_tool/repository/pool_stats_repository.dart';
import 'package:pegasus_tool/repository/pool_updates_repository.dart';
import 'package:pegasus_tool/repository/recent_block_repository.dart';
import 'package:pegasus_tool/repository/saturation_alert_repository.dart';
import 'package:pegasus_tool/repository/saturation_repository.dart';
import 'package:pegasus_tool/repository/stake_hist_repository.dart';
import 'package:pegasus_tool/repository/stake_pools_repository.dart';
import 'package:pegasus_tool/services/epoch_service.dart';
import 'package:pegasus_tool/services/firebase_analytics_service.dart';
import 'package:pegasus_tool/services/firebase_app_service.dart';
import 'package:pegasus_tool/services/firebase_auth_service.dart';
import 'package:pegasus_tool/services/firebase_database_service.dart';
import 'package:pegasus_tool/services/firebase_messaging_service.dart';
import 'package:pegasus_tool/services/hive_service.dart';
import 'package:pegasus_tool/services/local_database_service.dart';
import 'package:pegasus_tool/services/navigator_service.dart';

class Services {
  static Future<void> registerAll() async {
    // Register Hive Service
    GetIt.I
        .registerSingletonAsync<HiveService>(() async => HiveService().init());

    // Register Firebase Services
    GetIt.I.registerSingletonAsync<FirebaseAppService>(
        () async => FirebaseAppService().init());
    GetIt.I.registerSingletonWithDependencies<FirebaseMessagingService>(
        () => FirebaseMessagingService(),
        dependsOn: [FirebaseAppService]);
    GetIt.I.registerSingletonWithDependencies<FirebaseAnalyticsService>(
        () => FirebaseAnalyticsService(),
        dependsOn: [FirebaseAppService]);
    GetIt.I.registerSingletonWithDependencies<FirebaseDatabaseService>(
        () => FirebaseDatabaseService(),
        dependsOn: [FirebaseAppService]);
    GetIt.I.registerSingletonWithDependencies<FirebaseAuthService>(
        () => FirebaseAuthService(),
        dependsOn: [
          FirebaseAppService,
          FirebaseMessagingService,
          FirebaseDatabaseService
        ]);

    // Register Services
    GetIt.I.registerSingletonWithDependencies<LocalDatabaseService>(
        () => LocalDatabaseService(),
        dependsOn: [FirebaseDatabaseService]);
    GetIt.I.registerLazySingleton(() => NavigationService());
    GetIt.I.registerSingletonAsync<SaturationRepository>(
        () => SaturationRepository().init(),
        dependsOn: [FirebaseDatabaseService]);
    GetIt.I.registerSingletonWithDependencies<PoolUpdatesRepository>(
        () => PoolUpdatesRepository(),
        dependsOn: [FirebaseDatabaseService]);
    GetIt.I.registerSingletonWithDependencies<MaryDbSyncStatusRepository>(
        () => MaryDbSyncStatusRepository(),
        dependsOn: [FirebaseDatabaseService]);
    GetIt.I.registerSingletonWithDependencies<RecentBlockRepository>(
        () => RecentBlockRepository(),
        dependsOn: [FirebaseDatabaseService]);
    GetIt.I.registerSingletonWithDependencies<BlocksRepository>(
        () => BlocksRepository(),
        dependsOn: [FirebaseDatabaseService]);
    GetIt.I.registerSingletonWithDependencies<StakePoolsRepository>(
        () => StakePoolsRepository(),
        dependsOn: [
          HiveService,
          FirebaseDatabaseService,
          LocalDatabaseService
        ]);
    GetIt.I.registerSingletonWithDependencies<StakeHistoryRepository>(
        () => StakeHistoryRepository(),
        dependsOn: [FirebaseDatabaseService]);
    GetIt.I.registerSingletonWithDependencies<EpochRepository>(
        () => EpochRepository(),
        dependsOn: [FirebaseDatabaseService]);
    GetIt.I.registerSingletonWithDependencies<PoolBlocksNeRepository>(
        () => PoolBlocksNeRepository(),
        dependsOn: [FirebaseDatabaseService]);
    GetIt.I.registerSingletonWithDependencies<PoolStatsRepository>(
        () => PoolStatsRepository(),
        dependsOn: [FirebaseDatabaseService]);
    GetIt.I.registerSingletonWithDependencies<EcosystemRepository>(
        () => EcosystemRepository(),
        dependsOn: [FirebaseDatabaseService]);
    GetIt.I.registerSingletonWithDependencies<FeeAlertRepository>(
        () => FeeAlertRepository(),
        dependsOn: [FirebaseDatabaseService]);
    GetIt.I.registerSingletonWithDependencies<SaturationAlertRepository>(
        () => SaturationAlertRepository(),
        dependsOn: [FirebaseDatabaseService]);
    GetIt.I.registerSingletonWithDependencies<BlockAlertRepository>(
        () => BlockAlertRepository(),
        dependsOn: [FirebaseDatabaseService]);
    GetIt.I.registerSingletonWithDependencies<PledgeAlertRepository>(
        () => PledgeAlertRepository(),
        dependsOn: [FirebaseDatabaseService]);
    GetIt.I.registerSingletonWithDependencies<MyAddressesRepository>(
        () => MyAddressesRepository(),
        dependsOn: [FirebaseDatabaseService, FirebaseAuthService]);

    // Register Services that depend on Repositories
    GetIt.I.registerSingletonWithDependencies<EpochService>(
        () => EpochService(),
        dependsOn: [MaryDbSyncStatusRepository]);
  }
}
