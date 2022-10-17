import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_invoice_qlhd/utils/show_popup.dart';

import '../const/all_const.dart';

Future<void> checkConnectivity(Function function, {bool isShow = false}) async {
  var result = await Connectivity().checkConnectivity();
  if (result == ConnectivityResult.wifi ||
      result == ConnectivityResult.mobile) {
    function();
  } else if (isShow) {
    ShowPopup.showDialogNotification(AppStr.errorConnectFailedStr);
  }
}
