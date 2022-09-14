import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:easy_invoice_qlhd/application/app.dart';
import 'package:easy_invoice_qlhd/base/base.dart';
import 'package:easy_invoice_qlhd/const/all_const.dart';
import 'package:easy_invoice_qlhd/features/invoice/invoice.dart';
import 'package:easy_invoice_qlhd/features/profile/profile.dart';
import 'package:easy_invoice_qlhd/features/ticket/ticket_page.dart';
import 'package:easy_invoice_qlhd/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'home_controller.dart';

class HomePage extends BaseGetWidget<HomeController> {
  // final controllerNoti = Get.find<NotificationController>();
  @override
  HomeController get controller => Get.find<HomeController>();
  @override
  Widget buildWidgets() {
    Get.put(InvoicesControllerImp());
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: AppColors.darkAccentColor,
      statusBarColor: AppColors.statusBarColor(),
    ));
    controller.pageIndex.value = 0;
    return Obx(() => WillPopScope(
          onWillPop: () => onWillPop(),
          child: Stack(
            children: [
              Scaffold(
                body: _buildPageView(),
                bottomNavigationBar: _buildBottomNavigationBar(),
              ),
            ],
          ),
        ));
  }

  //Thêm PageStorageKey vào key của page để lưu trạng thái page hiện tại
  Widget _buildPageView() {
    return PageView(
      physics:
          const NeverScrollableScrollPhysics(), // avoid swipe to change page
      scrollDirection: Axis.horizontal,
      controller: controller.pageController.value,
      onPageChanged: (index) {
        controller.pageIndex.value = index;
      },
      children: <Widget>[
        // DashboardPage(
        //     // key: PageStorageKey("/dashboard"),
        //     ),
        TicketPage(),
        InvoicePage(
          key: const PageStorageKey(AppConst.routeInvoice),
        ),
        // const Text(""),
        // NotificationPage(),

        ProfilePage(),
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    var _badge = HIVE_INVOICE
        .toMap()
        .entries
        .toList()
        .where((element) =>
            element.value.invoiceNo == null || element.value.invoiceNo == 0)
        .length;
    return ConvexAppBar.badge(
      {1: _badge != 0 ? '$_badge' : ''},
      badgeMargin: const EdgeInsets.only(left: 20, bottom: 15, top: 100),
      backgroundColor: AppColors.backgroundHomeColor(),
      color: AppColors.textHomeColor(),
      activeColor: AppColors.iconHomeSelectColor(),
      top: -100,
      // height: 60,
      style: TabStyle.react,
      items: [
        // TabItem(
        //   icon: _buildItem(Icons.dashboard, 0),
        //   title: Get.textScaleFactor == 1
        //       ? AppStr.statistics.tr
        //       : AppStr.statisticsSort.tr,
        // ),
        TabItem(
          icon: _buildItem(Icons.print, 0),
          title: "In vé",
        ),
        TabItem(
          icon: _buildItem(Icons.wysiwyg, 1),
          title: AppStr.ticketTitleList,
        ),
        // const TabItem(
        //   icon: Icon(Icons.add, size: 0, color: AppColors.backgroundColor),
        // ),
        // TabItem(
        //   icon: _buildItem(Icons.notifications, 3),
        //   title: Get.width > 375
        //       ? AppStr.notification.tr
        //       : AppStr
        //           .notificationsort.tr, // giảm text hiển thị với màn hình nhỏ
        // ),

        TabItem(
          icon: _buildItem(Icons.menu_rounded, 2),
          title: AppStr.setting,
        ),
      ],
      initialActiveIndex: controller.pageIndex.value,
      onTap: (int index) => _bottomTapped(index),
    );
  }

  Widget _buildItem(IconData icon, int itemIndex) {
    return Icon(
      icon,
      size: 20,
      color: controller.pageIndex.value == itemIndex
          ? AppColors.iconHomeSelectColor()
          : AppColors.iconHomeColor(),
    );
  }

  void _bottomTapped(int index) {
    controller.pageIndex.value = index;
    // if (index != 2) {
    controller.pageController.value.jumpToPage(index);
    //   if (index == 3) {
    //     controllerNoti.onRefresh();
    //   }
    // }
  }
}
