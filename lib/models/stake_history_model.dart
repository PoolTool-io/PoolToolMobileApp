import 'package:pegasus_tool/models/stake_history_rewards_model.dart';

class StakeHistory {
  num epoch;
  StakeHistoryRewards rewards;

//<editor-fold desc="Data Methods">

  StakeHistory({
    required this.epoch,
    required this.rewards,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StakeHistory &&
          runtimeType == other.runtimeType &&
          epoch == other.epoch &&
          rewards == other.rewards);

  @override
  int get hashCode => epoch.hashCode ^ rewards.hashCode;

  @override
  String toString() {
    return 'StakeHistory{ epoch: $epoch, rewards: $rewards,}';
  }

  StakeHistory copyWith({
    num? epoch,
    StakeHistoryRewards? rewards,
  }) {
    return StakeHistory(
      epoch: epoch ?? this.epoch,
      rewards: rewards ?? this.rewards,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'epoch': epoch,
      'rewards': rewards,
    };
  }

  factory StakeHistory.fromMap(Map<dynamic, dynamic> map) {
    return StakeHistory(
      epoch: int.parse(map["epoch"]),
      rewards: StakeHistoryRewards.fromMap(map["rewards"]),
    );
  }

//</editor-fold>
}
