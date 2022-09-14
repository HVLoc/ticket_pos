part of 'setup_realm_page.dart';

Widget _listItem(
  String title,
  IconData icon,
  SetupRealmController controller,
  int idPage,
) =>
    ItemUtils.itemLine(
      leading: icon,
      func: () {
        controller.activeStep.value++;
        controller.idPage.value = idPage;
        controller.getSetup();
      },
      title: title,
    );

Widget _listSelectField(SetupRealmController controller) {
  return Column(
    children: [
      BaseWidget.buildCardBase(
        Column(
          children: [
            _listItem(
              AppStr.ticketCoach,
              Icons.directions_car,
              controller,
              0,
            ),
            _buildDivider(),
            _listItem(
              AppStr.ticketBus,
              Icons.directions_bus,
              controller,
              1,
            ),
            _buildDivider(),
            _listItem(
              AppStr.ticketParking,
              Icons.directions_bike,
              controller,
              2,
            ),
            _buildDivider(),
            _listItem(
              AppStr.ticketGames,
              Icons.gamepad,
              controller,
              3,
            ),
          ],
        ),
      ).marginOnly(left: AppDimens.paddingSmall, right: AppDimens.paddingSmall),
      BaseWidget.buildCardBase(
        _listItem(
          AppStr.ticketCustoms,
          Icons.dashboard_customize,
          controller,
          4,
        ),
      ).marginAll(AppDimens.paddingSmall),
    ],
  );
}

Widget _buildDivider() => const Divider(
      height: 1,
      color: Colors.black,
      indent: 20,
    );
Widget _buildDotStepper(SetupRealmController controller) {
  return Stack(
    children: [
      Center(
        child: Container(
          width: 240,
          height: 40,
          child: const Divider(
            color: Colors.black,
            thickness: 1,
          ),
        ),
      ),
    
    ],
  );
}

Widget _viewCenterPage(SetupRealmController controller) {
  switch (controller.activeStep.value) {
    case 1:
      return _buildTicketPage(controller);
    case 2:
      return _buildConfigPage(controller);
    case 3:
      return _buildSettingTicket(controller);
    default:
      return _listSelectField(controller);
  }
}

_buildTitle(SetupRealmController controller) {
  if (controller.activeStep.value == 1) {
    switch (controller.idPage.value) {
      case 0:
        return AppStr.ticketCoach;
      case 1:
        return AppStr.ticketBus;
      case 2:
        return AppStr.ticketParking;
      case 3:
        return AppStr.ticketGames;
      case 4:
        return AppStr.ticketCustoms;
    }
  } else {
    switch (controller.activeStep.value) {
      case 0:
        return AppStr.selectFiel;
      case 2:
        return AppStr.config;
      case 3:
        return AppStr.configTicket;
    }
  }
}

_buildTicketPage(SetupRealmController controller) {
  switch (controller.idPage.value) {
    case 0:
      return _buildCoachTicketPage(controller);
    case 1:
      return _buildBusTicketPage(controller);
    case 2:
      return _buildParkingTicketPage(controller);
    case 3:
      return _buildGameTicketPage(controller);
    case 4:
      return _buildCustomsTicketPage(controller);
  }
}


Widget _buildButton(SetupRealmController controller) {
  final isFistStep = controller.activeStep.value != 0;
  final isLastStep = controller.activeStep.value == 3;

  return Visibility(
    visible: isFistStep || isLastStep,
    child: Row(
      children: [
        Expanded(
          child: BaseWidget.buildButtonIconBeforeText(
            Icon(
              isLastStep ? Icons.print : Icons.keyboard_backspace_rounded,
            ),
            isLastStep ? AppStr.btnPrint : AppStr.btnBack,
            onPressed: () {
              isLastStep
                  ? {
                      controller.getKeySettingUserUse(),
                      Get.bottomSheet(
                        BaseWidget.baseBottomSheet(
                          title: AppStr.newInfor,
                          body: _buildBottomSheetData(controller),
                          isSecondDisplay: true,
                        ),
                        isScrollControlled: true,
                      ).whenComplete(() {
                        controller.getDataToListValue();
                      })
                    }
                  : controller.back();
            },
            backgroundColor: MaterialStateProperty.all(AppColors.appBarColor1),
            minimumSize: MaterialStateProperty.all(
              const Size(0, 50),
            ),
          ),
        ),
        Expanded(
          child: BaseWidget.buildButtonIconAfterText(
            isLastStep ? AppStr.save : AppStr.btnNext,
            icon: isLastStep ? Icons.save : Icons.east_rounded,
            onPressed: () {
              if (controller.activeStep.value == 2) {
                controller.getSettingPrint();
              }
              isLastStep
                  ? {
                      if (HIVE_SETTING.isNotEmpty)
                        {
                          HIVE_SETTING.clear(),
                        },
                      controller.list.forEach((element) {
                        HIVE_SETTING.add(element);
                      }),
                      controller.gotoHome(),
                    }
                  : controller.next();
            },
            minimumSize: MaterialStateProperty.all(
              const Size(0, 50),
            ),
            backgroundColor: MaterialStateProperty.all(
              isLastStep ? AppColors.colorBlueB1FF : AppColors.colorRed444,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildBottomSheetData(SetupRealmController controller) {
  return Column(
    children: [
      Expanded(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BaseWidget.sizedBoxPaddingHuge,
              ListView.separated(
                  scrollDirection: Axis.vertical,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: ((context, index) {
                    return BuildInputTextWithLabel(
                        label: AppStr.keySetting[
                                '${controller.keySettingUserUse[index]}'] ??
                            '',
                        buildInputText: BuildInputText(InputTextModel(
                          controller:
                              controller.listTextEditingController[index],
                        )));
                  }),
                  separatorBuilder: (context, index) {
                    return BaseWidget.sizedBox10;
                  },
                  itemCount: controller.keySettingUserUse.length),
            ],
          ),
        ),
      ),
      BaseWidget.buildButton(AppStr.btnPrint, () async {
        await SunmiPrinter.startTransactionPrint(true);
        await controller.configPrinter(
          controller.list,
        );
        await SunmiPrinter.exitTransactionPrint(true);
      })
    ],
  );
}
