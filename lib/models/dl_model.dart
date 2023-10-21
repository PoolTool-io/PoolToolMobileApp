import 'package:pegasus_tool/models/pool_ids_staked_model.dart';
import 'package:pegasus_tool/models/recent_10_model.dart';

class Dl {
  List<Recent10>? recent10;
  num? maxEpoch;
  String? currentPool;
  num? totalStaked;
  num? epochsStaked;
  List<PoolIdsStaked>? poolIdsStaked;

//<editor-fold desc="Data Methods">

  Dl({
    this.recent10,
    this.maxEpoch,
    this.currentPool,
    this.totalStaked,
    this.epochsStaked,
    this.poolIdsStaked,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Dl &&
          runtimeType == other.runtimeType &&
          recent10 == other.recent10 &&
          maxEpoch == other.maxEpoch &&
          currentPool == other.currentPool &&
          totalStaked == other.totalStaked &&
          epochsStaked == other.epochsStaked &&
          poolIdsStaked == other.poolIdsStaked);

  @override
  int get hashCode =>
      recent10.hashCode ^
      maxEpoch.hashCode ^
      currentPool.hashCode ^
      totalStaked.hashCode ^
      epochsStaked.hashCode ^
      poolIdsStaked.hashCode;

  @override
  String toString() {
    return 'Dl{ recent10: $recent10, maxEpoch: $maxEpoch, currentPool: $currentPool, totalStaked: $totalStaked, epochsStaked: $epochsStaked, poolIdsStaked: $poolIdsStaked,}';
  }

  Dl copyWith({
    List<Recent10>? recent10,
    num? maxEpoch,
    String? currentPool,
    num? totalStaked,
    num? epochsStaked,
    List<PoolIdsStaked>? poolIdsStaked,
  }) {
    return Dl(
      recent10: recent10 ?? this.recent10,
      maxEpoch: maxEpoch ?? this.maxEpoch,
      currentPool: currentPool ?? this.currentPool,
      totalStaked: totalStaked ?? this.totalStaked,
      epochsStaked: epochsStaked ?? this.epochsStaked,
      poolIdsStaked: poolIdsStaked ?? this.poolIdsStaked,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'recent10': recent10,
      'maxEpoch': maxEpoch,
      'currentPool': currentPool,
      'totalStaked': totalStaked,
      'epochsStaked': epochsStaked,
      'poolIdsStaked': poolIdsStaked,
    };
  }

  factory Dl.fromMap(Map<dynamic, dynamic> map) {
    List<Recent10> recent10 = [];
    List<PoolIdsStaked> poolIdsStaked = [];

    map['recent10']?.forEach((k, v) {
      recent10.add(Recent10(epoch: k, hash: v));
    });

    map['poolIdsStaked']?.forEach((k, v) {
      poolIdsStaked.add(PoolIdsStaked(
          hash: k,
          amount: v["amount"],
          epochs: v["epochs"],
          ticker: v["ticker"],
          rewards: v["rewards"],
          recent5Loyalty: v["recent5Loyalty"],
          lifetimeLoyalty: v["lifetimeLoyalty"],
          recent10Loyalty: v["recent10Loyalty"]));
    });

    return Dl(
      recent10: recent10,
      maxEpoch: map['maxEpoch'],
      currentPool: map['currentPool'],
      totalStaked: map['totalStaked'],
      epochsStaked: map['epochsStaked'],
      poolIdsStaked: poolIdsStaked,
    );
  }

//</editor-fold>
}
