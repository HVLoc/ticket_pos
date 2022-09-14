part of 'setup_realm_page.dart';

Widget _buildCustomsTicketPage(SetupRealmController controller) {
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
          ],
        ),
      ).marginAll(AppDimens.paddingSmall),
      Text(
        AppStr.busSelectWharf,
        style: Get.textTheme.bodyText1,
      ).marginOnly(left: AppDimens.paddingMedium, top: AppDimens.paddingMedium),
      BaseWidget.buildCardBase(
        Column(
          children: [
            ItemUtils.itemLine(
              leading: Icons.departure_board_rounded,
              trailing: CupertinoSwitch(
                value: controller.listSetupModel.value.busStation,
                onChanged: (val) {
                  controller.listSetupModel.update((value) {
                    value!.busStation = val;
                  });
                },
              ),
              title: AppStr.busStation,
            ),
            _buildDivider(),
            ItemUtils.itemLine(
              leading: Icons.group_work_outlined,
              trailing: CupertinoSwitch(
                value: controller.listSetupModel.value.busStationGroup,
                onChanged: (val) {
                  controller.listSetupModel.update((value) {
                    value!.busStationGroup = val;
                  });
                },
              ),
              title: AppStr.busStationGroup,
            ),
          ],
        ),
      ).marginAll(AppDimens.paddingSmall),
      Text(
        AppStr.selectTicket,
        style: Get.textTheme.bodyText1,
      ).marginOnly(left: AppDimens.paddingMedium, top: AppDimens.paddingMedium),
      BaseWidget.buildCardBase(
        Column(
          children: [
            ItemUtils.itemLine(
              leading: Icons.collections_bookmark_outlined,
              trailing: CupertinoSwitch(
                value: controller.listSetupModel.value.comboTicket,
                onChanged: (val) {
                  controller.listSetupModel.update((value) {
                    value!.comboTicket = val;
                  });
                },
              ),
              title: AppStr.ticketCombo,
            ),
            _buildDivider(),
            ItemUtils.itemLine(
                leading: Icons.confirmation_num_outlined,
                trailing: CupertinoSwitch(
                  value: controller.listSetupModel.value.basicTicket,
                  onChanged: (val) {
                    controller.listSetupModel.update((value) {
                      value!.basicTicket = val;
                    });
                  },
                ),
                title: AppStr.ticketBasic),
          ],
        ),
      ).marginAll(AppDimens.paddingSmall),
    ],
  );
}
