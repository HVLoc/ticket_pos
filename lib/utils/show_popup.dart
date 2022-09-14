import 'package:app_settings/app_settings.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_invoice_qlhd/base/base.dart';
import 'package:easy_invoice_qlhd/const/all_const.dart';
import 'package:easy_invoice_qlhd/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShowPopup {
  static int _numDialog = 0;

  static void _showDialog(Widget dialog, bool isActiveBack,
      {bool barrierDismissible = false}) {
    _numDialog++;
    Get.dialog(
      WillPopScope(
        onWillPop: () => onBackPress(isActiveBack),
        child: dialog,
      ),
      barrierDismissible: barrierDismissible,
    ).whenComplete(() => _numDialog--);
  }

  static Future<bool> onBackPress(bool isActiveBack) {
    return Future.value(isActiveBack);
  }

  static void dismissDialog() {
    if (_numDialog > 0) {
      Get.back();
    }
  }

  /// Hiển thị loading
  ///
  /// `isActiveBack` có cho phép back từ bàn phím Android khi loading hay không, default = true
  void showLoadingWave({bool isActiveBack = true}) {
    _showDialog(getLoadingWidget(), isActiveBack);
  }

  static Widget getLoadingWidget() {
    return const Center(
      child: CupertinoActivityIndicator(),
    );
  }

  static Widget _baseButton(
    Function? function,
    String text, {
    Color? colorText,
  }) {
    return BaseWidget.baseOnAction(
        onTap: () {
          dismissDialog();

          function?.call();
        },
        child: TextButton(
          onPressed: null,
          style: ButtonStyle(
            overlayColor: MaterialStateProperty.all(Colors.transparent),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: AppDimens.fontBig(),
              color: colorText ?? AppColors.textColor(),
            ),
            textScaleFactor: 1,
            maxLines: 1,
          ),
        ));
  }

  /// Hiển thị dialog thông báo với nội dung cần hiển thị
  ///
  /// `funtion` hành động khi bấm đóng
  ///
  /// `isActiveBack` có cho phép back từ bàn phím Android hay không, default = true
  ///
  /// `isChangeContext` default true: khi gọi func không close dialog hiện tại (khi chuyển sang màn mới thì dialog hiện tại sẽ tự đóng)
  static void showDialogNotification(
    String content, {
    bool isActiveBack = true,
    Function? function,
    String nameAction = AppStr.close,
  }) {
    _showDialog(
        Dialog(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(top: 15, bottom: 10),
                  child: Icon(
                    _buildIconDialog(content),
                    size: AppDimens.sizeDialogNotiIcon,
                    color: Colors.blueAccent,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(15.0),
                  constraints: const BoxConstraints(maxHeight: 200),
                  child: SingleChildScrollView(
                    child: Text(
                      content,
                      style: TextStyle(fontSize: AppDimens.fontMedium()),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.clip,
                      textScaleFactor: 1,
                    ),
                  ),
                ),
                const Divider(
                  height: 1,
                ),
                Container(
                  width: double.infinity,
                  child: _baseButton(
                    function,
                    nameAction.tr,
                    colorText: AppColors.colorBlueAccent,
                  ),
                ),
              ],
            ),
          ),
        ),
        isActiveBack);
  }

  static void showDialogInputPhoneHSM({
    bool isActiveBack = true,
    Function(String)? function,
    String nameAction = AppStr.close,
  }) {
    final TextEditingController _textEditingController =
        TextEditingController();
    final _formKey = GlobalKey<FormState>();
    _showDialog(
        Dialog(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(AppDimens.defaultPadding,
                    AppDimens.defaultPadding, AppDimens.defaultPadding, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(AppStr.inputPhoneWhenNotHaveHSMHint.tr,
                        textAlign: TextAlign.center,
                        style: Get.textTheme.bodyText1!
                            .copyWith(color: AppColors.hintTextColor())),
                    BaseWidget.sizedBoxPadding,
                    BuildInputText(InputTextModel(
                        iconLeading: Icons.phone_forwarded,
                        fillColor: AppColors.appBarColor(),
                        textInputType: TextInputType.number,
                        controller: _textEditingController,
                        currentNode: FocusNode()..requestFocus(),
                        validator: (value) {
                          if (value!.isEmpty)
                            return AppStr.invoicePhoneEmpty.tr;
                          if (value.length < 10 || value.length > 12)
                            return AppStr.invoicePhoneInvalid.tr;
                          return null;
                        })
                      ..isShowCounterText = false),
                    Row(
                      children: [
                        Expanded(
                          child: _baseButton(() {}, AppStr.cancel.tr,
                              colorText: AppColors.hintTextColor()),
                        ),
                        Expanded(
                          child: BaseWidget.baseOnAction(
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                dismissDialog();
                                function?.call(_textEditingController.text);
                              }
                            },
                            child: TextButton(
                              onPressed: null,
                              style: ButtonStyle(
                                overlayColor: MaterialStateProperty.all(
                                    Colors.transparent),
                              ),
                              child: Text(
                                nameAction.tr,
                                style: TextStyle(
                                  fontSize: AppDimens.fontBig(),
                                  color: AppColors.colorBlueAccent,
                                ),
                                textScaleFactor: 1,
                                maxLines: 1,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ).paddingAll(AppDimens.defaultPadding),
                  ],
                ),
              ),
            ),
          ),
        ),
        isActiveBack,
        barrierDismissible: true);
  }

  static void showDialogInvoiceExtendInput(
    int currentInvoiceNumber, {
    bool isActiveBack = true,
    Function(String, String)? function,
    String nameAction = AppStr.close,
  }) {
    final TextEditingController _inputNumberController =
        TextEditingController();
    final TextEditingController _inputPhoneController = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    _showDialog(
        Dialog(
          backgroundColor: AppColors.dialogInvExtend(),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(AppDimens.defaultPadding,
                  AppDimens.defaultPadding, AppDimens.defaultPadding, 0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: Text(AppStr.invoiceExtendTitle.tr,
                              style: Get.textTheme.bodyText1!)
                          .paddingOnly(bottom: AppDimens.defaultPadding),
                    ),
                    Container(
                      constraints: const BoxConstraints(maxHeight: 200),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Text(AppStr.hintInvoiceExtendCurrentNumber_1.tr,
                                style: Get.textTheme.bodyText1!
                                    .copyWith(color: AppColors.textColor())),
                            BaseWidget.sizedBoxPadding,
                            BuildInputText(InputTextModel(
                                iconLeading: Icons.timeline,
                                textInputType: TextInputType.number,
                                controller: _inputNumberController,
                                inputFormatters: 4,
                                maxLengthInputForm: 20,
                                hintText: AppStr.invoiceNumberNeedToBuy.tr,
                                currentNode: FocusNode()..requestFocus(),
                                validator: (value) {
                                  if (value!.isEmpty)
                                    return AppStr
                                        .invoiceNumberNeedToBuyError.tr;
                                  if (CurrencyUtils.formatNumberCurrency(
                                          value) <=
                                      0)
                                    return AppStr
                                        .invoiceNumberNeedToBuyErrorZero.tr;
                                  return null;
                                })
                              ..isShowCounterText = false),
                            BaseWidget.sizedBoxPadding,
                            BuildInputText(InputTextModel(
                                iconLeading: Icons.phone_forwarded,
                                textInputType: TextInputType.number,
                                hintText: AppStr.phoneContact.tr,
                                inputFormatters: 3,
                                maxLengthInputForm: 12,
                                controller: _inputPhoneController,
                                validator: (value) {
                                  if (value!.isEmpty)
                                    return AppStr
                                        .invoicePhoneNumberNeedToBuyError.tr;
                                  return null;
                                })
                              ..isShowCounterText = false),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      child: Row(
                        children: [
                          Expanded(
                            child: _baseButton(() {}, AppStr.cancel.tr,
                                colorText: AppColors.textColor()),
                          ),
                          Expanded(
                            child: BaseWidget.baseOnAction(
                              onTap: () {
                                if (_formKey.currentState!.validate()) {
                                  dismissDialog();
                                  function?.call(_inputNumberController.text,
                                      _inputPhoneController.text);
                                  Get.find<BaseGetxController>().showSnackBar(
                                      AppStr.invoiceExtendSuccess.tr,
                                      duration: const Duration(seconds: 5));
                                }
                              },
                              child: TextButton(
                                onPressed: null,
                                style: ButtonStyle(
                                  overlayColor: MaterialStateProperty.all(
                                      Colors.transparent),
                                ),
                                child: Text(
                                  nameAction,
                                  style: TextStyle(
                                    fontSize: AppDimens.fontBig(),
                                    color: AppColors.colorBlueAccent,
                                  ),
                                  textScaleFactor: 1,
                                  maxLines: 1,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ).paddingAll(AppDimens.defaultPadding),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        isActiveBack);
  }

  static void showErrorMessage(String error) {
    showDialogNotification(error, isActiveBack: false);
  }

  static IconData _buildIconDialog(String errorStr) {
    IconData iconData;
    switch (errorStr) {
      case AppStr.errorConnectTimeOut:
        iconData = Icons.alarm_off;
        break;
      case AppStr.error400:
      case AppStr.error401:
      case AppStr.error404:
      case AppStr.error502:
      case AppStr.error503:
      case AppStr.errorInternalServer:
        iconData = Icons.warning;
        break;
      case AppStr.errorConnectFailedStr:
        iconData = Icons.signal_wifi_off;
        break;
      default:
        iconData = Icons.notifications_none;
    }
    return iconData;
  }

  static void showDialogConfirm(
    String content, {
    required Function confirm,
    required String actionTitle,
    bool isActiveBack = true,
    String title = AppStr.notification,
    String exitTitle = AppStr.cancel,
    Function? cancelFunc,
    bool isAutoCloseDialog = false,
  }) {
    _showDialog(
        Dialog(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: AutoSizeText(
                    title.tr,
                    textScaleFactor: 1,
                    maxLines: 1,
                    style: TextStyle(
                        fontSize: AppDimens.fontBiggest(),
                        color: AppColors.textColor()),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(15.0),
                  constraints: const BoxConstraints(maxHeight: 200),
                  child: SingleChildScrollView(
                    child: Text(
                      content.tr,
                      style: Get.textTheme.bodyText1
                          ?.copyWith(color: AppColors.textColor()),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.clip,
                      textScaleFactor: 1,
                    ),
                  ),
                ),
                const Divider(
                  height: 1,
                ),
                Container(
                  width: double.infinity,
                  height: AppDimens.btnMedium,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: _baseButton(cancelFunc, exitTitle.tr,
                            colorText: AppColors.hintTextColor()),
                      ),
                      VerticalDivider(
                        width: 1,
                        color: AppColors.dividerColor(),
                      ),
                      Expanded(
                        child: _baseButton(
                          confirm,
                          actionTitle.tr,
                          colorText: Colors.redAccent,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        isActiveBack);
  }

  static void openAppSetting() {
    showDialogConfirm(
      AppStr.pdfHelper,
      confirm: () {
        Get.back();
        AppSettings.openAppSettings();
      },
      actionTitle: AppStr.openSettings,
    );
  }

  static void openSupport() {
    showDialogSupport(
      AppStr.supportCus.tr,
    );
  }

  static void showDialogSupport(
    String content, {
    bool isActiveBack = true,
    Function? function,
    String nameAction = AppStr.close,
  }) {
    _showDialog(
        Dialog(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: AutoSizeText(content.tr,
                      textScaleFactor: 1,
                      maxLines: 1,
                      style: Get.textTheme.headline6),
                ),
                BaseWidget.sizedBox10,
                ItemUtils.itemLine(
                  // iconColors: [AppColors.colorBlueB1FF,AppColors.colorBlueB1FF],
                  title: AppStr.zaloSupport,
                  imgAsset: AppStr.iconZalo,
                  func: () async {
                    // if (await canLaunch(AppConst.zalo)) {
                    //   await launch(AppConst.zalo,
                    //       forceSafariVC: true,
                    //       forceWebView: false,
                    //       enableJavaScript: true,
                    //       statusBarBrightness: Brightness.light);
                    // }
                  },
                ),
                BaseWidget.sizedBox10,
                ItemUtils.itemLine(
                  // iconColors: [AppColors.colorBlueB1FF,AppColors.colorBlueB1FF],
                  title: AppStr.loginFacebookSupport,
                  imgAsset: AppStr.iconFacebook,
                  func: () async {
                    // await launch(AppConst.facebook,
                    //     forceSafariVC: true,
                    //     forceWebView: false,
                    //     enableJavaScript: true,
                    //     statusBarBrightness: Brightness.light);
                  },
                ),
                BaseWidget.sizedBox10,
                ItemUtils.itemLine(
                  title: AppStr.phoneNumber,
                  imgAsset: AppStr.iconPhone,
                  func: () async {
                    // if (await canLaunch(AppStr.telSupportNumber)) {
                    //   await launch(AppStr.telSupportNumber);
                    // }
                  },
                ),
                Container(
                  width: double.infinity,
                  child: _baseButton(
                    function,
                    nameAction.tr,
                    colorText: AppColors.colorBlueAccent,
                  ),
                ),
              ],
            ),
          ),
        ),
        isActiveBack);
  }

  static void showDialogInputProfileCode({
    bool isActiveBack = true,
    Function(String)? confirmFuction,
  }) {
    final TextEditingController _inputProfileCodeController =
        TextEditingController();
    final _formKey = GlobalKey<FormState>();
    _showDialog(
        Dialog(
          backgroundColor: AppColors.dialogInvExtend(),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(AppDimens.defaultPadding,
                  AppDimens.defaultPadding, AppDimens.defaultPadding, 0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: Text(AppStr.invoiceProfileCodeDesc,
                              style: Get.textTheme.bodyText1!)
                          .paddingOnly(bottom: AppDimens.defaultPadding),
                    ),
                    Container(
                      constraints: const BoxConstraints(maxHeight: 200),
                      child: SingleChildScrollView(
                        child: BuildInputText(InputTextModel(
                            iconLeading: Icons.format_align_left_sharp,
                            textInputType: TextInputType.text,
                            controller: _inputProfileCodeController,
                            inputFormatters: 3,
                            maxLengthInputForm: 20,
                            hintText: AppStr.invoiceProfileCode,
                            currentNode: FocusNode()..requestFocus(),
                            validator: (value) {
                              if (value!.isEmpty)
                                return AppStr.invoiceProfileCodeError;

                              return null;
                            })
                          ..isShowCounterText = false),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: _baseButton(() {}, AppStr.cancel,
                              colorText: AppColors.textColor()),
                        ),
                        Expanded(
                          child: BaseWidget.baseOnAction(
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                dismissDialog();
                                confirmFuction
                                    ?.call(_inputProfileCodeController.text);
                              }
                            },
                            child: TextButton(
                              onPressed: null,
                              style: ButtonStyle(
                                overlayColor: MaterialStateProperty.all(
                                    Colors.transparent),
                              ),
                              child: Text(
                                AppStr.accept,
                                style: TextStyle(
                                  fontSize: AppDimens.fontBig(),
                                  color: AppColors.colorBlueAccent,
                                ),
                                textScaleFactor: 1,
                                maxLines: 1,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ).paddingOnly(bottom: AppDimens.paddingVerySmall),
                  ],
                ),
              ),
            ),
          ),
        ),
        isActiveBack);
  }
}
