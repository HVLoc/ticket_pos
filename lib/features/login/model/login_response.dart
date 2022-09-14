import 'dart:convert';

import 'package:easy_invoice_qlhd/const/const.dart';

LoginResponse loginResponseFromJson(String str) =>
    LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  LoginResponse({
    required this.code,
    this.data,
  });

  int code;
  dynamic data;

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        code: json["Code"],
        data: json["Code"] == AppConst.codeSuccess
            ? DataResponse.fromJson(json["Data"])
            : json["Data"],
      );

  Map<String, dynamic> toJson() => {
        "Code": code,
        "Data": data.toJson(),
      };
}

class DataResponse {
  DataResponse({
    required this.accountName,
    this.fullName,
    required this.comId,
    required this.comName,
    required this.isSerialCert,
    required this.permission,
    // required this.businessType,
  });

  String accountName;
  dynamic fullName;
  int comId;
  String comName;
  List<int> permission;
  bool isSerialCert;
  // int businessType;

  factory DataResponse.fromJson(Map<String, dynamic> json) => DataResponse(
        accountName: json["AccountName"],
        fullName: json["FullName"],
        comId: json["ComId"],
        comName: json["ComName"],
        isSerialCert: json["IsSerialCert"],
        // businessType: json["BusinessType"],
        permission: json["Permission"] != null
            ? List<int>.from(json["Permission"])
            : [-1],
      );

  Map<String, dynamic> toJson() => {
        "AccountName": accountName,
        "FullName": fullName,
        "ComId": comId,
        "ComName": comName,
        "IsSerialCert": isSerialCert,
        // "BusinessType": businessType,
        // "Permission": permission,
      };
}
