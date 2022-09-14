import 'dart:convert';

import 'package:device_info/device_info.dart';
import 'package:easy_invoice_qlhd/base/base_controller.dart';
import 'package:easy_invoice_qlhd/const/all_const.dart';
import 'package:easy_invoice_qlhd/features/invoice_creation/invoice_creation.dart';
import 'package:easy_invoice_qlhd/features/invoice_detail/invoice_detail.dart';
import 'package:easy_invoice_qlhd/features/product/model/product_extra.dart';
import 'package:easy_invoice_qlhd/utils/utils.dart';
import 'package:get/get.dart';
import 'package:xml/xml.dart';

double vatValue(int? vatRate) =>
    vatRate != null && vatRate != -1 ? vatRate / 100 : 0;

// Mẫu 32 sẽ form bán hàng sẽ check KPTQ, BLP & GTTT
// Mẫu 78 form bán hàng bắt đầu bằng 2
bool isSaleInv(String? pattern) {
  if (pattern == null) {
    return false;
  }
  return pattern.contains('KPTQ') ||
      pattern.contains('BLP') ||
      pattern.contains('GTTT') ||
      pattern.startsWith('2');
}

Future<String> getIkey(InvoiceArg invoiceArg) async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  String deviceId = GetPlatform.isAndroid
      ? await deviceInfo.androidInfo.then((value) => value.androidId)
      : await deviceInfo.iosInfo.then((value) => value.identifierForVendor);
  String ikey = invoiceArg.type == 5
      ? invoiceArg.ikey
      : (deviceId +
          (DateTime.now().millisecondsSinceEpoch ~/ 1000).toRadixString(16));
  return ikey;
}

