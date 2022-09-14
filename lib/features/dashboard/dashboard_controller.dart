import 'dart:math' as math;

import 'package:easy_invoice_qlhd/base/base_refresh_controller.dart';
import 'package:easy_invoice_qlhd/const/all_const.dart';
import 'package:easy_invoice_qlhd/features/dashboard/model/dashboard_request.dart';
import 'package:easy_invoice_qlhd/features/home/home_controller.dart';
import 'package:easy_invoice_qlhd/features/invoice/filter/filter_model.dart';
import 'package:easy_invoice_qlhd/features/invoice/invoice.dart';
import 'package:easy_invoice_qlhd/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

import 'dashboard.dart';

class DashboardController extends BaseRefreshGetxController {
  late DashboardRepository _dashboardRepository;
  final keyToolTip = GlobalKey<State<Tooltip>>();

  RxBool isShowAppBar = false.obs;

  ScrollController? scrollController;
  GlobalKey<State> hidingKey = GlobalKey();
  GlobalKey<State> hidingAppBarKey = GlobalKey();
  List<InvoicePattern> listPatternDashBoard = [];
  List<int> listDashBoardYears =
      List.generate(5, (index) => (DateTime.now().year - index));

  //response
  DashBoardResponse? barChartResponse;
  DashBoardResponse? pieChartResponse;
  InvoiceStatistics? invoiceStatistics;

  HomeController homeController = Get.find<HomeController>();
  // final LoginController c = Get.put(LoginController());

  DashboardController() {
    this._dashboardRepository = DashboardRepository(this);
  }
  late DashBoardRequest dashBoardRequest;
  late Rx<ChipFilterModel> currentFilter;

  @override
  Future<void> onInit() async {
    //mặc định lấy quý hiện tại khi chưa chọn bộ lọc
    dashBoardRequest = getQuarterByToday();

    currentFilter = ChipFilterModel(
            title: AppStr.quarter + " ${getQuarter(DateTime.now())}",
            fromDate: dashBoardRequest.fromDate,
            toDate: dashBoardRequest.toDate)
        .obs;
    sortListPatternDashboard();
    await getData();
    scrollController = ScrollController();
    scrollController!.addListener(() {
      if (scrollController!.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (isShowAppBar.value) isShowAppBar.value = false;
      }
      if (scrollController!.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (!isShowAppBar.value) isShowAppBar.value = true;
      }
    });

    // sortByRemainUsed();
    super.onInit();
  }

  @override
  Future<void> onLoadMore() async {}

  @override
  Future<void> onRefresh() async {
    listPatternDashBoard.clear();

    sortListPatternDashboard();
    getData();
  }

  Future getData() async {
    try {
      showLoading();
      await _dashboardRepository
          .getDataDashboard(dashBoardRequest)
          .then((value) {
        invoiceStatistics = value;
      });
    } catch (e) {
      //gọi lại lần nữa vì api này hay bị timeout

      if (invoiceStatistics == null) {
        await _dashboardRepository
            .getDataDashboard(dashBoardRequest)
            .then((value) {
          invoiceStatistics = value;
        });
      }
    } finally {
      try {
        await _dashboardRepository
            .getDataBarChart(dashBoardRequest)
            .then((value) {
          barChartResponse = value;
        });
      } catch (e) {
        if (barChartResponse == null) {
          await _dashboardRepository
              .getDataBarChart(dashBoardRequest)
              .then((value) {
            barChartResponse = value;
          });
        }
      } finally {
        try {
          await _dashboardRepository
              .getDataPieChart(dashBoardRequest)
              .then((value) {
            pieChartResponse = value;
          });
        } catch (e) {
          if (pieChartResponse == null) {
            await _dashboardRepository
                .getDataBarChart(dashBoardRequest)
                .then((value) {
              pieChartResponse = value;
            });
          }
        } finally {
          refreshController.refreshCompleted();
          hideLoading();
        }
      }
    }
  }

