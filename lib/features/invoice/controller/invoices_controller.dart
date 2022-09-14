import 'package:easy_invoice_qlhd/application/app.dart';
import 'package:easy_invoice_qlhd/base/base.dart';
import 'package:easy_invoice_qlhd/const/all_const.dart';
import 'package:easy_invoice_qlhd/features/home/home_controller.dart';
import 'package:easy_invoice_qlhd/features/invoice_detail/invoice_detail.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../filter/filter_invoice.dart';
import '../invoice.dart';

abstract class InvoicesController extends BaseRefreshGetxController {
  RxList<InvoiceDetailModel> listInvoiceDetailModel =
      <InvoiceDetailModel>[].obs;

  late List<InvoicePattern> listPatternInvoices;

  // bộ lọc hiện tại;
  late FilterInvoiceModel filter;

  RxString patternSerialStr = "".obs;

  List<String> listSearchHistory = [];

  List<String> listSearchNoHistory = [];

  RxBool isFilter =
      false.obs; // true: trạng thái bộ lọc đang hoạt động, false: ngược lại

  RxList<InvoiceList> listSelected = <InvoiceList>[].obs;

  HomeController homeController = Get.find<HomeController>();

  AppController appController = Get.find<AppController>();

  Map<int, String> mapAccount = {};
  Map<int, String> mapShift = {};
  Map<int, String> mapProduct = {};

  RxDouble totalMoney = 0.0.obs;

  @override
  Future<void> onInit() async {
    filter = FilterInvoiceModel();
    getListInvoiceWithFilter();

    var _listHive = HIVE_APP.get(AppConst.hiveFindHistory);
    if (_listHive != null) {
      listSearchHistory = _listHive;
    }

    var _listNoHive = HIVE_APP.get(AppConst.hiveFindNoHistory);
    if (_listNoHive != null) {
      listSearchNoHistory = _listNoHive;
    }
    HIVE_INVOICE.listenable().addListener(() {
      getListInvoiceWithFilter();
    });

    super.onInit();
  }

  @override
  Future<void> onRefresh() async {}

  @override
  Future<void> onLoadMore() async {}

  List<InvoiceStatus> listInvoiceStatusTicket();

  void goToInvDetail(InvoiceDetailModel item);

  void getListAccount();

  void getShift();

  void getProduct();

  void getListInvoiceWithFilter();

  void showFilterPage();

  void showFilterInputSearchInvoiceNo();

  Future<void> printTicket();
}
