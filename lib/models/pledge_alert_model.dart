class PledgeAlert {
  bool? enabled;

//<editor-fold desc="Data Methods">

  PledgeAlert({
    this.enabled,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PledgeAlert &&
          runtimeType == other.runtimeType &&
          enabled == other.enabled);

  @override
  int get hashCode => enabled.hashCode;

  @override
  String toString() {
    return 'PledgeAlert{ enabled: $enabled,}';
  }

  PledgeAlert copyWith({
    bool? enabled,
  }) {
    return PledgeAlert(
      enabled: enabled ?? this.enabled,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'enabled': enabled,
    };
  }

  factory PledgeAlert.fromMap(Map<dynamic, dynamic> map) {
    return PledgeAlert(
      enabled: map['enabled'],
    );
  }

//</editor-fold>
}