/// `type` kiểu điều chỉnh
/// `isInvoiceTax` hóa đơn chịu thuế
Future<void> buildBaseXml({
  required XmlBuilder builder,
  required String xmlName,
  required String ikey,
  required InvoiceDetailModel invoiceModel,
  required RxList<ProductItem> products,
  required bool isTaxBill,
  required bool isInvoiceTax,
  int? type,
  bool isNotHandleInfo = true,
}) async {
  builder.element(xmlName, nest: () {
    builder.element(AppStr.FIELD_INVOICE_IKEY, nest: ikey);
    builder.element('Fkey', nest: ikey);
    builder.element(AppStr.FIELD_INVOICE_CUS_CODE,
        nest: invoiceModel.cusCode.isStringNotEmpty
            ? invoiceModel.cusCode
            : null);
    builder.element(AppStr.FIELD_INVOICE_BUYER, nest: "Khách lẻ");
    builder.element(AppStr.FIELD_INVOICE_CUS_NAME, nest: invoiceModel.cusName);
    builder.element(AppStr.FIELD_INVOICE_EMAIL, nest: invoiceModel.email);
    builder.element(AppStr.FIELD_INVOICE_EMAIL_CC, nest: invoiceModel.emailCc);
    builder.element(AppStr.FIELD_INVOICE_CUS_EMAILS,
        nest: invoiceModel.cusEmails);
    builder.element(AppStr.FIELD_INVOICE_CUS_ADDRESS,
        nest: invoiceModel.cusAddress);
    builder.element(AppStr.FIELD_INVOICE_CUS_BANK_NAME,
        nest: invoiceModel.cusBankName);
    builder.element(AppStr.FIELD_INVOICE_CUS_BANK_NO,
        nest: invoiceModel.cusBankNo);
    builder.element(AppStr.FIELD_INVOICE_CUS_PHONE,
        nest: invoiceModel.cusPhone);
    builder.element(AppStr.FIELD_INVOICE_CUS_TAX_CODE,
        nest: invoiceModel.cusTaxCode);
    builder.element(AppStr.FIELD_INVOICE_PAYMENT_METHOD, nest: AppStr.cash);
    builder.element(AppStr.FIELD_INVOICE_ARISING_DATE,
        nest: convertDateToString(DateTime.now(), PATTERN_1));
    builder.element(AppStr.FIELD_INVOICE_EXCHANGE_RATE,
        nest: invoiceModel.exchangeRate);
    builder.element(AppStr.FIELD_INVOICE_CURRENCY_UNIT,
        nest: invoiceModel.currencyUnit);
    builder.element(AppStr.FIELD_INVOICE_EXTRA,
        nest: '{"CarNo": "${invoiceModel.extra}"}');
    if (type != null) {
      builder.element(AppStr.FIELD_INVOICE_TYPE_HANDLE, nest: type);
    }
    int i = 1;
    String extra = '';
    builder.element(AppStr.XML_PRODUCTS, nest: () {
      for (int index = 0; index < products.length; index++) {
        builder.element(AppStr.FIELD_PRODUCT, nest: () {
          builder.element(AppStr.FIELD_PRODUCT_CODE,
              nest: products[index].code);
          builder.element(AppStr.FIELD_PRODUCT_NAME,
              nest: products[index].name);
          builder.element(AppStr.FIELD_PRODUCT_UNIT,
              nest: products[index].unit);

          builder.element(AppStr.FIELD_PRODUCT_QUANTITY, nest: 1.0);
          builder.element(AppStr.FIELD_PRODUCT_PRICE,
              nest: products[index].price);
          builder.element(AppStr.FIELD_PRODUCT_TOTAL,
              nest: products[index].total);
          // Hóa đơn bán hàng không chịu thuế
          builder.element(AppStr.FIELD_PRODUCT_VAT_RATE,
              nest: isInvoiceTax ? (products[index].vatRate ?? 0) : -1);
          builder.element(AppStr.FIELD_PRODUCT_VAT_AMOUNT,
              nest: products[index].vatAmount ?? 0);
          builder.element(AppStr.FIELD_PRODUCT_AMOUNT,
              nest: products[index].amount);

          builder.element(AppStr.FIELD_PRODUCT_IS_SUM,
              nest: products[index].isSum ? 1 : 0);

          if (products[index].total != 0.0) {
            if (products[index].extra != null) {
              List<ProductExtra> productExtra =
                  listProductExtraFromString(products[index].extra);
              Map<String, dynamic> mapProductExtra = {
                for (var v in productExtra) v.name ?? '': v.value
              };
              extra = jsonEncode(mapProductExtra);
            } else {
              extra = '{"Pos":"$i"}';
            }
            i += 1;
          } else {
            extra = '{"Pos":""}';
          }
          builder.element(
            AppStr.FIELD_INVOICE_EXTRA,
            nest: extra,
          );
        });
      }
    });

    builder.element(AppStr.FIELD_INVOICE_TOTAL,
        nest: isNotHandleInfo ? invoiceModel.total.toInt() : 0);

    // Nếu là hóa đơn nhiều thuế VATRate = 0,
    // Hóa đơn bán hàng không chịu thuế VATRate = -1
    builder.element(AppStr.FIELD_INVOICE_VAT_RATE,
        nest: isInvoiceTax
            ? isTaxBill
                ? 0
                : isNotHandleInfo
                    ? invoiceModel.vatRate
                    : -1
            : -1);
    builder.element(AppStr.FIELD_INVOICE_VAT_AMONUT,
        nest: isNotHandleInfo ? invoiceModel.vatAmount.toInt() : 0);

    builder.element(AppStr.FIELD_INVOICE_AMOUNT, nest: invoiceModel.amount);
    builder.element(
      AppStr.FIELD_INVOICE_AMOUNT_IN_WORDS,
      nest: numberToWords(
        invoiceModel.amount.toInt(),
      ),
    );
  });
}

bool checkIkeyEmpty(String ikey) {
  if (!ikey.isStringNotEmpty)
    Get.find<BaseGetxController>().showSnackBar(
      AppStr.invoiceIkeyNull.tr,
      duration: 5.seconds,
      mainButton: BaseWidget.buildMainButtonPhone(),
    );
  return ikey.isStringNotEmpty;
}

String vatStr(ProductItem item) =>
    AppStr.vatSpace.tr +
    AppStr.listVAT.entries
        .firstWhere(
            (element) =>
                element.key == (item.vatRate ?? AppStr.listVAT.keys.first),
            orElse: () => {
                  1: item.vatRate.toString() + AppStr.percentSpace.tr,
                }.entries.first)
        .value;
