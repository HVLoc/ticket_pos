// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shift.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ShiftModelAdapter extends TypeAdapter<ShiftModel> {
  @override
  final int typeId = 4;

  @override
  ShiftModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ShiftModel(
      id: fields[0] as int,
      nameShift: fields[1] as String,
      nameShiftLeader: fields[2] as String,
      startDate: fields[3] as String,
      endDate: fields[4] as String,
      note: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ShiftModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.nameShift)
      ..writeByte(2)
      ..write(obj.nameShiftLeader)
      ..writeByte(3)
      ..write(obj.startDate)
      ..writeByte(4)
      ..write(obj.endDate)
      ..writeByte(5)
      ..write(obj.note);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShiftModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
