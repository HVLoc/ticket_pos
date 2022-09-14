part of 'setup_realm_page.dart';

Widget _buildGameTicketPage(SetupRealmController controller) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
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
