part of 'setup_realm_page.dart';

Widget _buildSettingTicket(SetupRealmController controller) {
  return Column(
    children: [
      Row(
        children: [
          Expanded(
            child: Text(
              AppStr.tutorialSettingLabel,
              style: Get.textTheme.subtitle2,
            ),
          ),
          const Spacer(),
          Row(
            children: [
              Text(
                AppStr.noteLable,
                style: Get.textTheme.subtitle1,
              ).paddingSymmetric(horizontal: AppDimens.paddingSmall),
              GestureDetector(
                onTap: () => Get.bottomSheet(
                  BaseWidget.baseBottomSheet(
                    title: AppStr.noteLable,
                    body: _buildBottomSheetSupport(),
                    isSecondDisplay: true,
                  ),
                  isScrollControlled: true,
                ),
                child: const Icon(
                  Icons.info,
                  size: AppDimens.sizeIconMedium,
                ),
              ),
            ],
          )
        ],
      ),
      BaseWidget.sizedBox10,
      BaseWidget.buildCardBase(
        Container(
          height:
              Get.height - 2 * AppDimens.defaultPadding - kToolbarHeight - 175,
          width: Get.width,
          child: _buildContent(controller),
        ),
      )
    ],
  ).paddingSymmetric(horizontal: AppDimens.paddingSmall);
}

Widget _buildContent(SetupRealmController controller) {
  return Obx(
    () => controller.list.isEmpty
        ? GestureDetector(
            onTap: () {
              controller.list.add(Setting());
            },
            child: Container(
              color: Colors.transparent,
              alignment: Alignment.topCenter,
              child: Text(
                AppStr.addALine,
                style: Get.textTheme.bodyText1!
                    .copyWith(color: AppColors.orangeSelected),
              ),
            ),
          )
        : ReorderableListView(
            shrinkWrap: true,
            onReorder: (int oldIndex, int newIndex) {
              if (oldIndex < newIndex) {
                newIndex -= 1;
              }
              final item = controller.list.removeAt(oldIndex);
              controller.list.insert(newIndex, item);
            },
            children: [
              for (int index = 0; index < controller.list.length; index++) ...[
                GestureDetector(
                  key: ValueKey(controller.list[index]),
                  onTap: () {
                    controller.getKeyBeforeFixSetting(
                        controller.list[index].title ?? "");
                    Get.bottomSheet(
                            BaseWidget.baseBottomSheet(
                                title: AppStr.config,
                                body: _buildBottomSheetFixSetting(controller,
                                    setting: controller.list[index]),
                                isSecondDisplay: true),
                            isScrollControlled: true)
                        .then((value) {
                      if (value != null) {
                        controller.list[index] = value;
                      }
                    });
                  },
                  child: Column(
                    key: ValueKey(controller.list[index]),
                    children: [
                      Slidable(
                        key: ValueKey('$index'),
                        secondaryActions: [
                          _iconSlideAction(
                            controller,
                            function: () {
                              controller.list.insert(index + 1, Setting());
                            },
                            icon: Icons.add,
                            text: AppStr.add,
                          ),
                          _iconSlideAction(
                            controller,
                            function: () {
                              controller.getKeyBeforeFixSetting(
                                  controller.list[index].title ?? "");
                              Get.bottomSheet(
                                      BaseWidget.baseBottomSheet(
                                          title: AppStr.config,
                                          body: _buildBottomSheetFixSetting(
                                              controller,
                                              setting: controller.list[index]),
                                          isSecondDisplay: true),
                                      isScrollControlled: true)
                                  .then((value) {
                                if (value != null) {
                                  controller.list[index] = value;
                                }
                              });
                            },
                            icon: Icons.edit,
                            text: AppStr.fix,
                          ),
                          _iconSlideAction(
                            controller,
                            function: () {
                              controller.deleteSetting(index);
                            },
                            icon: Icons.close,
                            text: AppStr.delete,
                          ),
                        ],
                        actionExtentRatio: 0.15,
                        actionPane: const SlidableScrollActionPane(),
                        child: StatefulBuilder(builder: (context, state) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                        (controller.list[index].isQRCode
                                                ? "Mã QR Code: "
                                                : "") +
                                            (controller.list[index].title ??
                                                AppStr.newInfor),
                                        maxLines: 3,
                                        softWrap: true,
                                        style: Get.textTheme.bodyText2!
                                            .copyWith(
                                                color: controller
                                                        .list[index].isQRCode
                                                    ? AppColors
                                                        .selectedInvoice()
                                                    : AppColors
                                                        .textColorDefault))
                                    .paddingOnly(right: AppDimens.paddingSmall),
                              ),
                              const Icon(Icons.arrow_right_rounded),
                            ],
                          ).paddingSymmetric(
                              vertical: AppDimens.paddingVerySmall);
                        }),
                      ),
                      BaseWidget.buildDivider(),
                    ],
                  ),
                ),
              ]
            ],
          ).paddingSymmetric(
            horizontal: AppDimens.paddingSmall,
          ),
  );
}

Widget _iconSlideAction(SetupRealmController controller,
    {required Function() function,
    required IconData icon,
    required String text}) {
  return SlideAction(
    color: Colors.transparent,
    onTap: function,
    child: BaseWidget.baseOnAction(
      onTap: function,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: AppColors.orangeSelected,
          ),
          Text(
            text,
            style: Get.textTheme.subtitle2!
                .copyWith(color: AppColors.orangeSelected),
          ),
        ],
      ),
    ),
  );
}

