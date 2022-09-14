import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sunmi_printer_plus/column_maker.dart';
import 'package:sunmi_printer_plus/enums.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';
import 'package:sunmi_printer_plus/sunmi_style.dart';

import '../../../application/app.dart';
import '../../../const/all_const.dart';
import '../../../utils/utils.dart';
import '../../invoice_detail/invoice_detail.dart';
import '../filter/filter_invoice.dart';
import '../invoice.dart';

class InvoicesControllerImp extends InvoicesController {
  @override
  void goToInvDetail(InvoiceDetailModel item) {
    Get.to(
      () => InvoiceDetailPage(),
      arguments: item,
    );
  }

  @override
  void getListAccount() {
    mapAccount = Map.fromIterable(HIVE_ACCOUNT.values,
        key: (e) => e.id, value: (e) => e.nameAccount);
    mapAccount.removeWhere((key, value) => key == 0);
  }

  @override
  void getListInvoiceWithFilter() {
    showLoadingOverlay();
    listInvoiceDetailModel = HIVE_INVOICE
        .toMap()
        .entries
        .map((e) => e.value)
        .where((e) => Get.find<AppController>().isAdmin.isTrue
            ? filter.idAccount != null
                ? e.accountIdPos == filter.idAccount
                : true
            : e.accountIdPos == HIVE_APP.get(AppConst.keyCurrentAccount))
        .where((e) => filter.idProduct != null
            ? e.items.first.id == filter.idProduct
            : true)
        .where((element) =>
            filter.idShift != null ? element.shiftId == filter.idShift : true)
        .where((element) => filter.status == -1
            ? true
            : element.status == null || element.status == filter.status)
        .where((element) => filter.no == ''
            ? true
            : int.tryParse(filter.no) == element.invoiceNo?.toInt())
        .where((element) => (filter.toDate.isStringNotEmpty ||
                filter.fromDate.isStringNotEmpty)
            ? (convertStringToDate(filter.fromDate, PATTERN_1)
                        .microsecondsSinceEpoch <=
                    convertStringToDate(element.arisingDate ?? '', PATTERN_1)
                        .microsecondsSinceEpoch &&
                convertStringToDate(filter.toDate, PATTERN_1)
                    .add(const Duration(days: 1))
                    .isAfter(convertStringToDate(
                        element.arisingDate ?? '', PATTERN_1)))
            : true)
        .toList()
        .obs;
    totalMoney.value = 0;
    listInvoiceDetailModel.forEach((element) {
      totalMoney.value = totalMoney.value + element.amount;
    });
    hideLoadingOverlay();
  }

  @override
  void getShift() {
    mapShift = Map.fromIterable(HIVE_SHIFT.values,
        key: (e) => e.id,
        value: (e) => '${e.nameShift} (${e.startDate} - ${e.endDate})');
  }

  @override
  List<InvoiceStatus> listInvoiceStatusTicket() => [
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
      ];

  @override
  void showFilterPage() {
    if (Get.isRegistered<FilterController>()) {
      Get.find<FilterController>().updateCurrentFilter();
    }
    getListAccount();
    getShift();
    getProduct();
    Get.bottomSheet<FilterInvoiceModel>(
      FilterPage(),
      isScrollControlled: true,
    ).then((value) {
      Get.delete<FilterController>(force: true);
      if (value != null) {
        filter = value;
        getListInvoiceWithFilter();
        isFilter.value = filter != FilterInvoiceModel();
        // getListInvoiceWithFilter().refresh();
        update();
      }
    });
  }

  @override
  void showFilterInputSearchInvoiceNo() {
    Get.bottomSheet<String>(
            FindInvoicePage(
              listKeyword: listSearchNoHistory,
              keyCurrent: filter.no,
              title: AppStr.searchNoTitle_Keyword.tr,
              hint: AppStr.searchNoHint_Keyword.tr,
              textInputType: GetPlatform.isAndroid
                  ? TextInputType.number
                  : TextInputType.text,
              isInvoiceNo: true,
              maxInput: 7,
            ),
            isScrollControlled: true)
        .then((value) {
      if (value != null && value.isNotEmpty) {
        filter = FilterInvoiceModel(
          pattern: filter.pattern,
          serial: filter.serial,
        );
        filter.no = value;
        isFilter.value = true;
        getListInvoiceWithFilter();
      } else if (value == '') {
        filter.no = '';
      }
    });
  }

  @override
  void getProduct() {
    mapProduct = Map.fromIterable(HIVE_PRODUCT.values,
        key: (e) => e.id, value: (e) => e.name);
  }

