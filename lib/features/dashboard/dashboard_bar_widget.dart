part of 'dashboard_page.dart';

Widget barChart(DashboardController controller) {
  if (controller.barChartResponse == null)
    return buildCardDashBoard(
      AppStr.dashboardInvoiceEachMonth.tr.toUpperCase() +
          controller.currentFilter.value.title.toUpperCase(),
      [BaseWidget.buildImgLostConnect()],
    );
  Duration animDuration = const Duration(milliseconds: 250);
  RxBool _isQuarter = (controller.barChartResponse!.data.length <= 3).obs;
  int _totalValue = 0;
  controller.barChartResponse?.data.forEach((element) {
    _totalValue += element.value;
  });

  final RxInt touchedIndex = (-1).obs;
  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    Color barColor = Colors.white,
    double width = 22,
    List<int> showTooltips = const [],
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          y: y,
          colors:
              isTouched ? AppColors.barReChartData() : AppColors.barChartData(),
          borderRadius: BorderRadius.all(Radius.circular(y == 0 ? 0.0 : 5.0)),
          width: _isQuarter.value ? 40 : 12,
          backDrawRodData: BackgroundBarChartRodData(
            show: y == 0,
            y: 0.1,
            colors: AppColors.barChartEmpty(),
          ),
        ),
      ],
      showingTooltipIndicators: _isQuarter.value ? [0] : [],
    );
  }

  List<BarChartGroupData> showingGroups() =>
      List.generate(controller.barChartResponse!.data.length, (i) {
        return makeGroupData(
          i,
          controller.barChartResponse!.data[i].value.toDouble(),
          isTouched: i == touchedIndex.value,
        );
      });

  BarChartData mainBarData() {
    return BarChartData(
      alignment: _isQuarter.value ? BarChartAlignment.spaceAround : null,
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.transparent,
            tooltipMargin: 10,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return (rod.y) != 0.0
                  ? BarTooltipItem(
                      rod.y.toInt().toString(),
                      TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textColor(),
                        fontSize: AppDimens.fontMedium(),
                      ),
                    )
                  : null;
            }),
        touchCallback: (barTouchResponse) {
          if (barTouchResponse.spot != null &&
              barTouchResponse.touchInput is! PointerUpEvent &&
              barTouchResponse.touchInput is! PointerExitEvent) {
            touchedIndex.value = barTouchResponse.spot!.touchedBarGroupIndex;
          } else {
            touchedIndex.value = -1;
          }
        },
      ),
      gridData: FlGridData(
        show: !_isQuarter.value,
        horizontalInterval: 1.0,
        drawHorizontalLine: true,
        getDrawingHorizontalLine: (value) {
          {
            return FlLine(
              dashArray: [5, 10],
              color: value == (controller.maxInList() / 10).ceil() ||
                      value == (controller.maxInList() / 2) ||
                      value == controller.maxInList()
                  ? AppColors.titleBarChart()
                  : Colors.transparent,
              strokeWidth: 0.75,
            );
          }
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          getTextStyles: (context, value) => TextStyle(
              color: AppColors.titleDataBarChart(),
              fontWeight: FontWeight.bold,
              fontSize: 14),
          margin: AppDimens.paddingSmall,
          getTitles: (val) {
            String _title =
                ' ${convertStringToDate(controller.barChartResponse!.data[val.toInt()].title, PATTERN_6).month}';

            return _title;
          },
        ),
        leftTitles: SideTitles(
          margin: _isQuarter.value ? -9 : 17,
          showTitles: !_isQuarter.value,
          interval: 1.0,
          getTextStyles: (context, value) => TextStyle(
            color: AppColors.leftBarChart(),
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
          getTitles: (value) {
            if (value == (controller.maxInList() / 10).ceil()) {
              return CurrencyUtils.formatNumberBarChart(value.toDouble());
            } else if (value == (controller.maxInList() / 2)) {
              return CurrencyUtils.formatNumberBarChart(value.toDouble());
            } else if (value == controller.maxInList()) {
              return CurrencyUtils.formatNumberBarChart(value.toDouble());
            } else {
              return '';
            }
          },
        ),
      ),
      borderData: FlBorderData(show: false),
      barGroups: showingGroups(),
    );
  }

  return Obx(
    () => buildCardDashBoard(
      AppStr.dashboardInvoiceEachMonth.tr.toUpperCase() +
          controller.currentTimeFilter(),
      _totalValue == 0
          ? [
              BaseWidget.buildEmptyIcon(
                  Icons.bar_chart_rounded, AppStr.dashboardEmpty)
            ]
          : [
              AspectRatio(
                aspectRatio: 1,
                child: Column(
                  children: [
                    const Spacer(),
                    Expanded(
                      flex: 5,
                      child: Padding(
                        padding: !_isQuarter.value
                            ? const EdgeInsets.only(
                                right: AppDimens.paddingItemList)
                            : EdgeInsets.zero,
                        child: BarChart(
                          mainBarData(),
                          swapAnimationDuration: animDuration,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                  ],
                ),
              ),
            ],
    ),
  );
}
