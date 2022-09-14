import 'package:easy_invoice_qlhd/base/base.dart';
import 'package:easy_invoice_qlhd/hive_local/setup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../application/app.dart';
import '../../const/all_const.dart';
import '../extra/extra_respone.dart';
import '../invoice_creation/invoice_creation.dart';
import '../login/login.dart';

class HomeController extends BaseGetxController {
  late Rx<PageController> pageController;

  RxInt pageIndex = 0.obs;
  late LoginRepository loginRepository;

  // mẫu số, kí hiệu lấy sau khi login
  // List<InvoicePattern> listPatternMerge = [];

  // List<InvoicePattern> listPatterns = [];

  // late AccountPermission accountPermission;

  late ExtraInfoRespone extraInfoRespone;

  // List<String> listBankDetailName = [];

  late InvoiceCreationRepository invoiceCreationRepository;

  HomeController() {
    invoiceCreationRepository = InvoiceCreationRepository(this);
    this.loginRepository = LoginRepository(this);
  }

  @override
  Future<void> onInit() async {
    // Map arg = Get.arguments;
    // accountPermission = arg["accountPermission"];
    // if (!accountPermission.canReport) {
    //   // Chuyển sang màn hoá đơn nếu không có quyền truy cập thống kê
    //   pageIndex.value = 1;
    // }
  
    pageController = PageController(initialPage: pageIndex.value).obs;

    // this.listPatterns = arg["listPattern"];

    this.extraInfoRespone = await loginRepository.getExtraInfo();
    // sortListPattern();
    // convertListBankDetail(arg["bank"]);

    super.onInit();
  }

  // Future<void> getListPattern() async {
  //   await _loginRepository.getInvoiceStrip().then((value) async {
  //     if (value.isNotEmpty) {
  //       listPatterns = value;
  //       sortListPattern();
  //     } else {
  //       ShowPopup.showDialogNotification(AppStr.loginListPatternEmpty.tr);
  //     }
  //   });
  // }

  // void sortListPattern() {
  //   this.listPatternMerge = List<InvoicePattern>.from(listPatterns);

  //   // sắp xếp theo thời gian, dải hóa đơn mua sau lên trước
  //   listPatternMerge..sort((a, b) => b.publishID.compareTo(a.publishID));

  //   listPatternMerge.forEach((element) {
  //     InvoicePattern temp = listPatternMerge.lastWhere((findElement) =>
  //         element.pattern == findElement.pattern &&
  //         element.serial == findElement.serial);
  //     element
  //       ..fromNoApp = temp.fromNo
  //       ..startDateApp = temp.startDate;
  //     element.statusApp = listPatternMerge
  //         .firstWhere((findElement) =>
  //             element.pattern == findElement.pattern &&
  //             element.serial == findElement.serial)
  //         .status;

  //     listPatternMerge
  //         .where((findElement) =>
  //             element.pattern == findElement.pattern &&
  //             element.serial == findElement.serial)
  //         .forEach((e) {
  //       element.currentUsedApp += e.currentUsed;
  //       if (element.status == 1 && element.fromNo > 1) {
  //         element.statusApp = 2;
  //       }
  //     });
  //   });

  //   listPatternMerge = listPatternMerge.toSet().toList();
  // }

  // List<String> convertListBankDetail(BankModel bankModel) {
  //   listBankDetailName.addAll(
  //       (bankModel.data ?? []).map((e) => e.shortName! + ' - ' + e.name!));

  //   return listBankDetailName;
  // }
}
