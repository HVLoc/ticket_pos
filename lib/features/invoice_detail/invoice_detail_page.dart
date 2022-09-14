import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_invoice_qlhd/base/base.dart';
import 'package:easy_invoice_qlhd/const/all_const.dart';
import 'package:easy_invoice_qlhd/features/invoice/invoice.dart';
import 'package:easy_invoice_qlhd/features/invoice_detail/invoice_detail_controller.dart';
import 'package:easy_invoice_qlhd/features/invoice_detail/model/invoice_detail_response.dart';
import 'package:easy_invoice_qlhd/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

part 'invoice_detail_widget.dart';

class InvoiceDetailPage extends BaseGetWidget<InvoiceDetailController> {
  InvoiceDetailPage();

  @override
  InvoiceDetailController get controller => Get.put(InvoiceDetailController());
  @override
  Widget buildWidgets() {
    return BaseWidget.buildSafeArea(Scaffold(
      backgroundColor: AppColors.appBarColor(),
      body: NestedScrollView(
        physics: const PageScrollPhysics(),
        controller: controller.scrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return _buildAppBarScroll();
        },
        body: baseShowLoading(
          () => buildLoadingOverlay(() => Column(
                children: [
                  Expanded(
                    child: listProduct(controller),
                  ),
                ],
              )),
        ),
      ),
    ));
  }

  List<Widget> _buildAppBarScroll() {
    return <Widget>[
      Obx(
        () => SliverAppBar(
          floating: false,
          pinned: false,
          automaticallyImplyLeading: controller.isScrollToTop(),
          flexibleSpace: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            return FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              title: Obx(
                () => AutoSizeText(
                  (controller.invoiceDetailModel.value.invoiceNo ?? 0) != 0 ||
                          controller.isShowLoading.value
                      ? formatInvoiceNo(
                          controller.invoiceDetailModel.value.invoiceNo ?? 0)
                      : AppStr.invoice.tr,
                  style: Get.textTheme.headline4,
                ),
              ),
            );
          }),
        ),
      ),
      Obx(
        () => SliverAppBar(
          pinned: true,
          floating: true,
          elevation: 0,
          collapsedHeight: !controller.isScrollToTop()
              ? AppDimens.sizeAppBarMedium
              : AppDimens.sizeAppBarSmall,
          expandedHeight: !controller.isScrollToTop()
              ? AppDimens.sizeAppBarMedium
              : AppDimens.sizeAppBarSmall,
          toolbarHeight: 30,
          automaticallyImplyLeading: !controller.isScrollToTop(),
          flexibleSpace: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  child: Obx(() => AutoSizeText(
                        controller.isShowLoading.value
                            ? ''
                            : controller.invoiceDetailModel.value.cusName
                                    .isStringNotEmpty
                                ? controller.invoiceDetailModel.value.cusName ??
                                    ''
                                : controller.invoiceDetailModel.value.buyer ??
                                    '',
                        maxLines: 2,
                        style: Get.textTheme.bodyText1,
                      )),
                ),
                controller.isScrollToTop()
                    ? Container()
                    : AutoSizeText(
                        CurrencyUtils.formatCurrency(
                            controller.invoiceDetailModel.value.amount),
                        style: Get.textTheme.bodyText1!
                            .copyWith(fontWeight: FontWeight.normal),
                      ),
              ],
            ).paddingOnly(
                left: !controller.isScrollToTop()
                    ? AppDimens.paddingSearchBarBig
                    : AppDimens.paddingSearchBarSmall,
                right: !controller.isScrollToTop()
                    ? AppDimens.paddingSearchBar
                    : AppDimens.paddingSearchBarSmall,
                top: !controller.isScrollToTop() ? AppDimens.paddingMedium : 0),
          ),
        ),
      ),
    ];
  }
}
