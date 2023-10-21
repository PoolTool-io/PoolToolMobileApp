class Epoch {
  num? blocks;
  num? epoch;
  num? fees;
  num? lastBlockTime;
  num? totalOutput;
  num? transactions;

//<editor-fold desc="Data Methods">

  Epoch({
    this.blocks,
    this.epoch,
    this.fees,
    this.lastBlockTime,
    this.totalOutput,
    this.transactions,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Epoch &&
          runtimeType == other.runtimeType &&
          blocks == other.blocks &&
          epoch == other.epoch &&
          fees == other.fees &&
          lastBlockTime == other.lastBlockTime &&
          totalOutput == other.totalOutput &&
          transactions == other.transactions);

  @override
  int get hashCode =>
      blocks.hashCode ^
      epoch.hashCode ^
      fees.hashCode ^
      lastBlockTime.hashCode ^
      totalOutput.hashCode ^
      transactions.hashCode;

  @override
  String toString() {
    return 'EpochModel{ blocks: $blocks, epoch: $epoch, fees: $fees, lastBlockTime: $lastBlockTime, totalOutput: $totalOutput, transactions: $transactions,}';
  }

  Epoch copyWith({
    num? blocks,
    num? epoch,
    num? fees,
    num? lastBlockTime,
    num? totalOutput,
    num? transactions,
  }) {
    return Epoch(
      blocks: blocks ?? this.blocks,
      epoch: epoch ?? this.epoch,
      fees: fees ?? this.fees,
      lastBlockTime: lastBlockTime ?? this.lastBlockTime,
      totalOutput: totalOutput ?? this.totalOutput,
      transactions: transactions ?? this.transactions,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'blocks': blocks,
      'epoch': epoch,
      'fees': fees,
      'lastBlockTime': lastBlockTime,
      'totalOutput': totalOutput,
      'transactions': transactions,
    };
  }

  factory Epoch.fromMap(Map<dynamic, dynamic> map) {
    return Epoch(
      blocks: map['blocks'],
      epoch: map['epoch'],
      fees: map['fees'],
      lastBlockTime: map['lastBlockTime'],
      totalOutput: map['totalOutput'],
      transactions: map['transactions'],
    );
  }

//</editor-fold>
}
