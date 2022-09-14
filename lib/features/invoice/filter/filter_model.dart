import 'package:easy_invoice_qlhd/const/all_const.dart';
import 'package:easy_invoice_qlhd/utils/utils.dart';
import 'package:get/get.dart';

class ChipFilterModel {
  String title;
  int? value;
  String fromDate;
  String toDate;
  ChipFilterModel({
    required this.title,
    this.value,
    this.fromDate = '',
    this.toDate = '',
  });
}

class FilterInvoiceModel {
  FilterInvoiceModel({
    this.pattern = "",
    this.serial = "",
    this.fromDate = '',
    this.toDate = '',
    this.status = -1,
    this.cusKey = "",
    this.type = -1,
    this.page = 1,
    this.pageSize = 10,
    this.sortOption = 4,
    this.isFilter = false,
    this.no = '',
    this.tCTCheckStatus = -3,
    this.idAccount,
    this.idShift,
  });

  String pattern;
  String serial;
  String fromDate;
  String toDate;

  ///-1: / tất cả hóa đơn /
  /// 0: / những hóa đơn chưa ký /
  /// 1: / những hóa đơn đã ký /
  /// 2: / những hóa đơn đã hủy /
  int status;
  String cusKey;

  /// -1: null, 0,1,2,3,4 : option
  int type;

  /// page bắt đầu từ 1
  int page;
  int pageSize;

  /// 0 : NULL, 1 : INVOICE_ASC, 2 : INVOICE_DESC, 3 : DATE_ASC, 4 : DATE_DESC
  int sortOption;

  /// true: trạng thái bộ lọc đang hoạt động, false: ngược lại. Dùng ở client
  bool isFilter;

  ///  số hđ
  String no;

  int tCTCheckStatus;
  int? idAccount;
  int? idShift;
  int? idProduct;

  Map<String, dynamic> toJson() => {
        "pattern": pattern,
        "serial": serial,
        "fromDate": fromDate,
        "toDate": toDate,
        "status": status,
        "cusKey": cusKey,
        "type": type,
        "page": page,
        "pageSize": pageSize,
        "sortOption": sortOption,
        "no": no,
        "TCTCheckStatus": tCTCheckStatus,
      };

  Map<String, String> emptyStr() {
    String _pattern = pattern.isStringNotEmpty ? "$pattern" : "";
    String _serial = serial.isStringNotEmpty ? "$serial" : "";
    String _fromDate = fromDate.isStringNotEmpty ? "$fromDate" : "";
    String _toDate = toDate.isStringNotEmpty ? "$toDate" : "";
    String _status = status != -1 ? getStatus().tr : "";
    String _type = type != -1 ? getType().tr : "";
    String _no = "$no\n";
    String _cusKey = cusKey.isNotEmpty ? "$cusKey" : "";
    String _tCTCheckStatus = tCTCheckStatus != -3 ? "$tCTCheckStatus" : "";

    Map<String, String> _rets = Map();
    if (_pattern.trim().isNotEmpty && _serial.trim().isNotEmpty)
      _rets[AppStr.serialAndPattern.tr] = '$_pattern | $_serial\n';
    else if (_pattern.trim().isNotEmpty)
      _rets[AppStr.pattern.tr] = '$_pattern\n';
    else if (_serial.trim().isNotEmpty) _rets[AppStr.serial.tr] = '$_serial\n';

    if (_fromDate.trim().isNotEmpty && _toDate.trim().isNotEmpty)
      _rets[AppStr.time.tr] = '$_fromDate - $_toDate\n';
    else if (_fromDate.trim().isNotEmpty)
      _rets[AppStr.fromNo.tr] = '$_fromDate\n';
    else if (_toDate.trim().isNotEmpty) _rets[AppStr.toNo.tr] = '$_fromDate\n';

    if (_type.trim().isNotEmpty && _status.trim().isNotEmpty)
      _rets[AppStr.filterInvoiceEmpty.tr] = '$_type - $_status\n';
    else if (_type.trim().isNotEmpty)
      _rets[AppStr.filterInvoiceTypeEmpty.tr] = '$_type\n';
    else if (_status.trim().isNotEmpty)
      _rets[AppStr.statusPattern.tr] = '$_status\n';
    if (_tCTCheckStatus.trim().isNotEmpty)
      _rets[AppStr.stateTCTCheckStatus.tr] =
          ': ${AppStr.listTCTCheckStatus.entries.firstWhere((element) => element.key == tCTCheckStatus).value}\n';

    if (_no.trim().isNotEmpty)
      _rets[AppStr.filterNoInvoiceEmpty.tr] = '$_no\n';
    else if (_cusKey.trim().isNotEmpty) _rets[AppStr.keyWord.tr] = '$_cusKey\n';

    return _rets;
  }

  String getStatus() {
    return AppStr.listStatusInvoice.entries
        .firstWhere((element) => element.key == status)
        .value;
  }

  String getType() {
    return AppStr.listTypeInvoice.entries
        .firstWhere((element) => element.key == type)
        .value;
  }

  @override
  bool operator ==(Object other) {
    return other is FilterInvoiceModel &&
        other.fromDate == this.fromDate &&
        other.toDate == this.toDate &&
        other.cusKey == this.cusKey &&
        other.type == this.type &&
        other.status == this.status &&
        other.sortOption == this.sortOption &&
        other.idAccount == this.idAccount &&
        other.idShift == this.idShift &&
        other.tCTCheckStatus == this.tCTCheckStatus;
  }

  @override
  int get hashCode => super.hashCode;
}
