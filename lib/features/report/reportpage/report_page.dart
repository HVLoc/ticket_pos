import 'package:easy_invoice_qlhd/application/app.dart';
import 'package:easy_invoice_qlhd/base/base_widget.dart';
import 'package:easy_invoice_qlhd/const/all_const.dart';
import 'package:easy_invoice_qlhd/features/report/report_send_page.dart';
import 'package:easy_invoice_qlhd/features/report/reportpage/report_controller.dart';
import 'package:easy_invoice_qlhd/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReportPage extends BaseGetWidget<ReportController> {
  @override
  Widget buildWidgets() {
    return Scaffold(
      appBar: AppBar(
        title: BaseWidget.buildAppBarTitle(
          AppStr.report,
        ),
      ),
      body: BaseWidget.buildCardBase(Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStr.reportComment,
            style:
                Get.textTheme.subtitle1!.copyWith(fontWeight: FontWeight.bold),
          ).paddingSymmetric(
              horizontal: AppDimens.paddingItemList,
              vertical: AppDimens.paddingVerySmall),
          // ItemUtils.itemLine(
          //   title: AppStr.reportZalo,
          //   imgAsset: AppStr.iconZalo,
          //   func: () async {
          //     if (await canLaunch(AppConst.zalo)) {
          //       await launch(AppConst.zalo,
          //           forceSafariVC: true,
          //           forceWebView: false,
          //           enableJavaScript: true,
          //           statusBarBrightness: Brightness.light);
          //     }
          //   },
          // ),
          // ItemUtils.itemLine(
          //   title: AppStr.phoneNumber,
          //   imgAsset: AppStr.iconPhone,
          //   func: () async {
          //     if (await canLaunch(AppStr.telSupportNumber)) {
          //       await launch(AppStr.telSupportNumber);
          //     }
          //   },
          // ),
          HIVE_APP.get(AppConst.keyTaxCodeCompany) != null
              ? ItemUtils.itemLine(
                  title: AppStr.reportSend,
                  func: () {
                    Get.to(() => FeedbackPage(), arguments: Get.arguments);
                  })
              : Container()
        ],
      )),
    );
  }
}
