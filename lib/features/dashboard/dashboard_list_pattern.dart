import 'package:easy_invoice_qlhd/const/all_const.dart';
import 'package:easy_invoice_qlhd/features/dashboard/dashboard.dart';
import 'package:easy_invoice_qlhd/features/invoice/invoice.dart';
import 'package:easy_invoice_qlhd/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PatternListPage extends StatelessWidget {
  final DashboardController controller = Get.find<DashboardController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BaseWidget.buildAppBarTitle(AppStr.listPattern.tr),
      ),
      body: Container(
        child: ListView.builder(
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return buildItem(controller.listPatternDashBoard[index]);
            },
            itemCount: controller.listPatternDashBoard.length),
      ),
    );
  }

  Widget buildItem(InvoicePattern invoicePattern) {
    return BaseWidget.baseOnAction(
      onTap: () {},
      child: BaseWidget.buildCardBase(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                controller.getTitlePatternDetail(invoicePattern.statusApp),
                Text(
                  AppStr.view.tr,
                  style: Get.textTheme.bodyText2!
                      .copyWith(color: AppColors.linkText()),
                ),
              ],
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildFilterSerialPattern(
                            invoicePattern.pattern, invoicePattern.serial,
                            style: Get.textTheme.headline6)
                        .paddingAll(AppDimens.defaultPadding),
                  ],
                ),
                Row(
                  children: [
                    _collumnItem(
                      AppStr.remainsInvNo.tr,
                      (invoicePattern.toNo - invoicePattern.currentUsedApp)
                          .toInt()
                          .toString(),
                      isBold: true,
                    ),
                    _collumnItem(
                      AppStr.dashBoardTotalInvoice.tr,
                      // formatInvoiceNo(invoicePattern.toNo),
                      // CurrencyUtils.formatCurrencyForeign(
                      invoicePattern.toNo.toInt().toString(),
                      // ),
                      crossAxisAlignment: CrossAxisAlignment.end,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ).paddingAll(AppDimens.defaultPadding),
        colorBorder: AppColors.borderCard(),
      ).paddingSymmetric(
          horizontal: AppDimens.paddingSmall,
          vertical: AppDimens.paddingVerySmall),
    );
  }

  Widget _collumnItem(
    String title,
    String value, {
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start,
    bool isBold = false,
  }) =>
      Expanded(
          child: Column(
        crossAxisAlignment: crossAxisAlignment,
        children: [
          Text(
            title,
            style: Get.textTheme.bodyText2,
          ).paddingSymmetric(vertical: AppDimens.paddingVerySmall),
          Text(
            value,
            style: Get.textTheme.bodyText1!.copyWith(
              fontSize: AppDimens.fontBig(),
              fontWeight: isBold ? FontWeight.bold : null,
            ),
          ),
        ],
      ).paddingSymmetric(vertical: AppDimens.paddingSmall));
}
