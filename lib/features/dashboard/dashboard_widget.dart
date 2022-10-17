part of 'dashboard_page.dart';

Widget buildHeaderTitle(String title, {Widget? widgetUtils}) {
  return Row(
    children: [
      Expanded(
        child: AutoSizeText(
          title,
          style:
              Get.textTheme.bodyText2!.copyWith(fontWeight: FontWeight.normal),
        ),
      ),
      if (widgetUtils != null) widgetUtils
    ],
  );
}

Widget buildListSerial(DashboardController controller) {
  return BaseWidget.baseOnAction(
    onTap: () => Get.to(() => PatternListPage()),
    child: BaseWidget.buildCardBase(Column(
      key: controller.hidingAppBarKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        buildHeaderTitle(
          AppStr.listPattern.tr.toUpperCase(),
          widgetUtils: Text(
            AppStr.seeMore.tr,
            style: TextStyle(color: AppColors.linkText()),
          ),
        ).paddingOnly(bottom: AppDimens.defaultPadding),
        Container(
          margin: const EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
            color: AppColors.cardBackgroundOrange(),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return buildItem(controller.listPatternDashBoard[index]);
                  },
                  separatorBuilder: (context, index) => const Divider(
                        height: 1,
                        color: AppColors.hintTextSolidColor,
                      ),
                  itemCount: controller.listPatternDashBoard.length < 3
                      ? controller.listPatternDashBoard.length
                      : 3)
              .paddingSymmetric(horizontal: AppDimens.defaultPadding),
        ),
      ],
    ).paddingAll(AppDimens.defaultPadding)),
  );
}

Widget buildItem(InvoicePattern invoicePattern) {
  int usedInvoice = invoicePattern.currentUsedApp.toInt();
  int totalInvoice = invoicePattern.toNo.toInt();
  return Container(
    height: 50,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        buildFilterSerialPattern(
          invoicePattern.pattern,
          invoicePattern.serial,
          color: Colors.white,
          hintColor: AppColors.hintTextSolidColor,
        ),
        const Spacer(),
        usedInvoice == totalInvoice
            ? Text(
                AppStr.invoiceStatusOver.tr,
                style: Get.textTheme.bodyText2!
                    .copyWith(color: AppColors.invoiceListOver()),
              )
            : Text(
                "${usedInvoice} / ${totalInvoice}",
                style: Get.textTheme.bodyText2!
                    .copyWith(color: AppColors.textColorWhite),
              ),
      ],
    ),
  );
}

Widget buildCardInforItem(
  String title,
  Widget widget,
) {
  return Column(
    children: [
      Text(
        title,
        textAlign: TextAlign.center,
        style: Get.textTheme.subtitle1,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          widget.paddingSymmetric(vertical: AppDimens.paddingVerySmall),
        ],
      ),
    ],
  );
}

Widget buildAppBarPin(DashboardController controller) {
  return BaseWidget.buildSafeArea(
    Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        color: AppColors.appBarColor(),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            NumberFormat.currency(
                  locale: 'en_US',
                  symbol: '',
                  decimalDigits: 0,
                ).format(
                  double.tryParse(
                      controller.invoiceStatistics?.data.totalAmount ?? '0'),
                ) +
                AppStr.vnd.tr,
            style: TextStyle(
              fontSize: AppDimens.fontBig(),
              color: AppColors.textColor(),
            ),
          ).paddingSymmetric(horizontal: AppDimens.defaultPadding),
          Obx(
            () => GestureDetector(
              onTap: () {
                Get.bottomSheet(
                  _buildBottomSheet(controller),
                  isScrollControlled: true,
                ).then((value) {
                  if (value != null) {
                    controller.dashBoardRequest = DashBoardRequest(
                        fromDate: value.fromDate, toDate: value.toDate);
                    controller.currentFilter.update((val) {
                      val!.title = value.title;
                      val.fromDate = value.fromDate;
                      val.toDate = value.toDate;
                      val.value = value.value;
                    });
                    controller.getData();
                  }
                });
              },
              child: Container(
                height: double.infinity,
                margin: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.selectedChip(),
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '${controller.currentFilter.value.title.tr}',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          fontSize: AppDimens.fontSmall()),
                    ),
                    const Icon(
                      Icons.arrow_drop_down,
                      size: AppDimens.sizeIcon,
                      color: Colors.white,
                    ),
                  ],
                ).paddingSymmetric(
                  horizontal: AppDimens.defaultPadding,
                ),
              ).paddingOnly(right: AppDimens.defaultPadding),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildBottomSheet(DashboardController controller) {
  RxInt _chipYearValue =
      RxInt(int.parse(controller.currentFilter.value.fromDate.split('/').last));
  Rx<ChipFilterModel> _currentFilterModel = controller.currentFilter.value.obs;
  return BaseWidget.baseBottomSheet(
    isSecondDisplay: true,
    title: AppStr.choiceTime,
    body: Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              children: [
                Obx(
                  () => DropdownButton<int>(
                      style: Get.textTheme.bodyText1,
                      iconEnabledColor: AppColors.textColor(),
                      underline: Container(
                        decoration: const BoxDecoration(
                            border: Border(
                                bottom: BorderSide(color: Colors.transparent))),
                      ),
                      dropdownColor: AppColors.inputText(),
                      onChanged: (newValue) {
                        if (newValue != _chipYearValue.value) {
                          _chipYearValue.value = newValue!;

                          _currentFilterModel.value =
                              listTimeFilter(year: _chipYearValue.value)
                                  .firstWhere((element) =>
                                      element.title ==
                                      _currentFilterModel.value.title);
                        }
                      },
                      hint: Text(
                        _chipYearValue.toString(),
                        style: Get.textTheme.bodyText1!
                            .copyWith(color: AppColors.textColor()),
                      ).paddingSymmetric(horizontal: AppDimens.paddingSmall),
                      items: controller.listDashBoardYears
                          .map(
                            (e) => DropdownMenuItem<int>(
                              value: e,
                              child: Text(e.toString()),
                            ),
                          )
                          .toList()),
                ),
                // buildListViewChip(
                //   listYearFilter(),
                //   'Chọn năm',
                //   onSelectedFunc: (item) => {
                //     Get.back(result: item),
                //     controller.isShowSelectedQuarterByYear()
                //   },
                //   onCompareFunc: (item) => controller.changeYear == false
                //       ? item.title == controller.currentFilter.value.title
                //       : false,
                //   numberItemPerRow: 2,
                //   borderRadius: 6,
                // ),
                Obx(
                  () => buildListViewChip(
                    listTimeFilter(year: _chipYearValue.value),
                    '',
                    onSelectedFunc: (item) => {
                      _currentFilterModel.value = item,
                    },
                    onCompareFunc: (item) =>
                        item.title.tr == _currentFilterModel.value.title.tr,
                    numberItemPerRow: 2,
                    borderRadius: 6,
                  ),
                ),
              ],
            ),
          ),
        ),
        BaseWidget.buildButton(
          AppStr.filter,
          () => {
            Get.back(result: _currentFilterModel.value),
          },
        ).paddingOnly(bottom: AppDimens.defaultPadding),
      ],
    ),
  );
}

