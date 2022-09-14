import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_invoice_qlhd/utils/show_popup.dart';
import 'package:get/get.dart';

import '../application/app.dart';
import '../const/all_const.dart';
import 'service.dart';

class ConnectivityService extends GetxService {
  bool isShowingDialog = false;

  @override
  void onInit() async {
    super.onInit();
    initLocal();
    Connectivity().onConnectivityChanged.listen((event) async {
      if (event == ConnectivityResult.wifi ||
          event == ConnectivityResult.mobile) {
        var listInvoice = HIVE_INVOICE.values
            .where((e) => e.invoiceNo == null || e.invoiceNo == 0)
            .toList();
        if (listInvoice.isNotEmpty) {
          for (var i = 0; i < listInvoice.length; i++) {
            String xml = await buildCreateXml(
                listInvoice[i].items.first, listInvoice[i].ikey!);
            await callIssueInvoice(listInvoice[i].xmlInv ?? xml);
          }
          showNotiGetx(listInvoice.length);
        }
      }
    });
  }
}

Future<void> checkConnectivity(Function function, {bool isShow = false}) async {
  var result = await Connectivity().checkConnectivity();
  if (result == ConnectivityResult.wifi ||
      result == ConnectivityResult.mobile) {
    function();
  } else if (isShow) {
    ShowPopup.showDialogNotification(AppStr.errorConnectFailedStr);
  }
}