Widget _buildBottomSheetFixSetting(SetupRealmController controller,
    {required Setting setting}) {
  controller.objectChange.value = controller.fillSettingToBottomSheet(setting);
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        height: 50,
        width: Get.width,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemBuilder: ((context, index) {
            return Obx(
              () => GestureDetector(
                onTap: () {
                  controller.actionTypeIndex.value = index;
                },
                child: Container(
                  width: Get.width / 2 - 2 * AppDimens.paddingSmall,
                  child: ChoiceChip(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    selectedColor: AppColors.orange,
                    backgroundColor: Colors.white,
                    label: Container(
                      child: Text(
                        AppStr.actionType[index],
                        textAlign: TextAlign.center,
                      ),
                    ),
                    selected: controller.actionTypeIndex.value == index,
                    onSelected: (value) {
                      controller.actionTypeIndex.value = index;
                    },
                  ).paddingSymmetric(horizontal: AppDimens.paddingSmall),
                ),
              ),
            );
          }),
          itemCount: AppStr.actionType.length,
        ),
      ),
      Obx(
        () => Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BaseWidget.sizedBoxPadding,
                BuildInputTextWithLabel(
                  label: AppStr.textLabel,
                  buildInputText: BuildInputText(
                    InputTextModel(
                        controller: controller.textEditingController),
                  ),
                ),
                BaseWidget.sizedBox10,
                _buildRowInput(
                  title: AppStr.fontSizeLabel,
                  widget: Container(
                      height: 40,
                      child: BuildInputText(
                        InputTextModel(
                          // ? controller.qrSizeController
                          inputFormatters: 1,
                          controller: controller.fontSizeController,
                          textInputType: TextInputType.number,
                        ),
                      )),
                ),
                BaseWidget.sizedBox5,
                if (controller.actionTypeIndex == 0) ...[
                  _buildRowInput(
                    title: AppStr.boldTextLabel,
                    widget: Obx(
                      () => CupertinoSwitch(
                          thumbColor: Colors.white,
                          value: controller.objectChange.value.isBoldText,
                          onChanged: (value) {
                            controller.objectChange.update((val) {
                              val!.isBoldText = value;
                            });
                          }),
                    ),
                  ),
                  BaseWidget.sizedBox5,
                  _buildRowInput(
                    title: AppStr.upperTextLabel,
                    widget: Obx(
                      () => CupertinoSwitch(
                          value: controller.objectChange.value.isToUpper,
                          onChanged: (value) {
                            controller.objectChange.update((val) {
                              val!.isToUpper = value;
                            });
                          }),
                    ),
                  ),
                ],
                BaseWidget.sizedBox10,
                _buildAlignText(controller,
                    title: AppStr.alignLable,
                    actionTypeIndex: controller.actionTypeIndex.value),
              ],
            ),
          ),
        ),
      ),
      // const Spacer(),
      BaseWidget.buildButton(AppStr.confirm, () {
        controller
            .fixKeyWhenUserFixSetting(controller.textEditingController.text);
        Get.back(
          result: controller.resultValue(),
        );
      }),
    ],
  ).paddingAll(AppDimens.paddingVerySmall);
}

Widget _buildRowInput({required String title, required Widget widget}) {
  return Row(
    children: [
      Expanded(
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: Get.textTheme.bodyText2,
          ),
        ),
      ),
      Expanded(
        child: widget,
      )
    ],
  );
}

Widget _buildAlignText(SetupRealmController controller,
    {required String title, int actionTypeIndex = 0}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        title,
        style: Get.textTheme.bodyText2,
      ),
      BaseWidget.sizedBox5,
      Container(
        height: 50,
        alignment: Alignment.center,
        child: ListView.separated(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: 3,
          separatorBuilder: (context, index) {
            return const SizedBox(
              width: 10,
            );
          },
          itemBuilder: (context, index) {
            return SizedBox(
              width: Get.width / 4,
              child: Obx(
                () => ChoiceChip(
                  label: Text(
                    AppStr.alignText[index],
                    style: Get.textTheme.subtitle1,
                  ),
                  selected: controller.objectChange.value.alignText == index,
                  selectedColor: AppColors.orangeSelected,
                  onSelected: (bool value) {
                    controller.objectChange.update((val) {
                      val!.alignText = index;
                    });
                  },
                ),
              ),
            );
          },
        ),
      ),
    ],
  );
}

Widget _buildBottomSheetSupport() {
  return Column(
    children: [
      BaseWidget.sizedBoxPaddingHuge,
      ListView.separated(
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return RichText(
              text: TextSpan(children: [
            TextSpan(
              text: AppStr.keySetting.keys.toList()[index],
              style: Get.textTheme.bodyText1!
                  .copyWith(color: AppColors.orangeSelected),
            ),
            TextSpan(text: ' : ', style: Get.textTheme.bodyText1),
            TextSpan(
                text: AppStr.keySetting.values.toList()[index],
                style: Get.textTheme.bodyText1),
          ]));
        },
        separatorBuilder: (context, index) {
          return BaseWidget.buildDivider();
        },
        itemCount: AppStr.keySetting.length,
      ),
    ],
  );
}
