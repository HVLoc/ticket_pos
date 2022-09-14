import 'dart:async';
import 'dart:convert';

import 'package:easy_invoice_qlhd/base/base.dart';
import 'package:easy_invoice_qlhd/base/base_page_add_product_controller.dart';
import 'package:easy_invoice_qlhd/const/all_const.dart';
import 'package:easy_invoice_qlhd/features/extra/extra_respone.dart';
import 'package:easy_invoice_qlhd/features/invoice_detail/invoice_detail.dart';
import 'package:easy_invoice_qlhd/features/product/model/product_arg.dart';
import 'package:easy_invoice_qlhd/features/product/model/product_extra.dart';
import 'package:easy_invoice_qlhd/features/product/product.dart';
import 'package:easy_invoice_qlhd/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xml/xml.dart';

import '../../application/app.dart';

class ProductDetailController extends BaseProductAddController {
  List<ExtraInfo> listProdExtraCurrent = <ExtraInfo>[];
  List<ProductExtra> listProductExtra = <ProductExtra>[]; //respone

  late ProductItem oldProduct;
  late ProductArg productArg;

  late ProductRepository _productRepository;

  ProductDetailController() {
    _productRepository = ProductRepository(this);
  }
  late List<TextEditingController> extraEditController;

  @override
  void onInit() {
    getValue();
    totalFocus.addListener(() {
      if (!isEnableTextFieldTotal.value) totalFocus.unfocus();
    });
    if (product.value.unit.isStringEmpty) {
      unitController.value.text = AppStr.productDetailUnitDefault;
    }
    listProdExtraCurrent
        .addAll(homeController.extraInfoRespone.data!.first.proExtra ?? []);
    extraEditController = List.generate(
        isProductExtraCurrent()
            ? listProductExtra.length
            : listProdExtraCurrent.length,
        (i) => TextEditingController(
            text: isProductExtraCurrent()
                ? listProductExtra[i].value?.trim() ?? ''
                : listProExtraRespone()[i]));
    super.onInit();
  }

