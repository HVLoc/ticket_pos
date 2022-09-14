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
                    textInputAction: controller.isCreateOrDuplicate()
                        ? TextInputAction.next
                        : TextInputAction.done,
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
            // if (controller.appController.isSys78.value &&
            //     !controller.isCreateOrDuplicate() &&
            //     controller.productArg.type != 1)
            //   Column(
            //     children: [
            //       Row(
            //         children: [
            //           Expanded(
            //             child: _buildInputNumber(
            //               title: AppStr.productDetailDiscountRatio,
            //               textEditingController:
            //                   controller.discountController.value,
            //               controller: controller,
            //               focusNode: controller.discountFocus,
            //               isSale: controller.isSale,
            //               notifier: controller.discountNotifier,
            //             ),
            //           ),
            //           Expanded(
            //             child: _buildInputNumber(
            //               title: AppStr.productDetailDiscount,
            //               textEditingController:
            //                   controller.discountAmountController.value,
            //               controller: controller,
            //               focusNode: controller.discountAmountFocus,
            //               isSale: controller.isSale,
            //               notifier: controller.discountAmountNotifier,
            //             ),
            //           ),
            //         ],
            //       ),
            //       const Divider(
            //         height: 0,
            //       ),
            //     ],
            //   ),
          ],
        ),
        // Row(
        //   children: [
        //     if (controller.isTaxBill && controller.isProductOrSale())
        //       Expanded(
        //         child: _buildInputNumber(
        //           controller: controller,
        //           focusNode: controller.vatAmountFocus,
        //           textEditingController: controller.vatAmountController.value,
        //           notifier: controller.vatAmountNotifier,
        //           title: AppStr.productDetailTotalVAT.tr,
        //           isSale: controller.isSale,
        //         ),
        //       ),
        //     Expanded(
        //       child: _buildInputNumber(
        //         controller: controller,
        //         focusNode: controller.totalFocus,
        //         textEditingController: controller.totalController.value,
        //         notifier: controller.totalNotifier,
        //         title: controller.isTaxBill
        //             ? AppStr.productDetailTotalPriceNotVat
        //             : AppStr.productDetailTotalPrice.tr,
        //         isSale: controller.isSale,
        //         isValidate: true,
        //       ),
        //     ),
        //   ],
        // ),
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

// Widget _buildDiscountRatio({
//   required ProductDetailController controller,
// }) {
//   return TextFormField(
//     keyboardAppearance: Brightness.light,
//     inputFormatters: [
//       NumericTextFormatter(),
//     ],
//     autovalidateMode: AutovalidateMode.onUserInteraction,
//     onChanged: (value) {
//       if (value.isNotEmpty && double.parse(value) >= 100) {
//         controller.discountController.value.text = '100';
//         controller.discountController.value.selection =
//             TextSelection.fromPosition(
//           TextPosition(offset: controller.discountController.value.text.length),
//         );
//       }

//       controller.changeDiscount();
//     },
//     keyboardType: TextInputType.number,
//     textAlign: TextAlign.end,
//     style: Get.textTheme.bodyText1!.copyWith(
//         decoration: controller.isSale.value ? TextDecoration.lineThrough : null,
//         decorationThickness: 3.0),
//     controller: controller.discountController.value,
//     maxLines: 1,
//     onTap: () {
//       controller.discountController.value.selection =
//           TextSelection.fromPosition(
//         TextPosition(offset: controller.discountController.value.text.length),
//       );
//     },
//     decoration: InputDecoration(
//       labelText: AppStr.productDetailDiscountRatio,
//       labelStyle: Get.textTheme.bodyText2,
//       errorStyle: TextStyle(color: AppColors.errorText()),
//       border: InputBorder.none,
//       contentPadding: const EdgeInsets.all(AppDimens.paddingSmall),
//     ),
//   ).paddingAll(1.0);
// }

Widget _buildSale(ProductDetailController controller) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        AppStr.productDetailSale.tr,
        style: Get.textTheme.bodyText1,
      ),
      Obx(
        () => CupertinoSwitch(
            activeColor: AppColors.chipColor,
            value: controller.isSale.value,
            onChanged: (value) {
              controller.isSale.toggle();
            }),
      ),
    ],
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

