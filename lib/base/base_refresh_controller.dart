import 'package:easy_invoice_qlhd/base/base.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

abstract class BaseRefreshGetxController extends BaseGetxController {
  /// Controller của smart refresh.
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  ScrollController scrollControllerUpToTop = ScrollController();
  RxBool showBackToTopButton = false.obs;

  /// Hàm load more.
  Future<void> onLoadMore();

  /// Hàm refresh page.
  Future<void> onRefresh();

  @override
  void onInit() {
    scrollControllerUpToTop.addListener(() {
      showBackToTopButton.value = scrollControllerUpToTop.offset >= 100;
    });
    super.onInit();
  }
}
