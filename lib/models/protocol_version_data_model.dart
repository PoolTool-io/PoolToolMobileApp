class ProtocolVersionData {
  num? blocks;
  num? blocks12hr;
  num? blocks1hr;
  num? blocks24hr;
  num? blocks6hr;
  num? qty;
  num? stake;
  String? ver;

//<editor-fold desc="Data Methods">

  ProtocolVersionData({
    this.blocks,
    this.blocks12hr,
    this.blocks1hr,
    this.blocks24hr,
    this.blocks6hr,
    this.qty,
    this.stake,
    this.ver,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProtocolVersionData &&
          runtimeType == other.runtimeType &&
          blocks == other.blocks &&
          blocks12hr == other.blocks12hr &&
          blocks1hr == other.blocks1hr &&
          blocks24hr == other.blocks24hr &&
          blocks6hr == other.blocks6hr &&
          qty == other.qty &&
          stake == other.stake &&
          ver == other.ver);

  @override
  int get hashCode =>
      blocks.hashCode ^
      blocks12hr.hashCode ^
      blocks1hr.hashCode ^
      blocks24hr.hashCode ^
      blocks6hr.hashCode ^
      qty.hashCode ^
      stake.hashCode ^
      ver.hashCode;

  @override
  String toString() {
    return 'ProtocolVersionData{ blocks: $blocks, blocks12hr: $blocks12hr, blocks1hr: $blocks1hr, blocks24hr: $blocks24hr, blocks6hr: $blocks6hr, qty: $qty, stake: $stake, ver: $ver,}';
  }

  ProtocolVersionData copyWith({
    num? blocks,
    num? blocks12hr,
    num? blocks1hr,
    num? blocks24hr,
    num? blocks6hr,
    num? qty,
    num? stake,
    String? ver,
  }) {
    return ProtocolVersionData(
      blocks: blocks ?? this.blocks,
      blocks12hr: blocks12hr ?? this.blocks12hr,
      blocks1hr: blocks1hr ?? this.blocks1hr,
      blocks24hr: blocks24hr ?? this.blocks24hr,
      blocks6hr: blocks6hr ?? this.blocks6hr,
      qty: qty ?? this.qty,
      stake: stake ?? this.stake,
      ver: ver ?? this.ver,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'blocks': blocks,
      'blocks12hr': blocks12hr,
      'blocks1hr': blocks1hr,
      'blocks24hr': blocks24hr,
      'blocks6hr': blocks6hr,
      'qty': qty,
      'stake': stake,
      'ver': ver,
    };
  }

  factory ProtocolVersionData.fromMap(Map<String, dynamic> map) {
    return ProtocolVersionData(
      blocks: map['blocks'] as num,
      blocks12hr: map['blocks12hr'] as num,
      blocks1hr: map['blocks1hr'] as num,
      blocks24hr: map['blocks24hr'] as num,
      blocks6hr: map['blocks6hr'] as num,
      qty: map['qty'] as num,
      stake: map['stake'] as num,
      ver: map['ver'] as String,
    );
  }

//</editor-fold>
}
