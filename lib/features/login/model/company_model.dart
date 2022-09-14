import 'dart:convert';

CompanyResponse companyResponseFromJson(String str) =>
    CompanyResponse.fromJson(json.decode(str));

String companyResponseToJson(CompanyResponse data) =>
    json.encode(data.toJson());

class CompanyResponse {
  CompanyResponse({
    required this.name,
    required this.taxCode,
    this.address,
    this.bankAccountName,
    this.bankName,
    this.bankNumber,
    this.email,
    this.fax,
    this.phone,
    this.representPerson,
    required this.publishDomain,
    required this.accountName,
    required this.portalLink,
    this.type,
    this.isActive,
    this.adminMail,
    this.serial,
    this.system,
    this.adminAccount,
  });

  String name;
  String taxCode;
  String? address;
  dynamic bankAccountName;
  dynamic bankName;
  dynamic bankNumber;
  dynamic email;
  String? fax;
  String? phone;
  dynamic representPerson;
  String publishDomain;
  String? accountName;
  String portalLink;
  int? type;
  bool? isActive;
  String? adminMail;
  dynamic serial;
  dynamic system;
  dynamic adminAccount;

  factory CompanyResponse.fromJson(Map<String, dynamic> json) =>
      CompanyResponse(
        name: json["Name"],
        taxCode: json["TaxCode"],
        address: json["Address"],
        bankAccountName: json["BankAccountName"],
        bankName: json["BankName"],
        bankNumber: json["BankNumber"],
        email: json["Email"],
        fax: json["Fax"],
        phone: json["Phone"],
        representPerson: json["RepresentPerson"],
        publishDomain: json["PublishDomain"],
        accountName: json["AccountName"],
        portalLink: json["PortalLink"],
        type: json["Type"],
        isActive: json["IsActive"],
        adminMail: json["AdminMail"],
        serial: json["Serial"],
        system: json["System"],
        adminAccount: json["AdminAccount"],
      );

  Map<String, dynamic> toJson() => {
        "Name": name,
        "TaxCode": taxCode,
        "Address": address,
        "BankAccountName": bankAccountName,
        "BankName": bankName,
        "BankNumber": bankNumber,
        "Email": email,
        "Fax": fax,
        "Phone": phone,
        "RepresentPerson": representPerson,
        "PublishDomain": publishDomain,
        "AccountName": accountName,
        "PortalLink": portalLink,
        "Type": type,
        "IsActive": isActive,
        "AdminMail": adminMail,
        "Serial": serial,
        "System": system,
        "AdminAccount": adminAccount,
      };
}
