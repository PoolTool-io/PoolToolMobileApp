class RewardAddrDetails {
  String? addr;
  num? amount;
  bool? forecast;
  num? operatorRewards;
  String? pool;
  num? stakeRewards;

//<editor-fold desc="Data Methods">

  RewardAddrDetails({
    this.addr,
    this.amount,
    this.forecast,
    this.operatorRewards,
    this.pool,
    this.stakeRewards,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RewardAddrDetails &&
          runtimeType == other.runtimeType &&
          addr == other.addr &&
          amount == other.amount &&
          forecast == other.forecast &&
          operatorRewards == other.operatorRewards &&
          pool == other.pool &&
          stakeRewards == other.stakeRewards);

  @override
  int get hashCode =>
      addr.hashCode ^
      amount.hashCode ^
      forecast.hashCode ^
      operatorRewards.hashCode ^
      pool.hashCode ^
      stakeRewards.hashCode;

  @override
  String toString() {
    return 'RewardAddrDetails{ addr: $addr, amount: $amount, forecast: $forecast, operatorRewards: $operatorRewards, pool: $pool, stakeRewards: $stakeRewards,}';
  }

  RewardAddrDetails copyWith({
    String? addr,
    num? amount,
    bool? forecast,
    num? operatorRewards,
    String? pool,
    num? stakeRewards,
  }) {
    return RewardAddrDetails(
      addr: addr ?? this.addr,
      amount: amount ?? this.amount,
      forecast: forecast ?? this.forecast,
      operatorRewards: operatorRewards ?? this.operatorRewards,
      pool: pool ?? this.pool,
      stakeRewards: stakeRewards ?? this.stakeRewards,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'addr': addr,
      'amount': amount,
      'forecast': forecast,
      'operatorRewards': operatorRewards,
      'pool': pool,
      'stakeRewards': stakeRewards,
    };
  }

  factory RewardAddrDetails.fromMap(Map<dynamic, dynamic> map) {
    return RewardAddrDetails(
      addr: map.keys.first as String,
      amount: map[map.keys.first]['amount'] as num,
      forecast: map[map.keys.first]['forecast'] as bool,
      operatorRewards: map[map.keys.first]['operatorRewards'] as num,
      pool: map[map.keys.first]['pool'] as String,
      stakeRewards: map[map.keys.first]['stakeRewards'] as num,
    );
  }

//</editor-fold>
}
