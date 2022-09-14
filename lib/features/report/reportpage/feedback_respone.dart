// To parse this JSON data, do
//
//     final accessCrmRespone = accessCrmResponeFromJson(jsonString);

import 'dart:convert';

FeedbackRespone accessCrmResponeFromJson(String str) => FeedbackRespone.fromJson(json.decode(str));

String accessCrmResponeToJson(FeedbackRespone data) => json.encode(data.toJson());

class FeedbackRespone {
    FeedbackRespone({
        this.status,
        this.message,
        this.data,
        this.option,
    });

    int? status;
    String? message;
    dynamic data;
    dynamic option;

    factory FeedbackRespone.fromJson(Map<String, dynamic> json) => FeedbackRespone(
        status: json["status"],
        message: json["message"],
        data: json["data"],
        option: json["option"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data,
        "option": option,
    };
}
