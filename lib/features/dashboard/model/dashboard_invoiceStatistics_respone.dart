import 'dart:convert';

InvoiceStatistics invoiceStatisticsFromJson(String str) =>
    InvoiceStatistics.fromJson(json.decode(str));

String invoiceStatisticsToJson(InvoiceStatistics data) =>
    json.encode(data.toJson());

class InvoiceStatistics {
  InvoiceStatistics({
    required this.status,
    required this.message,
    required this.data,
    required this.errorCode,
  });

  int status;
  String message;
  IStatistics data;
  int errorCode;

  factory InvoiceStatistics.fromJson(Map<String, dynamic> json) =>
      InvoiceStatistics(
        status: json["Status"],
        message: json["Message"],
        data: IStatistics.fromJson(json["Data"]),
        errorCode: json["ErrorCode"],
      );

  Map<String, dynamic> toJson() => {
        "Status": status,
        "Message": message,
        "Data": data.toJson(),
        "ErrorCode": errorCode,
      };
}

class IStatistics {
  IStatistics({
    required this.totalUsed,
    required this.totalRemained,
    required this.totalAmount,
  });

  String totalUsed;
  String totalRemained;
  String totalAmount;

  factory IStatistics.fromJson(Map<String, dynamic> json) => IStatistics(
        totalUsed: json["TotalUsed"] ?? '0',
        totalRemained: json["TotalRemained"] ?? '0',
        totalAmount: json["TotalAmount"] ?? '0',
      );

  Map<String, dynamic> toJson() => {
        "TotalUsed": totalUsed,
        "TotalRemained": totalRemained,
        "TotalAmount": totalAmount,
      };
}
