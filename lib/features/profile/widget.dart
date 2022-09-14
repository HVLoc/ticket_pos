part of 'profile_page.dart';

const Widget sizedBox = const SizedBox(height: AppDimens.paddingSmall);

Widget buildSearchInvoiceWidget(ProfileController controller) {
  return Container(
    decoration: BoxDecoration(
        gradient: const LinearGradient(
            colors: AppColors.colorGradientOrange,
            begin: const FractionalOffset(1.0, 0.0),
            end: const FractionalOffset(0.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp),
        borderRadius: BorderRadius.circular(10)),
    child: InkWell(
      onTap: () {
        Get.find<SearchInvoiceController>().navToSearchInvoicePage();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.qr_code_2,
                color: AppColors.textColorWhite,
                size: 25,
              ),
              const SizedBox(width: 5),
              Text(
                AppStr.searchInvoice.tr,
                style: Get.theme.textTheme.bodyText1!.copyWith(
                    color: AppColors.textColorWhite,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  AppStr.profileSearchInvoice.tr,
                  style: Get.context!.textTheme.bodyText2!
                      .copyWith(color: AppColors.textColorWhite),
                ),
              ),
              Flexible(
                child: InkWell(
                    onTap: () {
                      Get.find<SearchInvoiceController>()
                          .scanQrCode(controller);
                    },
                    child: Container(
                        margin: const EdgeInsets.only(left: 16),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 6),
                        decoration: BoxDecoration(
                            color: Colors.indigo[700],
                            borderRadius: BorderRadius.circular(10)),
                        child: Text(AppStr.scanQr.tr.toUpperCase(),
                            style: Get.textTheme.bodyText1!
                                .copyWith(color: Colors.white)))),
              )
            ],
          )
        ],
      ).paddingAll(AppDimens.defaultPadding),
    ),
  );
}

Widget buildAccountWidget(ProfileController controller) {
  return BaseWidget.buildCardBase(
    Column(
      children: [
        ItemUtils.itemLine(
          hasLeadingBg: true,
          leading: Icons.person,
          func: () {
            if (!controller.appController.isLogin.value) {
              Get.offAllNamed(AppConst.routeChangeAccount);
            } else {
              ShowPopup.showDialogConfirm(
                AppStr.profileLogoutTitle,
                confirm: () {
                  Get.offAllNamed(AppConst.routeChangeAccount);
                  Get.find<ProfileController>().sendLogout();
                },
                actionTitle: AppStr.logoutBtn,
              );
            }
          },
          trailing: controller.appController.isLogin.value
              ? Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.orange),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: Text(
                    AppStr.loginChangeUser,
                    style: Get.theme.textTheme.caption!.copyWith(
                      color: Colors.white,
                    ),
                  ),
                )
              : null,
          title: HIVE_ACCOUNT
                  .get(HIVE_APP.get(AppConst.keyCurrentAccount))
                  ?.nameAccount ??
              AppStr.loginBtn,
        ),
        // if (controller.homeController.accountPermission.canSearchCus) ...[
        //   _buildDivider(),
        //   ItemUtils.itemLine(
        //       hasLeadingBg: true,
        //       leading: Icons.people,
        //       func: () => Get.toNamed(AppConst.routeCustomer,
        //           arguments: CustomerArg(type: CusViewType.PROFILE)),
        //       title: AppStr.customer.tr),
        // ],
        // if (controller.homeController.accountPermission.canSearchProd) ...[
        //   _buildDivider(),
        //   ItemUtils.itemLine(
        //       hasLeadingBg: true,
        //       leading: Icons.local_grocery_store,
        //       func: () {
        //         Get.toNamed(AppConst.routeProduct, arguments: 1);
        //       },
        //       title: AppStr.productDetailProduct.tr),
        // ],
        if (controller.appController.isAdmin.value) ...[
          _buildDivider(),
          ItemUtils.itemLine(
            leading: Icons.near_me,
            func: () async {
              Get.toNamed(AppConst.routeInvoiceCreation);
            },
            title: AppStr.profileIssue,
          ),
          _buildDivider(),
          ItemUtils.itemLine(
            leading: Icons.people,
            func: () async {
              Get.to(() => AccountPage());
            },
            title: AppStr.profileAccount,
          ),
          if (HIVE_SETUP
              .get(HIVE_APP.get(AppConst.keyIdPage))!
              .configShift) ...[
            _buildDivider(),
            ItemUtils.itemLine(
              leading: Icons.send,
              title: AppStr.shiftUpdate,
              func: () {
                Get.to(() => ShiftPage());
              },
            ),
          ],
          if (HIVE_SETUP.get(HIVE_APP.get(AppConst.keyIdPage))!.licensePlates == 1) ...[
            _buildDivider(),
            ItemUtils.itemLine(
              leading: Icons.drive_eta,
              func: () async {
                Get.to(() => LicensePlates());
              },
              title: AppStr.licensePlates,
            ),
          ],
          if (HIVE_APP.get(AppConst.keyIdPage) == 1) ...[
            _buildDivider(),
            ItemUtils.itemLine(
              leading: Icons.drive_eta,
              func: () async {
                Get.to(() => AccountPage(),
                    arguments: HIVE_APP.get(AppConst.keyIdPage));
              },
              title: AppStr.driveConfig,
            ),
          ],
          _buildDivider(),
          ItemUtils.itemLine(
              leading: Icons.settings,
              func: () async {
                Get.offAllNamed(AppConst.routeSetupPage);
              },
              title: AppStr.config.tr),
        ],
        // _buildDivider(),
        // ItemUtils.itemLine(
        //   leading: Icons.people,
        //   func: () async {
        //     // HIVE_PRODUCT.clear();
        //     HIVE_INVOICE.clear();
        //     // HIVE_APP.clear();
        //     // HIVE_ACCOUNT.clear();
        //     // HIVE_SHIFT.clear();
        //   },
        //   title: "Xóa dữ liệu",
        // ),
      ],
    ),
  );
}

