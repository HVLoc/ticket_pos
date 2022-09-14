import 'package:easy_invoice_qlhd/const/all_const.dart';
import 'package:easy_invoice_qlhd/features/invoice_detail/invoice_detail.dart';

class InvoiceArg {
  final String appBarTitle;
  final String ikey;
  final InvoiceDetailModel invoiceDetailModel;

  /// 0: tạo lập,
  /// 1: thay thế,
  /// 2: điều chỉnh tăng,
  /// 3: điều chỉnh giảm,
  /// 4: điều chỉnh ttin,
  /// 5: chỉnh sửa
  /// 6: nhân bản
  final int type;

  /// 0: thông thường,
  /// 1: thay thế,
  /// 2: điều chỉnh tăng,
  /// 3: điều chỉnh giảm,
  /// 4: điều chỉnh ttin,
  final int typeFix;

  // ikey hóa đơn bị điều chỉnh, thay thế
  final String? refIkey;

  InvoiceArg({
    this.ikey = '',
    this.appBarTitle = AppStr.invoiceCreationTitle,
    required this.invoiceDetailModel,
    this.type = 0,
    this.typeFix = 0,
    this.refIkey,
  });
}
