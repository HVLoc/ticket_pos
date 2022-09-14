import 'dart:convert';
import 'dart:typed_data';

import 'package:easy_invoice_qlhd/const/all_const.dart';
import 'package:easy_invoice_qlhd/features/invoice/invoice.dart';
import 'package:easy_invoice_qlhd/features/search_invoice/search_invoice.dart';
import 'package:easy_invoice_qlhd/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

class QRDetailInvoicePage extends StatelessWidget {
  final String qrImage;

  final InvoiceList invoiceList;

  final SearchInvoiceModel? searchInvoiceModel;

  const QRDetailInvoicePage({
    Key? key,
    required this.qrImage,
    required this.invoiceList,
    this.searchInvoiceModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Uint8List bytes = const Base64Codec().decode(this.qrImage);
    return Scaffold(
      appBar: AppBar(
        title: BaseWidget.buildAppBarTitle(AppStr.numberInvoice +
            ': ' +
            formatInvoiceNo(double.parse(invoiceList.invoiceNo ?? '0'))),
      ),
      body: Column(
        children: [
          Container(
            height: Get.width / 2.3,
            width: Get.width / 2.3,
            child: Image.memory(bytes),
          ),
          _btnSaveImg(bytes),
        ],
      ),
    );
  }

  Widget _btnSaveImg(Uint8List bytes) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton(
          onPressed: () async {
            await _saveImgToGalley(bytes);
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(4, 2, 4, 2),
            child: Text(
              AppStr.savePicture.tr,
              style: const TextStyle(
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
        TextButton(
          onPressed: () async {
            await shareFile('QR_EI_${DateTime.now()}.jpg', bytes);
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(4, 2, 4, 2),
            child: Text(
              AppStr.sharePicture.tr,
              style: const TextStyle(
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _saveImgToGalley(Uint8List bytes) async {
    PermissionStatus permissionStatus =
        await checkPermission([Permission.storage]);
    switch (permissionStatus) {
      case PermissionStatus.granted:
        {
          final result = await ImageGallerySaver.saveImage(
            Uint8List.fromList(bytes),
            name: "QR_EI_${DateTime.now()}",
          );
          Fluttertoast.showToast(
            msg: AppStr.savePictureCompleted.tr,
          );
          print(result);
        }
        break;
      case PermissionStatus.permanentlyDenied:
        // showPopup.openAppSetting();
        break;
      default:
        return;
    }
  }
}
