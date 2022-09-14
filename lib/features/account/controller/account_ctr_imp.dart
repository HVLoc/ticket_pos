import 'package:easy_invoice_qlhd/features/account/controller/account_controller.dart';
import 'package:easy_invoice_qlhd/hive_local/account.dart';
import 'package:get/get.dart';
import '../../../const/all_const.dart';

class AccControllerImp extends AccController {
  @override
  void addAccount(AccountModel accountModel) {
    accountModel.id = getBox().isEmpty ? 1 : getBox().values.last.id + 1;
    getBox().put(accountModel.id, accountModel);
  }

  @override
  void deleteAccount(int id) {
    getBox().delete(id);
    showSnackBar(AppStr.deleteSuccess);
  }

  @override
  void updateAccount(AccountModel accountModel) {
    getBox().put(accountModel.id, accountModel);
  }

  @override
  void onInit() {
    typeAccount = Get.arguments;
    super.onInit();
  }
}
