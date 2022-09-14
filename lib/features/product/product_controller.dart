import 'package:easy_invoice_qlhd/base/base.dart';
import 'package:easy_invoice_qlhd/const/all_const.dart';
import 'package:easy_invoice_qlhd/features/home/home_controller.dart';
import 'package:easy_invoice_qlhd/features/invoice_detail/invoice_detail.dart';
import 'package:easy_invoice_qlhd/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../extra/extra_respone.dart';
import 'product.dart';

class ProductController extends BasePageSearchController<ProductItem> {
  var listSelected = RxList<ProductItem>();
  RxList<ProductItem> listProduct = RxList<ProductItem>();
  List<ExtraInfo> listProdExtra = <ExtraInfo>[];
  late ProductRepository _productRepository;
  RxInt totalPrices = 0.obs;
  late bool isTaxBill;

  // 0: Chọn hh-dv, 1: danh mục hh-dv
  late int type;

  RxBool isDeleteAllProduct = false.obs;

  HomeController homeController = Get.find<HomeController>();

  @override
  Future<void> onInit() async {
    //scroll app bar
    _productRepository = ProductRepository(this);
    scrollController = ScrollController();
    scrollController.addListener(() {
      scrollOffset.value = scrollController.offset;
    });
    type = Get.arguments;
    listProdExtra
        .addAll(homeController.extraInfoRespone.data!.first.proExtra ?? []);
    await getProducts();

    super.onInit();
  }

  @override
  Future<void> onRefresh() async {
    getProducts();
    refreshListProduct();
  }

  @override
  Future<void> onLoadMore() async {
    pageNumber++;
    var res = await _productRepository.productSearch(BaseRequestListModel(
      key: searchController.value.text.trim(),
      page: pageNumber,
    ));
    preprocessListProduct(res.data);
    refreshController.loadComplete();
    isDeleteAllProduct.value = false;
  }

  @override
  Future<void> functionSearch() async {
    getProducts();
    refreshListProduct();
  }

  Future<void> getProducts() async {
    showLoading();
    pageNumber = 1;
    var res = await _productRepository.productSearch(BaseRequestListModel(
      key: searchController.value.text.trim(),
      page: pageNumber,
    ));
    hideLoading();

    if (res.data.isNotEmpty) {
      totalRecords = res.totalRecords;
      listProduct.clear();
      preprocessListProduct(res.data);
    } else {
      rxList.clear();
    }
  }

  // với màn danh mục hh,dv => refresh danh sách hh khi thay đổi dữ liệu
  void refreshListProduct() {
    if (!isSelectProduct()) {
      listSelected.clear();
      rxList.refresh();
    }
  }

  void preprocessListProduct(List<ProductItem> data) {
    data.forEach((element) {
      ProductItem itemSelected = listSelected.singleWhere(
          (itemCheck) => itemCheck.code == element.code,
          orElse: () => element);
      // Khởi tạo giá trị cho phần mở rộng của sản phẩm nếu chưa được chọn, mặc định rỗng
      // if (itemSelected.listExtraValue.isEmpty)
      //   itemSelected.listExtraValue =
      //       List.generate(listProdExtra.length, (index) => '');
      listProduct.add(itemSelected);
    });
    rxList.assignAll(listProduct);
  }

  void selectAllProduct() {
    listSelected.clear();
    isDeleteAllProduct.value
        ? listSelected.addAll(rxList)
        : listSelected.clear();
    rxList.forEach((element) {
      element.isSelected.value = isDeleteAllProduct.value;
    });
  }

  void choiceItem(ProductItem item) {
    item.isSelected.toggle();
    item.total = item.amount = item.quantityLocal.value * item.price!;

    if (item.isSelected.value) {
      listSelected.add(item);
    } else {
      item.quantityLocal.value = 0;
      listSelected.remove(item);
    }
  }

  void choiceItemDelete(ProductItem item) {
    item.isSelected.toggle();
    item.isSelected.value ? listSelected.add(item) : listSelected.remove(item);
    isDeleteAllProduct.value =
        rxList.where((item) => item.isSelected.value).length == rxList.length;
  }

  Future<void> deleteProduct(
      BaseGetxController controller, List<ProductItem> productItems) async {
    ShowPopup.showDialogConfirm(AppStr.invoiceDetailRemoveContain, confirm: () {
      controller.showLoadingOverlay();
      _productRepository.deleteProduct(productItems).then((value) {
        if (Get.currentRoute == AppConst.routeProduct) {
          searchController.text = '';
          getProducts();
        } else {
          Get.back(result: "refresh");
        }
        showSnackBar(value.message);
        productItems.clear();
      }).whenComplete(
        () => controller.hideLoadingOverlay(),
      );
    },
        actionTitle: AppStr.delete,
        title: listSelected.isEmpty
            ? AppStr.titleDeleteProduct
            : AppConst.deleteProductNumber.trParams(
                {'length': (listSelected.length).toString()}).toString());
  }

  bool isSelectProduct() => type == 0;
}
