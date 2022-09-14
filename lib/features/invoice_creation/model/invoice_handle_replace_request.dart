import 'dart:convert';

import 'package:easy_invoice_qlhd/features/invoice_creation/invoice_creation.dart';

InvoiceHandleReplaceRequest invoiceHanldeReplaceRequestFromJson(String str) =>
    InvoiceHandleReplaceRequest.fromJson(json.decode(str));

String invoiceHanldeReplaceRequestToJson(InvoiceHandleReplaceRequest data) =>
    json.encode(data.toJson());

class InvoiceHandleReplaceRequest {
  String ikey;
  InvoiceCreationRequest invoiceCreationRequest;
  String? profileCode;

  InvoiceHandleReplaceRequest({
    required this.ikey,
    required this.invoiceCreationRequest,
    this.profileCode
  });

  factory InvoiceHandleReplaceRequest.fromJson(Map<String, dynamic> json) =>
      InvoiceHandleReplaceRequest(
          ikey: json["Ikey"],
          invoiceCreationRequest: InvoiceCreationRequest.fromJson(json),
          profileCode: json['ProfileCode']
          );

  Map<String, dynamic> toJson() => {
        "XmlData": invoiceCreationRequest.xmlData,
        "Ikey": ikey,
        "Pattern": invoiceCreationRequest.pattern,
        "Serial": invoiceCreationRequest.serial,
        "ProfileCode": profileCode,
      };
}
