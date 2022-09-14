import 'package:easy_invoice_qlhd/const/all_const.dart';
import 'package:easy_invoice_qlhd/utils/utils.dart';

class PdfInvoiceRequest {
  final double no;
  final String ikey;
  final String pattern;

  /// -1: Tệp xml
  /// 0: Tệp pdf thông thường
  ///	1: Tệp pdf chuyển đổi chứng minh nguồn gốc
  /// 2: Tệp pdf chuyển đổi lưu trữ

  final String option;

  PdfInvoiceRequest({
    this.no = 0,
    required this.ikey,
    required this.pattern,
    this.option = '0',
  });

  factory PdfInvoiceRequest.fromJson(dynamic json) => PdfInvoiceRequest(
        ikey: json["Ikey"],
        pattern: json["Pattern"],
        option: json["Option"],
      );

  Map<String, dynamic> toJson() => {
        "Ikey": ikey,
        "Pattern": pattern,
        "Option": option,
      };

  @override
  String toString() {
    return AppStr.appName +
        '_' +
        formatInvoiceNo(this.no) +
        '_' +
        convertDateToString(DateTime.now(), PATTERN_3) +
        ".pdf";
  }
}
