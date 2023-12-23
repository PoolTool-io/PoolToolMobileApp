import 'package:hive/hive.dart';

part 'stake_pool_model.g.dart';

@HiveType(typeId: 1)
class StakePool {
  @HiveField(0)
  num? ap;
  @HiveField(1)
  num? b;
  @HiveField(2)
  dynamic c;
  @HiveField(3)
  bool? d;
  @HiveField(4)
  num? eb;
  @HiveField(5)
  num? f;
  @HiveField(6)
  num? ff;
  @HiveField(7)
  num? fm;
  @HiveField(8)
  num? fp;
  @HiveField(9)
  String? g;
  @HiveField(10)
  String? ggg;
  @HiveField(11)
  bool? i;
  @HiveField(12)
  String? id;
  @HiveField(13)
  num? l;
  @HiveField(14)
  num? lros;
  @HiveField(15)
  num? ls;
  @HiveField(16)
  num? m;
  @HiveField(17)
  String? n;
  @HiveField(18)
  num? o;
  @HiveField(19)
  num? oo;
  @HiveField(20)
  num? p;
  @HiveField(21)
  num? r;
  @HiveField(22)
  num? s;
  @HiveField(23)
  num? sr;
  @HiveField(24)
  String? t;
  @HiveField(25)
  num? tr;
  @HiveField(26)
  bool? x;
  @HiveField(27)
  bool? xx;
  @HiveField(28)
  num? zl;
  @HiveField(29)
  dynamic z;
  @HiveField(30)
  dynamic ez;
  @HiveField(31)
  num? retiredEpoch;
  @HiveField(32)
  bool? forker;
  @HiveField(33)
  String? name;

