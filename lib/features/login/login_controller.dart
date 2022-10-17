import 'package:easy_invoice_qlhd/application/app_controller.dart';
import 'package:easy_invoice_qlhd/base/base.dart';
import 'package:easy_invoice_qlhd/const/all_const.dart';
import 'package:easy_invoice_qlhd/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../setup_realm/setup_realm.dart';

class LoginController extends BaseGetxController {
  var taxCodeController = TextEditingController(text: '2313123132');

  var userNameController = TextEditingController(text: "Tên công ty mặc định");

  var addressController = TextEditingController(text: "Địa chỉ mặc định");

  var codeController = TextEditingController(text: '123456');

  final formKey = GlobalKey<FormState>();

  RxBool haveAccount = (HIVE_APP.get(AppConst.keyUserName) != null).obs;

  AppController appController = Get.find<AppController>();

  @override
  void onInit() {
    taxCodeController.text = HIVE_APP.get(AppConst.keyTaxCodeCompany) ?? '12131231';
    super.onInit();
  }

  Future<void> funcCheckTaxCode() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      KeyBoard.hide();
      try {
        showLoading();
        if (codeController.text == '123456') {
          HIVE_APP.put(AppConst.keyTaxCodeCompany, taxCodeController.text);
          HIVE_APP.put(AppConst.keyAddress, addressController.text);
          HIVE_APP.put(AppConst.keyComName, userNameController.text);
          HIVE_APP.put(AppConst.keyCodeYear, codeController.text);
          Get.to(() => SetupRealmPage());
        }
      } catch (e) {
      } finally {
        hideLoading();
      }
    }
  }

  void changeUser() {
    if (!isShowLoading.value) {
      ShowPopup.showDialogConfirm(
        AppStr.loginChangeUserHelp,
        confirm: () {
          HIVE_APP.delete(AppConst.keyUserName);
          HIVE_APP.delete(AppConst.keyPassword);
          HIVE_APP.delete(AppConst.keyComName);
          // HIVE_APP.delete(AppConst.keyTaxCodeCompany);
          // taxCodeController.text = '';
          userNameController.text = '';
          addressController.text = '';
          haveAccount.value = false;
          Get.toNamed(AppConst.routeChangeAccount);
        },
        actionTitle: AppStr.accept,
      );
    }
  }
}
