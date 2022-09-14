import 'dart:async';

import 'package:easy_invoice_qlhd/base/base.dart';
import 'package:easy_invoice_qlhd/const/all_const.dart';
import 'package:easy_invoice_qlhd/features/product_creation_quick.dart/prod_crequick_controller.dart';
import 'package:easy_invoice_qlhd/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

part 'prod_crequick_widget.dart';

class ProdCreateQuick extends BaseGetWidget<ProdCreQuickController> {
  @override
  ProdCreQuickController get controller => Get.put(ProdCreQuickController());

  @override
  Widget buildWidgets() {
    return buildProdCreateQuick(controller);
  }
}

Widget buildProdCreateQuick(ProdCreQuickController controller) {
  return BaseWidget.baseBottomSheet(
      isSecondDisplay: false,
      title: AppStr.addProduct,
      body: Column(
        children: [
          Expanded(
            child: KeyboardActions(
              config: controller.buildConfig(),
              child: SingleChildScrollView(
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                     
                      Obx(
                        () => Container(
                            child: controller.isNote()
                                ? _buildProductTextFormField(
                                    title: AppStr.note,
                                    textEditingController:
                                        controller.prodNoteController,
                                    maxLength: 800,
                                    isValidate: true)
                                : Column(children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: _buildProductTextFormField(
                                              title: AppStr.productName,
                                              textEditingController:
                                                  controller.nameController,
                                              maxLength: 500,
                                              isValidate: true),
                                        ),
                                        if (controller.properties.value != 3)
                                          Expanded(
                                            child: Column(
                                              children: [
                                                _buildProductTextFormField(
                                                  title: AppStr.unit,
                                                  maxLength: 50,
                                                  textEditingController:
                                                      controller
                                                          .unitController.value,
                                                ).paddingOnly(
                                                    left:
                                                        AppDimens.paddingSmall),
                                              ],
                                            ),
                                          ),
                                      ],
                                    ),
                                    if (controller.properties.value != 3)
                                      Column(
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: _buildInputNumber(
                                                    controller: controller,
                                                    focusNode: controller
                                                        .quantityFocus,
                                                    textEditingController:
                                                        controller
                                                            .prodQuantityController
                                                            .value,
                                                    notifier: controller
                                                        .quantityNotifier,
                                                    title: AppStr.quantity.tr,
                                                    isSale: false.obs,
                                                    isValidate: true),
                                              ),
                                              const SizedBox(
                                                width: AppDimens.paddingSmall,
                                              ),
                                              Expanded(
                                                child: _buildInputNumber(
                                                  controller: controller,
                                                  focusNode:
                                                      controller.priceFocus,
                                                  textEditingController:
                                                      controller.priceController
                                                          .value,
                                                  notifier:
                                                      controller.priceNotifier,
                                                  title: AppStr
                                                      .productDetailPrice.tr,
                                                  isSale: controller.isSale,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: _buildInputNumber(
                                                  controller: controller,
                                                  focusNode:
                                                      controller.discountFocus,
                                                  textEditingController:
                                                      controller
                                                          .discountController
                                                          .value,
                                                  notifier: controller
                                                      .discountNotifier,
                                                  title: AppStr
                                                      .productDetailDiscountRatio
                                                      .tr,
                                                  isSale: controller.isSale,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: AppDimens.paddingSmall,
                                              ),
                                              Expanded(
                                                child: _buildInputNumber(
                                                  controller: controller,
                                                  focusNode: controller
                                                      .discountAmountFocus,
                                                  textEditingController: controller
                                                      .discountAmountController
                                                      .value,
                                                  notifier: controller
                                                      .discountAmountNotifier,
                                                  title: AppStr
                                                      .productDetailDiscount.tr,
                                                  isSale: controller.isSale,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    _buildInputNumber(
                                      controller: controller,
                                      focusNode: controller.totalFocus,
                                      textEditingController:
                                          controller.totalController.value,
                                      notifier: controller.totalNotifier,
                                      title: controller.properties.value != 3 &&
                                              !controller.isSellInv &&
                                              controller.invoicePattern
                                                      .invoiceType ==
                                                  1
                                          ? AppStr
                                              .productDetailTotalPriceNotVat.tr
                                          : AppStr.productDetailTotalPrice,
                                      isSale: false.obs,
                                    ),
                                    if (controller.properties.value != 3 &&
                                        !controller.isSellInv &&
                                        controller.invoicePattern.invoiceType ==
                                            1)
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                    AppStr.productDetailVAT +
                                                        ': ',
                                                    style: Get
                                                        .textTheme.subtitle1),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: AppColors
                                                        .inputTextBottomSheet(),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.0),
                                                    border: Border.all(
                                                        color: AppColors
                                                            .inputTextBottomSheet(),
                                                        style:
                                                            BorderStyle.solid,
                                                        width: 0.80),
                                                  ),
                                                  child: buildDropDownButton(
                                                    controller.selectedVat,
                                                    controller.listVat,
                                                    controller
                                                        .selectedVatString,
                                                    (newValueVat) {
                                                      controller.selectedVat =
                                                          newValueVat ??
                                                              controller
                                                                  .listVat[0];
                                                      controller
                                                              .selectedVatString
                                                              .value =
                                                          controller
                                                              .selectedVat.name;
                                                      controller.changeVAT(
                                                          controller
                                                              .selectedVatString
                                                              .value);
                                                    },
                                                  ).paddingOnly(
                                                      left: AppDimens
                                                          .paddingVerySmall),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            width: AppDimens.paddingSmall,
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: _buildInputNumber(
                                              controller: controller,
                                              focusNode:
                                                  controller.vatAmountFocus,
                                              textEditingController: controller
                                                  .vatAmountController.value,
                                              notifier:
                                                  controller.vatAmountNotifier,
                                              title: AppStr
                                                  .productDetailTotalVAT.tr,
                                              isSale: controller.isSale,
                                            ),
                                          )
                                        ],
                                      ),
                                  ])),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Obx(() => Visibility(
                visible: controller.isVisibleBtn.value,
                child: controller.buildBtnBottom(),
              )),
        ],
      ));
}
