import 'package:easy_invoice_qlhd/base/base.dart';
import 'package:easy_invoice_qlhd/const/const.dart';
import 'package:easy_invoice_qlhd/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import 'search_invoice.dart';

class SearchInvoiceController extends BaseGetxController {
  late SearchInvoiceRepository searchInvoiceRepository;

  var invoiceType = 0.obs;

  final TextEditingController taxCodeController = TextEditingController();

  final TextEditingController invoiceCodeController = TextEditingController();

  final FocusNode taxCodeFocus = FocusNode();

  final FocusNode invoiceCodeFocus = FocusNode();

  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    searchInvoiceRepository = SearchInvoiceRepository(this);

    super.onInit();
  }

  void _clearInputText() {
    taxCodeController.clear();
    invoiceCodeController.clear();
  }

  void navToSearchInvoicePage() async {
    _clearInputText();
    Get.toNamed(AppConst.routeSearchInvoice);
    await 500.milliseconds.delay();
    taxCodeFocus.requestFocus();
  }

  Future<void> onPressSearchInvoice(
      BaseGetxController controller, SearchInvoiceModel invoiceModel) async {
    if (formKey.currentState!.validate()) {
      KeyBoard.hide();

      controller.showLoadingOverlay();
      await searchInvoiceRepository
          .downloadFileWithFkey(invoiceModel)
          .then((value) {
        openFile(controller, value);
      }).whenComplete(() => controller.hideLoadingOverlay());
    }
  }

  Future<void> scanQrCode(BaseGetxController controller) async {
    PermissionStatus permissionStatus =
        await checkPermission([Permission.camera]);
    switch (permissionStatus) {
      case PermissionStatus.granted:
        {
          searchInvByQr().then((value) {
            searchInvoicePdf(controller, value);
          });
        }
        break;
      case PermissionStatus.permanentlyDenied:
        ShowPopup.openAppSetting();
        break;
      default:
        return;
    }
  }

  Future<void> searchInvoicePdf(
      BaseGetxController controller, String value) async {
    if (value.isNotEmpty) {
      try {
        controller.showLoadingOverlay();
        await searchInvoiceRepository.downloadWithQrCode(value).then((value) {
          openFile(controller, value);
        });
      } finally {
        controller.hideLoadingOverlay();
      }
    }
  }
}
