part of 'setup_realm_page.dart';

Widget _buildConfigPage(SetupRealmController controller) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        AppStr.configAccount,
        style: Get.textTheme.bodyText1,
      ).marginOnly(left: AppDimens.paddingMedium),
      BaseWidget.buildCardBase(
        Column(
          children: [
            ItemUtils.itemLine(
              func: () {
                controller.listSetupModel.update((value) {
                  value!.configAccount = !value.configAccount;
                });
              },
              leading: Icons.person,
              trailing: Icon(
                  controller.listSetupModel.value.configAccount
                      ? Icons.radio_button_off
                      : Icons.radio_button_checked,
                  color: controller.listSetupModel.value.configAccount
                      ? Colors.black
                      : Colors.red),
              title: AppStr.oneAccount,
            ),
            _buildDivider(),
            ItemUtils.itemLine(
                func: () {
                  controller.listSetupModel.update((value) {
                    value!.configAccount = !value.configAccount;
                  });
                },
                leading: Icons.groups,
                trailing: Icon(
                    !controller.listSetupModel.value.configAccount
                        ? Icons.radio_button_off
                        : Icons.radio_button_checked,
                    color: controller.listSetupModel.value.configAccount
                        ? Colors.red
                        : Colors.black),
                title: AppStr.multiAccount),
          ],
        ),
      ).marginAll(AppDimens.paddingSmall),
      Text(
        AppStr.configShift,
        style: Get.textTheme.bodyText1,
      ).marginOnly(left: AppDimens.paddingMedium, top: AppDimens.paddingMedium),
      BaseWidget.buildCardBase(
        Column(
          children: [
            ItemUtils.itemLine(
              func: () {
                controller.listSetupModel.update((value) {
                  value!.configShift = !value.configShift;
                });
              },
              leading: Icons.remove,
              trailing: Icon(
                  controller.listSetupModel.value.configShift
                      ? Icons.radio_button_off
                      : Icons.radio_button_checked,
                  color: controller.listSetupModel.value.configShift
                      ? Colors.black
                      : Colors.red),
              title: AppStr.oneShift,
            ),
            _buildDivider(),
            ItemUtils.itemLine(
              func: () {
                controller.listSetupModel.update((value) {
                  value!.configShift = !value.configShift;
                });
              },
              leading: Icons.drag_handle,
              trailing: Icon(
                  !controller.listSetupModel.value.configShift
                      ? Icons.radio_button_off
                      : Icons.radio_button_checked,
                  color: controller.listSetupModel.value.configShift
                      ? Colors.red
                      : Colors.black),
              title: AppStr.multiShift,
            ),
          ],
        ),
      ).marginAll(AppDimens.paddingSmall),
      Text(
        AppStr.configSecondAccount,
        style: Get.textTheme.bodyText1,
      ).marginOnly(left: AppDimens.paddingMedium, top: AppDimens.paddingMedium),
      BaseWidget.buildCardBase(
        Column(
          children: [
            ItemUtils.itemLine(
              leading: Icons.person_add,
              trailing: CupertinoSwitch(
                value: controller.listSetupModel.value.configSecondAccount,
                onChanged: (val) {
                  controller.listSetupModel.update((value) {
                    value!.configSecondAccount = val;
                  });
                },
              ),
              title: AppStr.configSecondAccount,
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
              leading: Icons.qr_code,
              trailing: CupertinoSwitch(
                value: controller.listSetupModel.value.configAddQRCode,
                onChanged: (val) {
                  controller.listSetupModel.update((value) {
                    value!.configAddQRCode = val;
                  });
                },
              ),
              title: AppStr.configAddQRCode,
            ),
          ],
        ),
      ).marginAll(AppDimens.paddingSmall),
    ],
  );
}
