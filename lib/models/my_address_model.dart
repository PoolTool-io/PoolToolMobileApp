class MyAddress {
  String? address;
  String? nickname;
  String? first;
  String? second;

//<editor-fold desc="Data Methods">

  MyAddress({
    this.address,
    this.nickname,
    this.first,
    this.second,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MyAddress &&
          runtimeType == other.runtimeType &&
          address == other.address &&
          nickname == other.nickname &&
          first == other.first &&
          second == other.second);

  @override
  int get hashCode =>
      nickname.hashCode ^ address.hashCode ^ first.hashCode ^ second.hashCode;

  @override
  String toString() {
    return 'MyAddress{ address: $address, nickname: $nickname, first: $first, second: $second,}';
  }

  MyAddress copyWith({
    String? address,
    String? nickname,
    String? first,
    String? second,
  }) {
    return MyAddress(
      nickname: nickname ?? this.nickname,
      address: address ?? this.address,
      first: first ?? this.first,
      second: second ?? this.second,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'address': address,
      'nickname': nickname,
      'first': first,
      'second': second,
    };
  }

  factory MyAddress.fromMap(Map<String, dynamic> map) {
    if (map[map.keys.first] is bool) {
      return MyAddress(
        address: map.keys.first,
        nickname: '',
        first: '',
        second: '',
      );
    }
    return MyAddress(
      address: map.keys.first,
      nickname: map.values.first['nickname'],
      first: map.values.first['first'],
      second: map.values.first['second'],
    );
  }

//</editor-fold>
}
