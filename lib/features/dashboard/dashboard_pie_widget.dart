part of 'dashboard_page.dart';

Widget pieChart(DashboardController controller) {
  if (controller.pieChartResponse == null)
    return buildCardDashBoard(
      AppStr.dashboardInvoiceStatus.tr.toUpperCase() +
          controller.currentTimeFilter(),
      [BaseWidget.buildImgLostConnect()],
    );
  double _totalInvoices = 0;
  controller.pieChartResponse!.data.forEach((element) {
    _totalInvoices += element.value;
  });

  RxInt touchedIndex = (-1).obs;
  PieChartSectionData pieChartSection(
    Color color,
    double value,
    String title,
    bool isTouched,
  ) {
    return PieChartSectionData(
        color: color,
        value: value,
        title: title,
        showTitle: isTouched,
        radius: isTouched ? 50.0 : 35.0,
        titlePositionPercentageOffset: -1.2,
        badgePositionPercentageOffset: 1.1,
        titleStyle: TextStyle(
          fontSize: isTouched ? AppDimens.fontBig() : 10,
          fontWeight: FontWeight.bold,
          color: AppColors.textColor(),
        ));
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(controller.pieChartResponse!.data.length, (i) {
      return pieChartSection(
        AppColors.colorPieDashboard[i],
        (controller.getPerCent(
            controller.pieChartResponse!.data[i].value, _totalInvoices, 2)),
        '${controller.pieChartResponse!.data[i].value.toInt()} \n (${(controller.getPerCent(controller.pieChartResponse!.data[i].value, _totalInvoices, 1))}%)',
        i == touchedIndex.value,
      );
    });
  }

  List<Widget> showingNotes() {
    return List.generate(controller.pieChartResponse!.data.length, (i) {
      return BaseWidget.baseOnAction(
        onTap: () {
          touchedIndex.value = i;
        },
        child: Indicator(
          percent:
              '${(controller.getPerCent(controller.pieChartResponse!.data[i].value, _totalInvoices, 1))}%',
          color: AppColors.colorPieDashboard[i],
          text: AppStr.pieInvoiceDashboard[i].tr,
          isSquare: false,
          size: touchedIndex.value == i ? 18 : 16,
          textColor: touchedIndex.value == i
              ? AppColors.textColor()
              : AppColors.hintTextColor(),
        ).paddingSymmetric(vertical: AppDimens.paddingVerySmall),
      );
    });
  }

  return buildCardDashBoard(
    AppStr.dashboardInvoiceStatus.tr.toUpperCase() +
        controller.currentTimeFilter(),
    [
      const SizedBox(height: 38),
      _totalInvoices == 0
          ? BaseWidget.buildEmptyIcon(Icons.pie_chart, AppStr.dashboardEmpty)
          : Obx(() => Column(
                children: [
                  AspectRatio(
                      aspectRatio: 1.3,
                      child: PieChart(
                        PieChartData(
                            pieTouchData:
                                PieTouchData(touchCallback: (pieTouchResponse) {
                              final desiredTouch = pieTouchResponse.touchInput
                                      is! PointerExitEvent &&
                                  pieTouchResponse.touchInput
                                      is! PointerUpEvent;
                              if (desiredTouch &&
                                  pieTouchResponse.touchedSection != null) {
                                touchedIndex.value = pieTouchResponse
                                    .touchedSection!.touchedSectionIndex;
                              } else {
                                touchedIndex.value = -1;
                              }
                            }),
                            borderData: FlBorderData(
                              show: false,
                            ),
                            sectionsSpace: 0,
                            centerSpaceRadius: 60,
                            sections: showingSections()),
                      )),
                  Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: showingNotes())
                      .paddingOnly(top: AppDimens.defaultPadding),
                ],
              ))
    ],
  );
}
