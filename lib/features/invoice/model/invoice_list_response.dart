import 'dart:convert';

import 'package:get/get.dart';

InvoiceModel invoiceModelFromJson(String str) =>
    InvoiceModel.fromJson(json.decode(str));

String invoiceModelToJson(InvoiceModel data) => json.encode(data.toJson());

class InvoiceModel {
  InvoiceModel({
    required this.page,
    required this.pageSize,
    required this.totalRecords,
    required this.data,
  });

  int page;
  int pageSize;
  int totalRecords;
  List<InvoiceList> data;

  factory InvoiceModel.fromJson(Map<String, dynamic> json) => InvoiceModel(
        page: json["page"],
        pageSize: json["pageSize"],
        totalRecords: json["totalRecords"],
        data: json["data"] != null
            ? List<InvoiceList>.from(
                json["data"].map((x) => InvoiceList.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "page": page,
        "pageSize": pageSize,
        "totalRecords": totalRecords,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class InvoiceList {
  InvoiceList({
    this.id,
    this.pattern,
    this.serial,
    this.invoiceNo,
    this.ikey,
    this.comId,
    this.comTaxCode,
    this.buyer,
    this.cusName,
    this.cusAddress,
    this.cusTaxCode,
    this.cusCode,
    this.status,
    this.type,
    this.arisingDate,
    this.amount,
    this.isSelected,
    this.taxAuthorityCode,
    this.tCTCheckStatus,
  });

  int? id;
  String? pattern;
  String? serial;
  String? invoiceNo;
  String? ikey;
  int? comId;
  dynamic comTaxCode;
  String? cusCode;
  String? buyer;
  String? cusName;
  String? cusAddress;
  String? cusTaxCode;

  /// -1: Hóa đơn chờ ký
  /// 0: Hóa đơn mới tạo lập
  /// 1: Hóa đơn có chữ ký số
  /// 2: Hóa đơn đã khai báo thuế
  /// 3: Hóa đơn bị thay thế
  /// 4: Hóa đơn bị điều chỉnh
  /// 5: Hóa đơn bị hủy
  /// 6: Hóa đơn đã duyệt
  int? status;

  /// 0: Hóa đơn thông thường
  /// 1: Hóa đơn thay thế
  /// 2: Hóa đơn điều chỉnh tăng
  /// 3: Hóa đơn điều chỉnh giảm
  /// 4: Hóa đơn điều chỉnh thông tin
  /// 5: Hóa đơn gửi đi phát hành
  int? type;
  String? arisingDate;
  double? amount;

  /// mã hóa đơn cấp của cơ quan thuế
  String? taxAuthorityCode;

  /// trạng thái của hóa đơn cơ quan thuế
  /// case -2: / không hợp lệ /
  /// case -1: / đang chờ cấp mã /
  /// case 1: / hợp lệ /
  /// 0 hoặc null: chưa xử lý
  int? tCTCheckStatus;

  /// biến lưu ở local, xác định hóa đơn được chọn
  RxBool? isSelected = false.obs;

  /// sử dụng ở local. báo lỗi hóa đơn khi chọn.
  RxString invoiceError = ''.obs;

  factory InvoiceList.fromJson(Map<String, dynamic> json) => InvoiceList(
      id: json["Id"],
      pattern: json["Pattern"],
      serial: json["Serial"],
      invoiceNo: json["InvoiceNo"],
      ikey: json["Ikey"],
      comId: json["ComId"],
      comTaxCode: json["ComTaxCode"],
      cusCode: json["CusCode"],
      cusName: json["CusName"],
      cusAddress: json["CusAddress"],
      cusTaxCode: json["CusTaxCode"],
      buyer: json["Buyer"],
      status: json["Status"],
      type: json["Type"],
      arisingDate: json["ArisingDate"],
      amount: json["Amount"].toDouble(),
      taxAuthorityCode: json["TaxAuthorityCode"],
      tCTCheckStatus: json["TCTCheckStatus"],
      isSelected: json["IsSelected"] ?? false.obs);

  Map<String, dynamic> toJson() => {
        "Id": id,
        "Pattern": pattern,
        "Serial": serial,
        "InvoiceNo": invoiceNo,
        "Ikey": ikey,
        "ComId": comId,
        "ComTaxCode": comTaxCode,
        "CusCode": cusCode,
        "CusName": cusName,
        "CusAddress": cusAddress,
        "CusTaxCode": cusTaxCode,
        "Buyer": buyer,
        "Status": status,
        "Type": type,
        "ArisingDate": arisingDate,
        "Amount": amount,
        "IsSelected": isSelected,
        "TaxAuthorityCode": taxAuthorityCode,
        "TCTCheckStatus": tCTCheckStatus,
      };
}
