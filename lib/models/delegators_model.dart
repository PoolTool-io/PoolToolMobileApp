class Delegators {
  String? delegator;
  num? amount;

//<editor-fold desc="Data Methods">

  Delegators({
    this.delegator,
    this.amount,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Delegators &&
          runtimeType == other.runtimeType &&
          delegator == other.delegator &&
          amount == other.amount);

  @override
  int get hashCode => delegator.hashCode ^ amount.hashCode;

  @override
  String toString() {
    return 'Delegators{ delegator: $delegator, amount: $amount,}';
  }

  Delegators copyWith({
    String? delegator,
    num? amount,
  }) {
    return Delegators(
      delegator: delegator ?? this.delegator,
      amount: amount ?? this.amount,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'delegator': delegator,
      'amount': amount,
    };
  }

  factory Delegators.fromMap(Map<dynamic, dynamic> map) {
    return Delegators(
      delegator: map['delegator'],
      amount: map['amount'],
    );
  }

  static List<Delegators?> getListDelegators(Map<dynamic, dynamic>? map) {
    List<Delegators?> delegators = [];

    map?.forEach((k, v) {
      delegators.add(Delegators(delegator: k, amount: v));
    });

    return delegators;
  }

//</editor-fold>
}
