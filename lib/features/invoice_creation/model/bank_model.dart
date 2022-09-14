// To parse this JSON data, do
//
//     final bankModel = bankModelFromJson(jsonString);

import 'dart:convert';

BankModel bankModelFromJson(String str) => BankModel.fromJson(json.decode(str));

String bankModelToJson(BankModel data) => json.encode(data.toJson());

class BankModel {
    BankModel({
        this.code,
        this.desc,
        this.data,
    });

    String? code;
    String? desc;
    List<BankItemModel>? data;

    factory BankModel.fromJson(Map<String, dynamic> json) => BankModel(
        code: json["code"],
        desc: json["desc"],
        data: json["data"] != null
            ? List<BankItemModel>.from(json["data"].map((x) => BankItemModel.fromJson(x)))
            : [],
    );

    Map<String, dynamic> toJson() => {
        "code": code,
        "desc": desc,
        "data": List<BankItemModel>.from(data!.map((x) => x.toJson())),
    };
}

class BankItemModel {
    BankItemModel({
        this.id,
         this.name,
        this.code,
        this.bin,
        this.isTransfer,
        this.shortName,
        this.logo,
        this.support,
    });

    int? id;
    String? name;
    String? code;
    String? bin;
    int? isTransfer;
    String? shortName;
    String? logo;
    int? support;

    factory BankItemModel.fromJson(Map<String, dynamic> json) => BankItemModel(
        id: json["id"],
        name: json["name"],
        code: json["code"],
        bin: json["bin"],
        isTransfer: json["isTransfer"],
        shortName: json["short_name"],
        logo: json["logo"],
        support: json["support"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "code": code,
        "bin": bin,
        "isTransfer": isTransfer,
        "short_name": shortName,
        "logo": logo,
        "support": support,
    };
}
