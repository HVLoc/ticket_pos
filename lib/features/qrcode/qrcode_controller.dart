import 'dart:async';

import 'package:easy_invoice_qlhd/base/base.dart';
import 'package:easy_invoice_qlhd/const/all_const.dart';
import 'package:easy_invoice_qlhd/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

const flashOn = 'FLASH ON';
const flashOff = 'FLASH OFF';

class QrCodeController extends BaseGetxController {
  var flashState = flashOn.obs;

  late QRViewController qrController;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  var isShowBottomSheet = false.obs;

  @override
  void onInit() {
    Timer(const Duration(seconds: 15), () {
      if (!isClosed && !isShowBottomSheet.value && !this.isClosed) {
        qrController.pauseCamera();
        ShowPopup.showDialogNotification(
          AppStr.searchInvNotificationQrScan.tr,
          function: () => qrController.resumeCamera(),
        );
      }
    });
    super.onInit();
  }

  bool isFlashOn(String current) {
    return flashOn == current;
  }

  void onQRViewCreated(QRViewController controller) {
    qrController = controller;
    controller.scannedDataStream.listen((scanData) {}).onData((data) {
      controller.dispose();
      Get.back(result: data);
    });
  }

  @override
  void onClose() {
    qrController.dispose();
    super.onClose();
  }
}
