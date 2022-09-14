import 'package:hive/hive.dart';

part 'account.g.dart';

@HiveType(typeId: 3)
class AccountModel {
  @HiveField(0)
  int id;

  @HiveField(1)
  String nameAccount;

  @HiveField(2)
  String userName;

  @HiveField(3)
  String password;

  @HiveField(4)
  int type;

  @HiveField(5)
  int? idShift;
  AccountModel({
    this.id = 0,
    this.nameAccount = '',
    this.userName = '',
    this.password = '',
    this.type = 1,
    this.idShift,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nameAccount': nameAccount,
      'userName': userName,
      'password': password,
      'type': type,
      'idShift':idShift,
    };
  }
  
  factory AccountModel.fromMap(Map<String, dynamic> map) {
    return AccountModel(
      id: map['id'] as int,
      nameAccount: map['nameAccount'] as String,
      userName: map['userName'] as String,
      password: map['password'] as String,
      type: map['type'] as int,
      idShift: map['shift'] as int?,
    );
  }
}
