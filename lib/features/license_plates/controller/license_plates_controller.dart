import 'package:easy_invoice_qlhd/base/base.dart';
import 'package:easy_invoice_qlhd/hive_local/account.dart';
abstract class LicensePlatesController extends BaseGetxController {
  void addLicensePlates(AccountModel shiftModel);

  void deleteLicensePlates(AccountModel accountModel);

  void updateLicensePlates(AccountModel accountModel);
}