  String displayName() {
    return t ?? name ?? n ?? id ?? '';
  }

//<editor-fold desc="Data Methods">
  StakePool({
    this.ap,
    this.b,
    required this.c,
    this.d,
    this.eb,
    this.f,
    this.ff,
    this.fm,
    this.fp,
    this.g,
    this.ggg,
    this.i,
    this.id,
    this.l,
    this.lros,
    this.ls,
    this.m,
    this.n,
    this.o,
    this.oo,
    this.p,
    this.r,
    this.s,
    this.sr,
    this.t,
    this.tr,
    this.x,
    this.xx,
    this.zl,
    required this.z,
    required this.ez,
    this.retiredEpoch,
    this.forker,
    this.name,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StakePool &&
          runtimeType == other.runtimeType &&
          ap == other.ap &&
          b == other.b &&
          c == other.c &&
          d == other.d &&
          eb == other.eb &&
          f == other.f &&
          ff == other.ff &&
          fm == other.fm &&
          fp == other.fp &&
          g == other.g &&
          ggg == other.ggg &&
          i == other.i &&
          id == other.id &&
          l == other.l &&
          lros == other.lros &&
          ls == other.ls &&
          m == other.m &&
          n == other.n &&
          o == other.o &&
          oo == other.oo &&
          p == other.p &&
          r == other.r &&
          s == other.s &&
          sr == other.sr &&
          t == other.t &&
          tr == other.tr &&
          x == other.x &&
          xx == other.xx &&
          zl == other.zl &&
          z == other.z &&
          ez == other.ez &&
          retiredEpoch == other.retiredEpoch &&
          forker == other.forker &&
          name == other.name);

  @override
  int get hashCode =>
      ap.hashCode ^
      b.hashCode ^
      c.hashCode ^
      d.hashCode ^
      eb.hashCode ^
      f.hashCode ^
      ff.hashCode ^
      fm.hashCode ^
      fp.hashCode ^
      g.hashCode ^
      ggg.hashCode ^
      i.hashCode ^
      id.hashCode ^
      l.hashCode ^
      lros.hashCode ^
      ls.hashCode ^
      m.hashCode ^
      n.hashCode ^
      o.hashCode ^
      oo.hashCode ^
      p.hashCode ^
      r.hashCode ^
      s.hashCode ^
      sr.hashCode ^
      t.hashCode ^
      tr.hashCode ^
      x.hashCode ^
      xx.hashCode ^
      zl.hashCode ^
      z.hashCode ^
      ez.hashCode ^
      retiredEpoch.hashCode ^
      forker.hashCode ^
      name.hashCode;

  @override
  String toString() {
    return 'StakePool{ ap: $ap, b: $b, c: $c, d: $d, eb: $eb, f: $f, ff: $ff, fm: $fm, fp: $fp, g: $g, ggg: $ggg, i: $i, id: $id, l: $l, lros: $lros, ls: $ls, m: $m, n: $n, o: $o, oo: $oo, p: $p, r: $r, s: $s, sr: $sr, t: $t, tr: $tr, x: $x, xx: $xx, zl: $zl, z: $z, ez: $ez, retiredEpoch: $retiredEpoch, forker: $forker, name: $name}';
  }

  StakePool copyWith({
    num? ap,
    num? b,
    dynamic c,
    bool? d,
    num? eb,
    num? f,
    num? ff,
    num? fm,
    num? fp,
    String? g,
    String? ggg,
    bool? i,
    String? id,
    num? l,
    num? lros,
    num? ls,
    num? m,
    String? n,
    num? o,
    num? oo,
    num? p,
    num? r,
    num? s,
    num? sr,
    String? t,
    num? tr,
    bool? x,
    bool? xx,
    num? zl,
    dynamic z,
    dynamic ez,
    num? retiredEpoch,
    bool? forker,
    String? name,
  }) {
    return StakePool(
      ap: ap ?? this.ap,
      b: b ?? this.b,
      c: c ?? this.c,
      d: d ?? this.d,
      eb: eb ?? this.eb,
      f: f ?? this.f,
      ff: ff ?? this.ff,
      fm: fm ?? this.fm,
      fp: fp ?? this.fp,
      g: g ?? this.g,
      ggg: ggg ?? this.ggg,
      i: i ?? this.i,
      id: id ?? this.id,
      l: l ?? this.l,
      lros: lros ?? this.lros,
      ls: ls ?? this.ls,
      m: m ?? this.m,
      n: n ?? this.n,
      o: o ?? this.o,
      oo: oo ?? this.oo,
      p: p ?? this.p,
      r: r ?? this.r,
      s: s ?? this.s,
      sr: sr ?? this.sr,
      t: t ?? this.t,
      tr: tr ?? this.tr,
      x: x ?? this.x,
      xx: xx ?? this.xx,
      zl: zl ?? this.zl,
      z: z ?? this.z,
      ez: ez ?? this.ez,
      retiredEpoch: retiredEpoch ?? this.retiredEpoch,
      forker: forker ?? this.forker,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ap': ap,
      'b': b,
      'c': c,
      'd': d,
      'eb': eb,
      'f': f,
      'ff': ff,
      'fm': fm,
      'fp': fp,
      'g': g,
      'ggg': ggg,
      'i': i,
      'id': id,
      'l': l,
      'lros': lros,
      'ls': ls,
      'm': m,
      'n': n,
      'o': o,
      'oo': oo,
      'p': p,
      'r': r,
      's': s,
      'sr': sr,
      't': t,
      'tr': tr,
      'x': x,
      'xx': xx,
      'zl': zl,
      'z': z,
      'ez': ez,
      'retiredEpoch': retiredEpoch,
      'forker': forker,
      'name': name,
    };
  }

  factory StakePool.fromMap(Map<dynamic, dynamic> map) {
    return StakePool(
      ap: map['ap'],
      b: map['b'],
      c: map['c'],
      d: map['d'],
      eb: map['eb'],
      f: map['f'],
      ff: map['ff'],
      fm: map['fm'],
      fp: map['fp'],
      g: map['g'],
      ggg: map['ggg'],
      i: map['i'],
      id: map['id'],
      l: map['l'],
      lros: map['lros'],
      ls: map['ls'],
      m: map['m'],
      n: map['n'],
      o: map['o'],
      oo: map['oo'],
      p: map['p'],
      r: map['r'],
      s: map['s'],
      sr: map['sr'],
      t: map['t'],
      tr: map['tr'],
      x: map['x'],
      xx: map['xx'],
      zl: map['zl'],
      z: map['z'],
      ez: map['ez'],
      retiredEpoch: map['retiredEpoch'],
      forker: map['forker'],
      name: map['name'],
    );
  }

//</editor-fold>
}
