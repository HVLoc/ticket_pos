import 'dart:convert';

import 'package:get/get.dart';
import 'package:hive/hive.dart';

part 'invoice_detail_response.g.dart';

InvoiceDetailResponse invoiceDetailResponseFromJson(String str) =>
    InvoiceDetailResponse.fromJson(json.decode(str));

String invoiceDetailResponseToJson(InvoiceDetailResponse data) =>
    json.encode(data.toJson());

class InvoiceDetailResponse {
  InvoiceDetailResponse({
    required this.invoice,
  });

  InvoiceDetailModel invoice;

  factory InvoiceDetailResponse.fromJson(Map<String, dynamic> json) =>
      InvoiceDetailResponse(
        invoice: InvoiceDetailModel.fromJson(json["Invoice"]),
      );

  Map<String, dynamic> toJson() => {
        "Invoice": invoice.toJson(),
      };
}

@HiveType(typeId: 0)
class InvoiceDetailModel {
  InvoiceDetailModel({
    this.items = const [],
    this.email,
    this.emailCc,
    this.cusEmails,
    this.parentName,
    this.comFax,
    this.arisingDate,
    this.invoiceName = '',
    this.invoicePattern,
    this.serialNo,
    this.invoiceNo,
    this.paymentMethod,
    this.comName,
    this.comTaxCode,
    this.comAddress,
    this.comPhone,
    this.comBankNo,
    this.comBankName,
    this.cusCode,
    this.cusName,
    this.cusTaxCode,
    this.cusPhone,
    this.cusAddress,
    this.cusBankName,
    this.cusBankNo,
    this.total = 0,
    this.vatAmount = 0.0,
    this.amount = 0.0,
    this.checkDiscount = false, //chi dung o local
    this.discountVatRate = 1, //chi dung o local
    this.totalDiscount, //chi dung o local
    this.amountInWords,
    this.buyer,
    this.exchangeRate = '1',
    this.currencyUnit = 'VND',
    this.extra = '',
    this.vatRate,
    this.processInvNote,
    this.refID,
    this.status = -2,
    this.type,
    this.ikey,
    this.refIkey,
    this.tCTCheckStatus,
    this.taxAuthorityCode,
    this.tCTErrorMessage,
  });
  @HiveField(0)
  List<ProductItem> items;

  @HiveField(1)
  dynamic email;

  @HiveField(2)
  dynamic emailCc;

  @HiveField(3)
  dynamic cusEmails;

  @HiveField(4)
  dynamic parentName;

  @HiveField(5)
  String? comFax;

  @HiveField(6)
  String? arisingDate;

  @HiveField(7)
  String? invoiceName;

  @HiveField(8)
  String? invoicePattern;

  @HiveField(9)
  String? serialNo;

  @HiveField(10)
  double? invoiceNo;

  @HiveField(11)
  String? paymentMethod;

  @HiveField(12)
  String? comName;

  @HiveField(13)
  String? comTaxCode;

  @HiveField(14)
  String? comAddress;

  @HiveField(15)
  String? comPhone;

  @HiveField(16)
  dynamic comBankNo;

  @HiveField(17)
  dynamic comBankName;

  @HiveField(18)
  String? cusCode;

  @HiveField(19)
  String? cusName;

  @HiveField(20)
  dynamic cusTaxCode;

  @HiveField(21)
  dynamic cusPhone;

  @HiveField(22)
  String? cusAddress;

  @HiveField(23)
  dynamic cusBankName;

  @HiveField(24)
  dynamic cusBankNo;

  @HiveField(25)
  double total;

  @HiveField(26)
  double vatAmount;

  @HiveField(27)
  double amount;

  @HiveField(28)
  String? amountInWords;

  @HiveField(29)
  String? buyer;

  @HiveField(30)
  String? exchangeRate;

  @HiveField(31)
  String? currencyUnit;

  @HiveField(32)
  String? extra;

  @HiveField(33)
  int? vatRate;

  @HiveField(34)
  bool checkDiscount = false; //chi dung o local

  @HiveField(35)
  double discountVatRate = 0; //chi dung o local

  @HiveField(36)
  double? totalDiscount; //chi dung o local

  @HiveField(37)
  String? processInvNote;

  @HiveField(38)
  int? refID;

  @HiveField(39)
  int? status;

  @HiveField(40)
  int? type;

  @HiveField(41)
  String? ikey;

  @HiveField(42)
  String? refIkey;

  @HiveField(43)
  int? tCTCheckStatus;

