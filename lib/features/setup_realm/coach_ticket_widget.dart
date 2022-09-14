part of 'setup_realm_page.dart';

Widget _buildCoachTicketPage(SetupRealmController controller) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        AppStr.selectTime,
        style: Get.textTheme.bodyText1,
      ).marginOnly(left: AppDimens.paddingMedium),
      BaseWidget.buildCardBase(
        Column(
          children: [
            ItemUtils.itemLine(
              leading: Icons.timer_outlined,
              trailing: CupertinoSwitch(
                value: controller.listSetupModel.value.startTime,
                onChanged: (val) {
                  controller.listSetupModel.update((value) {
                    value!.startTime = val;
                  });
                },
              ),
              title: AppStr.timeStart,
            ),
            _buildDivider(),
            ItemUtils.itemLine(
              leading: Icons.date_range,
              trailing: CupertinoSwitch(
                value: controller.listSetupModel.value.startDate,
                onChanged: (val) {
                  controller.listSetupModel.update((value) {
                    value!.startDate = val;
                  });
                },
              ),
              title: AppStr.dateStart,
            ),
          ],
        ),
      ).marginAll(AppDimens.paddingSmall),
      Text(
        AppStr.infomationExpanded,
        style: Get.textTheme.bodyText1,
      ).marginOnly(left: AppDimens.paddingMedium, top: AppDimens.paddingMedium),
      BaseWidget.buildCardBase(
        Column(
          children: [
            ItemUtils.itemLine(
              leading: Icons.near_me_outlined,
              trailing: CupertinoSwitch(
                value: controller.listSetupModel.value.licensePlates,
                onChanged: (val) {
                  controller.listSetupModel.update((value) {
                    value!.licensePlates = val;
                  });
                },
              ),
              title: AppStr.licensePlates,
            ),
            _buildDivider(),
            ItemUtils.itemLine(
              leading: Icons.chair_outlined,
              trailing: CupertinoSwitch(
                value: controller.listSetupModel.value.amountChair,
                onChanged: (val) {
                  controller.listSetupModel.update((value) {
                    value!.amountChair = val;
                  });
                },
              ),
              title: AppStr.amountChair,
            ),
          ],
        ),
      ).marginAll(AppDimens.paddingSmall),
      // Text(
      //   AppStr.infomationSeat,
      //   style: Get.textTheme.bodyText1,
      // ).marginOnly(left: AppDimens.paddingMedium, top: AppDimens.paddingMedium),
      // BaseWidget.buildCardBase(
      //   Column(
      //     children: [
      //       ItemUtils.itemLine(
      //         leading: Icons.confirmation_num_outlined,
      //         trailing: CupertinoSwitch(
      //          value: controller.listSetupModel.value.amountChair,
      //           onChanged: (val) {
      //             controller.listSetupModel.update((value) {
      //               value!.amountChair = val;
      //             });
      //           },
      //         ),
      //         title: AppStr.numberSeat,
      //       ),
      //     ],
      //   ),
      // ).marginAll(AppDimens.paddingSmall),
    ],
  );
}
