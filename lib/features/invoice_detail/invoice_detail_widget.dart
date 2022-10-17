part of 'invoice_detail_page.dart';

Widget listProduct(InvoiceDetailController controller) {
  return EasyListView(
    physics: const ClampingScrollPhysics(),
    padding: EdgeInsets.zero,
    itemCount: controller.invoiceDetailModel.value.items.length,
    itemBuilder: (cxt, index) {
      return _buildItem(
          controller, controller.invoiceDetailModel.value.items[index]);
    },
    headerBuilder: (cxt) => _buildHeader(controller),
    footerBuilder: (cxt) => _buildFooter(controller),
    scrollbarEnable: false,
  ).paddingSymmetric(horizontal: AppDimens.paddingSmall);
}

Widget _buildItem(
  InvoiceDetailController controller,
  ProductItem item,
) {
  return Container(
    color: AppColors.cardBackgroundColor(),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: item.code ?? '',
                          style: Get.theme.textTheme.subtitle1!.copyWith(
                              color: AppColors.chipColor,
                              fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: item.code.isStringNotEmpty
                              ? item.name.isStringNotEmpty
                                  ? ' - ' + (item.name ?? '')
                                  : ''
                              : item.name ?? '',
                          style: Get.theme.textTheme.subtitle1!
                              .copyWith(color: AppColors.textColor()),
                        ),
                      ],
                      style: Get.theme.textTheme.subtitle1,
                    ),
                  ).paddingSymmetric(vertical: AppDimens.paddingVerySmall),
                  Visibility(
                    visible: item.total != 0.0 || item.quantity != 0.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Visibility(
                          visible: item.feature == 3,
                          child: Text(AppStr.discount,
                              style: Get.textTheme.caption!
                                  .copyWith(color: AppColors.colorRed444)),
                        ),
                        Expanded(
                          child: Visibility(
                            visible: item.quantity != 0.0,
                            child: Row(
                              children: [
                                Visibility(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 1.0, horizontal: 4.0),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.blue.shade100),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(4))),
                                    child: Text(
                                      vatStr(item.vatRate),
                                      style: Get.theme.textTheme.subtitle2!
                                          .copyWith(
                                              fontSize: 10,
                                              color: AppColors.hintTextColor()),
                                    ),
                                  ).paddingOnly(right: 2),
                                ),
                                const SizedBox(
                                  width: 2,
                                ),
                                Expanded(
                                  child: AutoSizeText(
                                    " ${CurrencyUtils.formatCurrencyForeign(convertDoubleToStringSmart(item.quantity))} ${item.unit}" +
                                        (item.price == 0.0
                                            ? ""
                                            : " * ${CurrencyUtils.formatCurrencyForeign(convertDoubleToStringSmart(item.price))}"),
                                    style: Get.theme.textTheme.subtitle1!
                                        .copyWith(
                                            fontSize: AppDimens.fontSmall(),
                                            color: AppColors.hintTextColor()),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        item.isSum
                            ? Text(
                                AppStr.sale.tr,
                                style: Get.theme.textTheme.caption!.copyWith(
                                  color: AppColors.colorRed444,
                                ),
                              )
                            : AutoSizeText(
                                CurrencyUtils.formatCurrency(item.amount),
                                style: Get.theme.textTheme.subtitle1,
                                overflow: TextOverflow.ellipsis,
                              ),
                      ],
                    ),
                  ),
                ],
              ).paddingOnly(bottom: AppDimens.paddingVerySmall),
            ),
          ],
        ).paddingOnly(
          left: AppDimens.paddingSmall,
          right: AppDimens.paddingSmall,
          top: AppDimens.paddingSmall,
          bottom: AppDimens.paddingSmall,
        ),
        BaseWidget.buildDivider(height: 2, indent: AppDimens.paddingSmall),
      ],
    ),
  );
}

Widget _buildHeader(InvoiceDetailController controller) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildInforInvoice(controller),
      BaseWidget.sizedBox10,
      _buildCustomer(controller),
      BaseWidget.sizedBox10,
      Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.cardBackgroundColor(),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          border: Border.all(
              color: AppColors.primaryColor(), style: BorderStyle.solid),
        ),
        padding: const EdgeInsets.only(
            left: AppDimens.paddingSmall, top: AppDimens.paddingSmall),
        child: Text(
          AppStr.product.tr.replaceAll("*", "").toUpperCase(),
          style: Get.textTheme.bodyText2!,
        ),
      ),
    ],
  );
}

Widget _buildCustomer(InvoiceDetailController controller) {
  return TextButton(
    onPressed: () {},
    style: ButtonStyle(
      padding: MaterialStateProperty.all(EdgeInsets.zero),
      overlayColor: MaterialStateProperty.all(Colors.transparent),
    ),
    child: BaseWidget.buildCardBase(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppStr.invoiceCreationInfoBuyerTitle.tr.toUpperCase(),
                      style: Get.textTheme.bodyText2)
                  .paddingSymmetric(
                      vertical: AppDimens.paddingVerySmall,
                      horizontal: AppDimens.paddingSmall),
            ],
          ),
          Text(
            controller.invoiceDetailModel.value.cusName.isStringNotEmpty
                ? controller.invoiceDetailModel.value.cusName ?? ''
                : controller.invoiceDetailModel.value.buyer ?? '',
            maxLines: 3,
            style: Get.textTheme.bodyText1,
          ).paddingAll(AppDimens.paddingSmall),
        ],
      ),
    ),
  );
}

// Widget _buildStatusInvoice(InvoiceDetailController controller) {
//   String _invoiceStatus = listInvoiceStatus()
//           .firstWhereOrNull(
//             (element) =>
//                 element.status == controller.invoiceDetailModel.value.status,
//           )
//           ?.title ??
//       '';
//   return BaseWidget.buildCardBase(
//       Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//     Center(
//       child: Text(
//         _invoiceStatus.tr,
//         style: Get.textTheme.headline6,
//       ).paddingAll(AppDimens.paddingSmall),
//     ),
//   ]));
// }

