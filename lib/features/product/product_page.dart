import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_invoice_qlhd/base/base_page_search_widget.dart';
import 'package:easy_invoice_qlhd/const/all_const.dart';
import 'package:easy_invoice_qlhd/features/invoice_detail/invoice_detail.dart';
import 'package:easy_invoice_qlhd/features/product/model/product_arg.dart';
import 'package:easy_invoice_qlhd/features/product/product_description_page.dart';
import 'package:easy_invoice_qlhd/features/product_detail/product_detail.dart';
import 'package:easy_invoice_qlhd/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'product.dart';
import 'product_controller.dart';

class ProductPage extends BasePageSearchWidget<ProductController> {
  @override
  ProductController get controller => Get.put(ProductController());

  @override
  Widget buildWidgets() {
    return buildPage(
      body: buildAppBarScroll(
        listSliverAppBar: _buildListSliverAppBar(),
        widgetBody: buildLoadingOverlay(
          () => _buildBody(),
        ),
      ),
      miniumBottom: 12,
      isNeedUpToPage: true,
    );
  }

  List<Widget> _buildListSliverAppBar() {
    return listSliverAppBar(
      titleAppBar: controller.isSelectProduct()
          ? AppStr.selectProduct.tr
          : AppStr.productDetailProduct.tr,
      hintTextSearch: AppStr.productSearch.tr,
      actions: [
        if (controller.isSelectProduct())
          TextButton(
            onPressed: () => Get.to(
              () => ProductDetailPage(AppConst.createProduct),
              arguments: ProductArg(
                type: controller.isSelectProduct() ? 4 : 2,
                productItem: ProductItem(
                    price: 0.0, quantity: 0.0, vatRate: -1, extra: ""),
              ),
            )?.then((value) {
              if (value != null) {
                if (controller.isSelectProduct()) {
                  controller.listSelected.add(value);
                  Get.back(result: controller.listSelected);
                } else {
                  controller.getProducts();
                }
              }
            }),
            child: Icon(
              Icons.add_circle_outline,
              color: AppColors.textColor(),
              size: AppDimens.sizeIconMedium,
            ),
          ),
      ],
      widgetDesc: controller.isSelectProduct()
          ? Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.paddingSearchBarSmall),
              child: Ink(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: AppColors.inputTextWhite(),
                  ),
                  child: _buildAddProductDesc()),
            )
          : null,
    );
  }

  Widget _buildAddProductDesc() {
    return InkWell(
      onTap: () => {
        Get.bottomSheet<ProductItem>(ProductDescriptionPage((item) {
          controller.listSelected.add(item);
          Get.back();
          Get.back(result: controller.listSelected);
        }), isScrollControlled: true)
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            AppStr.addDesc.tr,
            style: Get.textTheme.bodyText2!
                .copyWith(color: AppColors.hintTextColor()),
          ),
          Icon(
            Icons.chevron_right,
            color: AppColors.hintTextColor(),
          )
        ],
      ).paddingAll(AppDimens.paddingSearchBarSmall),
    );
  }

  Widget _buildBody() {
    return baseShimmerLoading(
      () => BaseWidget.buildListAndBtn(
        child: controller.rxList.isEmpty
            ? BaseWidget.buildEmpty(onRefresh: () {
                controller.onRefresh();
              })
            : BaseWidget.buildSmartRefresher(
                refreshController: controller.refreshController,
                onRefresh: controller.onRefresh,
                onLoadMore: controller.onLoadMore,
                enablePullUp:
                    controller.rxList.length != controller.totalRecords,
                child: ListView.separated(
                  controller: controller.scrollControllerUpToTop,
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: EdgeInsets.only(
                      top: controller.isScrollToTop()
                          ? 0
                          : controller.isSelectProduct()
                              ? 100
                              : 50),
                  itemBuilder: (context, index) {
                    return widgetItemList(index);
                  },
                  separatorBuilder: (context, index) {
                    return ItemUtils.buildDivider();
                  },
                  itemCount: controller.rxList.length,
                ),
              ),
        buildBtn: controller.isSelectProduct()
            ? _buildBtnSelectProduct()
            : _buildBtnDeleteProduct(),
      ),
    );
  }

  @override
  Widget widgetItemList(int index) {
    ProductItem item = controller.rxList[index];
    return _buildItem(item);
  }

  Widget _buildItem(ProductItem item) {
    return Obx(
      () => ListTile(
        onTap: () {
          controller.isSelectProduct()
              ? controller.choiceItem(item)
              : controller.listSelected.isNotEmpty
                  ? controller.choiceItemDelete(item)
                  : Get.to(
                      () => ProductDetailPage(AppConst.editProduct),
                      arguments: ProductArg(type: 1, productItem: item),
                    )?.then((value) {
                      if (value != null) {
                        controller.searchController.text = '';
                        controller.getProducts();
                      }
                    });
        },
        onLongPress: () {
          if (controller.type != 0) controller.choiceItemDelete(item);
        },
        contentPadding: const EdgeInsets.all(AppDimens.defaultPadding),
        selectedTileColor: AppColors.selectedProduct(),
        selected: item.isSelected.value,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildName(item),
            BaseWidget.sizedBoxPadding,
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPrice(item),
                      _buildVAT(item),
                      Text("${AppStr.unit.tr} ${item.unit}",
                          style: Get.theme.textTheme.subtitle1!
                              .copyWith(color: AppColors.hintTextColor()))
                    ],
                  ),
                ),
                Flexible(
                  child: Visibility(
                    visible: item.quantity > 0 && controller.isSelectProduct(),
                    child: _buildSelectProduct(item),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildName(ProductItem item) {
    return Row(
      children: [
        Expanded(
          child: RichText(
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              children: [
                TextSpan(
                  children: BaseWidget.highlightText(
                    item.code ?? '',
                    controller.searchController.value.text,
                    AppColors.bgHighLight,
                  ),
                  style: Get.theme.textTheme.subtitle1!.copyWith(
                    color: AppColors.chipColor,
                  ),
                ),
                TextSpan(
                  children: BaseWidget.highlightText(
                    " - ${item.name}",
                    controller.searchController.value.text,
                    AppColors.bgHighLight,
                  ),
                )
              ],
              style: Get.theme.textTheme.subtitle1,
            ),
          ),
        ),
        if (controller.type != 0 && controller.listSelected.isEmpty)
          InkWell(
            onTap: () {
              controller.deleteProduct(controller, [item]);
            },
            child: Text(
              AppStr.delete.tr,
              style: Get.textTheme.bodyText2!.copyWith(
                color: AppColors.linkText(),
              ),
            ).paddingOnly(
              left: AppDimens.defaultPadding,
            ),
          ),
      ],
    );
  }

  Widget _buildPrice(ProductItem item) {
    return Text(
      AppStr.productPrice.tr +
          CurrencyUtils.formatCurrencyForeign(
              convertDoubleToStringSmart(item.price)),
      style: Get.theme.textTheme.subtitle1!
          .copyWith(color: AppColors.hintTextColor()),
    );
  }

  Widget _buildVAT(ProductItem item) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 4.0),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.blueAccent),
          borderRadius: const BorderRadius.all(Radius.circular(4))),
      child: Text(
        vatStr(item),
        style: Get.theme.textTheme.subtitle2!.copyWith(
          fontSize: AppDimens.fontSmallest(),
          color: AppColors.hintTextColor(),
        ),
      ),
    ).paddingSymmetric(vertical: AppDimens.paddingVerySmall);
  }

  Widget _buildSelectProduct(ProductItem item) {
    return BaseWidget.buildSpinBox(
      item.quantityLocal.value.toDouble().obs,
      (value) {
        if (value != null && value < 1.0) {
          item.isSelected.value = false;
          controller.listSelected
              .removeWhere((element) => item.id == element.id);
        }
        item.quantity = item.quantityLocal.value = value ?? 0;
        // controller.calculateTotalPrices();
      },
      Icon(
        Icons.indeterminate_check_box,
        size: AppDimens.sizeIconSpinner,
        color: item.quantityLocal.value != 1 ? Colors.white : Colors.grey,
      ),
      sizeIcon: AppDimens.sizeIconSpinner,
    );
  }

  Widget _buildBtnSelectProduct() {
    return Obx(() {
      // controller.calculateTotalPrices();
      return Visibility(
        visible: controller.listSelected.isNotEmpty,
        child: Container(
          alignment: Alignment.bottomCenter,
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
              color: AppColors.statusBarColor(),
              border: const Border(
                top: BorderSide(
                  color: AppColors.darkPrimaryColor,
                ),
              )),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    _buildLabelBottom(
                      AppStr.selected,
                      controller.listSelected.length.toString(),
                    ),
                    const VerticalDivider(),
                    _buildLabelBottom(
                      !controller.isTaxBill
                          ? AppStr.totalPreTaxMoney
                          : AppStr.totalAfterTaxMoney,
                      CurrencyUtils.formatCurrency(
                          controller.totalPrices.value),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: BaseWidget.buildButton(
                  AppStr.accept,
                  () {
                    Get.back(result: controller.listSelected);
                  },
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildBtnDeleteProduct() {
    return Obx(
      () => Visibility(
        visible: controller.listSelected.isNotEmpty,
        child: Container(
          alignment: Alignment.bottomCenter,
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: AppColors.statusBarColor(),
            border: Border(
              top: BorderSide(
                color: AppColors.cardBackgroundColor(),
              ),
            ),
          ),
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  controller.isDeleteAllProduct.toggle();
                  controller.selectAllProduct();
                },
                child: Column(
                  children: [
                    Obx(
                      () => Icon(
                        controller.isDeleteAllProduct.value
                            ? Icons.check_circle_outline_outlined
                            : Icons.radio_button_unchecked_outlined,
                        size: AppDimens.sizeIconMedium,
                      ),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Text(
                      '${controller.listSelected.length}',
                      style: Get.theme.textTheme.subtitle1!.copyWith(
                        color: AppColors.hintTextColor(),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: BaseWidget.buildButton(
                  AppStr.deleteProduct,
                  () {
                    controller.deleteProduct(
                        controller, controller.listSelected);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabelBottom(String title, String label) {
    return Column(
      children: [
        AutoSizeText(
          title.tr,
          style: Get.theme.textTheme.subtitle1!.copyWith(
            color: AppColors.hintTextColor(),
          ),
        ),
        const SizedBox(
          height: AppDimens.paddingSmall,
        ),
        Text(label, style: Get.theme.textTheme.bodyText1),
      ],
    );
  }
}
