import 'package:easy_invoice_qlhd/const/all_const.dart';
import 'package:easy_invoice_qlhd/features/invoice_detail/invoice_detail.dart';
import 'package:easy_invoice_qlhd/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget ProductDescriptionPage(Function(ProductItem) onSubmit,
    {String descValue = ''}) {
  final Rx<TextEditingController> _descController =
      TextEditingController(text: descValue).obs;
  final _formKey = GlobalKey<FormState>();

  void _saveDesc() {
    if (_formKey.currentState!.validate()) {
      onSubmit(
        ProductItem(
          name: _descController.value.text,
          quantity: 0.0,
          total: 0,
          price: 0,
          vatRate: -1,
        ),
      );
    }
  }

  return BaseWidget.baseBottomSheet(
    title: AppStr.note,
    iconTitle: TextButton(
      onPressed: _saveDesc,
      child: Text(
        AppStr.done.tr,
        style: Get.textTheme.bodyText1!
            .copyWith(color: AppColors.linkText(), fontWeight: FontWeight.bold),
      ),
    ),
    body: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Form(
            key: _formKey,
            child: Container(
              constraints: BoxConstraints(maxHeight: Get.height * 0.3),
              child: BuildInputText(
                InputTextModel(
                  fillColor: AppColors.inputText(),
                  autoFocus: true,
                  controller: _descController.value,
                  submitFunc: (v) => _saveDesc(),
                  iconNextTextInputAction: TextInputAction.done,
                  hintText: AppStr.descHint.tr,
                  borderRadius: 8.0,
                  textInputType: TextInputType.multiline,
                  maxLengthInputForm: 800,
                  validator: (value) {
                    if (value.isStringEmpty) {
                      return AppStr.notifyDescIsNotEmpty.tr;
                    }
                    return null;
                  },
                ),
              ),
            ).paddingSymmetric(vertical: AppDimens.paddingSmall),
          ),
          Text(
            AppStr.suggestion.tr,
            style: Get.textTheme.bodyText1!
                .copyWith(color: AppColors.hintTextColor()),
          ).paddingSymmetric(vertical: AppDimens.defaultPadding),
          SingleChildScrollView(
            child: Wrap(
              spacing: 10,
              runSpacing: 2,
              children: List<Widget>.generate(
                AppStr.listDescSuggestion.length,
                (index) => ActionChip(
                  backgroundColor: AppColors.inputText(),
                  onPressed: () {
                    _descController.value
                      ..text = AppStr.listDescSuggestion[index].tr
                      ..selection = TextSelection.fromPosition(TextPosition(
                          offset: AppStr.listDescSuggestion[index].length));
                  },
                  label: Text(AppStr.listDescSuggestion[index].tr),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
