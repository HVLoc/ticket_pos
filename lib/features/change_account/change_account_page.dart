import 'package:easy_invoice_qlhd/base/base_widget.dart';
import 'package:easy_invoice_qlhd/const/all_const.dart';
import 'package:easy_invoice_qlhd/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../application/app.dart';
import 'change_account.dart';
import 'change_account_controller.dart';

class ChangeAccPage extends BaseGetWidget<ChangeAccController> {
  final FocusNode _passwordFocus = FocusNode();

  @override
  ChangeAccController get controller => Get.put(ChangeAccController());

  @override
  Widget buildWidgets() {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return Obx(
      () => SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          height: Get.height,
          width: Get.width,
          decoration: const BoxDecoration(
            image: DecorationImage(
              // colorFilter: ColorFilter.mode(
              //   AppColors.darkAccentColor,
              //   BlendMode.difference,
              // ),
              image: AssetImage(AppStr.imgLoginBg),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              AppBar(
                backgroundColor: Colors.transparent,
                systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
                  statusBarColor: Colors.transparent,
                ),
              ),
              BaseWidget.buildLogo(AppStr.imgLoginLogo, AppDimens.sizeImage),
              const SizedBox(
                height: 20,
              ),
              Form(
                key: controller.formKey,
                child: Column(
                  children: <Widget>[
                    _buildUserInfor(),
                    _buildFilter(controller, AppStr.account,
                        controller.mapAccountEmployee, controller.idAccount),
                    const SizedBox(
                      height: 3,
                    ),
                    if (controller.idAccount.value != 0 &&
                        (HIVE_SETUP.get(HIVE_APP.get(AppConst.keyIdPage)))!
                            .configShift)
                      _buildFilter(controller, AppStr.shift,
                          controller.mapShift, controller.idShift),
                    if (controller.idAccount != 0 &&
                        (HIVE_SETUP
                            .get(HIVE_APP.get(AppConst.keyIdPage) ?? 0)!
                            .licensePlates))
                      _buildFilter(
                        controller,
                        'Chọn biển số xe',
                        controller.mapLicensePlates,
                        controller.idLicensePlates,
                      ),
                    if (controller.idAccount != 0 &&
                        (HIVE_APP.get(AppConst.keyIdPage) ?? 0) == 1)
                      _buildFilter(
                          controller,
                          'Chọn lái xe',
                          controller.mapAccountDriver,
                          controller.idAccountDriver),
                    _buildInputPassword(),
                    const SizedBox(
                      height: 20,
                    ),
                    BaseWidget.buildButton(
                      AppStr.accept,
                      controller.funcAccept,
                      isLoading: controller.isShowLoading.value,
                      colors: AppColors.colorGradientBlueLogin,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfor() {
    return Column(
      children: [
        Text(
          '${HIVE_APP.get(AppConst.keyComName)}\n${HIVE_APP.get(AppConst.keyTaxCodeCompany)}',
          style: Get.textTheme.headline6!.copyWith(color: Colors.white),
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          maxLines: 3,
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }

  Widget _buildFilter(ChangeAccController controller, String title,
      Map<int, String> map, RxInt id) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Get.textTheme.bodyText1!.copyWith(color: Colors.white),
        ),
        BaseWidget.sizedBox5,
        BaseWidget.buildDropdown(map, item: id, onChanged: (int? newValue) {
          if (newValue != null) {
            id.value = newValue;
          }
        }, fillColor: AppColors.inputTextBottomSheet()),
      ],
    );
  }

  Widget _buildInputPassword() {
    return BuildInputTextWithLabel(
      label: AppStr.password.tr,
      textStyle: Get.textTheme.bodyText2!.copyWith(
        color: Colors.white,
      ),
      buildInputText: BuildInputText(
        InputTextModel(
          suffixColor: Colors.white,
          hintTextColor: AppColors.hintTextSolidColor,
          textColor: Colors.white,
          errorTextColor: AppColors.errorTextLogin,
          prefixIconColor: AppColors.prefixIconLogin,
          fillColor: Colors.white38,
          iconLeading: Icons.vpn_key,
          hintText: AppStr.password.tr,
          controller: controller.passwordController,
          currentNode: _passwordFocus,
          iconNextTextInputAction: TextInputAction.done,
          isReadOnly: controller.isShowLoading.value,
          obscureText: true,
          submitFunc: (v) => controller.funcAccept(),
        ),
      ),
    );
  }
}
