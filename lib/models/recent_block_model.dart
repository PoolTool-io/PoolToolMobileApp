class RecentBlock {
  num? block;
  num? cborSizeBytes;
  num? epoch;
  num? fees;
  String? hash;
  String? leaderPoolId;
  String? leaderPoolName;
  String? leaderPoolTicker;
  num? output;
  num? size;
  num? slot;
  num? time;
  num? transactions;

//<editor-fold desc="Data Methods">

  RecentBlock({
    this.block,
    this.cborSizeBytes,
    this.epoch,
    this.fees,
    this.hash,
    this.leaderPoolId,
    this.leaderPoolName,
    this.leaderPoolTicker,
    this.output,
    this.size,
    this.slot,
    this.time,
    this.transactions,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecentBlock &&
          runtimeType == other.runtimeType &&
          block == other.block &&
          cborSizeBytes == other.cborSizeBytes &&
          epoch == other.epoch &&
          fees == other.fees &&
          hash == other.hash &&
          leaderPoolId == other.leaderPoolId &&
          leaderPoolName == other.leaderPoolName &&
          leaderPoolTicker == other.leaderPoolTicker &&
          output == other.output &&
          size == other.size &&
          slot == other.slot &&
          time == other.time &&
          transactions == other.transactions);

  @override
  int get hashCode =>
      block.hashCode ^
      cborSizeBytes.hashCode ^
      epoch.hashCode ^
      fees.hashCode ^
      hash.hashCode ^
      leaderPoolId.hashCode ^
      leaderPoolName.hashCode ^
      leaderPoolTicker.hashCode ^
      output.hashCode ^
      size.hashCode ^
      slot.hashCode ^
      time.hashCode ^
      transactions.hashCode;

  @override
  String toString() {
    return 'RecentBlock{ block: $block, cborSizeBytes: $cborSizeBytes, epoch: $epoch, fees: $fees, hash: $hash, leaderPoolId: $leaderPoolId, leaderPoolName: $leaderPoolName, leaderPoolTicker: $leaderPoolTicker, output: $output, size: $size, slot: $slot, time: $time, transactions: $transactions,}';
  }

  RecentBlock copyWith({
    num? block,
    num? cborSizeBytes,
    num? epoch,
    num? fees,
    String? hash,
    String? leaderPoolId,
    String? leaderPoolName,
    String? leaderPoolTicker,
    num? output,
    num? size,
    num? slot,
    num? time,
    num? transactions,
  }) {
    return RecentBlock(
      block: block ?? this.block,
      cborSizeBytes: cborSizeBytes ?? this.cborSizeBytes,
      epoch: epoch ?? this.epoch,
      fees: fees ?? this.fees,
      hash: hash ?? this.hash,
      leaderPoolId: leaderPoolId ?? this.leaderPoolId,
      leaderPoolName: leaderPoolName ?? this.leaderPoolName,
      leaderPoolTicker: leaderPoolTicker ?? this.leaderPoolTicker,
      output: output ?? this.output,
      size: size ?? this.size,
      slot: slot ?? this.slot,
      time: time ?? this.time,
      transactions: transactions ?? this.transactions,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'block': block,
      'cborSizeBytes': cborSizeBytes,
      'epoch': epoch,
      'fees': fees,
      'hash': hash,
      'leaderPoolId': leaderPoolId,
      'leaderPoolName': leaderPoolName,
      'leaderPoolTicker': leaderPoolTicker,
      'output': output,
      'size': size,
      'slot': slot,
      'time': time,
      'transactions': transactions,
    };
  }

  factory RecentBlock.fromMap(Map<dynamic, dynamic> map) {
    return RecentBlock(
      block: map['block'],
      cborSizeBytes: map['cborSizeBytes'],
      epoch: map['epoch'],
      fees: map['fees'],
      hash: map['hash'],
      leaderPoolId: map['leaderPoolId'],
      leaderPoolName: map['leaderPoolName'],
      leaderPoolTicker: map['leaderPoolTicker'],
      output: map['output'],
      size: map['size'],
      slot: map['slot'],
      time: map['time'],
      transactions: map['transactions'],
    );
  }

//</editor-fold>
}
