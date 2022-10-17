import 'dart:convert';

import 'package:easy_invoice_qlhd/application/app_controller.dart';
import 'package:easy_invoice_qlhd/features/invoice_detail/model/invoice_detail_response.dart';
import 'package:easy_invoice_qlhd/features/ticket/controller/ticket_controller.dart';
import 'package:get/get.dart';

import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';

import '../../../const/all_const.dart';

import '../../../service/issue_invoice.dart';
import '../../../utils/utils.dart';

import '../../product_detail/product_detail.dart';

class TicketControllerImp extends TicketController {
  @override
  Future<void> showDateTimePicker() async {
    final DateTime? picked = await BaseWidget.buildDateTimePicker(
      dateTimeInit: dateTime.value,
      // maxTime: DateTime.now(),
    );
    if (picked != null && picked != dateTime) dateTime.value = picked;
  }

  @override
  String convertCurrentTime() {
    return '${_addLeadingZeroIfNeeded(timeOfDay.value.hour)} : ${_addLeadingZeroIfNeeded(timeOfDay.value.minute)}';
  }

  String _addLeadingZeroIfNeeded(int value) {
    if (value < 10) return '0$value';
    return value.toString();
  }

  @override
  Future<void> printTicket(ProductItem item) async {
    try {
      showLoadingOverlay();
      await SunmiPrinter.initPrinter();
      await SunmiPrinter.startTransactionPrint(true);
      for (var i = 0; i < item.quantityLocal.value; i++) {
        if (i != 0) await Future.delayed(const Duration(seconds: 1));
        item.timeStart =
            '${_addLeadingZeroIfNeeded(timeOfDay.value.hour)} : ${_addLeadingZeroIfNeeded(timeOfDay.value.minute)}';
        addHiveInvoices(item);

        //TODO
        // _configPrinter(item, ikey);

      }

      await SunmiPrinter.exitTransactionPrint(true); // Close the transaction

    } finally {
      hideLoadingOverlay();
    }
  }

  @override
  String getOrigInvUrl(String portalLink, String fkey, String pattern,
      {String serial = "", String no = "0"}) {
    String token = base64Encode(
        utf8.encode(pattern + "_" + serial + "_" + no + "|" + fkey));
    return portalLink + "/Invoice/ViewFromFkey?token=" + token;
  }

  @override
  void addProduct() {
    Get.to(
      () => ProductDetailPage(AppStr.addProduct),
      arguments: ProductItem(price: 0.0, quantity: 0.0, vatRate: -1, extra: ""),
    )?.then((value) {
      if (value != null) {
        // products.add(value);
        value.quantityLocal.value = 1.0;
        HIVE_PRODUCT.put(
          value.id,
          value,
        );
      }
    });
  }

  @override
  void deleteProduct(String id) {
    ShowPopup.showDialogConfirm(
      AppStr.invoiceDetailRemoveContain,
      confirm: () => HIVE_PRODUCT.delete(id),
      actionTitle: AppStr.delete,
    );
  }

  @override
  void updateProduct(String id) {
    Get.to(
      () => ProductDetailPage(AppStr.updateProduct),
      arguments: HIVE_PRODUCT.get(id)!,
    )?.then((value) {
      if (value != null) {
        // products[index] = value;
        value.quantityLocal.value = 1.0;
        HIVE_PRODUCT.put(id, value);
      }
    });
  }

  @override
  String getTitle() {
    return HIVE_APP.get(AppConst.keyIdPage) == 1 &&
            appController.isAdmin.isFalse
        ? (HIVE_APP.get(AppConst.keyRouteBusNumber) ??
            'Bạn chưa cấu hình số tuyến !!!')
        : HIVE_ACCOUNT
                .get(HIVE_APP.get(AppConst.keyCurrentAccount))
                ?.nameAccount ??
            AppStr.loginBtn;
  }
}
