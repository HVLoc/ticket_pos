import 'dart:convert';

import 'package:easy_invoice_qlhd/hive_local/setup.dart';
import 'package:easy_invoice_qlhd/utils/utils.dart';
import 'package:get/get.dart';

import '../../../application/app.dart';
import '../../../const/all_const.dart';
import '../../invoice/filter/filter_invoice.dart';
import '../../invoice/invoice.dart';
import '../invoice_creation.dart';

class InvoiceCreationControllerImp extends InvoiceCreationController {
  @override
  void getInvoice() {
    if (HIVE_APP.get(AppConst.keyInvoiceModel) != null) {
      invoiceModel.value = HIVE_APP.get(AppConst.keyInvoiceModel);
    }
    fieldTextEditingController.text =
        invoiceModel.value.paymentMethod ?? AppStr.cash;
    cusNameTextEditingController.text =
        invoiceModel.value.buyer ?? AppStr.buyerDefault;
    userNameController.text = HIVE_APP.get(AppConst.keyUserName) ?? 'api';
    passwordController.text = HIVE_APP.get(AppConst.keyPassword) ?? '';
    if (invoiceModel.value.extra.isStringNotEmpty) {
      for (var i = 0; i < listInvExtra.length; i++) {
        listInvExtra[i].extraValue!.value = listInvExtraRespone()[i];
      }
    }
  }

  @override
  void selectPattern() {
    Get.bottomSheet<InvoicePattern>(
            FilterPatternPage(
              pattern: invoiceModel.value.invoicePattern,
              isHidePatternCancel: true,
            ),
            isScrollControlled: true)
        .then((value) {
      if (value != null) {
        if (value.pattern != invoiceModel.value.invoicePattern ||
            value.serial != invoiceModel.value.serialNo) {
          invoiceModel.update((val) {
            val!
              ..invoicePattern = value.pattern
              ..serialNo = value.serial;
          });
          invoicePattern = value;
        }
      }
    });
  }

  @override
  void actionInvoice() {
    // lưu cấu hình hóa đơn
    invoiceModel.value
      ..paymentMethod = fieldTextEditingController.text
      ..buyer = cusNameTextEditingController.text;
    HIVE_APP.put(AppConst.keyPatternFilter, invoiceModel.value.invoicePattern);
    HIVE_APP.put(AppConst.keyUserName, userNameController.text);
    HIVE_APP.put(AppConst.keyPassword, passwordController.text);
    HIVE_APP.put(AppConst.keyInvoiceModel, invoiceModel.value);
    HIVE_APP.put(AppConst.keyLicensePlates, licensePlatesController.text);
    HIVE_APP.put(
        AppConst.keyRouteBusNumber, 'Tuyến ${routeBusNumberController.text}');
    Get.back();
  }

  @override
  void getExtra() {
    // listInvExtra.addAll(homeController.extraInfoRespone.data!
    //         .firstWhere(((e) => e.pattern == invoiceController.filter.pattern))
    //         .invExtra ??
    //     []);
    // for (var i = 0; i < listInvExtra.length; i++) {
    //   listInvExtra[i].extraValue!.value = "";
    // }
  }
  @override
  void addInvExtraToXML() {
    var mapInvExtra = Map<String, String>.fromIterable(listInvExtra,
        key: (item) => item.name, value: (item) => item.extraValue.value);
    // if (controller.isSettingProduct.value && controller.invoiceArg.type != 4) {
    //   mapInvExtra.addAll({
    //     "CheckDiscount": "1",
    //     "DiscountVatRate":
    //         controller.invoiceModel.value.discountVatRate.toString(),
    //     "TotalDiscount": controller.invoiceModel.value.totalDiscount.toString(),
    //   });
    // }
    invoiceModel.update((val) {
      val!.extra = json.encode(mapInvExtra);
    });
  }

  @override
  List<dynamic> listInvExtraRespone() {
    try {
      Map<String, dynamic> mapProExtraRespone =
          jsonDecode(invoiceModel.value.extra ?? '');
      List<dynamic> listInvExtraRespone =
          mapProExtraRespone.entries.map((e) => e.value).toList();
      return listInvExtraRespone;
    } catch (e) {
      List<dynamic> listInvExtraRespone =
          List.generate(listInvExtra.length, (index) => '');
      return listInvExtraRespone;
    }
  }

  @override
  SetupModel getSetup() {
    return HIVE_SETUP.get(HIVE_APP.get(AppConst.keyIdPage))!;
  }
}
