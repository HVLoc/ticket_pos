import 'package:easy_invoice_qlhd/utils/utils.dart';

import '../application/app.dart';
import '../const/all_const.dart';
import '../features/invoice_detail/invoice_detail.dart';

Future<void> addHiveInvoices(ProductItem item) async {
  InvoiceDetailModel invoiceDetailModel = InvoiceDetailModel();
  invoiceDetailModel
    ..ikey = generateUiid("InvoiceDetailModel")
    ..buyer = AppStr.buyerDefault
    ..invoicePattern = HIVE_APP.get(AppConst.keyPatternFilter) ?? "5C22TYY"
    ..paymentMethod = AppStr.cash
    ..items = [item..quantity = 1]
    ..total = item.total ?? 0
    ..amount = item.amount ?? 0
    ..vatRate = item.vatRate ?? -1
    ..vatAmount = item.vatAmount ?? 0
    ..timePos = item.timeStart
    ..status = 0
    ..accountIdPos = HIVE_APP.get(AppConst.keyCurrentAccount)
    ..shiftId = HIVE_APP.get(AppConst.keyCurrentShift)
    ..arisingDate = convertDateToString(DateTime.now(), PATTERN_1);

  await HIVE_INVOICE.put(invoiceDetailModel.ikey, invoiceDetailModel);
}