Widget _buildInforInvoice(InvoiceDetailController controller) {
  var _isSerialNotEmpty =
      controller.invoiceDetailModel.value.serialNo?.isNotEmpty ?? false;
  InvoiceStatus _invoiceStatus = controller.invoicesController
      .listInvoiceStatusTicket()
      .firstWhere((element) =>
          element.status == controller.invoiceDetailModel.value.status);
  return BaseWidget.buildCardBase(
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(AppStr.invoiceDetailTicket.tr.toUpperCase(),
                style: Get.textTheme.bodyText2),
            const Spacer(),
            Container(
              decoration: BoxDecoration(
                  color: _invoiceStatus.colorBackground,
                  borderRadius: const BorderRadius.all(Radius.circular(4))),
              child: AutoSizeText(
                _invoiceStatus.title,
                style: Get.textTheme.subtitle2!.copyWith(
                  fontWeight: FontWeight.normal,
                  color: _invoiceStatus.colorTitle,
                ),
              ).paddingAll(3),
            )
          ],
        ).paddingSymmetric(
            vertical: AppDimens.paddingVerySmall,
            horizontal: AppDimens.paddingSmall),
        Center(
          child: Text(
                  CurrencyUtils.formatCurrency(
                      controller.invoiceDetailModel.value.amount),
                  style: Get.textTheme.headline2)
              .paddingSymmetric(
            vertical: AppDimens.paddingVerySmall,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _columnItem(
                    _isSerialNotEmpty
                        ? AppStr.searchInvoicePattern.tr
                        : AppStr.invoicePatternDetail,
                    controller.invoiceDetailModel.value.invoicePattern ?? ''),
                if (_isSerialNotEmpty)
                  _columnItem(
                    AppStr.searchInvoiceSerial.tr,
                    '${controller.invoiceDetailModel.value.serialNo}',
                    crossAxisAlignment: CrossAxisAlignment.end,
                  ),
              ],
            ),
            Row(
              children: [
                _columnItem(
                    AppStr.numberInvoice.tr,
                    controller.invoiceDetailModel.value.invoiceNo != 0
                        ? formatInvoiceNo(
                            controller.invoiceDetailModel.value.invoiceNo ?? 0)
                        : AppStr.invoiceNewly.tr),
                _columnItem(
                  AppStr.invoiceDetailArisingDate.tr,
                  controller.invoiceDetailModel.value.arisingDate ?? '',
                  crossAxisAlignment: CrossAxisAlignment.end,
                ),
              ],
            ),
          ],
        )
      ],
    ),
  );
}

// Widget _buildPaymentMethodView(InvoiceDetailController controller) {
//   return BaseWidget.buildCardBase(Container(
//     width: Get.width,
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       mainAxisAlignment: MainAxisAlignment.start,
//       children: [
//         Text(
//           AppStr.invoiceCreationPaymentMethods.toUpperCase(),
//           style: Get.textTheme.bodyText2,
//         ),
//         BaseWidget.sizedBox10,
//         Text(
//           controller.invoiceDetailModel.value.paymentMethod ?? '',
//           style: Get.textTheme.bodyText1!.copyWith(fontWeight: FontWeight.bold),
//         ),
//       ],
//     ).paddingAll(AppDimens.defaultPadding),
//   ));
// }

Widget _columnItem(String title, String value,
        {CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start}) =>
    Expanded(
      child: Column(
        crossAxisAlignment: crossAxisAlignment,
        children: [
          Text(
            title,
            style: Get.textTheme.subtitle2,
          ),
          Text(value, style: Get.textTheme.bodyText1),
        ],
      ).paddingAll(AppDimens.paddingVerySmall),
    );

Widget _rowCustomer(String title, String value,
        {MainAxisAlignment mainAxis = MainAxisAlignment.spaceBetween,
        bool isBold = false}) =>
    Container(
      child: Row(
        mainAxisAlignment: mainAxis,
        children: [
          Text(title,
                  style: Get.theme.textTheme.subtitle1!
                      .copyWith(color: AppColors.textColor()))
              .paddingSymmetric(horizontal: AppDimens.paddingSmall),
          Text(
            value,
            style: Get.theme.textTheme.subtitle1!.copyWith(
              fontWeight: isBold ? FontWeight.bold : null,
            ),
          ).paddingSymmetric(horizontal: AppDimens.paddingSmall),
        ],
      ).paddingOnly(bottom: AppDimens.paddingVerySmall),
    );

Widget _buildFooter(InvoiceDetailController controller) {
  return Container(
    margin: const EdgeInsets.only(bottom: 10),
    decoration: BoxDecoration(
      color: AppColors.cardBackgroundColor(),
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(10),
        bottomRight: Radius.circular(10),
      ),
      border:
          Border.all(color: AppColors.primaryColor(), style: BorderStyle.solid),
    ),
    child: Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        _rowCustomer(
          AppStr.totalPreTaxMoney.tr,
          CurrencyUtils.formatCurrency(
              controller.invoiceDetailModel.value.total),
        ),
        _rowCustomer(
            AppStr.invoiceCreationVAT.tr,
            CurrencyUtils.formatCurrency(
                controller.invoiceDetailModel.value.vatAmount.toInt())),
        _rowCustomer(
          AppStr.invoiceCreationAmountMoney.tr,
          CurrencyUtils.formatCurrency(
              controller.invoiceDetailModel.value.amount.toInt()),
        ),
        const SizedBox(
          height: 8,
        )
      ],
    ),
  );
}
