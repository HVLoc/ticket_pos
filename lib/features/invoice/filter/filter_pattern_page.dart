import 'package:easy_invoice_qlhd/const/all_const.dart';
import 'package:easy_invoice_qlhd/features/invoice/invoice.dart';
import 'package:easy_invoice_qlhd/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// [pattern] nếu không phải trường hợp tạo mới, select theo mẫu số
///
/// Màn invoice list có thể chọn nhiều mẫu số, trong màn màn tạo hóa đơn chỉ cho phép chọn cùng mẫu số
///
/// [isHidePatternCancel] ẩn những ký hiệu hóa đơn đã hủy, hết trong màn tạo hóa đơn
Widget FilterPatternPage(
    {bool isFromFilterPage = false,
    String? pattern,
    bool isHidePatternCancel = false}) {
  final List<InvoicePattern> _listPattern =
      Get.find<InvoicesControllerImp>().listPatternInvoices.toList();

  final TextEditingController _searchPatternController =
      TextEditingController();

  final RxList<InvoicePattern> _listPatternSearch = RxList<InvoicePattern>();

  // final int _paddingTopIndex = isFromFilterPage ? 5 : 1;
  void onSearchChange(String text) {
    _listPatternSearch.clear();

    String textSearch = text.toUpperCase();

    _listPattern.forEach((pattern) {
      if (pattern.pattern.toUpperCase().contains(textSearch) ||
          pattern.serial.toUpperCase().contains(textSearch))
        _listPatternSearch.add(pattern);
    });
  }

  void _onSelectPattern(InvoicePattern item) {
    Get.back(result: item);
  }

  Widget _buildListView(List<InvoicePattern> listPattern) {
    return ListView.separated(
      // ẩn bàn phím khi kéo list
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      physics: const ClampingScrollPhysics(),
      itemBuilder: (context, index) =>
          // không dùng Ripple effect ở đây
          ListTile(
        contentPadding: EdgeInsets.zero,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            buildFilterSerialPattern(
              listPattern[index].pattern,
              listPattern[index].serial,
            ),
            Text(
                (listPattern[index].invoiceType == 1) &&
                        !isSaleInv(listPattern[index].pattern)
                    ? " *"
                    : "",
                // 0: một VAT , 1: nhiều VAT
                style: const TextStyle(color: Colors.red)),
          ],
        ),
        onTap: () => _onSelectPattern(listPattern[index]),
        trailing: Icon(
          Icons.keyboard_arrow_right,
          color: AppColors.hintTextColor(),
        ),
      ),
      itemCount: listPattern.length,
      separatorBuilder: (context, index) => const Divider(),
    );
  }

  return BaseWidget.baseBottomSheet(
    title: pattern != null
        ? AppStr.filterSelectSerialPattern
        : AppStr.filterSelectPattern,
    body: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        BuildInputText(
          InputTextModel(
            fillColor: AppColors.inputText(),
            controller: _searchPatternController,
            submitFunc: (v) {
              onSearchChange(v);
              KeyBoard.hide();
            },
            prefixIconColor: AppColors.textColor(),
            iconNextTextInputAction: TextInputAction.search,
            hintText: AppStr.filterPatternHint.tr,
            iconLeading: Icons.search,
            onChanged: onSearchChange,
          ),
        ),
        RichText(
          text: TextSpan(
              text: "(",
              style: Get.theme.textTheme.subtitle1!
                  .copyWith(color: AppColors.textColor()),
              children: [
                const TextSpan(text: "*", style: TextStyle(color: Colors.red)),
                TextSpan(text: "): ${AppStr.filterInvoiceTaxBill.tr}"),
              ]),
        ).paddingSymmetric(vertical: AppDimens.defaultPadding),
        Expanded(
          child: Obx(
            () => _buildListView(_listPatternSearch.isNotEmpty ||
                    _searchPatternController.text.isNotEmpty
                ? _listPatternSearch
                : _listPattern),
          ),
        ),
      ],
    ),
    isSecondDisplay: isFromFilterPage,
  );
}
