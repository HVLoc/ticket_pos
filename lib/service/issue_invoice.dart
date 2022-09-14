import 'package:easy_invoice_qlhd/base/base.dart';
import 'package:easy_invoice_qlhd/utils/utils.dart';
import 'package:get/get.dart';
import 'package:xml/xml.dart';

import '../application/app.dart';
import '../const/all_const.dart';
import '../features/home/home_controller.dart';
import '../features/invoice_creation/invoice_creation.dart';
import '../features/invoice_detail/invoice_detail.dart';

Future<void> callIssueInvoice(String xmlData) async {
  try {
    BaseResponse invoiceBaseResponse = await Get.find<HomeController>()
        .invoiceCreationRepository
        .importAndIssueInvoice(
          InvoiceCreationRequest(
            pattern: HIVE_APP.get(AppConst.keyPatternFilter) ?? '5C22TYY',
            serial: '',
            xmlData: xmlData,
          ),
        );
    if (invoiceBaseResponse.status == AppConst.responseSuccess) {
      HIVE_INVOICE.put(
        invoiceBaseResponse.data.invoices.first.ikey,
        HIVE_INVOICE.get(invoiceBaseResponse.data.invoices.first.ikey)!
          ..invoiceNo =
              double.tryParse(invoiceBaseResponse.data.invoices.first.no)
          ..status = 1,
      );
    } else {
      ShowPopup.showErrorMessage(
          formatMessError(invoiceBaseResponse.data.keyInvoiceMsg));
    }
  } catch (e) {}
}

Future<String> buildCreateXml(ProductItem item, String ikey) async {
  InvoiceDetailModel invoiceDetailModel = InvoiceDetailModel();
  var builder = XmlBuilder();
  invoiceDetailModel
    ..ikey = ikey
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

  // addInvExtraToXML(this);
  builder.element(AppStr.XML_INVOICES, nest: () {
    // for (var i = 0; i < item.quantityLocal.value; i++) {
    builder.element(AppStr.XML_INV, nest: () {
      buildBaseXml(
        builder: builder,
        xmlName: AppStr.INVOICE,
        ikey: ikey,
        invoiceModel: invoiceDetailModel,
        products: RxList<ProductItem>([item]),
        isTaxBill: false,
        isInvoiceTax: true,
      );
    });
    // }
  });

  invoiceDetailModel.xmlInv = builder.buildDocument().toString();
  await HIVE_INVOICE.put(invoiceDetailModel.ikey, invoiceDetailModel);

  return invoiceDetailModel.xmlInv!;
}