  @HiveField(44)
  String? taxAuthorityCode;

  @HiveField(45)
  String? tCTErrorMessage;

  @HiveField(46)
  int? accountIdPos;

  @HiveField(47)
  String? timePos;

  @HiveField(48)
  int? shiftId;

  @HiveField(49)
  String? xmlInv;

  factory InvoiceDetailModel.fromJson(Map<String, dynamic> json) =>
      InvoiceDetailModel(
        items: json["Items"] != null
            ? List<ProductItem>.from(
                json["Items"].map((x) => ProductItem.fromJson(x)))
            : [],
        email: json["Email"],
        emailCc: json["EmailCC"],
        cusEmails: json["CusEmails"],
        parentName: json["ParentName"],
        comFax: json["ComFax"],
        arisingDate: json["ArisingDate"],
        invoiceName: json["InvoiceName"],
        invoicePattern: json["InvoicePattern"],
        serialNo: json["SerialNo"],
        invoiceNo: json["InvoiceNo"],
        paymentMethod: json["PaymentMethod"],
        comName: json["ComName"],
        comTaxCode: json["ComTaxCode"],
        comAddress: json["ComAddress"],
        comPhone: json["ComPhone"],
        comBankNo: json["ComBankNo"],
        comBankName: json["ComBankName"],
        cusCode: json["CusCode"],
        cusName: json["CusName"],
        cusTaxCode: json["CusTaxCode"],
        cusPhone: json["CusPhone"],
        cusAddress: json["CusAddress"],
        cusBankName: json["CusBankName"],
        cusBankNo: json["CusBankNo"],
        total: json["Total"].toDouble(),
        vatAmount: json["VATAmount"],
        amount: json["Amount"].toDouble(),
        amountInWords: json["AmountInWords"],
        buyer: json["Buyer"],
        vatRate: json["VATRate"].toInt(),
        processInvNote: json["ProcessInvNote"],
        refID: json["RefID"].toInt(),
        status: json["Status"],
        type: json["Type"],
        ikey: json["Ikey"],
        refIkey: json["RefIkey"],
        exchangeRate: json['exchangeRate'],
        extra: json['Extra'],
        currencyUnit: json["currencyUnit"],
        tCTCheckStatus: json["TCTCheckStatus"],
        taxAuthorityCode: json["TaxAuthorityCode"],
        tCTErrorMessage: json["TCTErrorMessage"],
        checkDiscount: json["CheckDiscount"] ?? false,
        discountVatRate: json["DiscountVatRate"] ?? 0,
        totalDiscount: json["TotalDiscount"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "Items": List<dynamic>.from(items.map((x) => x.toJsonProd())),
        "Email": email,
        "EmailCC": emailCc,
        "CusEmails": cusEmails,
        "ParentName": parentName,
        "ComFax": comFax,
        "ArisingDate": arisingDate,
        "InvoiceName": invoiceName,
        "InvoicePattern": invoicePattern,
        "SerialNo": serialNo,
        "InvoiceNo": invoiceNo,
        "PaymentMethod": paymentMethod,
        "ComName": comName,
        "ComTaxCode": comTaxCode,
        "ComAddress": comAddress,
        "ComPhone": comPhone,
        "ComBankNo": comBankNo,
        "ComBankName": comBankName,
        "CusCode": cusCode,
        "CusName": cusName,
        "CusTaxCode": cusTaxCode,
        "CusPhone": cusPhone,
        "CusAddress": cusAddress,
        "CusBankName": cusBankName,
        "CusBankNo": cusBankNo,
        "Total": total,
        "VATAmount": vatAmount,
        "Amount": amount,
        "AmountInWords": amountInWords,
        "Buyer": buyer,
        "VATRate": vatRate,
        "ProcessInvNote": processInvNote,
        "RefID": refID,
        "Ikey": ikey,
        "Status": status,
        "Type": type,
        "RefIkey": refIkey,
        "TCTCheckStatus": tCTCheckStatus,
        "TCTErrorMessage": tCTErrorMessage,
        "TaxAuthorityCode": taxAuthorityCode,
        "Extra": extra,
        "CheckDiscount": checkDiscount,
        "DiscountVatRate": discountVatRate,
        "TotalDiscount": totalDiscount
      };
  factory InvoiceDetailModel.fromJsonMoney(Map<String, dynamic> json) =>
      InvoiceDetailModel(
        total: json["Total"].toDouble(),
        vatAmount: json["VATAmount"],
        amount: json["Amount"].toDouble(),
        arisingDate: '',
        ikey: '',
        invoicePattern: '',
        serialNo: '',
        totalDiscount: json["TotalDiscount"],
      );

  Map<String, dynamic> toJsonMoney() => {
        "Total": total,
        "VATAmount": vatAmount,
        "Amount": amount,
        "TotalDiscount": totalDiscount,
      };
}

@HiveType(typeId: 1)
class ProductItem {
  ProductItem({
    this.id,
    this.invId,
    this.name,
    this.price = 0,
    required this.quantity,
    this.unit = '',
    this.vatRate,
    this.vatAmount = 0.0,
    this.amount = 0.0,
    this.discount,
    this.discountAmount,
    this.prodType,
    this.isSum = false,
    this.code,
    this.total,
    this.extra,
    this.listExtraValue = const [],
    this.desc = '',
    this.feature = 1,
  });

