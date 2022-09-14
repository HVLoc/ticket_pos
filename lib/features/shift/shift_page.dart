import 'package:easy_invoice_qlhd/features/shift/shift_controller.dart';
import 'package:easy_invoice_qlhd/hive_local/shift.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../base/base.dart';
import '../../const/all_const.dart';
import '../../utils/utils.dart';

class ShiftPage extends BaseGetWidget<ShiftController> {
  @override
  ShiftController get controller => Get.put(ShiftController());
  @override
  Widget buildWidgets() {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: BaseWidget.buildAppBarTitle(AppStr.shiftList),
        actions: [
          TextButton(
            onPressed: () {
              Get.bottomSheet(_buildBottomSheetAdd(ShiftModel()),
                      isScrollControlled: true)
                  .then((value) {
                if (value != null) {
                  controller.addShift(value);
                }
              });
            },
            child: Icon(
              Icons.add_circle_outline,
              color: AppColors.textColor(),
            ),
          )
        ],
      ),
      body: Obx(
        () => controller.shiftList.isEmpty
            ? buildEmptyShift()
            : ListView.builder(
                itemCount: controller.shiftList.length,
                itemBuilder: ((context, index) => buildItem(index)),
              ).paddingSymmetric(horizontal: AppDimens.defaultPadding),
      ),
    );
  }

  Widget buildItem(int index) {
    ShiftModel shiftModel = controller.shiftList[index];
    return GestureDetector(
      onTap: () => Get.bottomSheet(
              _buildBottomSheetAdd(shiftModel, isUpdate: true),
              isScrollControlled: true)
          .then((value) {
        if (value != null) {
          controller.updateShift(shiftModel, shiftModel.id);
        }
      }),
      child: BaseWidget.buildCardBase(
        Container(
          margin: const EdgeInsets.all(8),
          color: AppColors.cardBackgroundColor(),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BaseWidget.sizedBox5,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      shiftModel.nameShift,
                      style: Get.textTheme.bodyText1!
                          .copyWith(color: AppColors.linkText()),
                    ),
                    const Spacer(),
                    GestureDetector(
                        onTap: () {
                          ShowPopup.showDialogConfirm(
                              AppStr.invoiceDetailRemoveContain, confirm: () {
                            controller.deleteShift(shiftModel.id);
                          }, actionTitle: AppStr.delete);
                        },
                        child: Text(
                          AppStr.delete,
                          style: Get.textTheme.bodyText2!
                              .copyWith(color: AppColors.linkText()),
                        ))
                  ],
                ),
                BaseWidget.sizedBox10,
                rowInfor(AppStr.shiftLeader, shiftModel.nameShiftLeader),
                BaseWidget.sizedBox10,
                rowInfor(AppStr.timeText,
                    '${shiftModel.startDate} - ${shiftModel.endDate}'),
              ]).paddingSymmetric(horizontal: AppDimens.paddingSmall),
        ),
      ).paddingSymmetric(
        vertical: AppDimens.paddingSmall,
      ),
    );
  }

  Widget rowInfor(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title + ': ',
          style: Get.textTheme.subtitle1,
        ),
        Text(
          value,
          style: Get.textTheme.bodyText1,
        ),
      ],
    );
  }

  Widget _buildBottomSheetAdd(ShiftModel shiftModel, {bool isUpdate = false}) {
    TextEditingController nameShift =
        TextEditingController(text: shiftModel.nameShift);
    TextEditingController nameShiftLeader =
        TextEditingController(text: shiftModel.nameShiftLeader);
    RxString startTime = shiftModel.startDate.obs;
    RxString endTime = shiftModel.endDate.obs;
    final _formKey = GlobalKey<FormState>();

    return BaseWidget.baseBottomSheet(
        title: isUpdate ? AppStr.shiftUpdate : AppStr.shiftCreate,
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      inputInfor(nameShift, AppStr.shiftName),
                      BaseWidget.sizedBox10,
                      inputInfor(nameShiftLeader, AppStr.shiftNameLeader,
                          isValidate: false),
                      BaseWidget.sizedBox10,
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(AppStr.timeText),
                          BaseWidget.sizedBox10,
                          Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10.0)),
                              color: AppColors.inputTextBottomSheet(),
                            ),
                            height: 80,
                            child: Center(
                                child: Row(
                              children: [
                                Expanded(
                                  child: timePicker(
                                      startTime, AppStr.shiftStartTime),
                                ),
                                Expanded(
                                  child:
                                      timePicker(endTime, AppStr.shiftEndTime),
                                ),
                              ],
                            )),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            BaseWidget.buildButton(AppStr.save, () {
              if (_formKey.currentState!.validate()) {
                KeyBoard.hide();
                shiftModel.nameShift = nameShift.text;
                shiftModel.nameShiftLeader = nameShiftLeader.text;
                shiftModel.startDate = startTime.value;
                shiftModel.endDate = endTime.value;
                if (startTime.value.isNotEmpty && endTime.value.isNotEmpty) {
                  Get.back(result: shiftModel);
                } else
                  ShowPopup.showDialogNotification(
                      'Thời gian không được để trống');
              }
            })
          ],
        ));
  }

  BuildInputTextWithLabel inputInfor(
      TextEditingController nameShift, String label,
      {bool isValidate = true}) {
    return BuildInputTextWithLabel(
        label: label,
        buildInputText: BuildInputText(InputTextModel(
          controller: nameShift,
          validator: (value) {
            if (value.isStringEmpty && isValidate) {
              return AppStr.shiftValidate;
            }
            return null;
          },
        )));
  }

  Widget timePicker(RxString time, String title) {
    Future<void> show(RxString time) async {
      BuildContext context = Get.context!;

      final TimeOfDay? result = await showTimePicker(
        initialTime: TimeOfDay(
            hour: int.tryParse(time.split(':').first) ?? DateTime.now().hour,
            minute:
                int.tryParse(time.split(':').last) ?? DateTime.now().minute),
        context: context,
        initialEntryMode: TimePickerEntryMode.input,
        builder: (BuildContext context, Widget? child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child!,
          );
        },
      );
      if (result != null) {
        time.value = result.format(context);
      }
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(title),
        TextButton(
          onPressed: () {
            show(time);
          },
          child: Obx(() => Text(
                initTime(
                  time.value,
                ),
                style: Get.textTheme.subtitle1,
              )),
        ),
      ],
    );
  }

  String initTime(String time) =>
      time.isEmpty || time == "null" ? "--:--" : time;

  Widget buildEmptyShift() {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppStr.shiftEmpty,
              style: Get.textTheme.bodyText1!
                  .copyWith(fontSize: AppDimens.fontSize24()),
            ),
            BaseWidget.sizedBoxPadding,
            Container(
              width: 100,
              child: BaseWidget.buildButton(AppStr.add, () {
                Get.bottomSheet(_buildBottomSheetAdd(ShiftModel()),
                        isScrollControlled: true)
                    .then((value) {
                  if (value != null) controller.addShift(value);
                });
              }),
            )
          ],
        ),
      ),
    );
  }
}
