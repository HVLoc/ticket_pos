import 'dart:async';

import 'package:easy_invoice_qlhd/base/base_page_add_product_controller.dart';
import 'package:easy_invoice_qlhd/const/all_const.dart';
import 'package:easy_invoice_qlhd/features/invoice_detail/invoice_detail.dart';
import 'package:easy_invoice_qlhd/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductDetailController extends BaseProductAddController {
  late ProductItem oldProduct;

  @override
  void onInit() {
    getValue();

    totalFocus.addListener(() {
      if (!isEnableTextFieldTotal.value) totalFocus.unfocus();
    });
    if (product.value.unit.isStringEmpty) {
      unitController.value.text = AppStr.productDetailUnitDefault;
    }

    super.onInit();
  }

  void getValue() {
    oldProduct = Get.arguments;

    product = ProductItem.fromJson(oldProduct.toJsonProd()).obs;

    codeController.text = product.value.code ?? '';
    nameController.text = product.value.name ?? '';
    descController.text = product.value.desc ?? '';
    unitController.value.text = product.value.unit ?? '';
    priceController.value.text = product.value.amount == 0
        ? ''
        : CurrencyUtils.formatCurrencyForeign(
            product.value.amount!.toInt() == product.value.amount
                ? product.value.amount!.toInt()
                : product.value.amount);

    double vat = product.value.vatAmount != null
        ? product.value.vatAmount!
        : CurrencyUtils.formatNumberCurrency(totalController.value.text) *
            vatValue(product.value.vatRate);
    vatAmountController.value.text = product.value.vatAmount == 0
        ? ''
        : CurrencyUtils.formatCurrencyForeign(
            vat.toInt() == vat ? vat.toInt() : vat);

    isSale.value = product.value.isSum;
    isEnableTextFieldTotal.value = priceController.value.text.isEmpty;
    var _total =
        product.value.total ?? product.value.quantity * product.value.price!;
    properties.value = product.value.feature;

    discountController.value.text = CurrencyUtils.formatCurrencyForeign(
        (product.value.discount?.toInt() == product.value.discount
                ? product.value.discount?.toInt()
                : product.value.discount) ??
            0);
    discountAmountController.value.text =
        CurrencyUtils.formatCurrency(product.value.discountAmount ?? 0);

    totalController.value.text =
        CurrencyUtils.formatCurrency(isDiscount() ? _total.abs() : _total);
  }

  //change value
  void changeQuantity(double? value) {
    product.value.quantityLocal.value = value ?? 0;
    setDiscountAmount();
    setVatAmount();
    setTotal();
  }

  //calculator
  void setPrice() => product.value.quantityLocal.value == 0
      ? 0
      : priceController.value.text = CurrencyUtils.formatCurrency(
          CurrencyUtils.formatNumberCurrency(totalController.value.text) /
              product.value.quantityLocal.value);

  @override
  void onAccept() {
    if (formKey.currentState!.validate()) {
      KeyBoard.hide();
      formKey.currentState!.save();
      var _amount =
          CurrencyUtils.formatNumberCurrency(priceController.value.text);
      var _total =
          (_amount / (1 + vatValue(product.value.vatRate))).round().toDouble();

      product.value
        ..id = oldProduct.id ?? generateUiid('ProductItem')
        ..code = isProductOrSale() ? codeController.text : ''
        ..name = nameController.text
        ..price = double.tryParse(
            (_amount / (1 + vatValue(product.value.vatRate)))
                .toStringAsFixed(6))
        ..unit = isProductOrSale() ? unitController.value.text : ''
        ..vatAmount = _amount - _total
        ..total = _total
        ..amount = _amount
        ..discount = CurrencyUtils.formatNumberCurrency(
            discountController.value.text.trim())
        ..discountAmount = isProductOrSale()
            ? CurrencyUtils.formatNumberCurrency(
                discountAmountController.value.text)
            : 0
        ..isSum = isSale.value
        ..quantityLocal.value = 1
        ..quantity = isProductOrSale() ? product.value.quantityLocal.value : 0
        ..vatRate = product.value.vatRate
        ..feature = properties.value;

      Get.back(result: product.value);
    }
  }

  @override
  void setDiscountAmount() {
    double _disAmount = product.value.quantityLocal.value *
        CurrencyUtils.formatNumberCurrency(priceController.value.text) *
        (double.tryParse(discountController.value.text) ?? 0) /
        100;
    double _total = product.value.quantityLocal.value *
        CurrencyUtils.formatNumberCurrency(priceController.value.text);
    discountAmountController.value.text = _total < _disAmount
        ? AppStr.error.tr
        : CurrencyUtils.formatCurrency(
            _disAmount,
            isCheckError: true,
          );
  }

  @override
  void setTotal() {
    totalController.value.text = CurrencyUtils.formatCurrency(
      ((product.value.quantityLocal.value *
                  CurrencyUtils.formatNumberCurrency(
                      priceController.value.text))
              .round() -
          CurrencyUtils.formatNumberCurrency(
              discountAmountController.value.text)),
      isCheckError: true,
    );
  }

  @override
  void setVatAmount() {
    vatAmountController.value.text = CurrencyUtils.formatCurrency(
      (((product.value.quantityLocal.value *
                      CurrencyUtils.formatNumberCurrency(
                          priceController.value.text))
                  .round() -
              CurrencyUtils.formatNumberCurrency(
                  discountAmountController.value.text)) *
          vatValue(product.value.vatRate)),
    );
  }

  void saveProduct() async {
    if (formKey.currentState!.validate()) {
      KeyBoard.hide();
      formKey.currentState!.save();
      product.value
        ..code = codeController.text
        ..name = nameController.text
        ..price = CurrencyUtils.formatNumberCurrency(
            priceController.value.text.isNotEmpty
                ? priceController.value.text
                : '0')
        ..unit = unitController.value.text
        ..desc = descController.text;

      // updateProduct();
    }
  }

  Future<void> updateProduct() async {
    showLoadingOverlay();

    Get.back(result: 'refresh');
    showSnackBar(AppStr.saveDataSuccess.tr);
  }

  void backToProductList() {
    Get.until(ModalRoute.withName(AppConst.routeProduct));
  }

  @override
  Widget buildBtnBottom() {
    return Container(
      color: AppColors.appBarColor(),
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.all(AppDimens.paddingSmall),
      child: BaseWidget.buildButton(
        AppStr.accept,
        onAccept,
      ),
    );
  }
}
