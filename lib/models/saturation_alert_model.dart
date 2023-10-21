class SaturationAlert {
  final num? limit;

//<editor-fold desc="Data Methods">

  const SaturationAlert({
    this.limit,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SaturationAlert &&
          runtimeType == other.runtimeType &&
          limit == other.limit);

  @override
  int get hashCode => limit.hashCode;

  @override
  String toString() {
    return 'SaturationAlert{ limit: $limit,}';
  }

  SaturationAlert copyWith({
    num? limit,
  }) {
    return SaturationAlert(
      limit: limit ?? this.limit,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'limit': limit,
    };
  }

  factory SaturationAlert.fromMap(Map<dynamic, dynamic> map) {
    return SaturationAlert(
      limit: map['limit'],
    );
  }

  factory SaturationAlert.fromDouble(double l) {
    return SaturationAlert(
      limit: l,
    );
  }

//</editor-fold>
}
