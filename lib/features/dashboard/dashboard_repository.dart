import 'package:easy_invoice_qlhd/base/base.dart';
import 'package:easy_invoice_qlhd/const/all_const.dart';
import 'package:easy_invoice_qlhd/features/dashboard/model/dashboard_request.dart';

import 'dashboard.dart';

class DashboardRepository extends BaseRepository {
  DashboardRepository(BaseGetxController controller) : super(controller);

  /// Lấy thông tin DashboardModel
  Future<InvoiceStatistics> getDataDashboard(
      DashBoardRequest dashBoardRequest) async {
    var response = await baseSendRquest(
        AppConst.urlDashboardModel, RequestMethod.POST,
        jsonMap: dashBoardRequest.toJson());
    return InvoiceStatistics.fromJson(response);
  }

  /// Lấy thông tin BarchartModel
  Future<DashBoardResponse> getDataBarChart(
      DashBoardRequest dashBoardRequest) async {
    var response = await baseSendRquest(
        AppConst.urlBarChartModel, RequestMethod.POST,
        jsonMap: dashBoardRequest.toJson());

    return DashBoardResponse.fromJson(response);
  }

  /// Lấy thông tin PiechartModel
  Future<DashBoardResponse> getDataPieChart(
      DashBoardRequest dashBoardRequest) async {
    var response = await baseSendRquest(
        AppConst.urlPieChartModel, RequestMethod.POST,
        jsonMap: dashBoardRequest.toJson());

    return DashBoardResponse.fromJson(response);
  }
}