Widget _buildFilter(DashboardController controller) {
  ScrollController controllerFilter = ScrollController();

  // Chuyển tới trạng thái lọc hiện tại
  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    if (controllerFilter.hasClients)
      controllerFilter.animateTo(
        listTimeFilter()
                .map((e) => e.title.tr)
                .toList()
                .indexOf(controller.currentFilter.value.title.tr) *
            50,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 3),
      );
  });
  return Container(
    height: 50,
    child: ListView.builder(
      shrinkWrap: true,
      controller: controllerFilter,
      physics: const ClampingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      itemBuilder: (ctx, index) {
        return Padding(
          padding: const EdgeInsets.only(left: AppDimens.defaultPadding),
          child: ChoiceChip(
            backgroundColor: AppColors.chipColorTheme(),
            selectedColor: AppColors.selectedChip(),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            label: Text(listTimeFilter()[index].title.tr,
                textAlign: TextAlign.center,
                style: Get.textTheme.subtitle2!.copyWith(
                    color: controller.currentFilter.value.title.tr ==
                            listTimeFilter()[index].title.tr
                        ? Colors.white
                        : AppColors.textColor())),
            selected: controller.currentFilter.value.title.tr ==
                listTimeFilter()[index].title.tr,
            onSelected: (bool selected) {
              controller.dashBoardRequest = DashBoardRequest(
                  fromDate: listTimeFilter()[index].fromDate,
                  toDate: listTimeFilter()[index].toDate);
              controller.currentFilter.update((val) {
                val!.title = listTimeFilter()[index].title;
              });

              controller.getData();
            },
          ),
        );
      },
      itemCount: listTimeFilter().length,
    ),
  );
}

List<ChipFilterModel> listTimeFilter({int? year}) {
  DashboardController _dashboardController = Get.find();
  final DateTime firstDayOfYear = DateTime(year ??
      int.parse(
          _dashboardController.currentFilter.value.fromDate.split('/').last));
  final DateTime lastDayOfYear =
      Jiffy(firstDayOfYear).add(years: 1, days: -1).dateTime;
  DateTime firstDayOfQuarter(int quarter) =>
      DateTime(firstDayOfYear.year, (quarter - 1) * 3 + 1);
  DateTime lastDayOfQuarter(int quarter) =>
      DateTime(firstDayOfYear.year, quarter * 3 + 1, 0);
  return [
    ChipFilterModel(
      title: AppStr.quarterOne,
      value: 1,
      fromDate: formatDateTimeToString(firstDayOfQuarter(1)),
      toDate: formatDateTimeToString(lastDayOfQuarter(1)),
    ),
    ChipFilterModel(
      title: AppStr.quarterTwo,
      value: 2,
      fromDate: formatDateTimeToString(firstDayOfQuarter(2)),
      toDate: formatDateTimeToString(lastDayOfQuarter(2)),
    ),
    ChipFilterModel(
      title: AppStr.quarterThree,
      value: 3,
      fromDate: formatDateTimeToString(firstDayOfQuarter(3)),
      toDate: formatDateTimeToString(lastDayOfQuarter(3)),
    ),
    ChipFilterModel(
      title: AppStr.quarterFour,
      value: 4,
      fromDate: formatDateTimeToString(firstDayOfQuarter(4)),
      toDate: formatDateTimeToString(lastDayOfQuarter(4)),
    ),
    ChipFilterModel(
      title: AppStr.wholeYear,
      value: 0,
      fromDate: formatDateTimeToString(firstDayOfYear),
      toDate: formatDateTimeToString(lastDayOfYear),
    ),
  ];
}

Widget buildCardDashBoard(String title, List<Widget> children) {
  return BaseWidget.buildCardBase(Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      buildHeaderTitle(title).paddingOnly(bottom: AppDimens.defaultPadding),
      Flexible(
        child: Column(
          children: children,
        ),
      ),
    ],
  ).paddingAll(AppDimens.defaultPadding));
}
