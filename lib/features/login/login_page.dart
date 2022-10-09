import 'package:easy_invoice_qlhd/application/app.dart';
import 'package:easy_invoice_qlhd/base/base_widget.dart';
import 'package:easy_invoice_qlhd/const/all_const.dart';
import 'package:easy_invoice_qlhd/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'login.dart';
import 'login_controller.dart';

class LoginPage extends BaseGetWidget<LoginController> {
  final FocusNode _taxCodeFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _codeFocus = FocusNode();

  @override
  LoginController get controller => Get.put(LoginController());

  @override
  Widget buildWidgets() {
    return
        // SafeArea(
        //     child:
        AnnotatedRegion<SystemUiOverlayStyle>(
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
        // padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          height: Get.height,
          width: Get.width,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AppStr.imgLoginBg),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              const SizedBox(
                height: kBottomNavigationBarHeight * 1.0,
              ),
              const SizedBox(
                height: 20,
              ),
              BaseWidget.buildLogo(AppStr.imgLoginLogo, AppDimens.sizeImage),
              const SizedBox(
                height: 30,
              ),
              Form(
                key: controller.formKey,
                child: Column(
                  children: <Widget>[
                    controller.haveAccount.value
                        ? _buildUserInfor()
                        : _buildUserInput(),
                    _buildInputPassword(),
                    const SizedBox(
                      height: 3,
                    ),
                    _buildCode(),
                    const SizedBox(
                      height: 20,
                    ),
                    BaseWidget.buildButton(
                      AppStr.loginBtn,
                      controller.funcCheckTaxCode,
                      isLoading: controller.isShowLoading.value,
                      colors: AppColors.colorGradientBlueLogin,
                    ),
                    BaseWidget.sizedBox10,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (controller.haveAccount.value) _buildChangeUser()
                      ],
                    ),
                  ],
                ),
              ),
              BaseWidget.sizedBox10,
              const Spacer(),

              // _buildFooter(),
            ],
          ),
        ),
      ),
      // ),
    );
  }

  Widget _buildUserInput() {
    return Column(
      children: [
        _buildInputTaxCode(),
        const SizedBox(
          height: 3,
        ),
        _buildInputEmail(),
      ],
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
        Text(
          HIVE_APP.get(AppConst.keyUserName) ?? '',
          style: Get.textTheme.bodyText1!.copyWith(
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }

  Widget _buildInputTaxCode() {
    return BuildInputTextWithLabel(
      label: AppStr.taxCode.tr,
      textStyle: Get.textTheme.bodyText2!.copyWith(
        color: Colors.white,
      ),
      buildInputText: BuildInputText(
        InputTextModel(
          suffixColor: Colors.white,
          textColor: Colors.white,
          errorTextColor: AppColors.errorTextLogin,
          fillColor: Colors.white38,
          prefixIconColor: AppColors.prefixIconLogin,
          iconLeading: Icons.home_work,
          hintText: AppStr.taxCode.tr,
          hintTextColor: AppColors.hintTextSolidColor,
          controller: controller.taxCodeController,
          currentNode: _taxCodeFocus,
          inputFormatters: 2,
          nextNode: _emailFocus,
          isReadOnly: controller.isShowLoading.value,
          validator: (value) {
            if (value.isStringEmpty) {
              return AppStr.errorTaxCode.tr;
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget _buildInputEmail() {
    return BuildInputTextWithLabel(
      label: "Tên công ty",
      textStyle: Get.textTheme.bodyText2!.copyWith(
        color: Colors.white,
      ),
      buildInputText: BuildInputText(
        InputTextModel(
          suffixColor: Colors.white,
          textColor: Colors.white,
          errorTextColor: AppColors.errorTextLogin,
          fillColor: Colors.white38,
          prefixIconColor: AppColors.prefixIconLogin,
          iconLeading: Icons.person,
          hintText: "Tên công ty",
          controller: controller.userNameController,
          isReadOnly: controller.isShowLoading.value,
          currentNode: _emailFocus,
          nextNode: _passwordFocus,
          hintTextColor: AppColors.hintTextSolidColor,
          validator: (value) {
            if (value.isStringEmpty) {
              return AppStr.errorUserName.tr;
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget _buildInputPassword() {
    return BuildInputTextWithLabel(
      label: AppStr.address.tr,
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
          hintText: 'Địa chỉ',
          controller: controller.addressController,
          currentNode: _passwordFocus,
          nextNode: _codeFocus,
          isReadOnly: controller.isShowLoading.value,
          obscureText: true,
          validator: (value) {
            if (value != null && (value.length < 8 || value.length > 50)) {
              return AppStr.errorPassword.tr;
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget _buildChangeUser() {
    return TextButton(
      onPressed: controller.changeUser,
      child: Text(
        AppStr.loginChangeUser.tr,
        style: TextStyle(
          fontSize: AppDimens.fontMedium(),
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildCode() {
    return BuildInputTextWithLabel(
      label: 'Nhập mã code',
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
          hintText: 'Nhập mã code',
          controller: controller.codeController,
          currentNode: _codeFocus,
          iconNextTextInputAction: TextInputAction.done,
          isReadOnly: controller.isShowLoading.value,
          submitFunc: (v) => controller.funcCheckTaxCode(),
          validator: (value) {
            if (value != null && (value.length < 8 || value.length > 50)) {
              return AppStr.error.tr;
            }
            return null;
          },
        ),
      ),
    );
  }

  // Widget _buildIconLogin(
  //   String title,
  //   Function func,
  //   IconData icon,
  //   Color iconColor,
  // ) {
  //   return BaseWidget.buildButtonIcon(
  //       colors: Colors.white,
  //       padding: 10,
  //       sizeIcon: 25,
  //       radius: 60,
  //       icons: icon,
  //       iconColor: iconColor,
  //       func: func,
  //       title: title,
  //       textColor: Colors.white);
  // }
}
