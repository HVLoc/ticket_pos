import 'package:easy_invoice_qlhd/application/app.dart';
import 'package:easy_invoice_qlhd/base/base.dart';
import 'package:easy_invoice_qlhd/features/home/home_controller.dart';
import 'package:easy_invoice_qlhd/hive_local/setup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../const/all_const.dart';

abstract class InvoiceCreationController extends BaseGetxController {
  TextEditingController fieldTextEditingController =
      TextEditingController(text: "Tiền mặt");

  TextEditingController cusNameTextEditingController =
      TextEditingController(text: "Khách lẻ");

  TextEditingController licensePlatesController =
      TextEditingController(text: '29B 4897');

  TextEditingController routeBusNumberController = TextEditingController(
      text: HIVE_APP.get(AppConst.keyRouteBusNumber)?.split(' ').last ?? "");

  final FocusNode emailFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();
  final FocusNode licensePlateFocus = FocusNode();
  final FocusNode routeBusFocus = FocusNode();

  ScrollController scrollController = ScrollController();

  HomeController homeController = Get.find<HomeController>();

  AppController appController = Get.find<AppController>();

  final formKey = GlobalKey<FormState>();
  
  void actionInvoice();

  SetupModel getSetup();
}
