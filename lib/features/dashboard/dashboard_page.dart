import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_invoice_qlhd/application/app.dart';
import 'package:easy_invoice_qlhd/base/base_refresh_widget.dart';
import 'package:easy_invoice_qlhd/const/all_const.dart';
import 'package:easy_invoice_qlhd/features/dashboard/model/dashboard_request.dart';
import 'package:easy_invoice_qlhd/features/invoice/filter/filter_model.dart';
import 'package:easy_invoice_qlhd/features/invoice/filter/filter_utils.dart';
import 'package:easy_invoice_qlhd/features/invoice/invoice.dart';
import 'package:easy_invoice_qlhd/utils/utils.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';

import 'dashboard.dart';

part 'dashboard_bar_widget.dart';
part 'dashboard_pie_widget.dart';
part 'dashboard_widget.dart';

class DashboardPage extends BaseRefreshWidget<DashboardController> {
  @override
  Widget buildWidgets() {
    return SafeArea(
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scroll) {
          return controller.isScrollView(scroll);
        },
        child: baseShimmerLoading(
          _buildBody,
          shimmer: Column(
            children: [
              const SizedBox(height: AppDimens.paddingSmall),
              // _buildFilter(controller),
              Expanded(
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppColors.textColor(),
                    strokeWidth: 3,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    Widget _sizedBox = const SizedBox(height: AppDimens.paddingSmall);
    return buildPage(
        body: Stack(children: [
          BaseWidget.buildSmartRefresher(
            scrollController: controller.scrollController,
            refreshController: controller.refreshController,
            onRefresh: controller.onRefresh,
            enablePullUp: false,
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _sizedBox,
                  _buildFilter(controller),
                  _sizedBox,
                  buildListSerial(controller),
                  _sizedBox,
                  _buildCardInfor(),
                  _sizedBox,
                  barChart(controller),
                  _sizedBox,
                  pieChart(controller),
                  const SizedBox(height: AppDimens.paddingHuge),
                ],
              ),
            ),
          ),
          Obx(
            () => IgnorePointer(
              ignoring: !controller.isShowAppBar.value,
              child: AnimatedOpacity(
                  curve: Curves.easeIn,
                  duration: const Duration(milliseconds: 300),
                  opacity: controller.isShowAppBar.value ? 1.0 : 0.0,
                  child: controller.isShowAppBar.value
                      ? buildAppBarPin(controller)
                      : null),
            ),
          ),
        ]),
        isShowSupportCus: Get.find<AppController>().isShowSupportCus);
  }

  Widget _buildCardInfor() {
    return buildCardDashBoard(
        AppStr.dashboardInvoiceTotal.tr.toUpperCase() +
            controller.currentTimeFilter(),
        controller.invoiceStatistics != null
            ? [
                buildCardInforItem(
                  AppStr.totalAmount.tr,
                  GestureDetector(
                    onTap: controller.showToolTip,
                    child: Tooltip(
                      key: controller.keyToolTip,
                      preferBelow: false,
                      message: NumberFormat.currency(
                            locale: 'en_US',
                            symbol: '',
                            decimalDigits: 0,
                          ).format(
                            double.tryParse(controller
                                    .invoiceStatistics?.data.totalAmount ??
                                '0'),
                          ) +
                          ' ' +
                          AppConst.vnd,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            CurrencyUtils.formatMoney(double.tryParse(controller
                                        .invoiceStatistics!.data.totalAmount)
                                    ?.toInt() ??
                                0),
                            style: Get.textTheme.headline4,
                          ),
                          const Icon(
                            Icons.info,
                            color: AppColors.systemIconColor,
                            size: 15,
                          ).paddingOnly(left: 3),
                        ],
                      ),
                    ),
                  ),
                ).paddingSymmetric(vertical: AppDimens.defaultPadding),
                BaseWidget.buildDivider().paddingOnly(
                  bottom: AppDimens.defaultPadding,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: buildCardInforItem(
                            AppStr.dashboardTotalUsed.tr,
                            Text(
                              CurrencyUtils.formatCurrencyForeign(
                                  double.tryParse(controller.invoiceStatistics!
                                              .data.totalUsed)
                                          ?.toInt() ??
                                      0),
                              style: Get.textTheme.headline4,
                            )),
                      ),
                      Expanded(
                        child: buildCardInforItem(
                            AppStr.totalRemain.tr,
                            Text(
                              CurrencyUtils.formatCurrencyForeign(
                                  double.tryParse(controller.invoiceStatistics!
                                              .data.totalRemained)
                                          ?.toInt() ??
                                      0),
                              style: Get.textTheme.headline4,
                            )),
                      ),
                    ])
              ]
            : [BaseWidget.buildImgLostConnect()]);
  }
}