  @HiveField(0)
  int? id;

  @HiveField(1)
  int? invId;

  @HiveField(2)
  String? name;

  @HiveField(3)
  double? price;

  @HiveField(4)
  String? unit;

  @HiveField(5)
  int? vatRate;

  @HiveField(6)
  double? vatAmount;

  @HiveField(7)
  double? amount = 0.0;

  @HiveField(8)
  double? discount = 0.0;

  @HiveField(9)
  double? discountAmount = 0.0;

  @HiveField(10)
  double? prodType;

  /// isSum:true không tính tiền. mặc định false
  @HiveField(11)
  bool isSum = false;

  @HiveField(12)
  String? code;

  @HiveField(13)
  double? total;

  @HiveField(14)
  dynamic extra;

  @HiveField(15)
  List<String> listExtraValue; // chi dung o local

  @HiveField(16)
  double quantity = 0;

  RxBool isSelected = false.obs;

  @HiveField(17)
  String? desc;

  /// Sử dụng local: tính chất hàng hóa
  /// 1 Hàng hóa, dịch vụ
  /// 2: Khuyến mãi
  /// 3: Chiết khấu
  /// 4: Ghi chú
  @HiveField(18)
  int feature = 1;

  @HiveField(19)
  String? timeStart;

  RxDouble quantityLocal = 1.0.obs;

  @HiveField(20)
  String? licensePlates;

  factory ProductItem.fromJson(Map<String, dynamic> json) => ProductItem(
        id: json["id"]?.toInt() ?? json["Id"]?.toInt(),
        invId: json["InvID"],
        name: json["ProdName"] ?? json["Name"],
        price: json["ProdPrice"] ?? json["Price"],
        quantity: json["ProdQuantity"] != null ? json["ProdQuantity"] : 0.0,
        unit: json["ProdUnit"] ?? '${json["Unit"]}',
        vatRate:
            json["VATRate"] != null ? json["VATRate"].toInt() : json["VatRate"],
        vatAmount: json["VATAmount"],
        amount: json["Amount"],
        discount: json["Discount"],
        discountAmount: json["DiscountAmount"],
        prodType: json["ProdType"],
        isSum: json["IsSum"] ?? false,
        code: json["Code"],
        total: json["Total"],
        extra: json["Extra"],
        desc: json["Description"],
        feature: json["Feature"] ?? 1,
      )..quantityLocal = json["ProdQuantity"] != null
          ? RxDouble(json["ProdQuantity"])
          : 0.0.obs;

  Map<String, dynamic> toJson() => {
        "Id": id,
        "InvID": invId,
        "Name": name,
        "Price": price,
        "Quantity": quantity,
        "Unit": unit,
        "VATRate": vatRate,
        "VATAmount": vatAmount,
        "Amount": amount,
        "Discount": discount,
        "DiscountAmount": discountAmount,
        "ProdType": prodType,
        "IsSum": isSum,
        "Code": code,
        "Total": total,
        "Extra": extra,
        "Description": desc,
      };

  Map<String, dynamic> toJsonProd() => {
        "Id": id,
        "InvID": invId,
        "ProdName": name,
        "ProdPrice": price,
        "ProdQuantity": quantity,
        "ProdUnit": unit,
        "VATRate": vatRate,
        "VATAmount": vatAmount,
        "Amount": amount,
        "Discount": discount,
        "DiscountAmount": discountAmount,
        "ProdType": prodType,
        "IsSum": isSum,
        "Code": code,
        "Total": total,
        "Extra": extra,
        "Description": desc,
        "Feature": feature
      };
}
