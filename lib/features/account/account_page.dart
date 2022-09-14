import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_invoice_qlhd/base/base.dart';
import 'package:easy_invoice_qlhd/const/all_const.dart';
import 'package:easy_invoice_qlhd/features/account/account_src.dart';
import 'package:easy_invoice_qlhd/hive_local/account.dart';
import 'package:easy_invoice_qlhd/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AccountPage extends BaseGetWidget<AccController> {
  
  @override
  AccController get controller => Get.put(AccControllerImp());
  @override
  Widget buildWidgets() {
    return Scaffold(
      appBar: AppBar(
        title: BaseWidget.buildAppBarTitle(AppStr.accountList),
        actions: [
          TextButton(
            onPressed: () {
              Get.bottomSheet<AccountModel>(
                      buildAddAccountPage(
                        controller,
                        AccountModel(),
                      ),
                      isScrollControlled: true)
                  .then((value) {
                if (value != AccountModel() && value != null)
                  controller.addAccount(value);
              });
            },
            child: Icon(
              Icons.add_circle_outline,
              color: AppColors.textColor(),
            ),
          )
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: controller.getBox().listenable(),
        builder: (context, item, _) {
          return controller.getBox().values.isEmpty
              ? buildEmptyAccount()
              : ListView.builder(
                  itemCount: controller.getBox().values.length,
                  itemBuilder: ((context, index) =>
                      controller.getBox().getAt(index)?.type == 0
                          ? const SizedBox()
                          : _buildItem(index)),
                ).paddingSymmetric(horizontal: AppDimens.defaultPadding);
        },
      ),
    );
  }

  Widget _buildItem(int index) {
    AccountModel accountModel = controller.getBox().getAt(index)!;
    return GestureDetector(
      onTap: () {
        Get.bottomSheet(
                buildAddAccountPage(controller, accountModel, isUpdate: true),
                isScrollControlled: true)
            .then((value) {
          if (value != null) controller.updateAccount(accountModel);
        });
      },
      child: BaseWidget.buildCardBase(
        Column(
          children: [
            Row(
              children: [
                AutoSizeText(
                  accountModel.userName,
                  style: Get.textTheme.bodyText1?.copyWith(
                    color: AppColors.linkText(),
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    ShowPopup.showDialogConfirm(
                      AppStr.invoiceDetailRemoveContain,
                      confirm: () {
                        controller.deleteAccount(accountModel.id);
                      },
                      actionTitle: AppStr.delete,
                    );
                  },
                  child: AutoSizeText(
                    AppStr.delete,
                    style: Get.textTheme.bodyText2?.copyWith(
                      color: AppColors.linkText(),
                    ),
                  ),
                ),
              ],
            ),
            _rowCustomer(
              AppStr.nameAccount,
              accountModel.nameAccount,
              Get.textTheme.bodyText1,
            ),
            _rowCustomer(
              AppStr.roleSystem,
              AppStr.mapRoleCompany[accountModel.type] ?? 'admin',
              Get.textTheme.bodyText1,
            ),
          ],
        ).paddingAll(AppDimens.paddingMedium),
      ).paddingOnly(bottom: AppDimens.paddingMedium),
    );
  }

  Widget _rowCustomer(String label, String title, TextStyle? style) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Get.textTheme.bodyText2,
        ),
        AutoSizeText(
          title,
          style: style,
          overflow: TextOverflow.ellipsis,
        )
      ],
    ).paddingOnly(top: AppDimens.paddingVerySmall);
  }

  Widget buildAddAccountPage(
      AccController controller, AccountModel accountModel,
      {bool isUpdate = false}) {
    TextEditingController nameAccount =
        TextEditingController(text: accountModel.nameAccount);
    TextEditingController username =
        TextEditingController(text: accountModel.userName);
    TextEditingController password =
        TextEditingController(text: accountModel.password);
    // RxInt roleCom = accountModel.type.obs;
    final _formKey = GlobalKey<FormState>();
    return BaseWidget.baseBottomSheet(
        title: isUpdate ? AppStr.accountCreate : AppStr.addAccount,
        body: Container(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        if (isUpdate) ...[
                          AutoSizeText(
                            accountModel.userName,
                            style: Get.textTheme.bodyText1,
                          ),
                          BaseWidget.sizedBox10,
                        ],
                        inputInfor(nameAccount, AppStr.nameAccount),
                        BaseWidget.sizedBox10,
                        if (!isUpdate) ...[
                          inputInfor(username, AppStr.nameLogin),
                          BaseWidget.sizedBox10,
                        ],
                        inputInfor(password, AppStr.password,
                            isValidate: true, isHide: true),
                        // if (roleCom.value != 0)
                        //   buildListViewChip(
                        //       controller.listStatus, AppStr.roleSystem,
                        //       onCompareFunc: (item) =>
                        //           item.value == roleCom.value,
                        //       onSelectedFunc: (item) {
                        //         roleCom.value = roleCom.value == item.value!
                        //             ? -1
                        //             : item.value!;
                        //       },
                        //       numberItemPerRow: 2,
                        //       borderRadius: 6,
                        //       textStyle: Get.textTheme.bodyText2)
                      ],
                    ),
                  ),
                ),
              ),
              BaseWidget.buildButton(AppStr.save, () {
                if (_formKey.currentState!.validate()) {
                  KeyBoard.hide();
                  accountModel.nameAccount = nameAccount.text;
                  accountModel.userName = username.text;
                  accountModel.password = password.text;
                  accountModel.type = controller.typeAccount != null ? 2 : 1;
                  Get.back(result: accountModel);
                }
              })
            ],
          ),
        ));
  }

  BuildInputTextWithLabel inputInfor(
      TextEditingController controller, String title,
      {bool isValidate = true, bool isHide = false}) {
    return BuildInputTextWithLabel(
      label: title,
      buildInputText: BuildInputText(
        InputTextModel(
          obscureText: isHide,
          controller: controller,
          validator: (value) {
            if (value.isStringEmpty && isValidate) {
              return AppStr.accountValidate;
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget buildEmptyAccount() {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppStr.emptyAccount,
              style: Get.textTheme.bodyText1!
                  .copyWith(fontSize: AppDimens.fontSize24()),
            ),
            BaseWidget.sizedBoxPadding,
            Container(
              width: 100,
              child: BaseWidget.buildButton(AppStr.add, () {
                Get.bottomSheet(buildAddAccountPage(controller, AccountModel()),
                        isScrollControlled: true)
                    .then((value) {
                  if (value != null) controller.addAccount(value);
                });
              }),
            )
          ],
        ),
      ),
    );
  }
}
