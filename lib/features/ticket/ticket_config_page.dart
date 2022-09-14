import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_invoice_qlhd/application/app_controller.dart';
import 'package:easy_invoice_qlhd/features/ticket/controller/ticket_ctr_imp.dart';
import 'package:easy_invoice_qlhd/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../base/base.dart';
import '../../const/all_const.dart';
import '../invoice_detail/model/invoice_detail_response.dart';
import 'controller/ticket_controller.dart';

class TicketConfigPage extends BaseGetWidget<TicketController> {
  @override
  TicketController get controller => Get.put(TicketControllerImp());

  @override
  Widget buildWidgets() {
    return BaseWidget.buildSafeArea(
      Scaffold(
        appBar: AppBar(
          title: BaseWidget.buildAppBarTitle(HIVE_ACCOUNT
                  .get(HIVE_APP.get(AppConst.keyCurrentAccount))
                  ?.nameAccount ??
              AppStr.loginBtn),
          centerTitle: true,
          actions: [
            TextButton(
              onPressed: controller.addProduct,
              child: Text(
                AppStr.ticketAddProduct,
                style: Get.textTheme.subtitle1!.copyWith(
                  color: AppColors.linkText(),
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
        body: buildLoadingOverlay(
          () => _buildBody(),
        ),
      ),
    );
  }

  Widget _buildProductEmpty() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppStr.dataEmpty,
          style: Get.textTheme.headline4?.copyWith(
            color: AppColors.textColor(),
          ),
        ),
        BaseWidget.sizedBox10,
        Text(
          AppStr.ticketHelpLogin,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: AppDimens.fontBig(),
            color: AppColors.textColor(),
          ),
        ),
        BaseWidget.sizedBoxPaddingHuge,
        if (controller.appController.isAdmin.value)
          BaseWidget.buildButton(AppStr.ticketAddProduct, () {
            controller.addProduct();
          })
      ],
    ).paddingSymmetric(horizontal: AppDimens.paddingSmall);
  }

  Widget _buildBody() {
    return ValueListenableBuilder(
      valueListenable: HIVE_PRODUCT.listenable(),
      builder: (context, item, _) {
        return HIVE_PRODUCT.isEmpty
            ? _buildProductEmpty()
            : _buildListProduct();
      },
    );
  }

  Widget _buildListProduct() {
    return ListView.separated(
      itemBuilder: (context, index) {
        // reverse
        int _index = HIVE_PRODUCT.length - index - 1;
        return _buildItemAdmin(_index);
      },
      separatorBuilder: (context, index) {
        return BaseWidget.sizedBox10;
      },
      itemCount: HIVE_PRODUCT.length,
    ).paddingSymmetric(
      horizontal: AppDimens.paddingSmall,
    );
  }

  Widget _buildItemAdmin(int index) {
    ProductItem item = HIVE_PRODUCT.getAt(index)!;

    return Obx(
      () => BaseWidget.buildCardBase(
        InkWell(
          onTap: () {
            if (controller.appController.isAdmin.value) {
              controller.updateProduct(index);
            }
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              BaseWidget.sizedBox10,
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: AutoSizeText(
                      item.name.toString(),
                      style: Get.textTheme.bodyText1!.copyWith(fontSize: 16),
                    ),
                  ),
                  BaseWidget.sizedBox10,
                  TextButton(
                    onPressed: () {
                      controller.updateProduct(index);
                    },
                    child: AutoSizeText(
                      AppStr.fix,
                      style: Get.textTheme.bodyText1?.copyWith(
                        color: AppColors.linkText(),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      controller.deleteProduct(index);
                    },
                    child: AutoSizeText(
                      AppStr.delete,
                      style: Get.textTheme.bodyText1?.copyWith(
                        color: AppColors.linkText(),
                      ),
                    ),
                  ),
                ],
              ),
              if (item.unit.isStringNotEmpty)
                AutoSizeText(
                  AppStr.unit + (item.unit ?? ''),
                  style: Get.theme.textTheme.subtitle2!.copyWith(
                    fontSize: AppDimens.fontSmall(),
                    color: AppColors.hintTextColor(),
                  ),
                ),
              buildExtra(controller.homeController, item),
              AutoSizeText(
                AppStr.productPrice +
                    CurrencyUtils.formatCurrencyForeign(
                      convertDoubleToStringSmart(item.amount),
                    ),
                style: Get.theme.textTheme.subtitle2!.copyWith(
                  fontSize: AppDimens.fontSmall(),
                  color: AppColors.hintTextColor(),
                ),
              ),
              BaseWidget.sizedBox10,
            ],
          ).paddingSymmetric(
            horizontal: AppDimens.paddingVerySmall,
          ),
        ),
      ),
    );
  }
}
