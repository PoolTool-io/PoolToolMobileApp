import 'package:pegasus_tool/models/delegator_model.dart';

class LiveDelegators {
  num? delegatorHash;
  List<Delegator>? delegators;

//<editor-fold desc="Data Methods">

  LiveDelegators({
    this.delegatorHash,
    this.delegators,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LiveDelegators &&
          runtimeType == other.runtimeType &&
          delegatorHash == other.delegatorHash &&
          delegators == other.delegators);

  @override
  int get hashCode => delegatorHash.hashCode ^ delegators.hashCode;

  @override
  String toString() {
    return 'LiveDelegators{ delegatorHash: $delegatorHash, delegators: $delegators,}';
  }

  LiveDelegators copyWith({
    num? delegatorHash,
    List<Delegator>? delegators,
  }) {
    return LiveDelegators(
      delegatorHash: delegatorHash ?? this.delegatorHash,
      delegators: delegators ?? this.delegators,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'delegatorHash': delegatorHash,
      'delegators': delegators,
    };
  }

  factory LiveDelegators.fromMap(Map<dynamic, dynamic> map) {
    List<Delegator>? delegators = [];

    map['delegators']?.forEach((d) {
      delegators.add(Delegator.fromMap(d));
    });

    return LiveDelegators(
      delegatorHash: map['delegatorHash'],
      delegators: delegators,
    );
  }

//</editor-fold>
}
