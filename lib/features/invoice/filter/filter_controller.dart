import 'package:easy_invoice_qlhd/base/base.dart';
import 'package:easy_invoice_qlhd/const/all_const.dart';
import 'package:easy_invoice_qlhd/features/invoice/filter/filter_model.dart';
import 'package:easy_invoice_qlhd/features/invoice/invoice.dart';
import 'package:get/get.dart';

class FilterController extends BaseGetxController {
  InvoicesController get invoiceController => Get.find<InvoicesController>();
  List<String> listSearchHistory =
      Get.find<InvoicesController>().listSearchHistory;

  // Giá trị nhập để tìm kiếm hóa đơn theo tên đơn vị, mã KH, MST
  RxString searchInput = Get.find<InvoicesController>().filter.cusKey.obs;

  // Giá trị pattern/serial trước khi apply filter
  RxString filterPatternStr = Get.find<InvoicesController>().filter.pattern.obs;
  RxString filterSerialStr = Get.find<InvoicesController>().filter.serial.obs;

  // Value của bộ lọc loại hoá đơn hiện tại
  RxInt typeChip = Get.find<InvoicesController>().filter.type.obs;

  // Value của bộ lọc trạng thái hoá đơn hiện tại
  RxInt statusChip = Get.find<InvoicesController>().filter.status.obs;

  // Value của bộ lọc trạng thái hoá đơn gửi thuế hiện tại
  RxInt stateTCTCheckStatus =
      Get.find<InvoicesController>().filter.tCTCheckStatus.obs;

  // Giá trị từ ngày/đến ngày của Tuỳ chọn trước khi apply filter
  RxString fromDateStr = Get.find<InvoicesController>().filter.fromDate.obs;
  RxString toDateStr = Get.find<InvoicesController>().filter.toDate.obs;

  Map<int, String> mapAccount = Get.find<InvoicesController>().mapAccount;
  Map<int, String> mapShift = Get.find<InvoicesController>().mapShift;
  Map<int, String> mapProduct = Get.find<InvoicesController>().mapProduct;
  Rx<int?> idAccount = Get.find<InvoicesController>().filter.idAccount.obs;
  Rx<int?> idShift = Get.find<InvoicesController>().filter.idShift.obs;
  Rx<int?> idProduct = Get.find<InvoicesController>().filter.idProduct.obs;
  void updateCurrentFilter() => updateSerialPattern(
      invoiceController.filter.pattern, invoiceController.filter.serial);

  void updateSerialPattern(String pattern, String serial) {
    filterPatternStr.value = pattern;
    filterSerialStr.value = serial;
  }

// list statusInvoice
  final List<ChipFilterModel> listStatus = List.generate(
      AppStr.mapSynchronizedStatus.length,
      (index) => ChipFilterModel(
          title: AppStr.mapSynchronizedStatus.values.toList()[index],
          value: AppStr.mapSynchronizedStatus.keys.toList()[index]));

// list TCTCheckStatus
  final List<ChipFilterModel> listTCTCheckStatus = List.generate(
      AppStr.listTCTCheckStatus.length,
      (index) => ChipFilterModel(
          title: AppStr.listTCTCheckStatus.values.toList()[index].tr,
          value: AppStr.listTCTCheckStatus.keys.toList()[index]));

// list typeInvoice
  final List<ChipFilterModel> listTypeInvoice = List.generate(
      AppStr.listTypeInvoice.length,
      (index) => ChipFilterModel(
          title: AppStr.listTypeInvoice.values.toList()[index].tr,
          value: AppStr.listTypeInvoice.keys.toList()[index]));

  @override
  void onInit() {
    super.onInit();
  }
}
