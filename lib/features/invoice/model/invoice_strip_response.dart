import 'package:easy_invoice_qlhd/const/all_const.dart';

class InvoicePattern {
  InvoicePattern({
    required this.pattern,
    required this.serial,
    required this.status,
    required this.invoiceType,
    required this.startDate,
    required this.currentUsed,
    required this.fromNo,
    required this.toNo,
    required this.publishID,
    required this.registerID,
    this.startDateApp = '',
    this.fromNoApp = 0,
    this.currentUsedApp = 0,
    this.statusApp = -1,
  });

  String pattern;
  String serial;

  /// 0: chưa được chấp nhận(không hiển thị trên mobile) 1: chưa dùng , 2: đang dùng , 3: dùng hết, 4: đã hủy
  int status;

  /// 0: Một Thuế, 1: Nhiều thuế
  int invoiceType;
  String startDate;
  double currentUsed;
  // double currentNo;
  double fromNo;
  double toNo;
  int publishID;
  int registerID;

  // Dữ liệu gộp lại để sử dụng dưới app
  String startDateApp;
  double currentUsedApp;
  double fromNoApp;
  int statusApp;

  factory InvoicePattern.fromJson(Map<String, dynamic> json) => InvoicePattern(
        pattern: json["pattern"],
        serial: json["serial"],
        status: json["status"],
        invoiceType: json["invoiceType"] ?? 0,
        currentUsed: json["currentUsed"] ?? 0,
        fromNo: json["fromNo"] ?? 0,
        toNo: json["toNo"] ?? 0,
        startDate: json['startDate'],
        publishID: json['publishID'] ?? 0,
        registerID: json['registerID'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "pattern": pattern,
        "serial": serial,
        "status": status,
        "invoiceType": invoiceType,
        "currentUsed": currentUsed,
        "startDate": startDate,
        "fromNo": fromNo,
        "toNo": toNo,
        "publishID": publishID,
        "registerID": registerID,
      };

  @override
  bool operator ==(Object other) {
    return other is InvoicePattern &&
        other.pattern == this.pattern &&
        other.serial == this.serial;
  }

  @override
  int get hashCode => this.pattern.hashCode + this.serial.hashCode;

  String statusSerial() {
    switch (this.status) {
      case 1:
        return AppStr.invoiceStatusNotUsed;
      case 2:
        return AppStr.invoiceStatusUsing;
      case 3:
        return AppStr.invoiceStatusOver;
      case 4:
        return AppStr.invoiceStatusCanceled;
      default:
        return '';
    }
  }
}
