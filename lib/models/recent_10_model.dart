class Recent10 {
  String? epoch;
  String? hash;

//<editor-fold desc="Data Methods">

  Recent10({
    this.epoch,
    this.hash,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Recent10 &&
          runtimeType == other.runtimeType &&
          epoch == other.epoch &&
          hash == other.hash);

  @override
  int get hashCode => epoch.hashCode ^ hash.hashCode;

  @override
  String toString() {
    return 'Recent10{ epoch: $epoch, hash: $hash,}';
  }

  Recent10 copyWith({
    String? epoch,
    String? hash,
  }) {
    return Recent10(
      epoch: epoch ?? this.epoch,
      hash: hash ?? this.hash,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'epoch': epoch,
      'hash': hash,
    };
  }

  factory Recent10.fromMap(Map<dynamic, dynamic> map) {
    return Recent10(
      epoch: map['epoch'],
      hash: map['hash'],
    );
  }

//</editor-fold>
}
