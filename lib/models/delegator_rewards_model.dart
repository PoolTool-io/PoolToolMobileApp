class DelegatorsRewards {
  String? epoch;
  num? amount;

//<editor-fold desc="Data Methods">

  DelegatorsRewards({
    this.epoch,
    this.amount,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DelegatorsRewards &&
          runtimeType == other.runtimeType &&
          epoch == other.epoch &&
          amount == other.amount);

  @override
  int get hashCode => epoch.hashCode ^ amount.hashCode;

  @override
  String toString() {
    return 'DelegatorsRewards{ epoch: $epoch, amount: $amount,}';
  }

  DelegatorsRewards copyWith({
    String? epoch,
    num? amount,
  }) {
    return DelegatorsRewards(
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

  factory DelegatorsRewards.fromMap(Map<dynamic, dynamic> map) {
    return DelegatorsRewards(
      epoch: map['epoch'],
      amount: map['amount'],
    );
  }

  static List<DelegatorsRewards?> getListDelegatorsRewards(dynamic map) {
    List<DelegatorsRewards?> delegatorsRewards = [];

    if (map.runtimeType == List<Object?>) {
      for (var i = 0; i < map.length; i++) {
        delegatorsRewards
            .add(DelegatorsRewards(epoch: i.toString(), amount: map[i] ?? 0));
      }
    } else {
      map?.forEach((k, v) {
        delegatorsRewards.add(DelegatorsRewards(epoch: k, amount: v));
      });
    }

    return delegatorsRewards;
  }

//</editor-fold>
}
