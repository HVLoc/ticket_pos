import 'package:hive/hive.dart';

part 'introduction_setting_model.g.dart';

enum Realm { COACH, BUS, PARKING, GAMES, CUSTOM }

@HiveType(typeId: 6)
class Setting {
  Setting({
    this.isQRCode = false,
    this.title,
    this.fontSize = 22,
    this.isBoldText = false,
    this.isToUpper = false,
    this.alignText = 0,
    this.convertNumber,
  });
  @HiveField(0)
  String? title;
  @HiveField(1)
  int fontSize;
  @HiveField(2)
  //
  ///`alignText = 0` : căn trái
  ///`alignText = 1` : căn giữa
  ///`alignQText = 2` : căn phải
  int alignText;
  @HiveField(3)
  bool isQRCode;
  @HiveField(4)
  bool isBoldText;
  @HiveField(5)
  bool isToUpper;
  //dùng để phân biệt khi tách số và string
  @HiveField(6)
  bool? convertNumber;
  factory Setting.fromJson(Map<String, dynamic> json) => Setting(
        title: json['title'] as String,
        fontSize: json['fontSize'] as int,
        alignText: json['alignText'] as int,
        isQRCode: json['isQRCode'] as bool,
        isBoldText: json['isBoldText'] as bool,
        isToUpper: json['isToUpper'] as bool,
        convertNumber: json['convertNumber'],
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'fontSize': fontSize,
        'alignText': alignText,
        'isQRCode': isQRCode,
        'isBoldText': isBoldText,
        'isToUpper': isToUpper,
        'convertNumber': convertNumber,
      };
}
