import 'package:easy_invoice_qlhd/features/home/home_controller.dart';
import 'package:easy_invoice_qlhd/hive_local/setup.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../application/app.dart';
import '../../../base/base.dart';
import '../../../const/all_const.dart';
import '../../invoice_detail/invoice_detail.dart';

abstract class TicketController extends BaseGetxController {
  ScrollController scrollController = ScrollController();
  RxList<ProductItem> products = RxList<ProductItem>();
  TextEditingController licensePlatesParkingController =
      TextEditingController();
  Rx<DateTime> dateTime = DateTime.now().obs;
  Rx<DateTime> timeOfDay = Rx<DateTime>(
      (HIVE_APP.get(AppConst.keyTimeOfDay, defaultValue: DateTime.now())));

  HomeController homeController = Get.find<HomeController>();

  AppController appController = Get.find<AppController>();
  late SetupModel setupModel;
  @override
  void onInit() {
    if (HIVE_PRODUCT.isNotEmpty) {
      products.assignAll(HIVE_PRODUCT.values.toList());
    }
    HIVE_PRODUCT.listenable().addListener(() {
      products.assignAll(HIVE_PRODUCT.values.toList());
    });
    setupModel = HIVE_SETUP.get(HIVE_APP.get(AppConst.keyIdPage)) ?? SetupModel();
    super.onInit();
  }

  Future<void> showDateTimePicker();

  String convertCurrentTime();

  void addProduct();

  void updateProduct(String id);

  void deleteProduct(String id);

  //hải phượng
  Future<void> printTicket(ProductItem item);

  String getOrigInvUrl(String portalLink, String fkey, String pattern,
      {String serial = "", String no = "0"});
  String getTitle();
}
