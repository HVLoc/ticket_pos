import 'package:easy_invoice_qlhd/base/base.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends BaseGetxController {
  late Rx<PageController> pageController;

  RxInt pageIndex = 0.obs;

  HomeController() {}

  @override
  Future<void> onInit() async {
    pageController = PageController(initialPage: pageIndex.value).obs;

    super.onInit();
  }
}
