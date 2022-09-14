import 'package:easy_invoice_qlhd/application/app_controller.dart';
import 'package:easy_invoice_qlhd/base/base.dart';
import 'package:easy_invoice_qlhd/const/all_const.dart';
import 'package:easy_invoice_qlhd/hive_local/account.dart';
import 'package:easy_invoice_qlhd/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangeAccController extends BaseGetxController {
  var passwordController = TextEditingController(text: 'admin');

  final formKey = GlobalKey<FormState>();

  RxBool haveAccount = (HIVE_APP.get(AppConst.keyUserName) != null).obs;
  RxBool showIntro = (HIVE_APP.get(AppConst.keyShowIntro) != null).obs;

  AppController appController = Get.find<AppController>();

  Map<int, String> mapAccountEmployee = {};
  Map<int, String> mapShift = {};
  Map<int, String> mapAccountDriver = {};
  Map<int, String> mapLicensePlates = {};
  RxInt idAccount = RxInt(HIVE_APP.get(AppConst.keyCurrentAccount) ?? 0);
  RxInt idShift = RxInt(HIVE_APP.get(AppConst.keyCurrentShift) ?? 0);
  RxInt idAccountDriver =
      RxInt(HIVE_APP.get(AppConst.keyCurrentAccountDriver) ?? 1);
  RxInt idLicensePlates = RxInt(HIVE_APP.get(AppConst.keyCarNo) ?? 0);

  ChangeAccController() {}

  @override
  void onInit() {
    getListAccount();
    getShift();
    getListAccountDriver();
    getListLicensePlates();
    super.onInit();
  }

  Future<void> funcAccept() async {
    void _loginSuccess() {
      HIVE_APP.put(AppConst.keyCurrentAccount, idAccount.value);
      HIVE_APP.put(AppConst.keyCurrentAccountDriver, idAccountDriver.value);
      HIVE_APP.put(AppConst.keyCarNo, idLicensePlates.value);
      // databaseReference.set({
      //   (HIVE_ACCOUNT.get(HIVE_APP.get(AppConst.keyCurrentAccount)) ??
      //           AccountModel())
      //       .toMap()
      // });
      // print('ok');
      appController.isLogin.value = true;
      Get.toNamed(AppConst.routeHome);
      // Get.arguments != null
      //     ? Get.offAndToNamed(AppConst.routeHome)
      //     : Get.back();
    }

    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      KeyBoard.hide();
      AccountModel _accountModel =
          HIVE_ACCOUNT.get(idAccount.value) ?? AccountModel();
      appController.isAdmin.value = _accountModel.type == 0;

      if (_accountModel.password == passwordController.text.trim()) {
        HIVE_APP.put(AppConst.keyCurrentShift, idShift.value);
        _loginSuccess();
      } else {
        showSnackBar(AppStr.loginPasswordNotCorrect);
        return;
      }
    }
  }

  // void loginError() {
  //   passwordController.text = '';
  //   // HIVE_APP.delete(AppConst.keyPassword);
  //   // HIVE_APP.delete(AppConst.keyUrl);
  //   // HIVE_APP.delete(AppConst.keyTaxCodeCompany);
  // }

  // void changeUser() {
  //   if (!isShowLoading.value) {
  //     ShowPopup.showDialogConfirm(
  //       AppStr.loginChangeUserHelp,
  //       confirm: () {
  //         HIVE_APP.delete(AppConst.keyUrl);
  //         HIVE_APP.delete(AppConst.keyUserName);
  //         HIVE_APP.delete(AppConst.keyPassword);
  //         HIVE_APP.delete(AppConst.keyComName);
  //         // HIVE_APP.delete(AppConst.keyTaxCodeCompany);
  //         // taxCodeController.text = '';
  //         userNameController.text = '';
  //         passwordController.text = '';
  //         haveAccount.value = false;
  //       },
  //       actionTitle: AppStr.accept,
  //     );
  //   }
  // }

  // Future<void> quickLogin({
  //   isLoginFormApp = false,
  //   required String newPass,
  // }) async {
  //   try {
  //     if (haveAccount.value) {
  //       userNameController.text = HIVE_APP.get(AppConst.keyUserName);
  //     } else {
  //       HIVE_APP.put(AppConst.keyTaxCodeCompany, taxCodeController.text.trim());
  //     }
  //     LoginResponse userResponse = await loginRepository
  //         .loginUser(LoginModel(userNameController.text.trim(), newPass));

  //     if (userResponse.code == AppConst.codeSuccess) {
  //       HIVE_APP.put(AppConst.keyUserName, userNameController.text.trim());
  //       HIVE_APP.put(AppConst.keyPassword, newPass);
  //       appController.isBusinessHousehold.value =
  //           (userResponse.data.businessType == 1);
  //       AccountPermission accountPermission = AccountPermission();
  //       if (userResponse.data.permission.isNotEmpty) {
  //         accountPermission.checkPermissionAcc(userResponse.data.permission);
  //       }
  //
  //       var bank = await loginRepository.getBank();
  //       await loginRepository.getInvoiceStrip().then(
  //         (value) async {
  //           if (value.isNotEmpty) {
  //             if (!isLoginFormApp &&
  //                 HIVE_APP.get(AppConst.keyPassword) ==
  //                     HIVE_APP.get(AppConst.keyTaxCodeCompany)) {
  //               await Get.to(() => ChangePasswordPage(true));
  //             }
  //             // if (!showIntro.value) {
  //             //   await Get.to(() => const IntroPage());
  //             //   HIVE_APP.put(AppConst.keyShowIntro, showIntro.value);
  //             // }
  //             Get.offAllNamed(AppConst.routeHome, arguments: {
  //               "isSerialCert": userResponse.data?.isSerialCert ?? false,
  //               "listPattern": value,
  //               "accountPermission": accountPermission,
  //               "extra": extraInfo,
  //               "bank": bank,
  //             });
  //             Get.put(HomeController());
  //             Get.put(DashboardController());
  //             Get.put(NotificationController());
  //           } else {
  //             ShowPopup.showDialogNotification(AppStr.loginListPatternEmpty.tr);
  //           }
  //         },
  //       );
  //     } else {
  //       loginError();
  //       String _msg() {
  //         switch (userResponse.code) {
  //           case AppConst.codeBlocked:
  //             return AppStr.loginFailed.tr;

  //           case AppConst.codeAccountNotExist:
  //             return AppStr.loginAccountNotExist.tr;

  //           case AppConst.codePasswordNotCorrect:
  //             return AppStr.loginPasswordNotCorrect.tr;

  //           default:
  //             return userResponse.data;
  //         }
  //       }

  //       showSnackBar(_msg());
  //       if (isLoginFormApp) {
  //         Get.offAndToNamed(AppConst.routeLogin);
  //       }
  //     }
  //   } catch (e) {
  //     loginError();
  //     if (isLoginFormApp) {
  //       Get.offAndToNamed(AppConst.routeLogin);
  //     }
  //   } finally {
  //     hideLoading();
  //   }
  // }

  void getListAccount() {
    mapAccountEmployee = Map.fromIterable(HIVE_ACCOUNT.values,
        key: (e) => e.id, value: (e) => e.nameAccount);
    print(mapAccountEmployee);
  }

  void getShift() {
    mapShift = Map.fromIterable(HIVE_SHIFT.values,
        key: (e) => e.id,
        value: (e) => '${e.nameShift} (${e.startDate} - ${e.endDate})');
  }

  void getListAccountDriver() {
    mapAccountDriver = Map.fromIterable(HIVE_ACCOUNT_DRIVER.values,
        key: (e) => e.id, value: (e) => e.nameAccount);
  }

  void getListLicensePlates() {
    mapLicensePlates = Map.fromIterable(HIVE_LICENSE_PLATES.values,
        key: (e) => e.id, value: (e) => e.nameAccount);
  }
}
