import 'dart:convert';

InvoiceCreationRequest invoiceCreationRequestFromJson(String str) =>
    InvoiceCreationRequest.fromJson(json.decode(str));

String invoiceCreationRequestToJson(InvoiceCreationRequest data) =>
    json.encode(data.toJson());

class InvoiceCreationRequest {
  InvoiceCreationRequest({
    required this.xmlData,
    required this.pattern,
    required this.serial,
  });

  String xmlData;
  String pattern;
  String serial;

  factory InvoiceCreationRequest.fromJson(Map<String, dynamic> json) =>
      InvoiceCreationRequest(
        xmlData: json["XmlData"],
        pattern: json["Pattern"],
        serial: json["Serial"],
      );

  Map<String, dynamic> toJson() => {
        "XmlData": xmlData,
        "Pattern": pattern,
        "Serial": serial,
        // "updateCus": false
      };
}
