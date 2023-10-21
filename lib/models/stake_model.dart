class Stake {
  String? epoch;
  num? amount;

//<editor-fold desc="Data Methods">

  Stake({
    this.epoch,
    this.amount,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Stake &&
          runtimeType == other.runtimeType &&
          epoch == other.epoch &&
          amount == other.amount);

  @override
  int get hashCode => epoch.hashCode ^ amount.hashCode;

  @override
  String toString() {
    return 'Stake{ epoch: $epoch, amount: $amount,}';
  }

  Stake copyWith({
    String? epoch,
    num? amount,
  }) {
    return Stake(
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

  factory Stake.fromMap(Map<dynamic, dynamic> map) {
    return Stake(
      epoch: map['epoch'],
      amount: map['amount'],
    );
  }

  static List<Stake?> getListStake(dynamic map) {
    List<Stake?> stake = [];

    if (map.runtimeType == List<Object?>) {
      for (var i = 0; i < map.length; i++) {
        stake.add(Stake(epoch: i.toString(), amount: map[i] ?? 0));
      }
    } else {
      map?.forEach((k, v) {
        stake.add(Stake(epoch: k, amount: v));
      });
    }

    return stake;
  }

//</editor-fold>
}
