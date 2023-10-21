class BattleData {
  num? recentBattles;
  num? recentForkers;
  num? recentHeightBattles;
  num? recentSlotBattles;

//<editor-fold desc="Data Methods">

  BattleData({
    this.recentBattles,
    this.recentForkers,
    this.recentHeightBattles,
    this.recentSlotBattles,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BattleData &&
          runtimeType == other.runtimeType &&
          recentBattles == other.recentBattles &&
          recentForkers == other.recentForkers &&
          recentHeightBattles == other.recentHeightBattles &&
          recentSlotBattles == other.recentSlotBattles);

  @override
  int get hashCode =>
      recentBattles.hashCode ^
      recentForkers.hashCode ^
      recentHeightBattles.hashCode ^
      recentSlotBattles.hashCode;

  @override
  String toString() {
    return 'BattleData{ recentBattles: $recentBattles, recentForkers: $recentForkers, recentHeightBattles: $recentHeightBattles, recentSlotBattles: $recentSlotBattles,}';
  }

  BattleData copyWith({
    num? recentBattles,
    num? recentForkers,
    num? recentHeightBattles,
    num? recentSlotBattles,
  }) {
    return BattleData(
      recentBattles: recentBattles ?? this.recentBattles,
      recentForkers: recentForkers ?? this.recentForkers,
      recentHeightBattles: recentHeightBattles ?? this.recentHeightBattles,
      recentSlotBattles: recentSlotBattles ?? this.recentSlotBattles,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'recentBattles': recentBattles,
      'recentForkers': recentForkers,
      'recentHeightBattles': recentHeightBattles,
      'recentSlotBattles': recentSlotBattles,
    };
  }

  factory BattleData.fromMap(Map<dynamic, dynamic> map) {
    return BattleData(
      recentBattles: map['recentBattles'] as num,
      recentForkers: map['recentForkers'] as num,
      recentHeightBattles: map['recentHeightBattles'] as num,
      recentSlotBattles: map['recentSlotBattles'] as num,
    );
  }

//</editor-fold>
}