  @override
  Future<void> printTicket() async {
    try {
      showLoadingOverlay();

      await SunmiPrinter.initPrinter();
      await SunmiPrinter.startTransactionPrint(true);

      String dateStr = filter.fromDate == filter.toDate
          ? filter.fromDate
          : '${filter.fromDate}-${filter.toDate}';
      if (filter.fromDate.isNotEmpty) {
        await SunmiPrinter.setCustomFontSize(20);
        await SunmiPrinter.printText(AppStr.ticketReportDate + ': $dateStr',
            style: SunmiStyle(bold: true));
      }

      await SunmiPrinter.setCustomFontSize(20);
      await SunmiPrinter.printText(
          AppStr.account +
              ': ${HIVE_ACCOUNT.get(HIVE_APP.get(AppConst.keyCurrentAccount))?.nameAccount ?? ''}',
          style: SunmiStyle(bold: true));

      isFilter.value
          ? await _configPrinter()
          : await configPrintWithoutFilter();

      await SunmiPrinter.lineWrap(2); // Jump 2 lines
      await SunmiPrinter.printText('',
          style: SunmiStyle(align: SunmiPrintAlign.CENTER));

      await SunmiPrinter.exitTransactionPrint(true); // Close the transaction

    } finally {
      hideLoadingOverlay();
    }
  }

  Future<void> _configPrinter() async {
    int _amountReport = 0;
    int _amount = 0;
    await SunmiPrinter.line();
    for (var i = 0; i < HIVE_PRODUCT.length; i++) {
      ProductItem? tempProd = HIVE_PRODUCT.getAt(i);
      List<InvoiceDetailModel> tempList = listInvoiceDetailModel
          .where((p0) => p0.items.first.id == tempProd?.id)
          .toList();
      _amount = (tempList.length * (tempProd?.amount ?? 0)).toInt();
      _amountReport += _amount;
      if (tempList.length != 0) {
        await SunmiPrinter.printText('${tempProd?.name}',
            style: SunmiStyle(bold: true));

        await SunmiPrinter.printRow(cols: [
          ColumnMaker(
            text: CurrencyUtils.formatCurrency(tempProd?.amount) +
                ' x ${tempList.length}',
            width: 20,
          ),
          // ColumnMaker(text: tempList.length.toString()),
          ColumnMaker(
            text: CurrencyUtils.formatCurrency(_amount),
            width: 20,
            // align: SunmiPrintAlign.RIGHT,
          ),
        ]);
      }
    }
    await SunmiPrinter.line();
    await SunmiPrinter.printText(
        (AppStr.totalMoney + CurrencyUtils.formatCurrency(_amountReport)),
        style: SunmiStyle(bold: true));
  }

  Future<void> configPrintWithoutFilter() async {
    int _amountReport = 0;
    int _amount = 0;
    listInvoiceDetailModel.forEach((element) {
      dateFilter.add(element.arisingDate);
    });
    print(dateFilter);
    dateFilter = dateFilter.toSet().toList();
    for (int i = 0; i < dateFilter.length; i++) {
      await SunmiPrinter.printText(
          'Ngày ' +
              DateFormat.yMMMMd('vi')
                  .format(convertStringToDate(dateFilter[i] ?? '', PATTERN_1)),
          style: SunmiStyle(
            bold: true,
          ));
      for (var j = 0; j < HIVE_PRODUCT.values.length; j++) {
        ProductItem? tempProd = HIVE_PRODUCT.getAt(j);
        List<InvoiceDetailModel> tempList = filterInvoiceWithDate(dateFilter[i])
            .where((p0) => p0.items.first.id == tempProd?.id)
            .toList();
        if (tempList.length != 0) {
          _amount = (tempList.length * (tempProd?.amount ?? 0)).toInt();
          _amountReport += _amount;
          if (tempList.length != 0) {
            // await SunmiPrinter.printText('${tempProd?.name}',
            //     style: SunmiStyle(bold: true));
            await SunmiPrinter.printRow(cols: [
              ColumnMaker(
                text: CurrencyUtils.formatCurrency(tempProd?.amount) +
                    ' x ${tempList.length}',
                width: 20,
              ),
              // ColumnMaker(text: tempList.length.toString()),
              ColumnMaker(
                text: CurrencyUtils.formatCurrency(_amount),
                width: 20,
                // align: SunmiPrintAlign.RIGHT,
              ),
            ]);
          }
        }
      }
    }
    await SunmiPrinter.line();
    await SunmiPrinter.printText(
        (AppStr.totalMoney + CurrencyUtils.formatCurrency(_amountReport)),
        style: SunmiStyle(bold: true));
  }

  List<String?> dateFilter = [];
  List<InvoiceDetailModel> filterInvoiceWithDate(String? time) {
    return listInvoiceDetailModel
        .where((element) => element.arisingDate == time)
        .toList();
  }
}
