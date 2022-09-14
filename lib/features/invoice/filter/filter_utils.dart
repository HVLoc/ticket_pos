import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_invoice_qlhd/const/all_const.dart';
import 'package:easy_invoice_qlhd/features/invoice/filter/filter_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget buildListViewChip(
  List<ChipFilterModel> _list,
  String titleStr, {
  required Function(ChipFilterModel) onCompareFunc,
  required Function(ChipFilterModel) onSelectedFunc,
  int numberItemPerRow = 3,
  double borderRadius = 30,
  TextStyle? textStyle,
}) {
  final _width =
      (Get.size.width - (1 + numberItemPerRow) * AppDimens.defaultPadding) /
          numberItemPerRow;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        titleStr,
        style: textStyle ??
            Get.textTheme.bodyText1!.copyWith(color: AppColors.hintTextColor()),
      ).paddingOnly(bottom: AppDimens.paddingSmall, top: AppDimens.paddingHuge),
      Wrap(
        alignment: WrapAlignment.start,
        spacing: AppDimens.defaultPadding,
        runSpacing: AppDimens.defaultPadding * 0.5,
        children: List<Widget>.generate(
          _list.length,
          (int index) {
            return Container(
              width: _width.mulSF,
              child: Obx(
                () {
                  final ChipFilterModel _item = _list[index];
                  final bool _isSelected = onCompareFunc(_item);
                  return ChoiceChip(
                    backgroundColor: AppColors.chipColorTheme(),
                    selectedColor: AppColors.selectedChip(),
                    padding: const EdgeInsets.symmetric(
                        vertical: AppDimens.paddingSmall, horizontal: 5),
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.all(Radius.circular(borderRadius))),
                    label: Container(
                      alignment: Alignment.topCenter,
                      child: AutoSizeText(_item.title.tr,
                          textAlign: TextAlign.center,
                          style: Get.textTheme.subtitle2!.copyWith(
                              color: _isSelected
                                  ? Colors.white
                                  : AppColors.textColor())),
                    ),
                    selected: _isSelected,
                    onSelected: (bool selected) {
                      onSelectedFunc(_item);
                    },
                  );
                },
              ),
            );
          },
        ).toList(),
      ),
    ],
  );
}

Widget buildListViewChipTime(List<ChipFilterModel> _list, String titleStr,
    {required Function(ChipFilterModel) onSelectedFunc}) {
  final _width = Get.size.width * 0.85 / 3;
  final _spacing = (Get.size.width - _width * 3) / (5);
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text(
        titleStr,
        style:
            Get.textTheme.bodyText1!.copyWith(color: AppColors.hintTextColor()),
      ).paddingAll(AppDimens.paddingSmall),
      Wrap(
        alignment: WrapAlignment.start,
        spacing: _spacing,
        runSpacing: 0,
        children: List<Widget>.generate(
          _list.length,
          (int index) {
            final ChipFilterModel _item = _list[index];
            return Container(
              width: _width,
              child: ChoiceChip(
                backgroundColor: AppColors.chipColorTheme(),
                selectedColor: Colors.blueAccent[700],
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                label: Container(
                  alignment: Alignment.topCenter,
                  child: Text(_item.title,
                      textAlign: TextAlign.center,
                      style: Get.textTheme.subtitle2!
                          .copyWith(color: AppColors.textColor())),
                ),
                selected: false,
                onSelected: (bool selected) {
                  onSelectedFunc(_item);
                },
              ),
            );
          },
        ).toList(),
      ),
    ],
  );
}

Widget buildButtonDateOption(String title, RxString dateStr,
    {Function()? onClick}) {
  return TextButton(
    onPressed: onClick,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          textAlign: TextAlign.start,
          style: Get.textTheme.subtitle1!
              .copyWith(color: AppColors.hintTextColor()),
        ).paddingOnly(bottom: AppDimens.paddingSmall),
        Obx(
          () => Text(
            initDateTime(dateStr.value),
            maxLines: 1,
            overflow: TextOverflow.clip,
            style: Get.textTheme.bodyText1,
          ),
        ),
      ],
    ),
  );
}

String initDateTime(String dateTime) =>
    dateTime.isEmpty || dateTime == "null" ? "--/--/----" : dateTime;
