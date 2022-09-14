import 'dart:io';
import 'dart:typed_data';

import 'package:easy_invoice_qlhd/base/base.dart';
import 'package:easy_invoice_qlhd/const/all_const.dart';
import 'package:easy_invoice_qlhd/features/pdf/pdf_viewer_page.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:share_plus/share_plus.dart';

Future<PermissionStatus> checkPermission(
    List<Permission> listPermission) async {
  PermissionStatus status = PermissionStatus.granted;
  Map<Permission, PermissionStatus> statuses = await listPermission.request();
  for (var value in statuses.values) {
    if (value == PermissionStatus.permanentlyDenied) {
      status = PermissionStatus.permanentlyDenied;
      break;
    }
    if (value == PermissionStatus.denied) {
      status = PermissionStatus.denied;
      break;
    }
    // if (value == PermissionStatus.undetermined) {
    //   status = PermissionStatus.undetermined;
    //   break;
    // }
  }
  return status;
}

Future<String> getPath(String fileName) async {
  String path = await getTemporaryDirectory().then((value) => value.path);

  return '$path${Platform.pathSeparator}$fileName';
}

DateTime? _currentBackPressTime;
Future<bool> onWillPop() {
  DateTime now = DateTime.now();
  if (_currentBackPressTime == null ||
      now.difference(_currentBackPressTime ?? DateTime.now()) >
          const Duration(seconds: 2)) {
    _currentBackPressTime = now;
    Fluttertoast.showToast(msg: AppStr.exitApp.tr);
    return Future.value(false);
  }
  return Future.value(true);
}

bool isNumeric(String s) {
  return double.tryParse(s) != null;
}

Future<String> searchInvByQr() async {
  var qrCode = await Get.toNamed(AppConst.routeQrCode);
  return qrCode != null && qrCode.format == BarcodeFormat.qrcode
      ? qrCode.code
      : '';
}

void openFile(BaseGetxController controller, List<int> value) {
  if (!controller.isClosed) {
    Get.to(
      () => PdfPage(value),
    );
  }
}

Future<String> saveFile(String fileName, Uint8List bytes) async {
  File file = File(await getPath(fileName));
  file.writeAsBytes(bytes);

  return file.path;
}

Future<void> shareFilePDF(
  BaseGetxController controller,
  String fileName,
  List<int> value,
) async {
  // Hiện tại đang bị lỗi không chia sẻ được trên ipad nên sẽ sử dụng open file để mở dạng hệ thống
  if (Get.context!.isTablet) {
    String path = await saveFile(fileName, Uint8List.fromList(value));
    OpenFile.open(path);
  } else {
    openFile(controller, value);
  }
}

Future<void> shareFile(String fileName, Uint8List bytes) async {
  String path = await saveFile(fileName, bytes);
  await Share.shareFiles([path]);
}
