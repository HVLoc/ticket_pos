import 'dart:convert';

DashBoardResponse countInvoiceEachMonthFromJson(String str) =>
    DashBoardResponse.fromJson(json.decode(str));

String countInvoiceEachMonthToJson(DashBoardResponse data) =>
    json.encode(data.toJson());

class DashBoardResponse {
  DashBoardResponse({
    required this.status,
    required this.message,
    required this.data,
    required this.errorCode,
  });

  int status;
  String message;
  List<DataDashBoard> data;
  int errorCode;

  factory DashBoardResponse.fromJson(Map<String, dynamic> json) =>
      DashBoardResponse(
        status: json["Status"],
        message: json["Message"],
        data: json["Data"] != null
            ? List<DataDashBoard>.from(
                json["Data"].map((x) => DataDashBoard.fromJson(x)))
            : [],
        errorCode: json["ErrorCode"],
      );

  Map<String, dynamic> toJson() => {
        "Status": status,
        "Message": message,
        "Data": List<dynamic>.from(data.map((x) => x.toJson())),
        "ErrorCode": errorCode,
      };
}

class DataDashBoard {
  DataDashBoard({
    required this.title,
    required this.value,
  });

  String title;
  int value;

  factory DataDashBoard.fromJson(Map<String, dynamic> json) => DataDashBoard(
        title: json["title"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "value": value,
      };
}
