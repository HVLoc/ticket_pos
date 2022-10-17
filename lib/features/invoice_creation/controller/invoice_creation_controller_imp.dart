import 'package:easy_invoice_qlhd/hive_local/setup.dart';
import 'package:get/get.dart';

import '../../../application/app.dart';
import '../../../const/all_const.dart';
import '../invoice_creation.dart';

class InvoiceCreationControllerImp extends InvoiceCreationController {
  @override
  void actionInvoice() {
    HIVE_APP.put(AppConst.keyLicensePlates, licensePlatesController.text);
    HIVE_APP.put(
        AppConst.keyRouteBusNumber, 'Tuyến ${routeBusNumberController.text}');
    Get.back();
  }

  @override
  SetupModel getSetup() {
    return HIVE_SETUP.get(HIVE_APP.get(AppConst.keyIdPage))!;
  }
}
