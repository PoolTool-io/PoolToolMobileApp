import 'package:pegasus_tool/models/protocol_block_version_data.dart';

class ProtocolBlockVersions {
  ProtocolBlockVersionData? v0_0;
  ProtocolBlockVersionData? v6_0;
  ProtocolBlockVersionData? v7_0;
  ProtocolBlockVersionData? v7_1;
  ProtocolBlockVersionData? v7_2;

//<editor-fold desc="Data Methods">

  ProtocolBlockVersions({
    this.v0_0,
    this.v6_0,
    this.v7_0,
    this.v7_1,
    this.v7_2,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProtocolBlockVersions &&
          runtimeType == other.runtimeType &&
          v0_0 == other.v0_0 &&
          v6_0 == other.v6_0 &&
          v7_0 == other.v7_0 &&
          v7_1 == other.v7_1 &&
          v7_2 == other.v7_2);

  @override
  int get hashCode =>
      v0_0.hashCode ^
      v6_0.hashCode ^
      v7_0.hashCode ^
      v7_1.hashCode ^
      v7_2.hashCode;

  @override
  String toString() {
    return 'ProtocolBlockVersions{ v0_0: $v0_0, v6_0: $v6_0, v7_0: $v7_0, v7_1: $v7_1, v7_2: $v7_2,}';
  }

  ProtocolBlockVersions copyWith({
    ProtocolBlockVersionData? v0_0,
    ProtocolBlockVersionData? v6_0,
    ProtocolBlockVersionData? v7_0,
    ProtocolBlockVersionData? v7_1,
    ProtocolBlockVersionData? v7_2,
  }) {
    return ProtocolBlockVersions(
      v0_0: v0_0 ?? this.v0_0,
      v6_0: v6_0 ?? this.v6_0,
      v7_0: v7_0 ?? this.v7_0,
      v7_1: v7_1 ?? this.v7_1,
      v7_2: v7_2 ?? this.v7_2,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'v0_0': v0_0,
      'v6_0': v6_0,
      'v7_0': v7_0,
      'v7_1': v7_1,
      'v7_2': v7_2,
    };
  }

  factory ProtocolBlockVersions.fromMap(Map<dynamic, dynamic> map) {
    return ProtocolBlockVersions(
      v0_0: map['v0_0'],
      v6_0: map['v6_0'],
      v7_0: map['v7_0'],
      v7_1: map['v7_1'],
      v7_2: map['v7_2'],
    );
  }

//</editor-fold>
}
