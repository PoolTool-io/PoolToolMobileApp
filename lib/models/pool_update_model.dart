class PoolUpdate {
  String? id;
  String? from;
  String? name;
  String? poolId;
  String? ticker;
  int? time;
  String? to;
  String? type;
  String? retiring_epoch;

//<editor-fold desc="Data Methods">

  PoolUpdate({
    this.id,
    this.from,
    this.name,
    this.poolId,
    this.ticker,
    this.time,
    this.to,
    this.type,
    this.retiring_epoch,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PoolUpdate &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          from == other.from &&
          name == other.name &&
          poolId == other.poolId &&
          ticker == other.ticker &&
          time == other.time &&
          to == other.to &&
          type == other.type &&
          retiring_epoch == other.retiring_epoch);

  @override
  int get hashCode =>
      id.hashCode ^
      from.hashCode ^
      name.hashCode ^
      poolId.hashCode ^
      ticker.hashCode ^
      time.hashCode ^
      to.hashCode ^
      type.hashCode ^
      retiring_epoch.hashCode;

  @override
  String toString() {
    return 'PoolUpdate{ id: $id, from: $from, name: $name, poolId: $poolId, ticker: $ticker, time: $time, to: $to, type: $type, retiring_epoch: $retiring_epoch,}';
  }

  PoolUpdate copyWith({
    String? id,
    String? from,
    String? name,
    String? poolId,
    String? ticker,
    int? time,
    String? to,
    String? type,
    String? retiring_epoch,
  }) {
    return PoolUpdate(
      id: id ?? this.id,
      from: from ?? this.from,
      name: name ?? this.name,
      poolId: poolId ?? this.poolId,
      ticker: ticker ?? this.ticker,
      time: time ?? this.time,
      to: to ?? this.to,
      type: type ?? this.type,
      retiring_epoch: retiring_epoch ?? this.retiring_epoch,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'from': from,
      'name': name,
      'poolId': poolId,
      'ticker': ticker,
      'time': time,
      'to': to,
      'type': type,
      'retiring_epoch': retiring_epoch,
    };
  }

  factory PoolUpdate.fromMap(Map<dynamic, dynamic> map) {
    return PoolUpdate(
      id: map['id'],
      from: map['from'],
      name: map['name'],
      poolId: map['poolId'],
      ticker: map['ticker'],
      time: map['time'],
      to: map['to'],
      type: map['type'],
      retiring_epoch: map['retiring_epoch'],
    );
  }

//</editor-fold>
}
