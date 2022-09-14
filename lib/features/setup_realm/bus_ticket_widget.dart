part of 'setup_realm_page.dart';

Widget _buildBusTicketPage(SetupRealmController controller) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
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
                    value!.busStationGroup= val;
                  });
                },
              ),
              title: AppStr.busStationGroup,
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
  
              leading: Icons.date_range_outlined,
              trailing: CupertinoSwitch(
                value: controller.listSetupModel.value.monthlyTicket,
                onChanged: (val) {
                  controller.listSetupModel.update((value) {
                    value!.monthlyTicket = val;
                  });
                },
              ),
              title: AppStr.busMonthlyTicket,
            ),
          ],
        ),
      ).marginAll(AppDimens.paddingSmall),
    ],
  );
}
