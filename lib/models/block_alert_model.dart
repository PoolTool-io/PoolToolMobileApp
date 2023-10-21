class BlockAlert {
  bool? enabled;

//<editor-fold desc="Data Methods">

  BlockAlert({
    this.enabled,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BlockAlert &&
          runtimeType == other.runtimeType &&
          enabled == other.enabled);

  @override
  int get hashCode => enabled.hashCode;

  @override
  String toString() {
    return 'BlockAlert{ enabled: $enabled,}';
  }

  BlockAlert copyWith({
    bool? enabled,
  }) {
    return BlockAlert(
      enabled: enabled ?? this.enabled,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'enabled': enabled,
    };
  }

  factory BlockAlert.fromMap(Map<dynamic, dynamic> map) {
    return BlockAlert(
      enabled: map['enabled'],
    );
  }

//</editor-fold>
}
