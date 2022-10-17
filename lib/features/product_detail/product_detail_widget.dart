part of 'product_detail_page.dart';

Widget _buildMoney(ProductDetailController controller) {
  return BaseWidget.buildCardBase(
    Column(
      children: [
        Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildProductTextFormField(
                    title: AppStr.unit.tr.replaceAll(': ', ''),
                    textEditingController: controller.unitController.value,
                    controller: controller,
                    textAlign: TextAlign.right,
                    textInputAction: TextInputAction.next,
                  ),
                ),
                Expanded(
                  child: _buildInputNumber(
                    controller: controller,
                    focusNode: controller.priceFocus,
                    textEditingController: controller.priceController.value,
                    notifier: controller.priceNotifier,
                    isValidate: true,
                    title: AppStr.productDetailPrice.tr,
                    isSale: controller.isSale,
                  ),
                ),
              ],
            ),
            const Divider(
              height: 0,
            ),
          ],
        ),
        const Divider(
          height: 0,
        ),
        _buildProductTextFormField(
          textEditingController: controller.descController,
          title: AppStr.productDesc.tr,
          controller: controller,
          maxLines: 3,
          maxLength: 190,
          textInputAction: TextInputAction.newline,
        ).paddingOnly(bottom: 10),
      ],
    ),
  );
}

Widget _buildProductTextFormField({
  required String title,
  required TextEditingController textEditingController,
  required ProductDetailController controller,
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
      labelText: title,
      labelStyle: Get.textTheme.bodyText2,
      errorStyle: TextStyle(color: AppColors.errorText()),
      border: InputBorder.none,
      contentPadding: const EdgeInsets.all(AppDimens.paddingSmall),
    ),
  ).paddingAll(1.0);
}

Widget _buildInputNumber({
  required String title,
  required TextEditingController textEditingController,
  required FocusNode focusNode,
  required ProductDetailController controller,
  required ValueNotifier<TextEditingController> notifier,
  required RxBool isSale,
  bool isValidate = false,
}) {
  final textFieldFocusNode = FocusNode();
  return Focus(
    onFocusChange: (hasFocus) async {
      controller.isVisibleBtn.refresh();

      final bottom = WidgetsBinding.instance.window.viewInsets.bottom;
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
              labelText: title,
              labelStyle: Get.textTheme.bodyText2,
              errorStyle: TextStyle(
                color: AppColors.errorText(),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(AppDimens.paddingSmall),
            ),
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

Widget _buildSpinBox(ProductDetailController controller) {
  return BaseWidget.buildCardBase(
    Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            AppStr.quantity.tr,
            style: Get.textTheme.bodyText2,
          ).paddingOnly(
              left: AppDimens.paddingSmall, top: AppDimens.paddingSmall),
        ),
        Obx(
          () => Container(
            width: Get.width / 1.5,
            child: BaseWidget.buildSpinBox(
              controller.product.value.quantity.toDouble().obs,
              controller.changeQuantity,
              Icon(
                Icons.indeterminate_check_box,
                size: AppDimens.sizeDialogNotiIcon,
                color: controller.product.value.quantityLocal.value != 0
                    ? AppColors.spinboxColor()
                    : AppColors.hintTextColor(),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
