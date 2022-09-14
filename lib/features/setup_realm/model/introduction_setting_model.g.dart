// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'introduction_setting_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SettingAdapter extends TypeAdapter<Setting> {
  @override
  final int typeId = 6;

  @override
  Setting read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Setting(
      isQRCode: fields[3] as bool,
      title: fields[0] as String?,
      fontSize: fields[1] as int,
      isBoldText: fields[4] as bool,
      isToUpper: fields[5] as bool,
      alignText: fields[2] as int,
      convertNumber: fields[6] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, Setting obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.fontSize)
      ..writeByte(2)
      ..write(obj.alignText)
      ..writeByte(3)
      ..write(obj.isQRCode)
      ..writeByte(4)
      ..write(obj.isBoldText)
      ..writeByte(5)
      ..write(obj.isToUpper)
      ..writeByte(6)
      ..write(obj.convertNumber);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
