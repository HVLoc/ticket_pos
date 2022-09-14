import 'package:easy_invoice_qlhd/const/all_const.dart';
import 'package:easy_invoice_qlhd/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget FindInvoicePage(
    {required List<String> listKeyword,
    required String keyCurrent,
    required String title,
    required String hint,
    int? maxInput,
    TextInputType textInputType = TextInputType.text,
    bool isInvoiceNo = false,
    bool isFromFilter = false}) {
  final Rx<TextEditingController> _searchPatternController =
      TextEditingController(text: keyCurrent).obs;
  final FocusNode _searchFocus = FocusNode();
  final _formKey = GlobalKey<FormState>();

  return BaseWidget.baseBottomSheet(
      title: title,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Obx(
            () => Form(
              key: _formKey,
              child: BuildInputText(
                InputTextModel(
                  autoFocus: true,
                  controller: _searchPatternController.value,
                  currentNode: _searchFocus,
                  textInputType: textInputType,
                  maxLengthInputForm: maxInput,
                  submitFunc: (v) {
                    if (_formKey.currentState!.validate())
                      Get.back(
                          result: _searchPatternController.value.text.trim());
                  },
                  iconNextTextInputAction: TextInputAction.search,
                  hintText: hint,
                  prefixIconColor: AppColors.textColor(),
                  iconLeading: Icons.search,
                  inputFormatters: isInvoiceNo ? 1 : 0,
                  borderRadius: 8.0,
                ),
              ),
            ),
          ).paddingOnly(bottom: AppDimens.paddingSmall),
          Visibility(
            visible: listKeyword.isNotEmpty,
            child: Text(
              AppStr.filterTitle_history.tr,
              style: Get.textTheme.bodyText1!
                  .copyWith(color: AppColors.hintTextColor()),
            ).paddingSymmetric(vertical: AppDimens.defaultPadding),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Wrap(
                spacing: 10,
                runSpacing: 2,
                children: List<Widget>.generate(
                  listKeyword.length,
                  (index) => ActionChip(
                    backgroundColor: AppColors.inputText(),
                    onPressed: () {
                      _searchPatternController.value
                        ..text = listKeyword[index]
                        ..selection = TextSelection.fromPosition(
                            TextPosition(offset: listKeyword[index].length));
                      //Tránh trường hợp nhảy con trỏ trên Ios
                      if (!KeyBoard.keyboardIsVisible())
                        FocusScope.of(Get.context!).requestFocus(_searchFocus);
                    },
                    label: Text(listKeyword[index]),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      isSecondDisplay: isFromFilter);
}
