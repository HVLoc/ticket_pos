import 'dart:convert';

DashBoardRequest todayFromJson(String str) =>
    DashBoardRequest.fromJson(json.decode(str));

String todayToJson(DashBoardRequest data) => json.encode(data.toJson());

class DashBoardRequest {
  DashBoardRequest({
    required this.fromDate,
    required this.toDate,
  });

  String fromDate;
  String toDate;

  factory DashBoardRequest.fromJson(Map<String, dynamic> json) =>
      DashBoardRequest(
        fromDate: json["FromDate"],
        toDate: json["ToDate"],
      );

  Map<String, dynamic> toJson() => {
        "FromDate": fromDate,
        "ToDate": toDate,
      };
}
