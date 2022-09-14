import 'dart:convert';

DeleteResponse deleteResponseFromJson(String str) =>
    DeleteResponse.fromJson(json.decode(str));

String deleteResponseToJson(DeleteResponse data) => json.encode(data.toJson());

class DeleteResponse {
  DeleteResponse({
    required this.status,
    required this.message,
    required this.errorCode,
  });

  int status;
  String message;
  int errorCode;

  factory DeleteResponse.fromJson(Map<String, dynamic> json) => DeleteResponse(
        status: json["Status"],
        message: json["Message"],
        errorCode: json["ErrorCode"],
      );

  Map<String, dynamic> toJson() => {
        "Status": status,
        "Message": message,
        "ErrorCode": errorCode,
      };
}
