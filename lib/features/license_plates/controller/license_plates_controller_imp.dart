import 'package:easy_invoice_qlhd/application/app_controller.dart';
import 'package:easy_invoice_qlhd/hive_local/account.dart';
import 'package:get/get.dart';

import '../../../const/all_const.dart';
import 'license_plates_controller.dart';

class LicensePlatesControllerImp extends LicensePlatesController{
  @override
  void addLicensePlates(AccountModel accountModel) {
    void _addAcount() {
      accountModel.id =
          HIVE_LICENSE_PLATES.isNotEmpty ? HIVE_LICENSE_PLATES.values.last.id + 1 : 0;
      HIVE_LICENSE_PLATES.put(accountModel.id,accountModel);
    }

    if (HIVE_LICENSE_PLATES.isNotEmpty) {
      var tes = HIVE_LICENSE_PLATES.toMap().values.toList().firstWhereOrNull(
            (e) =>
                e.userName.toLowerCase() == accountModel.userName.toLowerCase(),
          );
      if (tes != null) {
        showSnackBar(AppStr.errorExistAccount);
      } else {
        _addAcount();
      }
    } else {
      _addAcount();
    }
  }

  @override
  void deleteLicensePlates(AccountModel accountModel) {
    HIVE_LICENSE_PLATES.delete(accountModel.id);
    showSnackBar(AppStr.deleteSuccess);
  }

  @override
  void updateLicensePlates(AccountModel accountModel) {
    HIVE_LICENSE_PLATES.put(accountModel.id, accountModel);
  }

  
}