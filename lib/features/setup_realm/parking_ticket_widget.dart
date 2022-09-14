part of 'setup_realm_page.dart';

Widget _buildParkingTicketPage(SetupRealmController controller) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        AppStr.infomationExpanded,
        style: Get.textTheme.bodyText1,
      ).marginOnly(left: AppDimens.paddingMedium, top: AppDimens.paddingMedium),
      BaseWidget.buildCardBase(
        Column(
          children: [
            ItemUtils.itemLine(
              leading: Icons.near_me_outlined,
              trailing: Checkbox(
                value: controller.listSetupModel.value.licensePlatesParking,
                onChanged: (val) {
                  controller.listSetupModel.update((value) {
                    value!.licensePlatesParking = val!;
                  });
                },
              ),
              title: AppStr.licensePlates,
            ),
          ],
        ),
      ).marginAll(AppDimens.paddingSmall),
    ],
  );
}
