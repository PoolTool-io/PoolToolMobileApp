import 'package:pegasus_tool/models/rewards_addr_details_model.dart';

class StakeHistoryRewards {
  num? amount;
  String? delegatedTo;
  String? delegatedToTicker;
  bool? forecast;
  num? lifeAmount;
  num? lifeOperatorRewards;
  num? lifeStakeRewards;
  num? operatorRewards;
  RewardAddrDetails? rewardAddrDetails;
  String? rewardsSentTo;
  num? stakeRewards;

//<editor-fold desc="Data Methods">

  StakeHistoryRewards({
    this.amount,
    this.delegatedTo,
    this.delegatedToTicker,
    this.forecast,
    this.lifeAmount,
    this.lifeOperatorRewards,
    this.lifeStakeRewards,
    this.operatorRewards,
    this.rewardAddrDetails,
    this.rewardsSentTo,
    this.stakeRewards,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StakeHistoryRewards &&
          runtimeType == other.runtimeType &&
          amount == other.amount &&
          delegatedTo == other.delegatedTo &&
          delegatedToTicker == other.delegatedToTicker &&
          forecast == other.forecast &&
          lifeAmount == other.lifeAmount &&
          lifeOperatorRewards == other.lifeOperatorRewards &&
          lifeStakeRewards == other.lifeStakeRewards &&
          operatorRewards == other.operatorRewards &&
          rewardAddrDetails == other.rewardAddrDetails &&
          rewardsSentTo == other.rewardsSentTo &&
          stakeRewards == other.stakeRewards);

  @override
  int get hashCode =>
      amount.hashCode ^
      delegatedTo.hashCode ^
      delegatedToTicker.hashCode ^
      forecast.hashCode ^
      lifeAmount.hashCode ^
      lifeOperatorRewards.hashCode ^
      lifeStakeRewards.hashCode ^
      operatorRewards.hashCode ^
      rewardAddrDetails.hashCode ^
      rewardsSentTo.hashCode ^
      stakeRewards.hashCode;

  @override
  String toString() {
    return 'StakeHistoryRewardsModel{ amount: $amount, delegatedTo: $delegatedTo, delegatedToTicker: $delegatedToTicker, forecast: $forecast, lifeAmount: $lifeAmount, lifeOperatorRewards: $lifeOperatorRewards, lifeStakeRewards: $lifeStakeRewards, operatorRewards: $operatorRewards, rewardAddrDetails: $rewardAddrDetails, rewardsSentTo: $rewardsSentTo, stakeRewards: $stakeRewards,}';
  }

  StakeHistoryRewards copyWith({
    num? amount,
    String? delegatedTo,
    String? delegatedToTicker,
    bool? forecast,
    num? lifeAmount,
    num? lifeOperatorRewards,
    num? lifeStakeRewards,
    num? operatorRewards,
    RewardAddrDetails? rewardAddrDetails,
    String? rewardsSentTo,
    num? stakeRewards,
  }) {
    return StakeHistoryRewards(
      amount: amount ?? this.amount,
      delegatedTo: delegatedTo ?? this.delegatedTo,
      delegatedToTicker: delegatedToTicker ?? this.delegatedToTicker,
      forecast: forecast ?? this.forecast,
      lifeAmount: lifeAmount ?? this.lifeAmount,
      lifeOperatorRewards: lifeOperatorRewards ?? this.lifeOperatorRewards,
      lifeStakeRewards: lifeStakeRewards ?? this.lifeStakeRewards,
      operatorRewards: operatorRewards ?? this.operatorRewards,
      rewardAddrDetails: rewardAddrDetails ?? this.rewardAddrDetails,
      rewardsSentTo: rewardsSentTo ?? this.rewardsSentTo,
      stakeRewards: stakeRewards ?? this.stakeRewards,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'delegatedTo': delegatedTo,
      'delegatedToTicker': delegatedToTicker,
      'forecast': forecast,
      'lifeAmount': lifeAmount,
      'lifeOperatorRewards': lifeOperatorRewards,
      'lifeStakeRewards': lifeStakeRewards,
      'operatorRewards': operatorRewards,
      'rewardAddrDetails': rewardAddrDetails,
      'rewardsSentTo': rewardsSentTo,
      'stakeRewards': stakeRewards,
    };
  }

  factory StakeHistoryRewards.fromMap(Map<dynamic, dynamic> map) {
    return StakeHistoryRewards(
      amount: map['amount'],
      delegatedTo: map['delegatedTo'],
      delegatedToTicker: map['delegatedToTicker'],
      forecast: map['forecast'],
      lifeAmount: map['lifeAmount'],
      lifeOperatorRewards: map['lifeOperatorRewards'],
      lifeStakeRewards: map['lifeStakeRewards'],
      operatorRewards: map['operatorRewards'],
      rewardAddrDetails: map['rewardAddrDetails'] != null
          ? RewardAddrDetails.fromMap(map['rewardAddrDetails'])
          : null,
      rewardsSentTo: map['rewardsSentTo'],
      stakeRewards: map['stakeRewards'],
    );
  }

//</editor-fold>
}
