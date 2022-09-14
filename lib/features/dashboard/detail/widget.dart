// import 'package:easy_invoice_qlhd/application/firebase_database.dart';
// import 'package:easy_invoice_qlhd/const/all_const.dart';
// import 'package:easy_invoice_qlhd/features/dashboard/detail/dashboard_detail_controller.dart';
// import 'package:flutter/material.dart';

// Widget buildInvoiceExtendWidgets(DashBoardDetailController controller) {
//   final InvoiceExtendRetStr iExtend = controller.invoiceExtend.value;
//   return iExtend.dataLengthStr.isNotEmpty &&
//           iExtend.totalExtendNumber.isNotEmpty
//       ? RichText(
//           text: TextSpan(
//               text: iExtend.leadingStr,
//               children: [
//                 TextSpan(
//                   text: iExtend.dataLengthStr,
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 18,
//                   ),
//                 ),
//                 TextSpan(
//                   text: iExtend.subContentStr,
//                 ),
//                 TextSpan(
//                   text: iExtend.totalExtendNumber,
//                   style: const TextStyle(
//                     color: AppColors.colorInvoicesAdjust,
//                   ),
//                 )
//               ],
//               style: const TextStyle(color: Colors.white70)),
//         )
//       : const SizedBox();
// }
