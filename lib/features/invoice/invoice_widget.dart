part of 'invoice_page.dart';

final itemHeaderStyle = Get.theme.textTheme.caption!.copyWith(
  color: AppColors.hintTextColor(),
);
final itemValueStyle = Get.theme.textTheme.bodyText1!.copyWith(
  color: AppColors.textColor(),
);

// Widget buildStickyHeader(String title) {
//   InvoiceController controller = Get.find<InvoiceController>();
//   final RxList<InvoiceList> _invoices =
//       Get.isRegistered<RxList<InvoiceList>>(tag: Key(title).toString())
//           ? Get.find<RxList<InvoiceList>>(tag: Key(title).toString())
//           : <InvoiceList>[].obs;

//   return SliverStickyHeader(
//     header: title.isNotEmpty
//         ? Header(key: Key(title), title: title, dataCount: _invoices)
//         : _buildDivider(),
//     sliver: Obx(() => SliverList(
//           delegate: SliverChildBuilderDelegate(
//             (context, i) {
//               if (i == (_invoices.length - 1)) {
//                 return buildItemInvoice(controller, _invoices[i]);
//               } else {
//                 return Column(
//                   children: [
//                     buildItemInvoice(controller, _invoices[i]),
//                     _buildDivider()
//                   ],
//                 );
//               }
//             },
//             childCount: _invoices.length,
//           ),
//         )),
//   );
// }

Widget _buildListInvoice(InvoicesController controller) {
  return Container(
    color: AppColors.invoiceList(),
    child: controller.listInvoiceDetailModel.isEmpty
        ? DataEmpty()
        : ListView.separated(
            controller: controller.scrollControllerUpToTop,
            itemBuilder: (context, index) {
              int _index = controller.listInvoiceDetailModel.length - index - 1;
              return buildItemTicket(
                  controller, controller.listInvoiceDetailModel[_index]);
            },
            separatorBuilder: (context, index) {
              return _buildDivider();
            },
            itemCount: controller.listInvoiceDetailModel.length,
          ),
  );
}

Widget buildItemTicket(InvoicesController controller, InvoiceDetailModel item) {
  InvoiceStatus _invoiceStatus = controller
      .listInvoiceStatusTicket()
      .firstWhere((element) =>
          element.status ==
          ((item.invoiceNo == null || item.invoiceNo == 0) ? 0 : 1));

  bool _isInvoiceCreation = item.status == 0;
  // bool _isCancel = item.status == 3 || item.status == 5;

  return Container(
          color: AppColors.invoiceList(),
          child: TextButton(
            style: TextButton.styleFrom(
                primary: AppColors.selectedInvoicePressed()),
            onPressed: () {
              controller.goToInvDetail(item);
            },
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: _invoiceStatus.colorBackground,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(4))),
                      child: Text(
                        _invoiceStatus.title.tr,
                        style: Get.textTheme.subtitle2!.copyWith(
                            fontWeight: FontWeight.normal,
                            color: _invoiceStatus.colorTitle),
                      ).paddingAll(3),
                    ),

                    const Spacer(),
                    Text(
                      _isInvoiceCreation
                          ? AppStr.invoiceNewly.tr
                          : formatInvoiceNo(
                              double.parse(item.invoiceNo?.toString() ?? '0')),
                      style: Get.textTheme.bodyText1,
                    )
                  ],
                ),
                BaseWidget.sizedBox10,
                AutoSizeText(
                  item.items.first.name ?? '',
                  style: itemValueStyle.copyWith(color: AppColors.textColor()),
                ),
                BaseWidget.sizedBox10,
                Row(
                  children: [
                    Text(
                      (item.timePos ?? "") + " - " + (item.arisingDate ?? ''),
                      style: itemHeaderStyle.copyWith(
                          color: AppColors.hintTextColor()),
                    ),
                    const Spacer(),
                    Text(
                      CurrencyUtils.formatCurrency(item.amount),
                      style: Get.textTheme.bodyText2,
                    ),
                  ],
                ),
              ],
            ),
          ),
  
     

  );
}


Widget _buildDivider() {
  return const Divider(
    height: 1.0,
    indent: AppDimens.defaultPadding,
    endIndent: AppDimens.defaultPadding,
    // color: AppColors.dividerColor(),
  );
}



Widget buildFilterSerialPattern(
  String _pattern,
  String _serial, {
  Color? color,
  Color? hintColor,
  TextStyle? style,
}) {
  return RichText(
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
    text: TextSpan(
      children: [
        TextSpan(text: _pattern),
        if (_serial.isNotEmpty)
          TextSpan(
              text: AppConst.invoiceSeparator,
              style: style?.copyWith(
                    color: hintColor ?? AppColors.hintTextColor(),
                  ) ??
                  Get.theme.textTheme.subtitle1!.copyWith(
                    color: hintColor ?? AppColors.hintTextColor(),
                  )),
        TextSpan(text: _serial),
      ],
      style: style ??
          Get.theme.textTheme.subtitle1!.copyWith(
            fontWeight: FontWeight.bold,
            color: color ?? AppColors.textColor(),
          ),
    ),
  );
}

Widget rowPayment(String title, String value) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        title,
        style: Get.textTheme.subtitle1?.copyWith(
          color: AppColors.textColorWhite,
        ),
      ),
      Text(
        value,
        style: Get.textTheme.bodyText1!.copyWith(
          color: AppColors.textColorWhite,
        ),
      ),
    ],
  ).paddingAll(AppDimens.paddingVerySmall);
}

class Header extends StatelessWidget {
  const Header({
    Key? key,
    required this.title,
    required this.dataCount,
    this.color = Colors.lightBlue,
  }) : super(key: key);

  final String title;
  final RxList dataCount;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.stickyHead(),
      padding: const EdgeInsets.all(AppDimens.paddingSmall),
      alignment: Alignment.center,
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: Get.textTheme.bodyText2!
                  .copyWith(color: AppColors.invoiceStickyHead()),
            ),
          ),
          Obx(
            () => Text(
              "(${dataCount.length})",
              style: Get.textTheme.subtitle1!
                  .copyWith(color: AppColors.invoiceStickyHead()),
            ),
          )
        ],
      ),
    );
  }
}
