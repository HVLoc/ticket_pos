import 'package:easy_invoice_qlhd/base/base.dart';
import 'package:easy_invoice_qlhd/const/all_const.dart';
import 'package:easy_invoice_qlhd/features/extra/extra_respone.dart';
import 'package:easy_invoice_qlhd/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget buildBottomSheetExtra(
    String title,
    BaseGetxController controller,
    List<ExtraInfo> listExtra,
    List<String> values,
    Function(List<String>) acceptBtn) {
  List<TextEditingController> extraEditController = List.generate(
      listExtra.length, (i) => TextEditingController(text: values[i]));
  return BaseWidget.baseBottomSheet(
    title: title,
    isSecondDisplay: false,
    body: Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: listExtra.length,
              itemBuilder: (BuildContext context, int index) =>
                  buildExtraItem(controller, extraEditController[index],
                      index, listExtra[index].label),
            ),
          ),
        ),
        _buildBottomButton(
          AppStr.accept,
          () {
            acceptBtn(extraEditController.map((e) => e.text).toList());
            Get.back();
          },
        ),
      ],
    ),
  );
}

Widget buildExtraItem(BaseGetxController controller,
    TextEditingController textEditingController, int index, String label) {
  return Container(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: Get.textTheme.bodyText2,
        ).paddingOnly(bottom: AppDimens.paddingVerySmall),
        BuildInputText(
          InputTextModel(
            controller: textEditingController,
            iconNextTextInputAction: TextInputAction.done,
            hintText: AppStr.invoiceCreationExtraRange.tr,
            borderRadius: 8.0,
            maxLengthInputForm: 20,
          ),
        ),
      ],
    ),
  );
}

Widget _buildBottomButton(String title, Function func,
    {List<Color> colors = AppColors.colorGradientOrange}) {
  return BaseWidget.buildButton(title, func, colors: colors);
}