Widget buildAppWidget(ProfileController controller) {
  return BaseWidget.buildCardBase(
    Column(
      children: <Widget>[
        
        ItemUtils.itemLine(
          leading: Icons.phone,
          func: () async {
            if (await canLaunchUrlString(AppStr.telSupportNumber)) {
              await launchUrlString(AppStr.telSupportNumber);
            }
          },
          title: AppStr.phoneNumber.tr,
        ),
        _buildDivider(),
        ItemUtils.itemLine(
            leading: Icons.insert_comment_rounded,
            func: () async {
              ShowPopup.showDialogConfirm(
                  'Thao tác này sẽ xoá thông tin mã số thuế, tài khoản và cấu hình mẫu vé in và yêu cầu bạn đăng nhập lại app!!!\n Bạn có muốn tiếp tục',
                  confirm: () {
                HIVE_APP.deleteFromDisk();
                HIVE_ACCOUNT.deleteFromDisk();
                HIVE_PRODUCT.deleteFromDisk();
                HIVE_INVOICE.deleteFromDisk();
                HIVE_SHIFT.deleteFromDisk();
                SystemNavigator.pop();
              }, actionTitle: 'Xác nhận');
            },
            title: AppStr.changeTaxCode.tr),
      ],
    ),
  );
}

Widget buildInforAppWidget(ProfileController controller) {
  return BaseWidget.buildCardBase(
    Column(
      children: [
        ItemUtils.itemLine(
            leading: Icons.phone_iphone,
            trailing: null,
            title: "${packageInfo.appName} ${packageInfo.version}"),
        _buildDivider(),
        // ItemUtils.itemLine(
        //   leading: controller.appController.isBusinessHousehold.value
        //       ? Icons.store
        //       : Icons.business_outlined,
        //   func: () async {
        //     controller.appController.changeBusinessType();
        //   },
        //   title: controller.appController.isBusinessHousehold.value
        //       ? AppStr.householdBusiness.tr
        //       : AppStr.incorp.tr,
        //   trailing: const Icon(
        //     Icons.loop_rounded,
        //     size: 25,
        //   ),
        // ),
        // _buildDivider(),
        ItemUtils.itemLine(
          title: AppStr.aboutUs.tr,
          func: () async {
            try {
              if (await canLaunchUrlString(AppConst.aboutUsUrl)) {
                await launchUrlString(
                  AppConst.aboutUsUrl,
                );
              }
            } catch (e) {
              print(e);
            }
          },
          subtitle: Text('© 2019 - 2021 by SoftDreams',
              style: Get.textTheme.bodyText2!
                  .copyWith(color: AppColors.textColor())),
        )
      ],
    ),
  );
}

Widget _buildDivider() => Divider(
      height: 0,
      color: AppColors.dividerColor(),
      indent: 64,
    );


