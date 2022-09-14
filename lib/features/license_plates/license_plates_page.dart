import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_invoice_qlhd/application/app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../base/base.dart';
import '../../const/all_const.dart';
import '../../hive_local/account.dart';
import '../../utils/utils.dart';
import 'controller/license_plates_controller.dart';
import 'controller/license_plates_controller_imp.dart';

class LicensePlates extends BaseGetWidget<LicensePlatesController> {
  final bool isFirtLogin;

  LicensePlates({this.isFirtLogin = false});

  @override
  LicensePlatesController get controller =>
      Get.put(LicensePlatesControllerImp());
  @override
  Widget buildWidgets() {
    return WillPopScope(
      onWillPop: () => Future.value(!isFirtLogin),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: !isFirtLogin,
          centerTitle: true,
          title: BaseWidget.buildAppBarTitle('Danh sách biển số xe'),
          actions: [
            TextButton(
              onPressed: () {
                Get.bottomSheet(buildAddAccountPage(AccountModel()),
                        isScrollControlled: true)
                    .then((value) {
                  if (value != null) {
                    controller.addLicensePlates(value);
                  }
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
          valueListenable: HIVE_LICENSE_PLATES.listenable(),
          builder: (context, item, _) {
            return HIVE_LICENSE_PLATES.isEmpty
                ? buildEmptyAccount()
                : ListView.builder(
                    itemCount: HIVE_LICENSE_PLATES.length,
                    itemBuilder: ((context, index) => _buildItem(index)),
                  ).paddingSymmetric(horizontal: AppDimens.defaultPadding);
          },
        ),
        bottomNavigationBar: isFirtLogin
            ? BaseWidget.buildButton(AppStr.next, () {
                Get.offAllNamed(AppConst.routeHome);
              }).paddingAll(AppDimens.defaultPadding)
            : null,
      ),
    );
  }

  Widget _buildItem(int index) {
    AccountModel accountModel = HIVE_LICENSE_PLATES.getAt(index)!;
    return GestureDetector(
      onTap: () {
        Get.bottomSheet(
                buildAddAccountPage(
                  accountModel,
                  isUpdate: true,
                ),
                isScrollControlled: true)
            .then((value) {
          if (value != null) controller.updateLicensePlates(value);
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
                        controller.deleteLicensePlates(accountModel);
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
              'Biển số xe',
              accountModel.nameAccount,
              Get.textTheme.bodyText1,
            ),
            // _rowCustomer(
            //   'Mã biển số xe',
            //   accountModel.userName,
            //   Get.textTheme.bodyText1,
            // ),
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

  Widget buildAddAccountPage(AccountModel accountModel,
      {bool isUpdate = false}) {
    TextEditingController nameAccount =
        TextEditingController(text: accountModel.nameAccount);
    TextEditingController username =
        TextEditingController(text: accountModel.userName);

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
                        if (!isUpdate) ...[
                          inputInfor(username, 'Mã biển số xe'),
                          BaseWidget.sizedBox10,
                        ],
                        inputInfor(nameAccount, 'Biển số xe'),
                        BaseWidget.sizedBox10,
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
            SizedBox(
              width: Get.width * 2 / 3,
              child: Text(
                'Chưa có biển số xe nào được thiết lập',
                textAlign: TextAlign.center,
                style: Get.textTheme.bodyText1!
                    .copyWith(fontSize: AppDimens.fontSize24()),
              ),
            ),
            BaseWidget.sizedBoxPadding,
            Container(
              width: 100,
              child: BaseWidget.buildButton(AppStr.add, () {
                Get.bottomSheet(buildAddAccountPage(AccountModel()),
                        isScrollControlled: true)
                    .then((value) {
                  if (value != null) controller.addLicensePlates(value);
                });
              }),
            )
          ],
        ),
      ),
    );
  }

  Widget buildEmptyShift() {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppStr.shiftEmpty,
              style: Get.textTheme.bodyText1!
                  .copyWith(fontSize: AppDimens.fontSize24()),
            ),
            BaseWidget.sizedBoxPadding,
            Container(
              width: 100,
              child: BaseWidget.buildButton(AppStr.add, () {
                Get.bottomSheet(buildAddAccountPage(AccountModel()),
                        isScrollControlled: true)
                    .then((value) {
                  if (value != null) controller.addLicensePlates(value);
                });
              }),
            )
          ],
        ),
      ),
    );
  }
}
