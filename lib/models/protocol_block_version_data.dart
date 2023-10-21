class ProtocolBlockVersionData {
  num? blocks;
  String? ver;

//<editor-fold desc="Data Methods">

  ProtocolBlockVersionData({
    this.blocks,
    this.ver,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProtocolBlockVersionData &&
          runtimeType == other.runtimeType &&
          blocks == other.blocks &&
          ver == other.ver);

  @override
  int get hashCode => blocks.hashCode ^ ver.hashCode;

  @override
  String toString() {
    return 'ProtocolBlockVersionData{ blocks: $blocks, ver: $ver,}';
  }

  ProtocolBlockVersionData copyWith({
    num? blocks,
    String? ver,
  }) {
    return ProtocolBlockVersionData(
      blocks: blocks ?? this.blocks,
      ver: ver ?? this.ver,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'blocks': blocks,
      'ver': ver,
    };
  }

  factory ProtocolBlockVersionData.fromMap(Map<String, dynamic> map) {
    return ProtocolBlockVersionData(
      blocks: map['blocks'] as num,
      ver: map['ver'] as String,
    );
  }

//</editor-fold>
}
