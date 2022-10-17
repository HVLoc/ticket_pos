import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:easy_invoice_qlhd/application/app_controller.dart';
import 'package:easy_invoice_qlhd/base/base.dart';
import 'package:easy_invoice_qlhd/features/home/home_controller.dart';
import 'package:easy_invoice_qlhd/features/invoice/invoice.dart';
import 'package:easy_invoice_qlhd/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'invoice_detail.dart';

class InvoiceDetailController extends BaseGetxController {
  Rx<InvoiceDetailModel> invoiceDetailModel =
      Rx<InvoiceDetailModel>(InvoiceDetailModel());

  InvoicesController invoicesController = Get.find<InvoicesController>();

  /// Controller của NestscrollView.
  late ScrollController scrollController;

  /// `scrollOffset`: biến trạng thái vị trí scroll.
  RxDouble scrollOffset = 0.0.obs;

  double appBarHeight = 70.0;

  HomeController homeController = Get.find<HomeController>();

  AppController appController = Get.find<AppController>();

  InvoiceDetailController() {}

  @override
  void onInit() {
    //scroll app bar
    scrollController = ScrollController();
    scrollController.addListener(() {
      scrollOffset.value = scrollController.offset;
    });

    // listExtra.addAll(homeController.extraInfoRespone.data!
    //         .firstWhere(((e) => e.pattern == invoiceList.pattern))
    //         .invExtra ??
    //     []);
    getInvoice();
    super.onInit();
  }

  Future<void> getInvoice() async {
    invoiceDetailModel.value = Get.arguments;

    listInvExtraViewRespone();
  }

  bool isScrollToTop() {
    return scrollOffset <= (appBarHeight - kToolbarHeight / 2);
  }

  bool isNotCancelInv() => !(invoiceDetailModel.value.status == 5 ||
      invoiceDetailModel.value.status == 3);

  bool isCreate() => invoiceDetailModel.value.status == 0;

  bool isInvoiceWait() => invoiceDetailModel.value.status == -1;

  String getListTextImportant() {
    List<String> txt =
        invoiceDetailModel.value.processInvNote?.split(' ') ?? [];

    for (var i = 0; i < txt.length; i++) {
      if (txt[i].contains(",")) {
        txt[i] = txt[i].replaceAll(',', '');
        if (isNumeric(txt[i])) {
          return txt[i];
        }
      }
    }

    return '';
  }

  List<dynamic> listInvExtraViewRespone() {
    try {
      Map<String, dynamic> mapProExtraRespone =
          jsonDecode(invoiceDetailModel.value.extra ?? '');

      invoiceDetailModel.value
        ..checkDiscount = (mapProExtraRespone.entries
                .firstWhereOrNull((element) => element.key == "CheckDiscount")
                ?.value ==
            '1')
        ..discountVatRate = double.parse(
          (mapProExtraRespone.entries
                  .firstWhereOrNull(
                      (element) => element.key == "DiscountVatRate")
                  ?.value ??
              '0'),
        )
        ..totalDiscount = double.parse(
          (mapProExtraRespone.entries
                  .firstWhereOrNull((element) => element.key == "TotalDiscount")
                  ?.value ??
              '0'),
        );

      List<dynamic> listInvExtraViewRespone =
          mapProExtraRespone.entries.map((e) => e.value).toList();
      return listInvExtraViewRespone;
    } catch (e) {
      return [];
    }
  }
}
