import 'dart:core';

import 'package:pegasus_tool/models/protocol_version_data_model.dart';

class ProtocolVersions {
  ProtocolVersionData? v0_0;
  ProtocolVersionData? v6_0;
  ProtocolVersionData? v7_0;
  ProtocolVersionData? v7_1;
  ProtocolVersionData? v7_2;

//<editor-fold desc="Data Methods">

  ProtocolVersions({
    this.v0_0,
    this.v6_0,
    this.v7_0,
    this.v7_1,
    this.v7_2,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProtocolVersions &&
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
    return 'ProtocolVersions{ v0_0: $v0_0, v6_0: $v6_0, v7_0: $v7_0, v7_1: $v7_1, v7_2: $v7_2,}';
  }

  ProtocolVersions copyWith({
    ProtocolVersionData? v0_0,
    ProtocolVersionData? v6_0,
    ProtocolVersionData? v7_0,
    ProtocolVersionData? v7_1,
    ProtocolVersionData? v7_2,
  }) {
    return ProtocolVersions(
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

  factory ProtocolVersions.fromMap(Map<dynamic, dynamic> map) {
    return ProtocolVersions(
      v0_0: map['v0_0'],
      v6_0: map['v6_0'],
      v7_0: map['v7_0'],
      v7_1: map['v7_1'],
      v7_2: map['v7_2'],
    );
  }

//</editor-fold>
}
