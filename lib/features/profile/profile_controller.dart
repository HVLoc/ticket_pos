import 'package:easy_invoice_qlhd/application/app_controller.dart';
import 'package:easy_invoice_qlhd/base/base.dart';
import 'package:easy_invoice_qlhd/const/all_const.dart';
import 'package:easy_invoice_qlhd/features/home/home_controller.dart';
import 'package:get/get.dart';

class ProfileController extends BaseGetxController {
  HomeController homeController = Get.find<HomeController>();
  AppController appController = Get.find<AppController>();
  Future<void> sendLogout() async {
    logoutSuccess();
  }

  Future<void> logoutSuccess() async {
    HIVE_APP.delete(AppConst.keyCurrentAccount);
    HIVE_APP.delete(AppConst.keyCurrentShift);
    HIVE_APP.delete(AppConst.keyCurrentAccountDriver);
    appController.isAdmin.value = false;
    appController.isLogin.value = false;
  }
}
