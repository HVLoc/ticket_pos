import 'package:easy_invoice_qlhd/application/app_controller.dart';
import 'package:easy_invoice_qlhd/base/base.dart';
import 'package:easy_invoice_qlhd/const/all_const.dart';
import 'package:easy_invoice_qlhd/features/login/login.dart';
import 'package:easy_invoice_qlhd/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../hive_local/account.dart';
import '../setup_realm/setup_realm.dart';

class LoginController extends BaseGetxController {
  var taxCodeController = TextEditingController();

  var userNameController = TextEditingController(text: "api");

  var passwordController = TextEditingController(text: "Api@2802415041");

  final formKey = GlobalKey<FormState>();

  RxBool haveAccount = (HIVE_APP.get(AppConst.keyUserName) != null).obs;
  RxBool showIntro = (HIVE_APP.get(AppConst.keyShowIntro) != null).obs;

  late LoginRepository loginRepository;

  AppController appController = Get.find<AppController>();

  LoginController() {
    this.loginRepository = LoginRepository(this);
  }

  @override
  void onInit() {
    taxCodeController.text =
        HIVE_APP.get(AppConst.keyTaxCodeCompany) ?? "2802415041";
    super.onInit();
  }

  Future<void> funcCheckTaxCode() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      KeyBoard.hide();
      try {
        if (haveAccount.value) {
          userNameController.text = HIVE_APP.get(AppConst.keyUserName);
        } else {
          HIVE_APP.put(
              AppConst.keyTaxCodeCompany, taxCodeController.text.trim());
        }
        showLoading();
        await loginRepository.checkTaxCode(taxCodeController.text.trim(), (e) {
          ShowPopup.showErrorMessage(AppStr.error302.tr);
        }).then((value) async {
          HIVE_APP.put(
              AppConst.keyUrl, value.publishDomain.replaceAll(':7878', ''));
          HIVE_APP.put(AppConst.keyTaxCodeCompany, value.taxCode.trim());
          HIVE_APP.put(AppConst.keyComName, value.name);
          await funcLogin();
        });
      } finally {
        hideLoading();
      }
    }
  }

  Future<void> funcLogin() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      KeyBoard.hide();
      showLoading();
      await quickLogin(newPass: passwordController.text.trim()).then((value) =>
          HIVE_APP.put(AppConst.keyLoginFirstTimeSesion, DateTime.now()));
    }
  }

  void loginError() {
    // passwordController.text = '';
    // HIVE_APP.delete(AppConst.keyPassword);
    // HIVE_APP.delete(AppConst.keyUrl);
    // HIVE_APP.delete(AppConst.keyTaxCodeCompany);
  }

  void changeUser() {
    if (!isShowLoading.value) {
      ShowPopup.showDialogConfirm(
        AppStr.loginChangeUserHelp,
        confirm: () {
          HIVE_APP.delete(AppConst.keyUrl);
          HIVE_APP.delete(AppConst.keyUserName);
          HIVE_APP.delete(AppConst.keyPassword);
          HIVE_APP.delete(AppConst.keyComName);
          // HIVE_APP.delete(AppConst.keyTaxCodeCompany);
          // taxCodeController.text = '';
          userNameController.text = '';
          passwordController.text = '';
          haveAccount.value = false;
          Get.toNamed(AppConst.routeChangeAccount);
        },
        actionTitle: AppStr.accept,
      );
    }
  }

  Future<void> quickLogin({
    isLoginFormApp = false,
    required String newPass,
  }) async {
    try {
      if (haveAccount.value) {
        userNameController.text = HIVE_APP.get(AppConst.keyUserName);
      } else {
        HIVE_APP.put(AppConst.keyTaxCodeCompany, taxCodeController.text.trim());
      }
      LoginResponse userResponse = await loginRepository
          .loginUser(LoginModel(userNameController.text.trim(), newPass));
      if (userResponse.code == AppConst.codeSuccess) {
        try {
         
          HIVE_APP.put(AppConst.keyUserName, userNameController.text.trim());
          HIVE_APP.put(AppConst.keyPassword, newPass);
          if (HIVE_ACCOUNT.isEmpty) {
            HIVE_ACCOUNT.add(AccountModel(
                id: 0,
                nameAccount: 'admin',
                userName: 'admin',
                password: 'admin',
                type: 0));
          }
          HIVE_APP.put(AppConst.keyCurrentAccount, HIVE_ACCOUNT.values.last.id);
          Get.to(() => SetupRealmPage());
        } catch (e) {
          print(e);
        }

      } else {
        loginError();
        String _msg() {
          switch (userResponse.code) {
            case AppConst.codeBlocked:
              return AppStr.loginFailed.tr;

            case AppConst.codeAccountNotExist:
              return AppStr.loginAccountNotExist.tr;

            case AppConst.codePasswordNotCorrect:
              return AppStr.loginPasswordNotCorrect.tr;

            default:
              return userResponse.data;
          }
        }

        showSnackBar(_msg());
        if (isLoginFormApp) {
          Get.offAndToNamed(AppConst.routeLogin);
        }
      }
    } catch (e) {
      loginError();
      if (isLoginFormApp) {
        Get.offAndToNamed(AppConst.routeLogin);
      }
    } finally {
      hideLoading();
    }
  }
}
