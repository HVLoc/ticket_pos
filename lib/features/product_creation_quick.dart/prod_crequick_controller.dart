import 'package:easy_invoice_qlhd/base/base_page_add_product_controller.dart';
import 'package:easy_invoice_qlhd/const/all_const.dart';
import 'package:easy_invoice_qlhd/features/invoice/invoice.dart';
import 'package:easy_invoice_qlhd/utils/utils.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class ProdCreQuickController extends BaseProductAddController {
  List<DropdownItem> listFeatures = AppStr.listFeatures.entries
      .map((entry) => DropdownItem(entry.key, entry.value))
      .toList();
  List<DropdownItem> listVat = AppStr.listVAT.entries
      .map((entry) => DropdownItem(entry.key, entry.value))
      .toList();
  late DropdownItem selectedFeature;
  late DropdownItem selectedVat;

  RxString selectedFeaturedString = ''.obs;
  RxString selectedVatString = ''.obs;
  late InvoicePattern invoicePattern;

  TextEditingController prodNoteController = TextEditingController();

  late bool isSellInv;

  @override
  void onInit() {
    isSellInv = invoicePattern.pattern.startsWith('2');
    isTaxBill = true;
    selectedFeature = listFeatures[0];
    selectedVat = listVat[0];
    super.onInit();
  }

  void changeVAT(String value) {
    KeyBoard.hide();
    product.update((val) {
      val!.vatRate = AppStr.listVAT.entries
          .firstWhere((element) => element.value == value)
          .key;
    });
    setVatAmount();
  }

  void setPrice() =>
      CurrencyUtils.formatNumberCurrency(prodQuantityController.value.text) ==
              0.0
          ? 0
          : priceController.value.text = CurrencyUtils.formatCurrency(
              CurrencyUtils.formatNumberCurrency(totalController.value.text) /
                  CurrencyUtils.formatNumberCurrency(
                      prodQuantityController.value.text));

  @override
  onAccept() {
    if (formKey.currentState!.validate()) {
      KeyBoard.hide();
      formKey.currentState!.save();
      var _total =
          CurrencyUtils.formatNumberCurrency(totalController.value.text);
      var _amount = isTaxBill
          ? (_total +
              CurrencyUtils.formatNumberCurrency(
                  vatAmountController.value.text))
          : _total;

      product.value
        ..name = isNote() ? prodNoteController.text : nameController.text
        ..price = isProductOrSale()
            ? CurrencyUtils.formatNumberCurrency(
                priceController.value.text.isNotEmpty
                    ? priceController.value.text
                    : '0')
            : 0
        ..quantity = isProductOrSale()
            ? CurrencyUtils.formatNumberCurrency(
                prodQuantityController.value.text)
            : 0
        ..unit = isProductOrSale() ? unitController.value.text : ''
        ..vatAmount = isProductOrSale()
            ? CurrencyUtils.formatNumberCurrency(vatAmountController.value.text)
            : 0
        ..discount = isNote()
            ? 0
            : CurrencyUtils.formatNumberCurrency(discountController.value.text)
        ..discountAmount = isNote()
            ? 0
            : CurrencyUtils.formatNumberCurrency(
                discountAmountController.value.text)
        ..total = isNote() ? 0 : _total
        ..amount = isNote() ? 0 : _amount
        ..isSum = isSale.value
        ..vatRate = isProductOrSale() || isSellInv ? selectedVat.id : -1
        ..feature = properties.value;

      Get.back(result: product.value);
    }
  }

  @override
  setDiscountAmount() {
    double _disAmount =
        (CurrencyUtils.formatNumberCurrency(prodQuantityController.value.text) *
            CurrencyUtils.formatNumberCurrency(priceController.value.text) *
            (double.tryParse(discountController.value.text) ?? 0) /
            100);
    double _total =
        CurrencyUtils.formatNumberCurrency(prodQuantityController.value.text) *
            CurrencyUtils.formatNumberCurrency(priceController.value.text);
    discountAmountController.value.text = _total < _disAmount
        ? AppStr.error.tr
        : CurrencyUtils.formatCurrency(
            _disAmount,
            isCheckError: true,
          );
    product.value.discountAmount =
        CurrencyUtils.formatNumberCurrency(discountAmountController.value.text);
  }

  @override
  void setTotal() {
    totalController.value.text = CurrencyUtils.formatCurrency(
        ((CurrencyUtils.formatNumberCurrency(
                        prodQuantityController.value.text) *
                    CurrencyUtils.formatNumberCurrency(
                        priceController.value.text))
                .round() -
            CurrencyUtils.formatNumberCurrency(
                discountAmountController.value.text)),
        isCheckError: true);
  }

  @override
  void setVatAmount() {
    if (isTaxBill)
      vatAmountController.value.text = CurrencyUtils.formatCurrency(
        ((CurrencyUtils.formatNumberCurrency(
                        prodQuantityController.value.text) *
                    CurrencyUtils.formatNumberCurrency(
                        priceController.value.text) -
                CurrencyUtils.formatNumberCurrency(
                    discountAmountController.value.text)) *
            vatValue(product.value.vatRate)),
      );
  }

  @override
  Widget buildBtnBottom() {
    return Container(
      height: 80,
      child: BaseWidget.buildButton(AppStr.done, () {
        onAccept();
      }).paddingAll(AppDimens.paddingSmall),
    );
  }
}

class DropdownItem {
  const DropdownItem(this.id, this.name);
  final int id;
  final String name;
}
