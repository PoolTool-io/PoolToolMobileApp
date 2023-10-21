class FeeAlert {
  num? fixedFee;
  num? variableFee;
  num? pledge;

//<editor-fold desc="Data Methods">

  FeeAlert({
    this.fixedFee,
    this.variableFee,
    this.pledge,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FeeAlert &&
          runtimeType == other.runtimeType &&
          fixedFee == other.fixedFee &&
          variableFee == other.variableFee &&
          pledge == other.pledge);

  @override
  int get hashCode =>
      fixedFee.hashCode ^ variableFee.hashCode ^ pledge.hashCode;

  @override
  String toString() {
    return 'FeeAlert{ fixedFee: $fixedFee, variableFee: $variableFee, pledge: $pledge,}';
  }

  FeeAlert copyWith({
    num? fixedFee,
    num? variableFee,
    num? pledge,
  }) {
    return FeeAlert(
      fixedFee: fixedFee ?? this.fixedFee,
      variableFee: variableFee ?? this.variableFee,
      pledge: pledge ?? this.pledge,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fixedFee': fixedFee,
      'variableFee': variableFee,
      'pledge': pledge,
    };
  }

  factory FeeAlert.fromMap(Map<dynamic, dynamic> map) {
    return FeeAlert(
      fixedFee: map['fixedFee'],
      variableFee: map['variableFee'],
      pledge: map['pledge'],
    );
  }

//</editor-fold>
}
