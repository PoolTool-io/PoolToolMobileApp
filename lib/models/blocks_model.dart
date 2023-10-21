class Blocks {
  String? epoch;
  num? amount;

//<editor-fold desc="Data Methods">

  Blocks({
    this.epoch,
    this.amount,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Blocks &&
          runtimeType == other.runtimeType &&
          epoch == other.epoch &&
          amount == other.amount);

  @override
  int get hashCode => epoch.hashCode ^ amount.hashCode;

  @override
  String toString() {
    return 'Blocks{ epoch: $epoch, amount: $amount,}';
  }

  Blocks copyWith({
    String? epoch,
    num? amount,
  }) {
    return Blocks(
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

  factory Blocks.fromMap(Map<dynamic, dynamic> map) {
    return Blocks(
      epoch: map['epoch'],
      amount: map['amount'],
    );
  }

  // static List<Blocks?> getListBlocks(Map<dynamic, dynamic>? map) {
  static List<Blocks?> getListBlocks(dynamic map) {
    List<Blocks?> blocks = [];

    if (map.runtimeType == List<Object?>) {
      for (var i = 0; i < map.length; i++) {
        blocks.add(Blocks(epoch: i.toString(), amount: map[i] ?? 0));
      }
    } else {
      map?.forEach((k, v) {
        blocks.add(Blocks(epoch: k, amount: v));
      });
    }

    return blocks;
  }

//</editor-fold>
}
