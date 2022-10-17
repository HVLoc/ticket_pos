import 'dart:async';

import 'package:easy_invoice_qlhd/base/base_widget.dart';
import 'package:easy_invoice_qlhd/const/all_const.dart';
import 'package:easy_invoice_qlhd/features/product_detail/product_detail_controller.dart';
import 'package:easy_invoice_qlhd/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

part 'product_detail_widget.dart';

class ProductDetailPage extends BaseGetWidget<ProductDetailController> {
  final String tag;
  ProductDetailPage(this.tag);
  @override
  ProductDetailController get controller =>
      Get.put(ProductDetailController(), tag: tag);
  @override
  Widget buildWidgets() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        // actions: [
        // if (controller.productArg.type == 1)
        //   TextButton(
        //     onPressed: () {
        //       KeyBoard.hide();
        //       _buildMenu(controller);
        //     },
        //     child: Icon(
        //       Icons.more_vert,
        //       color: AppColors.textColor(),
        //     ),
        //   ),
        // ],
        title: BaseWidget.buildAppBarTitle(
          tag,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: buildLoadingOverlay(
              () => _buildBody(),
            ),
          ),
          Obx(
            () => Visibility(
              visible: controller.isVisibleBtn.value,
              child: controller.buildBtnBottom(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return KeyboardActions(
      config: controller.buildConfig(),
      child: Form(
        key: controller.formKey,
        child: Column(
          children: [
            BaseWidget.buildCardBase(
              Column(
                children: [
                  if (controller.isProductOrSale())
                    Column(
                      children: [
                        _buildProductTextFormField(
                          title: AppStr.productCode.tr,
                          textEditingController: controller.codeController,
                          controller: controller,
                          textInputAction: TextInputAction.next,
                          isProductCode: true,
                        ),
                        const Divider(
                          height: 0,
                        ),
                      ],
                    ),
                  _buildProductTextFormField(
                    title: controller.isNote()
                        ? AppStr.note.tr
                        : AppStr.productName.tr,
                    textEditingController: controller.nameController,
                    controller: controller,
                    maxLength: 800,
                    isValidate: true,
                    textInputAction: TextInputAction.done,
                  ),
                  const SizedBox(
                    height: AppDimens.paddingVerySmall,
                  )
                ],
              ),
            ),
            Column(
              children: [
                BaseWidget.sizedBox10,
                _buildMoney(controller),
                BaseWidget.sizedBox10,
              ],
            ),
            Obx(
              () => Visibility(
                child: Column(
                  children: [
                    BaseWidget.sizedBox10,
                    BaseWidget.buildChipVAT(
                      controller.product.value.vatRate!,
                      controller.changeVAT,
                      isUpperCase: false,
                    ),
                  ],
                ),
              ),
            ),
            BaseWidget.sizedBox10,
          ],
        ).paddingAll(AppDimens.paddingSmall),
      ),
    );
  }
}
