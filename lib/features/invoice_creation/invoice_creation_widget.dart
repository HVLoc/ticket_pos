part of 'invoice_creation_page.dart';

Widget listProduct(InvoiceCreationController controller) {
  return ListView(
    padding: const EdgeInsets.symmetric(
      horizontal: AppDimens.paddingSmall,
    ),
    children: [
      _buildInfoBuyer(controller),
      BaseWidget.sizedBox10,
      _buildPaymentMethods(controller),
      BaseWidget.sizedBox10,
      if (controller.getSetup().licensePlates ||
          HIVE_APP.get(AppConst.keyIdPage) == 1)
        _buildOptional(controller),
      BaseWidget.sizedBox10,
    ],
  );
}

Widget _buildAccountIssue(InvoiceCreationController controller) {
  return BaseWidget.buildCardBase(
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppStr.invoiceCreationAccount.tr.toUpperCase(),
                    style: Get.textTheme.bodyText2)
                .paddingOnly(
              bottom: AppDimens.defaultPadding,
            ),
          ],
        ),
      ],
    ).paddingOnly(
      top: AppDimens.defaultPadding,
      left: AppDimens.defaultPadding,
      right: AppDimens.defaultPadding,
      bottom: AppDimens.paddingVerySmall,
    ),
  );
}

Widget _buildPaymentMethods(InvoiceCreationController controller) {
  return BaseWidget.buildCardBase(
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppStr.invoiceCreationPaymentMethods.tr.toUpperCase(),
            style: Get.textTheme.bodyText2),
        Autocomplete<String>(
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text == '') {
              return const Iterable<String>.empty();
            }
            return AppStr.listPaymentMethods78.where((String option) {
              return option
                  .toLowerCase()
                  .contains(textEditingValue.text.toLowerCase());
            });
          },
          onSelected: (String selection) {
            KeyBoard.hide();

            controller.fieldTextEditingController.text = selection;
          },
          displayStringForOption: (option) => option,
          fieldViewBuilder: (BuildContext context,
              TextEditingController fieldTextEditingController,
              FocusNode fieldFocusNode,
              VoidCallback onFieldSubmitted) {
            fieldTextEditingController.text =
                controller.fieldTextEditingController.text;
            return BuildInputText(
              InputTextModel(
                controller: fieldTextEditingController,
                currentNode: fieldFocusNode,
                fillColor: Colors.transparent,
                onChanged: (v) {
                  controller.fieldTextEditingController.text = v;
                },
                suffixIcon: const SizedBox(),
              ),
            );
          },
        ),
        BaseWidget.buildDivider(height: 1),
      ],
    ).paddingAll(AppDimens.defaultPadding),
  );
}

Widget _buildCustomerTextFormField({
  String? title,
  required TextEditingController textEditingController,
  String hintText = '',
  int maxLength = 80,
  int? maxLines = 1,
  bool isValidate = false,
  bool enable = true,
  TextAlign textAlign = TextAlign.start,
  TextInputAction textInputAction = TextInputAction.next,
  bool isProductCode = false,
  TextInputType keyboardType = TextInputType.multiline,
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
    keyboardType: keyboardType,
    style: Get.textTheme.bodyText1,
    controller: textEditingController,
    maxLength: maxLength,
    maxLines: maxLines,
    enabled: enable,
    textAlign: textAlign,
    textInputAction: textInputAction,
    decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.inputQuickInvoice(),
        hintText: hintText,
        hintStyle: Get.textTheme.bodyText2!.copyWith(
          color: AppColors.hintTextColor(),
        ),
        labelText: title,
        labelStyle: Get.textTheme.bodyText2!.copyWith(
          color: AppColors.hintTextColor(),
        ),
        errorStyle: TextStyle(color: AppColors.errorText()),
        border: InputBorder.none,
        enabledBorder: UnderlineInputBorder(
          borderSide:
              BorderSide(width: 1, color: AppColors.inputQuickInvoice()),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide:
              BorderSide(width: 1, color: AppColors.inputQuickInvoice()),
          borderRadius: BorderRadius.circular(10),
        )),
  ).paddingOnly(bottom: 4);
}

Widget _buildInfoBuyer(InvoiceCreationController controller) {
  return BaseWidget.buildCardBase(
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppStr.customerName.toUpperCase() + ' *',
                style: Get.textTheme.bodyText2)
            .paddingOnly(bottom: AppDimens.defaultPadding),
        _buildCustomerTextFormField(
            textEditingController: controller.cusNameTextEditingController,
            maxLength: 100),
      ],
    ).paddingAll(AppDimens.paddingSmall),
  );
}

Widget buildBtn(InvoiceCreationController controller) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 6),
    color: AppColors.appBarColor(),
    height: kBottomNavigationBarHeight + 12,
    child: BaseWidget.buildButton(AppStr.save, () {
      controller.actionInvoice();
    }, colors: AppColors.colorGradientOrange)
        .paddingSymmetric(
      horizontal: AppDimens.defaultPadding,
      vertical: AppDimens.paddingVerySmall,
    ),
  ).paddingOnly(
    bottom:
        GetPlatform.isIOS ? AppDimens.paddingMedium : AppDimens.paddingSmall,
  );
}

Widget _buildOptional(InvoiceCreationController controller) {
  return BaseWidget.buildCardBase(Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(AppStr.optionalTitle.toUpperCase() + ' *',
              style: Get.textTheme.bodyText2)
          .paddingSymmetric(
        vertical: AppDimens.defaultPadding,
        horizontal: AppDimens.defaultPadding,
      ),
      if (controller.getSetup().licensePlates)
        _buildLicensePlatesInput(controller).paddingSymmetric(
            horizontal: AppDimens.defaultPadding,
            vertical: AppDimens.paddingSmall),
      if (HIVE_APP.get(AppConst.keyIdPage) == 1)
        _buildRouteBusNumberInput(controller).paddingSymmetric(
          horizontal: AppDimens.defaultPadding,
          vertical: AppDimens.paddingSmall,
        ),
    ],
  ));
}

Widget _buildLicensePlatesInput(InvoiceCreationController controller) {
  return BuildInputTextWithLabel(
    label: AppStr.licensePlates,
    buildInputText: BuildInputText(
      InputTextModel(
        controller: controller.licensePlatesController,
        isReadOnly: controller.isShowLoading.value,
        iconNextTextInputAction: TextInputAction.next,
        currentNode: controller.licensePlateFocus,
        nextNode: controller.routeBusFocus,
      ),
    ),
  );
}

Widget _buildRouteBusNumberInput(InvoiceCreationController controller) {
  return BuildInputTextWithLabel(
    label: AppStr.routeBusNumber,
    buildInputText: BuildInputText(
      InputTextModel(
        controller: controller.routeBusNumberController,
        iconNextTextInputAction: TextInputAction.done,
        isReadOnly: controller.isShowLoading.value,
        currentNode: controller.routeBusFocus,
      ),
    ),
  );
}
