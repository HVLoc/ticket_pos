// import 'package:easy_invoice_qlhd/application/firebase_database.dart';
// import 'package:easy_invoice_qlhd/base/base.dart';
// import 'package:easy_invoice_qlhd/const/all_const.dart';
// import 'package:easy_invoice_qlhd/features/dashboard/hmtl_view_page/html_inappview/html_viewer.dart';
// import 'package:easy_invoice_qlhd/features/invoice/invoice.dart';
// import 'package:easy_invoice_qlhd/utils/utils.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import '../dashboard_controller.dart';
// import 'dashboard_detail_controller.dart';

// class PatternItemDetailPage extends BaseGetWidget<DashBoardDetailController> {
//   final List<InvoicePattern> invoicePatterns;
//   final InvoicePattern invoicePattern;

//   PatternItemDetailPage(
//     this.invoicePatterns,
//     this.invoicePattern,
//   );

//   @override
//   DashBoardDetailController get controller => Get.put(DashBoardDetailController(
//         invoicePattern.pattern,
//         invoicePattern.serial,
//       ));

//   @override
//   Widget buildWidgets() {
//     return Scaffold(
//       appBar: AppBar(
//         title: BaseWidget.buildAppBarTitle(AppStr.detailPattern),
//         centerTitle: true,
//         actions: [
//           IconButton(
//               onPressed: () {
//                 if (!controller.isLoadingOverlay.value)
//                   controller.getHtmlViewer().then((value) {
//                     if (value != null) {
//                       Get.to(() => HtmlViewerPage(), arguments: value.data);
//                     }
//                   });
//               },
//               icon: const Icon(Icons.find_in_page_rounded)
//                   .paddingOnly(right: AppDimens.paddingVerySmall)),
//         ],
//         actionsIconTheme: IconThemeData(color: AppColors.textColor()),
//       ),
//       body: _buildBody(),
//     );
//   }

//   Widget _buildBody() {
//     return buildLoadingOverlay(
//       () => Container(
//         child: Column(children: [
//           Expanded(
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   buildInfor(),
//                   ListView.builder(
//                       physics: const NeverScrollableScrollPhysics(),
//                       itemCount: invoicePatterns.length,
//                       shrinkWrap: true,
//                       reverse: true,
//                       itemBuilder: (_, idx) {
//                         return _buildHistoryPattern(invoicePatterns[idx]);
//                       }),
//                 ],
//               ),
//             ),
//           ),
//           BaseWidget.sizedBoxPadding,
//           if (!KeyBoard.keyboardIsVisible())
//             BaseWidget.buildButton(AppStr.invoiceExtend, () {
//               ShowPopup.showDialogInvoiceExtendInput(
//                   (invoicePattern.toNo - invoicePattern.currentUsedApp).toInt(),
//                   function: (invoiceNumberStr, phoneStr) async {
//                 controller.invoiceExtend.value =
//                     await FirebaseDataBase.sendInvoiceExtendData(
//                         invoicePattern.pattern,
//                         invoicePattern.serial,
//                         invoiceNumberStr,
//                         phone: phoneStr);
//               }, nameAction: AppStr.send.tr);
//             }, colors: AppColors.colorGradientOrange)
//                 .paddingOnly(bottom: AppDimens.defaultPadding)
//         ]).paddingAll(AppDimens.defaultPadding),
//       ),
//     );
//   }

//   Widget buildInfor() {
//     return BaseWidget.buildCardBase(
//       Column(
//         children: [
//           buildFilterSerialPattern(
//                   invoicePattern.pattern, invoicePattern.serial,
//                   style: Get.textTheme.headline4)
//               .paddingSymmetric(vertical: AppDimens.paddingSmall),
//           Get.find<DashboardController>()
//               .getTitlePatternDetail(invoicePattern.statusApp)
//               .paddingOnly(bottom: AppDimens.defaultPadding),
//           _rowItem(AppStr.currentNo.tr,
//               formatInvoiceNo(invoicePattern.currentUsedApp)),
//           BaseWidget.buildDivider(),
//           _rowItem(
//               AppStr.remainsInvNo.tr,
//               (invoicePattern.toNo - invoicePattern.currentUsedApp)
//                   .toInt()
//                   .toString()),
//           BaseWidget.buildDivider(),
//           _rowItem(
//             AppStr.dashBoardTotalInvoice.tr,
//             invoicePattern.toNo.toInt().toString(),
//           ),
//         ],
//       ).paddingAll(AppDimens.paddingSmall),
//     ).paddingOnly(bottom: AppDimens.defaultPadding);
//   }

//   Widget _buildHistoryPattern(InvoicePattern item) {
//     return BaseWidget.buildCardBase(
//       Column(
//         children: [
//           _rowItem(AppStr.fromNo.tr, formatInvoiceNo(item.fromNo)),
//           BaseWidget.buildDivider(),
//           _rowItem(AppStr.toNo.tr, formatInvoiceNo(item.toNo)),
//           BaseWidget.buildDivider(),
//           _rowItem(
//             AppStr.statusPattern.tr,
//             item.statusSerial().tr,
//           ),
//           BaseWidget.buildDivider(),
//           _rowItem(
//             AppStr.startDate.tr,
//             convertDateToString(
//                 convertStringToDate(item.startDate, PATTERN_8), PATTERN_1),
//           ),
//         ],
//       ).paddingAll(AppDimens.paddingSmall),
//     ).paddingOnly(bottom: AppDimens.defaultPadding);
//   }

//   Widget _rowItem(
//     String title,
//     String value,
//   ) =>
//       Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             title,
//             style: Get.textTheme.bodyText2,
//           ),
//           Text(
//             value,
//             style: Get.textTheme.bodyText1!.copyWith(
//               fontSize: AppDimens.fontMedium(),
//             ),
//           ),
//         ],
//       ).paddingSymmetric(vertical: AppDimens.paddingSmall);
// }
