import 'package:easy_invoice_qlhd/base/base.dart';
import 'package:easy_invoice_qlhd/const/all_const.dart';
import 'package:easy_invoice_qlhd/features/invoice_detail/invoice_detail.dart';
import 'package:easy_invoice_qlhd/features/search_invoice/search_invoice_controller.dart';
import 'package:easy_invoice_qlhd/hive_local/account.dart';
import 'package:easy_invoice_qlhd/hive_local/setup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:package_info/package_info.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import '../features/home/home_controller.dart';
import '../features/setup_realm/model/introduction_setting_model.dart';
import '../hive_local/shift.dart';

late Box HIVE_APP;
late Box<InvoiceDetailModel> HIVE_INVOICE;
late Box<ProductItem> HIVE_PRODUCT;
late Box<AccountModel> HIVE_ACCOUNT;
late Box<ShiftModel> HIVE_SHIFT;
late Box<SetupModel> HIVE_SETUP;
late Box<AccountModel> HIVE_ACCOUNT_DRIVER;
late Box<AccountModel> HIVE_LICENSE_PLATES;
late Box<Setting> HIVE_SETTING;

late PackageInfo packageInfo;

late bool canPrint = false;

class AppController extends GetxController {
  final RxBool isShowSupportCus = true.obs;

  RxBool isAdmin = false.obs;
  RxBool isLogin = false.obs;

  @override
  void onInit() {
    initHive().then((value) {
      Get.put(BaseRequest(), permanent: true);

      Get.put(BaseGetxController(), permanent: true);

      Get.put(SearchInvoiceController(), permanent: true);

      Get.put(HomeController(), permanent: true);

      if (HIVE_ACCOUNT.isEmpty) {
        // HIVE_APP.put(AppConst.keyUserName, r'api');
        // HIVE_APP.put(AppConst.keyPassword, 'API@${AppStr.companyTaxCode}');
        HIVE_ACCOUNT.add(
          AccountModel(
              id: 0,
              nameAccount: 'admin',
              userName: 'admin',
              password: 'admin',
              type: 0),
        );
        isAdmin.value = true;
      }
      if (HIVE_APP.get(AppConst.keyCurrentAccount) != null) {
        isAdmin.value = HIVE_APP.get(AppConst.keyCurrentAccount) == 0;
        isLogin.value = true;
      }
      // print(HIVE_SETUP);
      // print(HIVE_SETUP.length);
      // print(HIVE_SETUP.values.toList());
      // if (HIVE_SETUP.isEmpty) {
      //   List.generate(5, (i) => i = i + 1).forEach((index) {
      //     HIVE_SETUP.add(SetupModel());
      //   });
      // }
      if (HIVE_APP.get(AppConst.keyIdPage) == null && isAdmin.isTrue) {
        Get.toNamed(AppConst.routeSetupPage);
      }
      try {
        if (isLogin.value) {
          Get.offAllNamed(AppConst.routeHome);
        } else {
          Get.offAndToNamed(AppConst.routeLogin, arguments: "login");
        }

        // HIVE_APP.put(AppConst.keyUserName, 'admin');
        // HIVE_APP.put(AppConst.keyPassword, r'pass!@#$%');
        // HIVE_APP.put(
        //     AppConst.keyUrlPortalLink, 'http://5200297117hd.softdreams.vn');

        // _checkSesionLogin()
        //     ? Get.offAndToNamed(AppConst.routeLogin)
        //     : Get.put(LoginController()).quickLogin(
        //         isLoginFormApp: true,
        //         newPass: HIVE_APP.get(AppConst.keyPassword));
      } catch (e) {
        Get.offAndToNamed(AppConst.routeLogin);
      }
    });

    super.onInit();
  }
}

Future<void> initHive() async {
  WidgetsFlutterBinding.ensureInitialized();
  // if key not exists return null

  final appDocumentDirectory =
      await path_provider.getApplicationDocumentsDirectory();

  Hive.init(appDocumentDirectory.path);
  Hive.registerAdapter(InvoiceDetailModelAdapter());
  Hive.registerAdapter(ProductItemAdapter());
  Hive.registerAdapter(AccountModelAdapter());
  Hive.registerAdapter(ShiftModelAdapter());
  Hive.registerAdapter(SettingAdapter());
  Hive.registerAdapter(SetupModelAdapter());

  HIVE_APP = await Hive.openBox(
    AppStr.appName,
  );
  HIVE_INVOICE = await Hive.openBox(
    'InvoiceDetailModelAdapter',
  );
  HIVE_PRODUCT = await Hive.openBox(
    'ProductItemAdapter',
  );
  HIVE_ACCOUNT = await Hive.openBox(
    'AccountModelAdapter',
  );
  HIVE_SHIFT = await Hive.openBox(
    'ShiftModelAdapter',
  );
  HIVE_SETUP = await Hive.openBox(
    'SetUp',
  );
  HIVE_SETTING = await Hive.openBox(
    'Setting',
  );
  HIVE_ACCOUNT_DRIVER = await Hive.openBox(
    'HIVE_ACCOUNT_DRIVER',
  );
  HIVE_LICENSE_PLATES = await Hive.openBox(
    'HIVE_LICENSE_PLATES',
  );

  packageInfo = await PackageInfo.fromPlatform();
}
