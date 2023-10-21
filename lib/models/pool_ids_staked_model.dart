class PoolIdsStaked {
  String? hash;
  num? amount;
  num? epochs;
  String? ticker;
  num? rewards;
  num? recent5Loyalty;
  num? lifetimeLoyalty;
  num? recent10Loyalty;

//<editor-fold desc="Data Methods">

  PoolIdsStaked({
    this.hash,
    this.amount,
    this.epochs,
    this.ticker,
    this.rewards,
    this.recent5Loyalty,
    this.lifetimeLoyalty,
    this.recent10Loyalty,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PoolIdsStaked &&
          runtimeType == other.runtimeType &&
          hash == other.hash &&
          amount == other.amount &&
          epochs == other.epochs &&
          ticker == other.ticker &&
          rewards == other.rewards &&
          recent5Loyalty == other.recent5Loyalty &&
          lifetimeLoyalty == other.lifetimeLoyalty &&
          recent10Loyalty == other.recent10Loyalty);

  @override
  int get hashCode =>
      hash.hashCode ^
      amount.hashCode ^
      epochs.hashCode ^
      ticker.hashCode ^
      rewards.hashCode ^
      recent5Loyalty.hashCode ^
      lifetimeLoyalty.hashCode ^
      recent10Loyalty.hashCode;

  @override
  String toString() {
    return 'PoolIdsStaked{ hash: $hash, amount: $amount, epochs: $epochs, ticker: $ticker, rewards: $rewards, recent5Loyalty: $recent5Loyalty, lifetimeLoyalty: $lifetimeLoyalty, recent10Loyalty: $recent10Loyalty,}';
  }

  PoolIdsStaked copyWith({
    String? hash,
    num? amount,
    num? epochs,
    String? ticker,
    num? rewards,
    num? recent5Loyalty,
    num? lifetimeLoyalty,
    num? recent10Loyalty,
  }) {
    return PoolIdsStaked(
      hash: hash ?? this.hash,
      amount: amount ?? this.amount,
      epochs: epochs ?? this.epochs,
      ticker: ticker ?? this.ticker,
      rewards: rewards ?? this.rewards,
      recent5Loyalty: recent5Loyalty ?? this.recent5Loyalty,
      lifetimeLoyalty: lifetimeLoyalty ?? this.lifetimeLoyalty,
      recent10Loyalty: recent10Loyalty ?? this.recent10Loyalty,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'hash': hash,
      'amount': amount,
      'epochs': epochs,
      'ticker': ticker,
      'rewards': rewards,
      'recent5Loyalty': recent5Loyalty,
      'lifetimeLoyalty': lifetimeLoyalty,
      'recent10Loyalty': recent10Loyalty,
    };
  }

  factory PoolIdsStaked.fromMap(Map<dynamic, dynamic> map) {
    return PoolIdsStaked(
      hash: map['hash'],
      amount: map['amount'],
      epochs: map['epochs'],
      ticker: map['ticker'],
      rewards: map['rewards'],
      recent5Loyalty: map['recent5Loyalty'],
      lifetimeLoyalty: map['lifetimeLoyalty'],
      recent10Loyalty: map['recent10Loyalty'],
    );
  }

//</editor-fold>
}