// Future _buildMenu(ProductDetailController controller) {
//   return Get.bottomSheet(
//     Container(
//       decoration: BoxDecoration(
//         color: AppColors.buttonColor,
//         borderRadius: const BorderRadius.only(
//           topLeft: Radius.circular(10),
//           topRight: Radius.circular(10),
//         ),
//         border:
//             Border.all(color: AppColors.buttonColor, style: BorderStyle.solid),
//       ),
//       child: BaseWidget.buildSafeArea(
//         Wrap(
//           children: [
//             Column(
//               children: [
//                 ...[
//                   BaseWidget.buildItemShowBottomSheet(
//                     backgroundIcons: AppColors.colorRed444,
//                     icon: Icons.delete_forever,
//                     title: AppStr.delete,
//                     function: () {
//                       Get.find<ProductController>().deleteProduct(
//                           controller, [controller.product.value]);
//                     },
//                   ),
//                   const Divider(
//                     height: 0,
//                     indent: 64,
//                   )
//                 ],
//                 BaseWidget.buildItemShowBottomSheet(
//                   backgroundIcons: AppColors.colorBlue67ff,
//                   icon: Icons.library_books_sharp,
//                   title: AppStr.duplicate,
//                   function: () => Get.to(
//                     () => ProductDetailPage(AppConst.duplicateProduct),
//                     arguments: ProductArg(
//                         type: 3, productItem: controller.product.value),
//                     preventDuplicates: false,
//                   ),
//                 )
//               ],
//             )
//           ],
//         ),
//       ),
//     ),
//   );
// }

Widget buildProExtra(ProductDetailController controller, List<ExtraInfo> list) {
  List<dynamic> _listExtra = controller.productArg.type == 2 ||
          controller.productArg.type == 4 ||
          controller.productArg.type == 0
      ? list
      : controller.listProductExtra;
  return _listExtra.isEmpty
      ? const SizedBox()
      : BaseWidget.buildCardBase(Column(
          children: [
            ListView.builder(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: _listExtra.length,
              itemBuilder: (BuildContext context, int index) =>
                  _buildProductTextFormField(
                //productExtra
                title: _listExtra[index].label ?? '',
                controller: controller,
                textEditingController: controller.extraEditController[index],
                maxLength: 20,
              ),
            ),
          ],
        ).paddingOnly(bottom: AppDimens.paddingVerySmall));
}

// Widget _buildNature(ProductDetailController controller) {
//   return Card(
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[
//         Text(
//           AppStr.productDetailNature,
//           style: Get.textTheme.bodyText2,
//         ),
//         Column(
//           children: List<Widget>.generate(
//             AppStr.listNature.length,
//             (index) => RadioListTile<String>(
//               title: Text(
//                 AppStr.listNature[index],
//                 style: Get.textTheme.bodyText1,
//               ),
//               value: AppStr.listNature[index],
//               dense: true,
//               activeColor: AppColors.chipColor,
//               groupValue: AppStr.listNature[0],
//               onChanged: (value) {},
//             ),
//           ),
//         )
//       ],
//     ).paddingAll(AppDimens.paddingVerySmall),
//   ).paddingAll(AppDimens.paddingVerySmall);
// }
// Widget _buildProperties(ProductDetailController controller) {
//   return Obx(
//     () => BaseWidget.buildCardBase(
//       Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           Text(
//             AppStr.productDetailPropertie,
//             style: Get.textTheme.bodyText2,
//           ),
//           GridView.count(
//             crossAxisCount: 2,
//             physics: const NeverScrollableScrollPhysics(),
//             childAspectRatio: 3,
//             shrinkWrap: true,
//             children:
//                 List<Widget>.generate(AppStr.listFeatures.length, (index) {
//               bool isChoose = AppStr.listFeatures.keys.toList().firstWhere(
//                       (element) => element == controller.properties.value) ==
//                   AppStr.listFeatures.keys.toList()[index];
//               return ChoiceChip(
//                 padding: EdgeInsets.zero,
//                 backgroundColor: AppColors.chipColorTheme(),
//                 selectedColor: AppColors.linkText(),
//                 labelStyle: TextStyle(
//                     color: isChoose ? Colors.white : AppColors.linkText()),
//                 shape: RoundedRectangleBorder(
//                     borderRadius: const BorderRadius.all(Radius.circular(5)),
//                     side: BorderSide(
//                       color:
//                           isChoose ? AppColors.linkText() : Colors.transparent,
//                     )),
//                 label: SizedBox(
//                   width: Get.width / 3,
//                   child: AutoSizeText(
//                     AppStr.listFeatures.values.toList()[index],
//                     maxLines: 1,
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//                 selected: isChoose,
//                 onSelected: (val) {
//                   KeyBoard.hide();
//                   controller.changeProperties(
//                       AppStr.listFeatures.keys.toList()[index]);
//                 },
//               ).paddingAll(AppDimens.paddingSmall);
//             }),
//           )
//         ],
//       ).paddingAll(AppDimens.paddingVerySmall),
//     ),
//   );
// }
