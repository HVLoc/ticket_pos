import 'package:easy_invoice_qlhd/application/app.dart';
import 'package:easy_invoice_qlhd/base/base.dart';
import 'package:easy_invoice_qlhd/features/home/home_controller.dart';
import 'package:easy_invoice_qlhd/features/invoice/invoice.dart';
import 'package:easy_invoice_qlhd/features/invoice_detail/invoice_detail.dart';
import 'package:easy_invoice_qlhd/hive_local/setup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../const/all_const.dart';
import '../../extra/extra_respone.dart';

abstract class InvoiceCreationController extends BaseGetxController {
  Rx<InvoiceDetailModel> invoiceModel = InvoiceDetailModel().obs;

  RxList<ExtraInfo> listInvExtra = <ExtraInfo>[].obs;
  TextEditingController fieldTextEditingController =
      TextEditingController(text: "Tiền mặt");

  TextEditingController cusNameTextEditingController =
      TextEditingController(text: "Khách lẻ");

  TextEditingController licensePlatesController =
      TextEditingController(text: '29B 4897');

  TextEditingController routeBusNumberController =
      TextEditingController(text: HIVE_APP.get(AppConst.keyRouteBusNumber)?.split(' ').last ?? "");

  var userNameController = TextEditingController(text: 'api');

  var passwordController = TextEditingController();

  final FocusNode emailFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();
  final FocusNode licensePlateFocus = FocusNode();
  final FocusNode routeBusFocus = FocusNode();

  ScrollController scrollController = ScrollController();

  InvoicePattern? invoicePattern;

  HomeController homeController = Get.find<HomeController>();

  AppController appController = Get.find<AppController>();

  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    //Lấy giá trị pattern và serial từ màn danh sách

    getExtra();

    getInvoice();

    super.onInit();
  }

  void getInvoice();

  // Chọn mẫu hóa đơn
  void selectPattern();

  void actionInvoice();

  void getExtra();

  void addInvExtraToXML();

  List<dynamic> listInvExtraRespone();
  
  SetupModel getSetup();
}
