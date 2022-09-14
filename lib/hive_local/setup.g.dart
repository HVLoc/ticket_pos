// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'setup.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SetupModelAdapter extends TypeAdapter<SetupModel> {
  @override
  final int typeId = 5;

  @override
  SetupModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SetupModel(
      startTime: fields[0] as bool,
      startDate: fields[1] as bool,
      licensePlates: fields[2] as bool,
      numberChair: fields[3] as bool,
      amountChair: fields[4] as bool,
      busStation: fields[5] as bool,
      busStationGroup: fields[6] as bool,
      monthlyTicket: fields[7] as bool,
      licensePlatesParking: fields[8] as bool,
      comboTicket: fields[9] as bool,
      basicTicket: fields[10] as bool,
      configAccount: fields[11] as bool,
      configShift: fields[12] as bool,
      configSecondAccount: fields[13] as bool,
      configAddQRCode: fields[14] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, SetupModel obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.startTime)
      ..writeByte(1)
      ..write(obj.startDate)
      ..writeByte(2)
      ..write(obj.licensePlates)
      ..writeByte(3)
      ..write(obj.numberChair)
      ..writeByte(4)
      ..write(obj.amountChair)
      ..writeByte(5)
      ..write(obj.busStation)
      ..writeByte(6)
      ..write(obj.busStationGroup)
      ..writeByte(7)
      ..write(obj.monthlyTicket)
      ..writeByte(8)
      ..write(obj.licensePlatesParking)
      ..writeByte(9)
      ..write(obj.comboTicket)
      ..writeByte(10)
      ..write(obj.basicTicket)
      ..writeByte(11)
      ..write(obj.configAccount)
      ..writeByte(12)
      ..write(obj.configShift)
      ..writeByte(13)
      ..write(obj.configSecondAccount)
      ..writeByte(14)
      ..write(obj.configAddQRCode);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SetupModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
