import 'dart:convert';

ViewInvoiceResponse viewInvoiceResponseFromJson(String str) =>
    ViewInvoiceResponse.fromJson(json.decode(str));

String viewInvoiceResponseToJson(ViewInvoiceResponse data) =>
    json.encode(data.toJson());

class ViewInvoiceResponse {
  ViewInvoiceResponse({
    required this.status,
    required this.message,
    required this.data,
    required this.errorCode,
  });

  int status;
  String message;
  Data data;
  int errorCode;

  factory ViewInvoiceResponse.fromJson(Map<String, dynamic> json) =>
      ViewInvoiceResponse(
        status: json["Status"],
        message: json["Message"],
        data: Data.fromJson(json["Data"]),
        errorCode: json["ErrorCode"],
      );

  Map<String, dynamic> toJson() => {
        "Status": status,
        "Message": message,
        "Data": data.toJson(),
        "ErrorCode": errorCode,
      };
}

class Data {
  Data({
    required this.html,
    // this.invoiceStatus,
    // this.buyer,
    // this.taxAmount,
    // this.publishedBy,
    // this.pattern,
    // this.serial,
    // this.no,
    // this.ikey,
    // this.arisingDate,
    // this.issueDate,
    // this.customerName,
    // this.customerAddress,
    // this.customerCode,
    // this.customerTaxCode,
    // this.total,
    // this.amount,
    // this.lookupCode,
    // this.linkView,
  });

  String html;
  // int invoiceStatus;
  // String buyer;
  // double taxAmount;
  // String publishedBy;
  // String pattern;
  // String serial;
  // String no;
  // String ikey;
  // String arisingDate;
  // String issueDate;
  // String customerName;
  // String customerAddress;
  // String customerCode;
  // String customerTaxCode;
  // int total;
  // int amount;
  // String lookupCode;
  // dynamic linkView;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        html: json["Html"],
        // invoiceStatus: json["InvoiceStatus"],
        // buyer: json["Buyer"],
        // taxAmount: json["TaxAmount"],
        // publishedBy: json["PublishedBy"],
        // pattern: json["Pattern"],
        // serial: json["Serial"],
        // no: json["No"],
        // ikey: json["Ikey"],
        // arisingDate: json["ArisingDate"],
        // issueDate: json["IssueDate"],
        // customerName: json["CustomerName"],
        // customerAddress: json["CustomerAddress"],
        // customerCode: json["CustomerCode"],
        // customerTaxCode: json["CustomerTaxCode"],
        // total: json["Total"],
        // amount: json["Amount"],
        // lookupCode: json["LookupCode"],
        // linkView: json["LinkView"],
      );

  Map<String, dynamic> toJson() => {
        "Html": html,
        // "InvoiceStatus": invoiceStatus,
        // "Buyer": buyer,
        // "TaxAmount": taxAmount,
        // "PublishedBy": publishedBy,
        // "Pattern": pattern,
        // "Serial": serial,
        // "No": no,
        // "Ikey": ikey,
        // "ArisingDate": arisingDate,
        // "IssueDate": issueDate,
        // "CustomerName": customerName,
        // "CustomerAddress": customerAddress,
        // "CustomerCode": customerCode,
        // "CustomerTaxCode": customerTaxCode,
        // "Total": total,
        // "Amount": amount,
        // "LookupCode": lookupCode,
        // "LinkView": linkView,
      };
}
