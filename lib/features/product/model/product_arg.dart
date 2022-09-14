import 'package:easy_invoice_qlhd/features/invoice_detail/invoice_detail.dart';

class ProductArg {
  /// 0: Chi tiết sp
  /// 1: Sửa
  /// 2: Tạo mới
  /// 3: Nhân bản
  /// 4: Tạo mới từ màn hóa đơn(không lưu lại dữ liệu)
  final int type;
  final ProductItem productItem;

  ProductArg({
    this.type = 0,
    required this.productItem,
  });
}
