import 'package:easy_invoice_qlhd/application/app.dart';
import 'package:easy_invoice_qlhd/base/base.dart';
import 'package:easy_invoice_qlhd/hive_local/account.dart';
import 'package:hive/hive.dart';

abstract class AccController extends BaseGetxController {
  late int? typeAccount;
  void addAccount(AccountModel accountModel);

  void updateAccount(AccountModel accountModel);

  void deleteAccount(int id);
  @override
  void onInit() {
    super.onInit();
  }

  Box<AccountModel> getBox() {
    return typeAccount != null ? HIVE_ACCOUNT_DRIVER : HIVE_ACCOUNT;
  }
  // final List<ChipFilterModel> listStatus = List.generate(
  //   AppStr.mapRoleCompany.length,
  //   (index) => ChipFilterModel(
  //     title: AppStr.mapRoleCompany.values.toList()[index],
  //     value: AppStr.mapRoleCompany.keys.toList()[index],
  //   ),
  // );

  // bool checkAccountIsEmpty() {
  //   return HIVE_ACCOUNT.values
  //       .toList()
  //       .where((element) => element.id != 0)
  //       .where((element) => element.type == (typeAccount == 1 ? 2 : 1))
  //       .isEmpty;
  // }

  // void sortAccountWithType();
}
