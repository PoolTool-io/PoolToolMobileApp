class PoolFees {
  String? epoch;
  num? amount;

//<editor-fold desc="Data Methods">

  PoolFees({
    this.epoch,
    this.amount,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PoolFees &&
          runtimeType == other.runtimeType &&
          epoch == other.epoch &&
          amount == other.amount);

  @override
  int get hashCode => epoch.hashCode ^ amount.hashCode;

  @override
  String toString() {
    return 'PoolFees{ epoch: $epoch, amount: $amount,}';
  }

  PoolFees copyWith({
    String? epoch,
    num? amount,
  }) {
    return PoolFees(
      epoch: epoch ?? this.epoch,
      amount: amount ?? this.amount,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'epoch': epoch,
      'amount': amount,
    };
  }

  factory PoolFees.fromMap(Map<dynamic, dynamic> map) {
    return PoolFees(
      epoch: map['epoch'],
      amount: map['amount'],
    );
  }

  static List<PoolFees?> getListPoolFees(dynamic map) {
    List<PoolFees?> poolFees = [];

    if (map.runtimeType == List<Object?>) {
      for (var i = 0; i < map.length; i++) {
        poolFees.add(PoolFees(epoch: i.toString(), amount: map[i] ?? 0));
      }
    } else {
      map?.forEach((k, v) {
        poolFees.add(PoolFees(epoch: k, amount: v));
      });
    }

    return poolFees;
  }

//</editor-fold>
}
