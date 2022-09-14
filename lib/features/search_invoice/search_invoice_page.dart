
import 'package:easy_invoice_qlhd/base/base.dart';
import 'package:easy_invoice_qlhd/const/all_const.dart';
import 'package:easy_invoice_qlhd/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'search_invoice.dart';

class SearchInvoicePage extends BaseGetWidget<SearchInvoiceController> {
  @override
  SearchInvoiceController get controller => Get.find<SearchInvoiceController>();

  @override
  Widget buildWidgets() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backgroundHomeColor(),
        elevation: 0.0,
        title:
            BaseWidget.buildAppBarTitle(AppStr.searchInvoice.tr.toUpperCase()),
      ),
      body: buildLoadingOverlay(
        () => _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return Container(
      color: AppColors.backgroundHomeColor(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Form(
          key: controller.formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                AppStr.searchInvoiceTitle.tr,
                textAlign: TextAlign.center,
                style: AppStyle.textHintStyle,
              ),

              const SizedBox(height: 40),
              _buildInputTaxCode(),
              const SizedBox(height: 20),
              _buildInputInvoiceCode(),
              // SizedBox(height: 30),
              // _buildSelectInvoiceType(), // chưa sd
              const SizedBox(height: 30),
              _buildButtonSearch(),
              BaseWidget.sizedBox10,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputTaxCode() {
    return BuildInputText(
      InputTextModel(
        prefixIconColor: AppColors.hintTextColor(),
        fillColor: AppColors.inputText(),
        iconLeading: Icons.account_balance_wallet,
        hintText: AppStr.taxCode.tr,
        controller: controller.taxCodeController,
        currentNode: controller.taxCodeFocus,
        nextNode: controller.invoiceCodeFocus,
        inputFormatters: 2,
        // textInputType: TextInputType.number,
        validator: (value) {
          if (value?.trim().isEmpty ?? false) {
            return AppStr.taxCodeEmpty.tr;
          }
          return null;
        },
      ),
    );
  }

  Widget _buildInputInvoiceCode() {
    return BuildInputText(
      InputTextModel(
        prefixIconColor: AppColors.hintTextColor(),
        fillColor: AppColors.inputText(),
        iconLeading: Icons.search,
        hintText: AppStr.searchInvoiceCode.tr,
        controller: controller.invoiceCodeController,
        currentNode: controller.invoiceCodeFocus,
        validator: (value) {
          if (value?.trim().isEmpty ?? false) {
            return AppStr.fKeyCodeEmpty.tr;
          }
          return null;
        },
        iconNextTextInputAction: TextInputAction.done,
        submitFunc: (v) => controller.onPressSearchInvoice(
            controller,
            SearchInvoiceModel(
                fkey: controller.invoiceCodeController.text.trim(),
                taxCode: controller.taxCodeController.text.trim())),
      ),
    );
  }

  Widget _buildButtonSearch() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
            child: BaseWidget.buildButton(
                AppStr.search.tr.toUpperCase(),
                () => controller.onPressSearchInvoice(
                    controller,
                    SearchInvoiceModel(
                        fkey: controller.invoiceCodeController.text.trim(),
                        taxCode: controller.taxCodeController.text.trim())),
                isLoading: controller.isShowLoading.value)),
        const SizedBox(
          width: 10,
        ),
        BaseWidget.baseOnAction(
          onTap: () => controller.scanQrCode(controller),
          child: InkWell(
            child: Container(
              width: AppDimens.btnMedium,
              height: AppDimens.btnMedium,
              decoration: BoxDecoration(
                  gradient:
                      const LinearGradient(colors: AppColors.colorGradientBlue),
                  borderRadius: BorderRadius.circular(8)),
              child: const Icon(
                Icons.qr_code_2,
                size: 30,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
// widget chọn kiểu hoá đơn/phiếu xuất kho (chưa sd)
// Widget _buildSelectInvoiceType() {

//   return Column(
//     mainAxisAlignment: MainAxisAlignment.start,
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: <Widget>[
//       Container(
//         alignment: Alignment.centerLeft,
//         child: Text(
//           AppStr.searchInvoiceTypes,
//           textScaleFactor: 1,
//           style: AppStyle.textStyleDefault.copyWith(color: Colors.white),
//         ),
//       ),
//       SizedBox(
//         height: 10,
//       ),
//       BaseWidget.buildSelectInvoiceType((type) {
//         controller.invoiceType.value = type;
//       }, controller.invoiceType.value)
//     ],
//   );
// }