  void getValue() {
    productArg = Get.arguments;
    isTaxBill = true;
    // clone object, tránh trường hợp 2 màn hình cùng listen 1 object.
    oldProduct = productArg.productItem;
    product = ProductItem.fromJson(oldProduct.toJsonProd()).obs;

    // nhân bản => mã sp trở về rỗng
    codeController.text = productArg.type != 3 ? product.value.code ?? '' : '';
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
    // if (productArg.type == 1) {
    try {
      print(jsonDecode(productArg.productItem.extra));
      listProductExtra = productArg.productItem.extra != null &&
              productArg.productItem.extra.isNotEmpty
          ? List<ProductExtra>.from(jsonDecode(productArg.productItem.extra)
              .map((x) => ProductExtra.fromJson(x)))
          : [];
    } catch (e) {
      print(e);
    }
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

  bool isProductExtraCurrent() => productArg.type == 1;

  @override
  void onAccept() {
    if (formKey.currentState!.validate()) {
      KeyBoard.hide();
      formKey.currentState!.save();
      var _amount =
          CurrencyUtils.formatNumberCurrency(priceController.value.text);
      var _total =
          (_amount / (1 + vatValue(product.value.vatRate))).round().toDouble();

      if (isCreateOrDuplicate()) {
        product.value.id = HIVE_PRODUCT.isEmpty
            ? 0
            : (HIVE_PRODUCT.toMap().entries.last.value.id! + 1);
      }

      product.value
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
        ..feature = properties.value
        ..extra = addProdExtraToNewProd(productArg.productItem);

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
    if (isTaxBill)
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

  bool isProductDetailView() => productArg.type == 0 || productArg.type == 4;

  bool isCreateOrDuplicate() => productArg.type == 2 || productArg.type == 3;

  String titleAppBar() {
    if (productArg.type == 0) return AppStr.productDetailTitle;
    switch (productArg.type) {
      case 1:
        return AppStr.updateProduct.tr;
      default:
        return AppStr.addProduct.tr;
    }
  }

  void saveProduct() async {
    if (formKey.currentState!.validate()) {
      KeyBoard.hide();
      formKey.currentState!.save();
      // if (isCreateOrDuplicate()) {
      //   var response = await _productRepository.productSearch(
      //       BaseRequestListModel(key: codeController.text.trim(), page: 0));
      //   if (response.totalRecords > 0) {
      //     showSnackBar(AppStr.productCodeDuplicate.tr);
      //     return;
      //   }
      // }
      product.value
        ..code = codeController.text
        ..name = nameController.text
        ..price = CurrencyUtils.formatNumberCurrency(
            priceController.value.text.isNotEmpty
                ? priceController.value.text
                : '0')
        ..unit = unitController.value.text
        ..desc = descController.text
        ..extra = ((productArg.productItem.extra?.isNotEmpty ?? false) ||
                    !(isProductExtraCurrent() || (productArg.type == 0))) &&
                isProductOrSale()
            ? addProdExtraToNewProd(productArg.productItem)
            : '';

      // updateProduct();
    }
  }

  // Api update product
  Future<void> updateProduct() async {
    showLoadingOverlay();
    XmlDocument xml = await buildUpdateProductXml();
    BaseResponse updateResponse = await _productRepository
        .updateProduct(xml.toString())
        .whenComplete(() => hideLoadingOverlay());
    if (updateResponse.status == AppConst.responseSuccess) {
      if (productArg.type == 3) Get.back();
      Get.back(result: 'refresh');
      showSnackBar(AppStr.saveDataSuccess.tr);
    } else {
      showSnackBar(updateResponse.message, duration: 5.seconds);
    }
  }

  void backToProductList() {
    Get.until(ModalRoute.withName(AppConst.routeProduct));
  }

  // build Xml update product
  Future<XmlDocument> buildUpdateProductXml() async {
    var builder = XmlBuilder();
    builder.element(AppStr.XML_PRODUCTS, nest: () {
      builder.element(AppStr.FIELD_PRODUCT, nest: () {
        builder.element(AppStr.FIELD_PRODUCT_CODE, nest: product.value.code);
        builder.element(AppStr.FIELD_NAME, nest: product.value.name);
        builder.element(AppStr.FIELD_UNIT, nest: product.value.unit);
        builder.element(AppStr.FIELD_PRICE, nest: product.value.price);
        builder.element(AppStr.FIELD_PRODUCT_DES, nest: product.value.desc);
        builder.element(AppStr.FIELD_PRODUCT_VAT_RATE,
            nest: product.value.vatRate);
        builder.element(AppStr.FIELD_INVOICE_EXTRA, nest: product.value.extra);
      });
    });
    return builder.buildDocument();
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

  String addProdExtraToXML(ProductItem item) {
    var mapProExtra = Map<String, String>();
    for (var i = 0; i < extraEditController.length; i++) {
      mapProExtra[listProdExtraCurrent[i].name] =
          extraEditController.map((e) => e.text).toList()[i];
    }
    item.extra = json.encode(mapProExtra);
    return item.extra;
  }

  String addProdExtraToNewProd(ProductItem productItem) {
    List<ProductExtra> listProExtraCreate = List.generate(
        listProdExtraCurrent.length,
        (index) => ProductExtra(
            label: listProdExtraCurrent[index].label,
            name: listProdExtraCurrent[index].name,
            value: extraEditController[index].text,
            visibility: true));
    return jsonEncode(listProExtraCreate);
  }

  List<String> listProExtraRespone() {
    try {
      Map<String, dynamic> mapProExtraRespone =
          jsonDecode(productArg.productItem.extra ?? '');
      List<String> listProExtraRespone =
          List.generate(listProdExtraCurrent.length, (index) => '');
      for (var i = 0; i < listProdExtraCurrent.length; i++) {
        listProExtraRespone[i] = mapProExtraRespone.entries
            .firstWhere((e) => e.key == listProdExtraCurrent[i].name)
            .value
            .toString();
      }
      return listProExtraRespone;
    } catch (e) {
      List<String> listProExtraRespone =
          List.generate(listProdExtraCurrent.length, (index) => '');
      for (var i = 0; i < listProdExtraCurrent.length; i++) {
        listProExtraRespone[i] = listProductExtra
                .firstWhereOrNull((e) => e.name == listProdExtraCurrent[i].name)
                ?.value ??
            '';
      }
      return listProExtraRespone;
    }
  }

}
