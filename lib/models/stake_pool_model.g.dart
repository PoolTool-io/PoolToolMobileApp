// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stake_pool_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StakePoolAdapter extends TypeAdapter<StakePool> {
  @override
  final int typeId = 1;

  @override
  StakePool read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StakePool(
      ap: fields[0] as num?,
      b: fields[1] as num?,
      c: fields[2] as dynamic,
      d: fields[3] as bool?,
      eb: fields[4] as num?,
      f: fields[5] as num?,
      ff: fields[6] as num?,
      fm: fields[7] as num?,
      fp: fields[8] as num?,
      g: fields[9] as String?,
      ggg: fields[10] as String?,
      i: fields[11] as bool?,
      id: fields[12] as String?,
      l: fields[13] as num?,
      lros: fields[14] as num?,
      ls: fields[15] as num?,
      m: fields[16] as num?,
      n: fields[17] as String?,
      o: fields[18] as num?,
      oo: fields[19] as num?,
      p: fields[20] as num?,
      r: fields[21] as num?,
      s: fields[22] as num?,
      sr: fields[23] as num?,
      t: fields[24] as String?,
      tr: fields[25] as num?,
      x: fields[26] as bool?,
      xx: fields[27] as bool?,
      zl: fields[28] as num?,
      z: fields[29] as dynamic,
      ez: fields[30] as dynamic,
      retiredEpoch: fields[31] as num?,
      forker: fields[32] as bool?,
      name: fields[33] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, StakePool obj) {
    writer
      ..writeByte(34)
      ..writeByte(0)
      ..write(obj.ap)
      ..writeByte(1)
      ..write(obj.b)
      ..writeByte(2)
      ..write(obj.c)
      ..writeByte(3)
      ..write(obj.d)
      ..writeByte(4)
      ..write(obj.eb)
      ..writeByte(5)
      ..write(obj.f)
      ..writeByte(6)
      ..write(obj.ff)
      ..writeByte(7)
      ..write(obj.fm)
      ..writeByte(8)
      ..write(obj.fp)
      ..writeByte(9)
      ..write(obj.g)
      ..writeByte(10)
      ..write(obj.ggg)
      ..writeByte(11)
      ..write(obj.i)
      ..writeByte(12)
      ..write(obj.id)
      ..writeByte(13)
      ..write(obj.l)
      ..writeByte(14)
      ..write(obj.lros)
      ..writeByte(15)
      ..write(obj.ls)
      ..writeByte(16)
      ..write(obj.m)
      ..writeByte(17)
      ..write(obj.n)
      ..writeByte(18)
      ..write(obj.o)
      ..writeByte(19)
      ..write(obj.oo)
      ..writeByte(20)
      ..write(obj.p)
      ..writeByte(21)
      ..write(obj.r)
      ..writeByte(22)
      ..write(obj.s)
      ..writeByte(23)
      ..write(obj.sr)
      ..writeByte(24)
      ..write(obj.t)
      ..writeByte(25)
      ..write(obj.tr)
      ..writeByte(26)
      ..write(obj.x)
      ..writeByte(27)
      ..write(obj.xx)
      ..writeByte(28)
      ..write(obj.zl)
      ..writeByte(29)
      ..write(obj.z)
      ..writeByte(30)
      ..write(obj.ez)
      ..writeByte(31)
      ..write(obj.retiredEpoch)
      ..writeByte(32)
      ..write(obj.forker)
      ..writeByte(33)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StakePoolAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
