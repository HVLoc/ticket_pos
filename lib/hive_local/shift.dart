import 'package:hive/hive.dart';

part 'shift.g.dart';

@HiveType(typeId: 4)
class ShiftModel {
  @HiveField(0)
  int id;

  @HiveField(1)
  String nameShift;

  @HiveField(2)
  String nameShiftLeader;

  @HiveField(3)
  String startDate;

  @HiveField(4)
  String endDate;

  @HiveField(5)
  String note;

  ShiftModel({
    this.id = 0,
    this.nameShift = '',
    this.nameShiftLeader = '',
    this.startDate = '',
    this.endDate = '',
    this.note = '',
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nameShift': nameShift,
      'nameShiftLeader': nameShiftLeader,
      'startDate': startDate,
      'endDate': endDate,
      'note': note,
    };
  }

  factory ShiftModel.fromMap(Map<String, dynamic> map) {
    return ShiftModel(
      id: map['id'] as int,
      nameShift: map['nameShift'] as String,
      nameShiftLeader: map['nameShiftLeader'] as String,
      startDate: map['startDate'] as String,
      endDate: map['endDate'] as String,
      note: map['note'] as String,
    );
  }
}
