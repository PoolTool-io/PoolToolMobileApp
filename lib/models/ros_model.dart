class Ros {
  String? epoch;
  num? amount;

//<editor-fold desc="Data Methods">

  Ros({
    this.epoch,
    this.amount,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Ros &&
          runtimeType == other.runtimeType &&
          epoch == other.epoch &&
          amount == other.amount);

  @override
  int get hashCode => epoch.hashCode ^ amount.hashCode;

  @override
  String toString() {
    return 'Ros{ epoch: $epoch, amount: $amount,}';
  }

  Ros copyWith({
    String? epoch,
    num? amount,
  }) {
    return Ros(
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

  factory Ros.fromMap(Map<dynamic, dynamic> map) {
    return Ros(
      epoch: map['epoch'],
      amount: map['amount'],
    );
  }

  static List<Ros?> getListRos(dynamic map) {
    List<Ros?> ros = [];

    if (map.runtimeType == List<Object?>) {
      for (var i = 0; i < map.length; i++) {
        ros.add(Ros(epoch: i.toString(), amount: map[i] ?? 0));
      }
    } else {
      map?.forEach((k, v) {
        ros.add(Ros(epoch: k, amount: v));
      });
    }

    return ros;
  }

//</editor-fold>
}
