import 'package:pegasus_tool/models/dl_model.dart';

class Delegator {
  Dl? dl;
  String? ph;
  List<dynamic>? ah;
  String? k;
  num? v;

//<editor-fold desc="Data Methods">

  Delegator({
    this.dl,
    this.ph,
    this.ah,
    this.k,
    this.v,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Delegator &&
          runtimeType == other.runtimeType &&
          dl == other.dl &&
          ph == other.ph &&
          ah == other.ah &&
          k == other.k &&
          v == other.v);

  @override
  int get hashCode =>
      dl.hashCode ^ ph.hashCode ^ ah.hashCode ^ k.hashCode ^ v.hashCode;

  @override
  String toString() {
    return 'Delegators{ dl: $dl, ph: $ph, ah: $ah, k: $k, v: $v,}';
  }

  Delegator copyWith({
    Dl? dl,
    String? ph,
    List<dynamic>? ah,
    String? k,
    num? v,
  }) {
    return Delegator(
      dl: dl ?? this.dl,
      ph: ph ?? this.ph,
      ah: ah ?? this.ah,
      k: k ?? this.k,
      v: v ?? this.v,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'dl': dl,
      'ph': ph,
      'ah': ah,
      'k': k,
      'v': v,
    };
  }

  factory Delegator.fromMap(Map<dynamic, dynamic> map) {
    return Delegator(
      dl: map['dl'] != null ? Dl.fromMap(map['dl']) : null,
      ph: map['ph'],
      ah: map['ah'],
      k: map['k'],
      v: map['v'],
    );
  }

//</editor-fold>
}
