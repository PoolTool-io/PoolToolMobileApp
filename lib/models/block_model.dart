class Block {
  num? block;
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

  Block({
    this.block,
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
      (other is Block &&
          runtimeType == other.runtimeType &&
          block == other.block &&
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
    return 'PoolBlocksNe{ block: $block, epoch: $epoch, fees: $fees, hash: $hash, leaderPoolId: $leaderPoolId, leaderPoolName: $leaderPoolName, leaderPoolTicker: $leaderPoolTicker, output: $output, size: $size, slot: $slot, time: $time, transactions: $transactions,}';
  }

  Block copyWith({
    num? block,
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
    return Block(
      block: block ?? this.block,
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

  factory Block.fromMap(Map<dynamic, dynamic> map) {
    return Block(
      block: map['block'],
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
