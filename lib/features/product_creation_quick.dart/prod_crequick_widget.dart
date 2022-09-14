part of 'prod_crequick_page.dart';

Widget _buildProductTextFormField({
  required String title,
  required TextEditingController textEditingController,
  int maxLength = 80,
  int maxLines = 1,
  bool isValidate = false,
  bool enable = true,
  TextAlign textAlign = TextAlign.start,
  TextInputAction textInputAction = TextInputAction.next,
  bool isProductCode = false,
}) {
  return TextFormField(
      keyboardAppearance: Brightness.light,
      validator: (val) {
        if (isValidate) {
          if (val!.isStringEmpty) {
            return AppStr.productDetailNotEmpty.tr;
          }
          return null;
        }
        return null;
      },
      inputFormatters: isProductCode
          ? [
              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9-_\.]')),
              LengthLimitingTextFieldFormatterFixed(maxLength),
            ]
          : [
              LengthLimitingTextFieldFormatterFixed(maxLength),
            ],
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: TextInputType.multiline,
      style: Get.textTheme.bodyText1,
      controller: textEditingController,
      maxLength: maxLength,
      maxLines: maxLines,
      enabled: enable,
      textAlign: textAlign,
      textInputAction: textInputAction,
      decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.inputTextBottomSheet(),
          labelText: title,
          labelStyle: Get.textTheme.bodyText2!
              .copyWith(color: AppColors.hintTextColor()),
          errorStyle: TextStyle(color: AppColors.errorText()),
          border: InputBorder.none,
          enabledBorder: UnderlineInputBorder(
            borderSide: const BorderSide(width: 1, color: Colors.transparent),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: const BorderSide(width: 1, color: Colors.transparent),
            borderRadius: BorderRadius.circular(10),
          ),
          errorBorder: UnderlineInputBorder(
            borderSide:
                const BorderSide(width: 1, color: AppColors.colorRed444),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedErrorBorder: UnderlineInputBorder(
            borderSide:
                const BorderSide(width: 1, color: AppColors.colorRed444),
            borderRadius: BorderRadius.circular(10),
          )));
}

Widget _buildInputNumber({
  required String title,
  required TextEditingController textEditingController,
  required FocusNode focusNode,
  required ProdCreQuickController controller,
  required ValueNotifier<TextEditingController> notifier,
  required RxBool isSale,
  bool isValidate = false,
}) {
  final textFieldFocusNode = FocusNode();
  return Focus(
    onFocusChange: (hasFocus) async {
      controller.isVisibleBtn.refresh();
      final bottom = WidgetsBinding.instance!.window.viewInsets.bottom;
      final mainFocusNode = Get.focusScope!;

      if (mainFocusNode.hasFocus && bottom > 0) {
        mainFocusNode.unfocus();

        Timer(
          const Duration(milliseconds: 100),
          () => focusNode.requestFocus(),
        );
      }
      textFieldFocusNode.addListener(() {
        controller.isVisibleBtn.value = !(textFieldFocusNode.hasFocus);
      });
    },
    child: KeyboardCustomInput<TextEditingController>(
      focusNode: focusNode,
      notifier: notifier,
      builder: (context, val, hasFocus) {
        textEditingController = val;
        if (hasFocus ?? false) textFieldFocusNode.requestFocus();
        return Obx(
          () => TextFormField(
            focusNode: textFieldFocusNode,
            validator: (val) {
              if (isValidate && val.isStringEmpty) {
                return AppStr.productDetailNotEmpty.tr;
              } else if (val == AppStr.error.tr) {
                return AppStr.errorDataOverload.tr;
              }
              return null;
            },
            controller: textEditingController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            showCursor: true,
            readOnly: true,
            textAlign: TextAlign.right,
            style: Get.textTheme.bodyText1!.copyWith(
                decoration: isSale.value ? TextDecoration.lineThrough : null,
                decorationThickness: 3.0),
            decoration: InputDecoration(
                counterText: '',
                filled: true,
                fillColor: AppColors.inputTextBottomSheet(),
                labelText: title,
                labelStyle: Get.textTheme.bodyText2!
                    .copyWith(color: AppColors.hintTextColor()),
                errorStyle: TextStyle(color: AppColors.errorText()),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(AppDimens.paddingSmall),
                enabledBorder: UnderlineInputBorder(
                  borderSide:
                      const BorderSide(width: 0, color: Colors.transparent),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide:
                      const BorderSide(width: 0, color: Colors.transparent),
                  borderRadius: BorderRadius.circular(10),
                ),
                errorBorder: UnderlineInputBorder(
                    borderSide:
                        const BorderSide(width: 0, color: Colors.transparent),
                    borderRadius: BorderRadius.circular(10)),
                focusedErrorBorder: UnderlineInputBorder(
                  borderSide:
                      const BorderSide(width: 0, color: AppColors.colorRed444),
                  borderRadius: BorderRadius.circular(10),
                )),
            onTap: () {
              textEditingController.selection = TextSelection.fromPosition(
                TextPosition(offset: textEditingController.text.length),
              );
            },
          ),
        );
      },
    ),
  );
}

Widget buildDropDownButton(
  DropdownItem dropdownItem,
  List<DropdownItem> list,
  RxString selectedString,
  Function(dynamic) onChanged,
) {
  return DropdownButton<DropdownItem>(
      value: dropdownItem,
      style: Get.textTheme.bodyText1,
      iconEnabledColor: AppColors.textColor(),
      underline: Container(
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    color: AppColors.textColor(),
                    style: BorderStyle.none,
                    width: 0.8))),
      ),
      dropdownColor: AppColors.inputTextBottomSheet(),
      onChanged: onChanged,
      hint: Text(
        selectedString.value,
        style: Get.textTheme.bodyText1!.copyWith(color: AppColors.textColor()),
      ),
      items: list.map((DropdownItem value) {
        return DropdownMenuItem<DropdownItem>(
          value: value,
          child: Text(value.name),
        );
      }).toList());
}
