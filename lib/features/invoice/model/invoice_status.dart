import 'package:easy_invoice_qlhd/const/all_const.dart';
import 'package:flutter/material.dart';

class InvoiceStatus {
  final int status;
  final String title;
  final Color colorTitle;
  final Color? colorBackground;

  InvoiceStatus(
    this.status,
    this.title,
    this.colorBackground, {
    this.colorTitle = Colors.white70,
  });
}

/// -1:Hóa đơn chờ ký số
/// 0: Hóa đơn mới tạo lập
/// 1: Hóa đơn có chữ ký số
/// 2: Hóa đơn đã khai báo thuế
/// 3: Hóa đơn bị thay thế
/// 4: Hóa đơn bị điều chỉnh
/// 5: Hóa đơn bị hủy
/// 6: Hóa đơn đã duyệt
List<InvoiceStatus> listInvoiceStatus() => [
      InvoiceStatus(
        -1,
        AppStr.invoiceStatusWait,
        AppColors.invoiceStatusWait(),
      ),
      InvoiceStatus(
        0,
        AppStr.invoiceStatusNewly,
        const Color(0x6682c341),
        colorTitle: AppColors.hintTextColor(),
      ),
      InvoiceStatus(
        1,
        AppStr.invoiceStatusPublished, //HD có CKS
        // AppColors.invoiceStatusPublished(),
        const Color(0xff00CF97),
        colorTitle: Colors.white,
      ),
      InvoiceStatus(
        2,
        AppStr.invoiceStatusTaxDeclared,
        AppColors.invoiceStatusTaxDeclared(),
      ),
      InvoiceStatus(
        3,
        AppStr.invoiceStatusReplaced,
        const Color(0xFFFF4747),
        // AppColors.invoiceStatusReplaced(),
      ),
      InvoiceStatus(
        4,
        AppStr.invoiceStatusHandle,
        const Color(0xFFff7e5f),
      ),
      InvoiceStatus(
        5,
        AppStr.invoiceStatusCanceled, //HD bị hủy
        AppColors.invoiceStatusCanceled(),
      ),
      InvoiceStatus(
        6,
        AppStr.invoiceStatusApproved,
        AppColors.invoiceStatusApproved(),
      ),
    ];
