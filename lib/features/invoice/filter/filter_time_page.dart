import 'package:easy_invoice_qlhd/const/all_const.dart';
import 'package:easy_invoice_qlhd/features/invoice/filter/filter_model.dart';
import 'package:easy_invoice_qlhd/features/invoice/filter/filter_utils.dart';
import 'package:easy_invoice_qlhd/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';

Widget FilterTimePage({bool isFromFilter = false}) {
  // set DATETIME
  final DateTime _today = DateTime.now();
  final DateTime firstDayOfWeek =
      Jiffy(_today).subtract(days: _today.weekday - 1).dateTime;
  final DateTime lastDayOfWeek = Jiffy(firstDayOfWeek).add(days: 6).dateTime;
  final DateTime firstDayOfMonth = DateTime(_today.year, _today.month);
  final DateTime lastDayOfMonth =
      Jiffy(Jiffy(firstDayOfMonth).add(months: 1)).subtract(days: 1).dateTime;
  final DateTime firstDayOfYear = DateTime(_today.year);
  final DateTime lastDayOfYear =
      Jiffy(firstDayOfYear).add(years: 1, days: -1).dateTime;
  DateTime theFirstOfMonth(int month) => DateTime(_today.year, month);
  DateTime theLastOfMonth(int month) => DateTime(_today.year, month + 1, 0);
  DateTime firstDayOfQuarter(int quarter) =>
      DateTime(_today.year, (quarter - 1) * 3 + 1);
  DateTime lastDayOfQuarter(int quarter) =>
      DateTime(_today.year, quarter * 3 + 1, 0);

// list TimeQuick
  final List<ChipFilterModel> _listTimeQuick = [
    ChipFilterModel(
      title: AppStr.today.tr,
      fromDate: formatDateTimeToString(_today),
      toDate: formatDateTimeToString(_today),
    ),
    ChipFilterModel(
      title: AppStr.thisWeek.tr,
      fromDate: formatDateTimeToString(firstDayOfWeek),
      toDate: formatDateTimeToString(lastDayOfWeek),
    ),
    ChipFilterModel(
      title: AppStr.thisMonth.tr,
      fromDate: formatDateTimeToString(firstDayOfMonth),
      toDate: formatDateTimeToString(lastDayOfMonth),
    ),
    ChipFilterModel(
      title: AppStr.thisYear.tr,
      fromDate: formatDateTimeToString(firstDayOfYear),
      toDate: formatDateTimeToString(lastDayOfYear),
    ),
  ];

  // list TimeQuater
  final List<ChipFilterModel> _listTimeQuarter = [
    ChipFilterModel(
      title: AppStr.quarterOne.tr,
      fromDate: formatDateTimeToString(firstDayOfQuarter(1)),
      toDate: formatDateTimeToString(lastDayOfQuarter(1)),
    ),
    ChipFilterModel(
      title: AppStr.quarterTwo.tr,
      fromDate: formatDateTimeToString(firstDayOfQuarter(2)),
      toDate: formatDateTimeToString(lastDayOfQuarter(2)),
    ),
    ChipFilterModel(
      title: AppStr.quarterThree.tr,
      fromDate: formatDateTimeToString(firstDayOfQuarter(3)),
      toDate: formatDateTimeToString(lastDayOfQuarter(3)),
    ),
    ChipFilterModel(
      title: AppStr.quarterFour.tr,
      fromDate: formatDateTimeToString(firstDayOfQuarter(4)),
      toDate: formatDateTimeToString(lastDayOfQuarter(4)),
    ),
  ];

  // list TimeMonth
  List<ChipFilterModel> _listTimeMonth = List.generate(
    AppStr.listMonth.length,
    (index) => ChipFilterModel(
      title: AppStr.listMonth[index].tr,
      fromDate: formatDateTimeToString(theFirstOfMonth(index + 1)),
      toDate: formatDateTimeToString(theLastOfMonth(index + 1)),
    ),
  );
  return BaseWidget.baseBottomSheet(
      title: AppStr.choiceTime,
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildListViewChipTime(
              _listTimeQuick,
              AppStr.suggestion.tr,
              onSelectedFunc: (item) => Get.back(result: item),
            ),
            buildListViewChipTime(
              _listTimeMonth,
              AppStr.month.tr,
              onSelectedFunc: (item) => Get.back(result: item),
            ),
            buildListViewChipTime(
              _listTimeQuarter,
              AppStr.quarter.tr,
              onSelectedFunc: (item) => Get.back(result: item),
            ),
          ],
        ),
      ),
      isSecondDisplay: isFromFilter);
}
