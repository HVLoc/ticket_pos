import 'package:easy_invoice_qlhd/application/app.dart';
import 'package:easy_invoice_qlhd/base/base.dart';
import 'package:easy_invoice_qlhd/const/all_const.dart';
import 'package:easy_invoice_qlhd/features/invoice/filter/filter_controller.dart';
import 'package:easy_invoice_qlhd/features/invoice/filter/filter_model.dart';
import 'package:easy_invoice_qlhd/features/invoice/filter/filter_time_page.dart';
import 'package:easy_invoice_qlhd/features/invoice/filter/filter_utils.dart';
import 'package:easy_invoice_qlhd/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FilterPage extends BaseGetWidget<FilterController> {
  @override
  FilterController get controller => Get.put(FilterController());

  @override
  Widget buildWidgets() {
    return BaseWidget.baseBottomSheet(
        title: AppStr.filterInvoice, body: _buildBody());
  }

  Widget _buildBody() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildFilterInput(),
                _buildFilterStatus(),
                // if (Get.find<AppController>().isSys78.value)
                //   _buildFilterTCTCheckStatus(),
                // _buildFilterType(),

                if (Get.find<AppController>().isAdmin.isTrue) ...[
                  BaseWidget.sizedBoxPaddingHuge,
                  _buildFilter(controller, AppStr.nameAccount,
                      controller.mapAccount, controller.idAccount),
                ], 

                if (controller.mapProduct.isNotEmpty) ...[
                  BaseWidget.sizedBoxPaddingHuge,
                  _buildFilter(
                      controller,
                      AppStr.product.replaceAll("*", '').trim(),
                      controller.mapProduct,
                      controller.idProduct),
                ],
                if (controller.mapShift.isNotEmpty) ...[
                  BaseWidget.sizedBoxPaddingHuge,
                  _buildFilter(controller, AppStr.shift, controller.mapShift,
                      controller.idShift),
                ],
                BaseWidget.sizedBoxPaddingHuge
              ],
            ),
          ),
        ),
        _buildBottomAction(),
      ],
    );
  }

  Widget _buildFilterInput() {
    return Column(
      children: [
        // _buildInputSearch(),
        // const SizedBox(
        //   height: AppDimens.paddingHuge,
        // ),
        // _buildInvoiceForm(),
        // const SizedBox(
        //   height: AppDimens.paddingHuge,
        // ),
        _buildItemTimeSelect(),
      ],
    );
  }

  Widget _buildFilterStatus() {
    return buildListViewChip(
      controller.listStatus,
      AppStr.invoiceStatus.tr,
      onCompareFunc: (item) => item.value == controller.statusChip.value,
      onSelectedFunc: (item) {
        controller.statusChip.value = controller.statusChip.value == item.value!
            ? -1 // Bỏ trạng thái lọc khi chọn lại giá trị
            : item.value!;
        // trạng thái chưa phát hành sẽ không chọn được trạng thái gửi thuế
        // if (controller.statusChip.value == 0) {
        //   controller.stateTCTCheckStatus.value = -3;
        // }
      },
      numberItemPerRow: 2,
      borderRadius: 6,
    );
  }

  // Widget _buildFilterTCTCheckStatus() {
  //   return buildListViewChip(
  //     controller.listTCTCheckStatus,
  //     AppStr.stateTCTCheckStatus.tr,
  //     onCompareFunc: (item) =>
  //         item.value == controller.stateTCTCheckStatus.value,
  //     onSelectedFunc: (item) {
  //       // trạng thái chưa phát hành sẽ không chọn được trạng thái gửi thuế
  //       if (controller.statusChip.value != 0) {
  //         controller.stateTCTCheckStatus.value =
  //             controller.stateTCTCheckStatus.value == item.value!
  //                 ? -3 // Bỏ trạng thái lọc khi chọn lại giá trị
  //                 : item.value!;
  //       } else {
  //         Fluttertoast.showToast(msg: AppStr.stateTCTCheckStatusNotSelect);
  //       }
  //     },
  //     numberItemPerRow: 2,
  //     borderRadius: 6,
  //   );
  // }

  // Widget _buildFilterType() {
  //   return buildListViewChip(
  //       controller.listTypeInvoice, AppStr.searchInvoiceTypes.tr,
  //       onCompareFunc: (item) => item.value == controller.typeChip.value,
  //       onSelectedFunc: (item) {
  //         if (controller.typeChip.value == item.value)
  //           controller.typeChip.value = -1;
  //         else
  //           controller.typeChip.value = item.value!;
  //       },
  //       numberItemPerRow: 2,
  //       borderRadius: 6);
  //   //   ],
  //   // );
  // }

  // Widget _buildInputSearch() {
  //   return Container(
  //     width: Get.width,
  //     decoration: BoxDecoration(
  //         color: AppColors.inputText(),
  //         borderRadius: BorderRadius.circular(10)),
  //     child: Obx(() {
  //       bool isFinding = controller.searchInput.value.isNotEmpty;
  //       return ListTile(
  //         onTap: () => Get.bottomSheet<String>(
  //                 FindInvoicePage(
  //                     listKeyword: controller.listSearchHistory,
  //                     keyCurrent: controller.searchInput.value,
  //                     title: AppStr.filterTitle_Keyword.tr,
  //                     hint: AppStr.filterHint_Keyword.tr,
  //                     isFromFilter: true),
  //                 isScrollControlled: true)
  //             .then((value) {
  //           if (value != null) {
  //             controller.searchInput.value = value;
  //           }
  //         }),
  //         title: Text(
  //           isFinding
  //               ? controller.searchInput.value
  //               : AppStr.filterHint_Keyword.tr,
  //           maxLines: 1,
  //           overflow: TextOverflow.ellipsis,
  //           style: Get.textTheme.bodyText1!
  //               .copyWith(color: AppColors.hintTextColor()),
  //         ),
  //         trailing: isFinding
  //             ? InkWell(
  //                 onTap: () => controller.searchInput.value = "",
  //                 child: Icon(
  //                   Icons.clear,
  //                   color: AppColors.hintTextColor(),
  //                 ),
  //               )
  //             : Icon(Icons.search, color: AppColors.hintTextColor()),
  //       );
  //     }),
  //   );
  // }

  // Widget _buildInvoiceForm() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(AppStr.invoiceForm.tr,
  //           style: Get.textTheme.bodyText1!
  //               .copyWith(color: AppColors.hintTextColor())),
  //       const SizedBox(
  //         height: AppDimens.paddingSmall,
  //       ),
  //       Obx(
  //         () => Container(
  //           decoration: BoxDecoration(
  //               color: AppColors.cardBackgroundOrange(),
  //               borderRadius: BorderRadius.circular(10)),
  //           child: ListTile(
  //             onTap: () {
  //               Get.bottomSheet<InvoicePattern>(
  //                       FilterPatternPage(isFromFilterPage: true),
  //                       isScrollControlled: true)
  //                   .then((value) {
  //                 if (value != null)
  //                   controller.updateSerialPattern(value.pattern, value.serial);
  //               });
  //             },
  //             contentPadding: const EdgeInsets.symmetric(
  //                 horizontal: AppDimens.defaultPadding),
  //             title: buildFilterSerialPattern(
  //               controller.filterPatternStr.value,
  //               controller.filterSerialStr.value,
  //               color: AppColors.textColorWhite,
  //               hintColor: AppColors.hintTextSolidColor,
  //             ),
  //             trailing: const Icon(
  //               Icons.keyboard_arrow_right,
  //               size: AppDimens.sizeIconMedium,
  //               color: AppColors.textColorWhite,
  //             ),
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildItemTimeSelect() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              AppStr.timeText.tr,
              style: Get.textTheme.bodyText1!
                  .copyWith(color: AppColors.hintTextColor()),
            ),
            const Spacer(),
            Obx(
              () => Visibility(
                visible: controller.fromDateStr.value.isNotEmpty ||
                    controller.toDateStr.value.isNotEmpty,
                child: BaseWidget.baseOnAction(
                  onTap: () {
                    controller.fromDateStr.value =
                        controller.toDateStr.value = '';
                  },
                  child: Text(
                    AppStr.delete.tr,
                    style: Get.textTheme.bodyText1!
                        .copyWith(color: AppColors.colorBlueAccent),
                  ).paddingOnly(left: AppDimens.paddingMedium),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: AppDimens.paddingSmall,
        ),
        Container(
          height: 80.mulSF,
          decoration: BoxDecoration(
            color: AppColors.inputText(),
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            border: Border.all(
                color: AppColors.borderColor(), style: BorderStyle.solid),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: buildButtonDateOption(
                    AppStr.fromDateText.tr, controller.fromDateStr,
                    onClick: () async {
                  final DateTime? picked = await BaseWidget.buildDateTimePicker(
                    dateTimeInit: controller.fromDateStr.value.isEmpty
                        ? DateTime.now()
                        : convertStringToDate(
                            controller.fromDateStr.value, PATTERN_1),
                  );
                  if (picked != null)
                    controller.fromDateStr.value =
                        formatDateTimeToString(picked);
                }),
              ),
              const VerticalDivider(width: 1)
                  .paddingSymmetric(vertical: AppDimens.defaultPadding),
              Expanded(
                child: buildButtonDateOption(
                    AppStr.toDateText.tr, controller.toDateStr,
                    onClick: () async {
                  final DateTime? picked = await BaseWidget.buildDateTimePicker(
                    dateTimeInit: controller.toDateStr.value.isEmpty
                        ? DateTime.now()
                        : convertStringToDate(
                            controller.toDateStr.value, PATTERN_1),
                  );
                  if (picked != null)
                    controller.toDateStr.value = formatDateTimeToString(picked);
                }),
              ),
              const VerticalDivider(width: 1)
                  .paddingSymmetric(vertical: AppDimens.defaultPadding),
              Expanded(
                child: TextButton(
                  onPressed: () => Get.bottomSheet<ChipFilterModel>(
                          FilterTimePage(isFromFilter: true),
                          isScrollControlled: true)
                      .then(
                    (element) {
                      if (element != null) {
                        controller.fromDateStr.value = element.fromDate;
                        controller.toDateStr.value = element.toDate;
                      }
                    },
                  ),
                  child: Text(
                    AppStr.optional.tr,
                    maxLines: 2,
                    style: Get.textTheme.bodyText1!
                        .copyWith(color: AppColors.colorBlueAccent),
                  ).paddingSymmetric(horizontal: AppDimens.paddingSmall),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomAction() {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: BaseWidget.buildButton(
            AppStr.removeFilterText,
            () => Get.back(
                result: FilterInvoiceModel()
                  ..pattern = controller.filterPatternStr.value
                  ..serial = controller.filterSerialStr.value
                  ..isFilter = false),
            colors: AppColors.removeFilter(),
          ),
        ),
        const SizedBox(width: AppDimens.paddingSmall),
        Expanded(
          flex: 1,
          child: BaseWidget.buildButton(
            AppStr.applyText,
            () {
              // if (controller.searchInput.value.isNotEmpty) {
              // controller.setCurrentListSearch(controller.searchInput.value);

              // //   Get.back(
              // //     result: FilterInvoiceModel()
              // //       ..pattern = controller.filterPatternStr.value
              // //       ..serial = controller.filterSerialStr.value
              // //       ..cusKey = controller.searchInput.value,
              // //   );
              // // } else {
              // int fromDateInt =
              //     convertDMYToTimeStamps(controller.fromDateStr.value);
              // int toDateInt =
              //     convertDMYToTimeStamps(controller.toDateStr.value);
              // if (fromDateInt == 0 ||
              //     toDateInt == 0 ||
              //     fromDateInt <= toDateInt) {
              Get.back(
                result: FilterInvoiceModel()
                  ..pattern = controller.filterPatternStr.value
                  ..serial = controller.filterSerialStr.value
                  ..cusKey = controller.searchInput.value
                  ..fromDate = controller.fromDateStr.value
                  ..toDate = controller.toDateStr.value
                  ..status = controller.statusChip.value
                  ..type = controller.typeChip.value
                  ..tCTCheckStatus = controller.stateTCTCheckStatus.value
                  ..idAccount = controller.idAccount.value
                  ..idShift = controller.idShift.value
                  ..idProduct = controller.idProduct.value,
              );

              // } else {
              //   controller.showSnackBar(AppStr.filterDateTimeError.tr);
              // }
            },
          ),
        ),
      ],
    ).paddingSymmetric(vertical: AppDimens.paddingSmall);
  }

  Widget _buildFilter(FilterController controller, String title,
      Map<int, String> map, Rx<int?> id) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Get.textTheme.bodyText1!
              .copyWith(color: AppColors.hintTextColor()),
        ),
        BaseWidget.sizedBox5,
        BaseWidget.buildDropdown(map, item: id, onChanged: (int? newValue) {
          if (newValue != null) {
            id.value = newValue;
          }
        }, fillColor: AppColors.inputTextBottomSheet()),
      ],
    );
  }
}
