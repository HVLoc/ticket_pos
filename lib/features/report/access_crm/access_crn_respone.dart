// To parse this JSON data, do
//
//     final accessCrmRespone = accessCrmResponeFromJson(jsonString);

import 'dart:convert';

AccessCrmRespone accessCrmResponeFromJson(String str) => AccessCrmRespone.fromJson(json.decode(str));

String accessCrmResponeToJson(AccessCrmRespone data) => json.encode(data.toJson());

class AccessCrmRespone {
    AccessCrmRespone({
        this.status,
        this.message,
        this.data,
        this.option,
    });

    int? status;
    String? message;
    AccessCrmResponeData? data;
    int? option;

    factory AccessCrmRespone.fromJson(Map<String, dynamic> json) => AccessCrmRespone(
        status: json["status"],
        message: json["message"],
        data: AccessCrmResponeData.fromJson(json["data"]),
        option: json["option"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data!.toJson(),
        "option": option,
    };
}

class AccessCrmResponeData {
    AccessCrmResponeData({
        this.id,
        this.account,
        this.token,
    });

    String? id;
    String? account;
    String? token;

    factory AccessCrmResponeData.fromJson(Map<String, dynamic> json) => AccessCrmResponeData(
        id: json["id"],
        account: json["account"],
        token: json["token"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "account": account,
        "token": token,
    };
}
