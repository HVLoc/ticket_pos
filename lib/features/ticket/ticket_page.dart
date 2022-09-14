import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_invoice_qlhd/application/app_controller.dart';
import 'package:easy_invoice_qlhd/features/ticket/controller/ticket_ctr_imp.dart';
import 'package:easy_invoice_qlhd/features/ticket/ticket_config_page.dart';
import 'package:easy_invoice_qlhd/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../base/base.dart';
import '../../const/all_const.dart';
import '../invoice_detail/model/invoice_detail_response.dart';
import 'controller/ticket_controller.dart';

class TicketPage extends BaseGetWidget<TicketController> {
  @override
  TicketController get controller => Get.put(TicketControllerImp());

  @override
  Widget buildWidgets() {
    return BaseWidget.buildSafeArea(
      Scaffold(
        body: buildLoadingOverlay(
          () => _buildBody(),
        ),
        bottomNavigationBar: (controller.setupModel.licensePlatesParking &&
                controller.appController.isAdmin.isFalse)
            ? BaseWidget.buildCardBase(
                Container(
                  height: 120,
                  width: Get.width,
                  color: Colors.white,
                  child: Row(
                    children: [
                      Expanded(
                        child: BuildInputTextWithLabel(
                          label: "Nhập biển số xe",
                          buildInputText: BuildInputText(
                            InputTextModel(
                                controller:
                                    controller.licensePlatesParkingController),
                          ),
                        ).paddingSymmetric(
                            horizontal: AppDimens.defaultPadding,
                            vertical: AppDimens.defaultPadding),
                      ),
                      // Align(
                      //   alignment: Alignment.topRight,
                      //   child: IntrinsicHeight(
                      //     child: Container(
                      //       padding: const EdgeInsets.all(0),
                      //       decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.circular(50),
                      //         color: Colors.green.shade700,
                      //       ),
                      //       child: const Icon(
                      //         Icons.print,
                      //         color: Colors.white,
                      //       ).paddingSymmetric(
                      //         horizontal: AppDimens.paddingVerySmall,
                      //         vertical: AppDimens.paddingVerySmall,
                      //       ),
                      //     ).paddingSymmetric(
                      //       horizontal: AppDimens.paddingVerySmall,
                      //       vertical: AppDimens.paddingVerySmall,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ).paddingSymmetric(horizontal: AppDimens.paddingSmall)
            : null,
      ),
    );
  }

  Widget _buildProductEmpty() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppStr.dataEmpty,
          style: Get.textTheme.headline4?.copyWith(
            color: AppColors.textColor(),
          ),
        ),
        BaseWidget.sizedBox10,
        Text(
          controller.appController.isAdmin.value
              ? AppStr.ticketHelpLogin
              : AppStr.ticketHelpNotLogin,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: AppDimens.fontBig(),
            color: AppColors.textColor(),
          ),
        ),
        BaseWidget.sizedBoxPaddingHuge,
        if (controller.appController.isAdmin.value)
          BaseWidget.buildButton(AppStr.ticketAddProduct, () {
            controller.addProduct();
          })
      ],
    ).paddingSymmetric(horizontal: AppDimens.paddingSmall);
  }

  Widget _buildNeedLogin() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppStr.ticketNeedLogin,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: AppDimens.fontBig(),
            color: AppColors.errorText(),
          ),
        ),
        BaseWidget.sizedBoxPaddingHuge,
        BaseWidget.buildButton(AppStr.loginBtn, () {
          Get.toNamed(AppConst.routeLogin);
        })
      ],
    ).paddingSymmetric(horizontal: AppDimens.paddingSmall);
  }

  Widget _buildBody() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: //(HIVE_PRODUCT.isEmpty ||
                  // !controller.appController.isLogin.value ||
                  // controller.setupModel.idPage != 0 ) &&
                  !controller.setupModel.startTime ||
                          controller.appController.isAdmin.isTrue
                      ? const SizedBox()
                      : TextButton.icon(
                          onPressed: () {
                            showTimePicker(
                              context: Get.context!,
                              initialTime: TimeOfDay(
                                  hour: controller.timeOfDay.value.hour,
                                  minute: controller.timeOfDay.value.minute),
                            ).then((value) {
                              if (value != null) {
                                controller.timeOfDay.value = DateTime(
                                  controller.timeOfDay.value.year,
                                  controller.timeOfDay.value.month,
                                  controller.timeOfDay.value.day,
                                  value.hour,
                                  value.minute,
                                );
                                HIVE_APP.put(AppConst.keyTimeOfDay,
                                    controller.timeOfDay.value);
                              }
                            });
                          },
                          icon: Icon(
                            Icons.access_time,
                            color: AppColors.iconHomeColor(),
                          ),
                          label: Text(controller.convertCurrentTime()),
                        ),
            ),
            if ((HIVE_APP.get(AppConst.keyIdPage) ?? 0) == 1 ||
                controller.appController.isAdmin.isTrue)
              Expanded(
                child: Center(
                  child: InkWell(
                    onTap: () {
                      if (!controller.appController.isLogin.value) {
                        Get.toNamed(AppConst.routeLogin);
                      }
                    },
                    child: AutoSizeText(
                      controller.getTitle(),
                      style: Get.textTheme.titleLarge,
                    ),
                  ),
                ),
              ),
            Expanded(
              child: controller.appController.isAdmin.isTrue
                  ? !HIVE_PRODUCT.isEmpty
                      ? TextButton(
                          onPressed: () => Get.to(() => TicketConfigPage()),
                          child: Align(
                            child: Text(
                              'Cấu hình s/p',
                              style: Get.textTheme.subtitle1!.copyWith(
                                color: AppColors.orangeSelected,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                      : const SizedBox()
                  : !controller.setupModel.startDate
                      ? const SizedBox()
                      : TextButton(
                          onPressed: controller.showDateTimePicker,
                          child: Obx(
                            () => Text(
                              convertDateToString(
                                  controller.dateTime.value, PATTERN_1),
                              style: Get.textTheme.subtitle1!.copyWith(
                                color: AppColors.linkText(),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
            ),
          ],
        ),
        if (controller.appController.isAdmin.isFalse) _buildInfoAccount(),
        Expanded(
          child: controller.appController.isLogin.value
              ? controller.products.isEmpty
                  ? _buildProductEmpty()
                  : _buildListProduct()
              : _buildNeedLogin(),
        ),
      ],
    );
  }

  Widget _buildInfoAccount() {
    return Row(
      children: [
        Expanded(
          child: Center(
            child: Text(
                HIVE_ACCOUNT
                    .get(HIVE_APP.get(AppConst.keyCurrentAccount) ?? 0)!
                    .nameAccount,
                style: Get.textTheme.titleLarge),
          ),
        ),
        if (HIVE_APP.get(AppConst.keyIdPage) == 1)
          Expanded(
            child: Center(
              child: Text(
                HIVE_ACCOUNT_DRIVER
                    .get(HIVE_APP.get(AppConst.keyCurrentAccountDriver) ?? 0)!
                    .nameAccount,
                style: Get.textTheme.titleLarge,
              ),
            ),
          ),
      ],
    ).paddingSymmetric(vertical: AppDimens.paddingSmall);
  }

  Widget _buildListProduct() {
    return Column(
      children: [
        Expanded(
          child: ReorderableListView(
            scrollController: controller.scrollController,
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.paddingSmall,
            ),
            onReorder: (int oldindex, int newindex) {
              if (newindex <= controller.products.length) {
                if (newindex > oldindex) {
                  newindex--;
                }
                final items = controller.products.removeAt(oldindex);
                controller.products.insert(newindex, items);
              }
            },
            shrinkWrap: true,
            children: <Widget>[
              for (int index = 0; index < controller.products.length; index++)
                _buildItemUser(index),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildItemUser(int index) {
    ProductItem item = controller.products[index];

    return Container(
      key: ValueKey(item),
      margin: const EdgeInsets.symmetric(
        vertical: AppDimens.paddingSmall,
      ),
      child: Obx(
        () => BaseWidget.buildCardBase(
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              BaseWidget.sizedBox10,
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: AutoSizeText(
                      item.name.toString(),
                      style: Get.textTheme.bodyText1!.copyWith(fontSize: 16),
                    ),
                  ),
                  BaseWidget.sizedBox10,
                  if (controller.appController.isAdmin.isFalse)
                    BaseWidget.buildButtonIcon(
                      icons: Icons.print,
                      func: () {
                        controller.printTicket(item);
                      },
                      colors: Colors.green.shade700,
                      title: '',
                    )
                ],
              ),
              // buildExtra(controller.homeController, item),
              if (controller.appController.isAdmin.isFalse)
                Row(
                  children: [
                    Expanded(
                      child: Text('Số lượng',
                          style: Get.textTheme.bodyText1!
                              .copyWith(fontWeight: FontWeight.w400)),
                    ),
                    // Expanded(
                    //   child: AutoSizeText(
                    //     CurrencyUtils.formatCurrencyForeign(
                    //       convertDoubleToStringSmart(
                    //           (item.amount ?? 0) * item.quantityLocal.value),
                    //     ),
                    //     style: Get.theme.textTheme.subtitle1,
                    //   ),
                    // ),
                    Expanded(
                      flex: 2,
                      child: BaseWidget.buildSpinBox(
                        item.quantityLocal,
                        (value) {
                          item.quantityLocal.value = value ?? 0.0;
                        },
                        const Icon(
                          Icons.indeterminate_check_box,
                          size: AppDimens.sizeDialogNotiIcon,
                        ),
                      ),
                    ),
                  ],
                ),
              Row(
                children: [
                  Text(
                    (controller.appController.isAdmin.isTrue)
                        ? 'Đơn giá'
                        : 'Thành tiền',
                    style: Get.textTheme.bodyText1!
                        .copyWith(fontWeight: FontWeight.w400),
                  ).paddingSymmetric(vertical: AppDimens.paddingSmall),
                  const Spacer(),
                  AutoSizeText(
                    controller.appController.isAdmin.isFalse
                        ? (item.unit.isStringNotEmpty &&
                                    controller.appController.isAdmin.isFalse
                                ? '${CurrencyUtils.formatCurrencyForeign(item.quantityLocal.value, lastDecimal: 1)} ${item.unit} * '
                                : '') +
                            CurrencyUtils.formatCurrencyForeign(
                              convertDoubleToStringSmart(item.amount),
                            ) +
                            ' = ${CurrencyUtils.formatCurrencyForeign(item.quantityLocal.value * item.amount!, lastDecimal: 1)}'
                        : "${CurrencyUtils.formatCurrencyForeign(item.amount, lastDecimal: 1)} đồng/ ${item.unit.isStringNotEmpty ? item.unit : ''}",
                    style: Get.theme.textTheme.bodyText1!.copyWith(
                        fontSize: AppDimens.fontSmall(),
                        fontWeight: FontWeight.w400),
                  ),
                ],
              )
            ],
          ).paddingSymmetric(
            horizontal: AppDimens.paddingVerySmall,
          ),
        ),
      ),
    );
  }
}
