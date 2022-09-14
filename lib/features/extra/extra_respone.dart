// To parse this JSON data, do
//
//     final extraInfo = extraInfoFromJson(jsonString);

import 'dart:convert';

import 'package:get/get.dart';

ExtraInfoRespone extraInfoFromJson(String str) =>
    ExtraInfoRespone.fromJson(json.decode(str));

String extraInfoToJson(ExtraInfoRespone data) => json.encode(data.toJson());

class ExtraInfoRespone {
  ExtraInfoRespone({
    this.status,
    this.message,
    this.data,
    this.errorCode,
  });

  int? status;
  String? message;
  List<Extra>? data;
  int? errorCode;

  factory ExtraInfoRespone.fromJson(Map<String, dynamic> json) =>
      ExtraInfoRespone(
        status: json["Status"],
        message: json["Message"],
        data: json["Data"] != null
            ? List<Extra>.from(json["Data"].map((x) => Extra.fromJson(x)))
            : [],
        errorCode: json["ErrorCode"],
      );

  Map<String, dynamic> toJson() => {
        "Status": status,
        "Message": message,
        "Data": List<dynamic>.from(data!.map((x) => x.toJson())),
        "ErrorCode": errorCode,
      };
}

class Extra {
  Extra({
    this.pattern,
    this.invExtra,
    this.proExtra,
  });

  String? pattern;
  List<ExtraInfo>? invExtra;
  List<ExtraInfo>? proExtra;

  factory Extra.fromJson(Map<String, dynamic> json) => Extra(
        pattern: json["Pattern"],
        invExtra: json["InvExtra"] != null && json["InvExtra"].isNotEmpty
            ? List<ExtraInfo>.from(jsonDecode(json["InvExtra"])
                    .map((x) => ExtraInfo.fromJson(x)) ??
                [])
            : [],
        proExtra: json["ProExtra"] != null && json["ProExtra"].isNotEmpty
            ? List<ExtraInfo>.from(jsonDecode(json["ProExtra"])
                    .map((x) => ExtraInfo.fromJson(x)) ??
                [])
            : [],
      );

  Map<String, dynamic> toJson() => {
        "Pattern": pattern,
        "InvExtra": List<dynamic>.from(invExtra!.map((x) => x.toJson())),
        "ProExtra": List<dynamic>.from(proExtra!.map((x) => x.toJson())),
      };
}

class ExtraInfo {
  String label;
  String name;
  bool? visibility;
  RxString? extraValue = ''.obs; //chi dung o local

  ExtraInfo({
    required this.label,
    required this.name,
    this.visibility = true,
  });
  factory ExtraInfo.fromJson(Map<String, dynamic> json) => ExtraInfo(
        label: json["Label"],
        name: json["Name"],
        visibility: json["Visibility"],
      );

  Map<String, dynamic> toJson() => {
        "Label": label,
        "Name": name,
        "Visibility": visibility,
      };
}
