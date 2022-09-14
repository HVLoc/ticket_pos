import 'package:easy_invoice_qlhd/const/all_const.dart';
import 'package:easy_invoice_qlhd/utils/utils.dart';

class SearchInvoiceModel {
  final String fkey;
  final String taxCode;

  /// 0: Hoá đơn. Chưa có giá trị cho phiếu xuất kho
  final int type;

  /// Trạng thái hóa đơn
  ///
  /// -1: Tra cứu bằng nhập fkey, qr code. Luôn tải hóa đơn mới.
  ///
  /// 1: Phát hành.
  ///
  /// 4: Hóa đơn thay thế.
  ///
  /// 5: Đã hủy.
  final int status;

  /// khi có api phiếu xuất kho, [type] bỏ default và yêu cầu truyền giá trị
  SearchInvoiceModel({
    required this.fkey,
    required this.taxCode,
    this.type = 0,
    this.status = -1,
  });

  factory SearchInvoiceModel.parse(String qrCode) {
    var _listqr = qrCode.split('|');

    var _listCode = _listqr.last.split(';');
    if (_listCode.length >= 4) {
      return SearchInvoiceModel(
        fkey: _listqr.first,
        taxCode: _listCode[2],
      );
    }
    return SearchInvoiceModel(
      fkey: '',
      taxCode: '',
    );
  }

  factory SearchInvoiceModel.fromJson(dynamic json) => SearchInvoiceModel(
        fkey: json["fkey"],
        taxCode: json["taxcode"],
        type: json["type"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "fkey": fkey,
        "taxcode": taxCode,
        "type": type,
        "status": status,
      };

  @override
  String toString() {
    return AppStr.appName +
        '_' +
        this.taxCode +
        '_' +
        this.fkey +
        '_' +
        convertDateToString(DateTime.now(), PATTERN_3) +
        ".pdf";
  }
}
