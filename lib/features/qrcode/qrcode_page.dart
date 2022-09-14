import 'package:easy_invoice_qlhd/base/base.dart';
import 'package:easy_invoice_qlhd/const/all_const.dart';
import 'package:easy_invoice_qlhd/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'qrcode_controller.dart';

class QRInvoicePage extends BaseGetWidget<QrCodeController> {
  @override
  QrCodeController get controller => Get.put(QrCodeController());
  @override
  Widget buildWidgets() {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(controller.flashState == flashOff
                ? Icons.flash_off
                : Icons.flash_on),
            onPressed: () {
              controller.qrController.toggleFlash();
              controller.flashState.value =
                  controller.isFlashOn(controller.flashState.value)
                      ? flashOff
                      : flashOn;
            },
          ),
          IconButton(
            icon: const Icon(Icons.help),
            onPressed: () {
              controller.isShowBottomSheet.value = true;
              Get.bottomSheet(
                BaseWidget.baseBottomSheet(
                  title: AppStr.help.tr,
                  body: Container(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      AppStr.searchInvHelpQrScan.tr,
                      style: Get.textTheme.bodyText1,
                    ),
                  ),
                ),
                isScrollControlled: true,
              );
            },
          ),
        ],
      ),
      body: QRView(
        key: controller.qrKey,
        onQRViewCreated: controller.onQRViewCreated,
        overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: 300,
        ),
      ),
    );
  }
}