  bool isScrollView(ScrollNotification scroll) {
    var currentContext = hidingAppBarKey.currentContext;
    if (currentContext == null) return false;

    var renderObject = currentContext.findRenderObject();
    RenderAbstractViewport viewport = RenderAbstractViewport.of(renderObject)!;
    var offsetToRevealBottom = viewport.getOffsetToReveal(renderObject!, 1.0);
    var offsetToRevealTop = viewport.getOffsetToReveal(renderObject, 0.0);
    if (scrollController!.position.userScrollDirection !=
        ScrollDirection.idle) {
      if (offsetToRevealBottom.offset > scroll.metrics.pixels ||
          scrollController!.position.pixels > offsetToRevealTop.offset) {
        if (!isShowAppBar.value) {
          isShowAppBar.value = true;
        }
      } else if (isShowAppBar.value) {
        isShowAppBar.value = false;
      }
    }
    return true;
  }

  DashBoardRequest getQuarterByToday() {
    final DateTime today = DateTime.now();
    DateTime firstDayOfQuarter(int quarter) =>
        DateTime(today.year, (quarter - 1) * 3 + 1);
    DateTime lastDayOfQuarter(int quarter) =>
        DateTime(today.year, quarter * 3 + 1, 0);

    return DashBoardRequest(
        fromDate: formatDateTimeToString(firstDayOfQuarter(getQuarter(today))),
        toDate: formatDateTimeToString(lastDayOfQuarter(getQuarter(today))));
  }

  /// 0: chưa được chấp nhận(không hiển thị trên mobile) 1: chưa dùng , 2: đang dùng , 3: dùng hết
  Widget getTitlePatternDetail(int status) {
    String _title = '';
    Color _colorText = Colors.white;
    switch (status) {
      case 1:
        _title = AppStr.invoiceStatusNotUsed.tr;
        _colorText = Colors.grey;
        break;
      case 2:
        _title = AppStr.invoiceStatusUsing.tr;
        _colorText = Colors.green;
        break;
      case 3:
        _title = AppStr.invoiceStatusOver.tr;
        _colorText = Colors.red;
        break;
      case 4:
        _title = AppStr.invoiceStatusCanceled.tr;
        _colorText = Colors.yellow;
        break;
      default:
        return Container();
    }
    return RichText(
      text: TextSpan(children: [
        TextSpan(
          text: _title,
          style: Get.textTheme.bodyText1!.copyWith(color: _colorText),
        )
      ]),
    );
  }

  void showToolTip() {
    final dynamic tooltip = keyToolTip.currentState;
    tooltip?.ensureTooltipVisible();
    5.seconds.delay().then((value) => tooltip?.deactivate());
  }

  void sortListPatternDashboard() {
    void changeStatusApp() {
      this.listPatternDashBoard.forEach((element) {
        if (element.statusApp == 1) {
          element.statusApp = 2;
        } else if (element.statusApp == 2) {
          element.statusApp = 1;
        }
      });
    }


    // Đổi trạng thái để sắp xếp bộ lọc
    // Đang sd -> Chưa dùng -> Đã hết -> Đã hủy
    changeStatusApp();

    listPatternDashBoard
      ..sort((a, b) =>
          (a.toNo - a.currentUsedApp).compareTo(b.toNo - b.currentUsedApp))
      ..sort((a, b) => a.statusApp.compareTo(b.statusApp));

    // Đổi trạng thái về ban đầu
    changeStatusApp();
  }

  int maxInList() {
    var number = barChartResponse?.data.map((e) => e.value).toList() ?? [];
    int max = number.reduce(math.max);
    if (max == 1)
      return max + 1;
    else if (max >= 20) {
      return (max ~/ 10) * 10;
    } else if (max.isOdd) return max - 1;
    return max;
  }

  double getPerCent(int a, double total, int precision) {
    return ((a / total) * 100).toPrecision(precision);
  }

  String currentTimeFilter() {
    return currentFilter.value.title.tr.toUpperCase() +
        " - " +
        currentFilter.value.fromDate.split('/').last;
  }
}
