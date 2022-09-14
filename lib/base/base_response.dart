import 'dart:convert';

import 'package:easy_invoice_qlhd/const/all_const.dart';

BaseResponse invoiceCreationResponseFromJson(String str) =>
    BaseResponse.fromJson(json.decode(str));

String invoiceCreationResponseToJson(BaseResponse data) =>
    json.encode(data.toJson());

class BaseResponse {
  BaseResponse({
    required this.status,
    required this.message,
    required this.data,
    required this.errorCode,
  });

  int status;
  String message;
  dynamic data;
  int? errorCode;

  factory BaseResponse.fromJson(Map<String, dynamic> json,
          {bool isInvoice = true}) =>
      BaseResponse(
          status: json["Status"],
          message: json["Message"],
          data: json["Data"] != null && isInvoice
              ? json["Status"] == AppConst.responseSuccess
                  ? Data.fromJson(json["Data"])
                  : Data.fromJsonError(json["Data"])
              : Data(keyInvoiceMsg: json["Message"]),
          errorCode: json['ErrorCode']);

  Map<String, dynamic> toJson() => {
        "Status": status,
        "Message": message,
        "Data": data.toJson(),
        "DataError": errorCode,
      };
}

class Data {
  Data({
    this.pattern,
    this.serial,
    this.invoices,
    this.keyInvoiceMsg,
  });

  String? pattern;
  String? serial;
  List<Invoice>? invoices;
  dynamic keyInvoiceMsg;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        pattern: json["Pattern"],
        serial: json["Serial"],
        invoices: json["Invoices"] != null
            ? List<Invoice>.from(
                json["Invoices"].map((x) => Invoice.fromJson(x)))
            : [],
      );
  factory Data.fromJsonError(Map<String, dynamic> json) => Data(
        pattern: json["Pattern"],
        serial: json["Serial"],
        keyInvoiceMsg: json["KeyInvoiceMsg"],
      );

  Map<String, dynamic> toJson() => {
        "Pattern": pattern,
        "Serial": serial,
        "Invoices": List<dynamic>.from(invoices!.map((x) => x.toJson())),
      };
}

class Invoice {
  Invoice({
    // required this.invoiceStatus,
    required this.ikey,
    required this.no,
    // required this.issueDate,
    // required this.buyer,
    // required this.amount,
    required this.pattern,
    this.linkView,
  });

  // int invoiceStatus;
  String pattern;
  // String serial;
  String no;
  // String lookupCode;
  String? ikey;
  // String arisingDate;
  // String issueDate;
  String? linkView;

  // String buyer;
  // double amount;

  factory Invoice.fromJson(Map<String, dynamic> json) => Invoice(
        // invoiceStatus: json["InvoiceStatus"],
        pattern: json["Pattern"],
        // serial: json["Serial"],
        no: json["No"],
        // lookupCode: json["LookupCode"],
        ikey: json["Ikey"],
        // arisingDate: json["ArisingDate"],
        // issueDate: json["IssueDate"],
        // buyer: json["Buyer"],
        // amount: json["Amount"],
        linkView: json["LinkView"],
      );

  Map<String, dynamic> toJson() => {
        // "InvoiceStatus": invoiceStatus,
        "Pattern": pattern,
        // "Serial": serial,
        "No": no,
        // "LookupCode": lookupCode,
        "Ikey": ikey,
        "linkView": linkView,
        // "ArisingDate": arisingDate,
        // "IssueDate": issueDate,
        // "Buyer": buyer,
        // "Amount": amount,
      };
}
