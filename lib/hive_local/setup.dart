import 'package:hive/hive.dart';

part 'setup.g.dart';

@HiveType(typeId: 5)
class SetupModel extends HiveObject {
  //vé xe khách
  @HiveField(0)
  late bool startTime = false;

  @HiveField(1)
  late bool startDate = false;

  @HiveField(2)
  late bool licensePlates = false;

  @HiveField(3)
  late bool numberChair = false;

  @HiveField(4)
  late bool amountChair = false;
  //Vé xe buýt
  @HiveField(5)
  late bool busStation = false;

  @HiveField(6)
  late bool busStationGroup = false;

  @HiveField(7)
  late bool monthlyTicket = false;

// Vé gửi xe
  @HiveField(8)
  late bool licensePlatesParking = false;

//Vé trò chơi
  @HiveField(9)
  late bool comboTicket = false;

  @HiveField(10)
  late bool basicTicket = false;
//Cấu hình
  @HiveField(11)
  late bool configAccount = false;

  @HiveField(12)
  late bool configShift = false;

  @HiveField(13)
  late bool configSecondAccount = false;

  @HiveField(14)
  late bool configAddQRCode = false;

  SetupModel({
    this.startTime = false,
    this.startDate = false,
    this.licensePlates = false,
    this.numberChair = false,
    this.amountChair = false,
    this.busStation = false,
    this.busStationGroup = false,
    this.monthlyTicket = false,
    this.licensePlatesParking = false,
    this.comboTicket = false,
    this.basicTicket = false,
    this.configAccount = false,
    this.configShift = false,
    this.configSecondAccount = false,
    this.configAddQRCode = false,
  });
}
