
import 'package:easy_invoice_qlhd/application/app_controller.dart';
import 'package:easy_invoice_qlhd/base/base.dart';
import 'package:easy_invoice_qlhd/const/all_const.dart';
import 'package:easy_invoice_qlhd/features/license_plates/license_plates_page.dart';
import 'package:easy_invoice_qlhd/features/search_invoice/search_invoice_controller.dart';
import 'package:easy_invoice_qlhd/features/shift/shift_page.dart';
import 'package:easy_invoice_qlhd/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../account/account_src.dart';
import 'profile.dart';

part 'widget.dart';

class ProfilePage extends BaseGetWidget<ProfileController> {
  @override
  ProfileController get controller => Get.put(ProfileController());

  @override
  Widget buildWidgets() {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        body: buildLoadingOverlay(() => _buildBody()),
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Stack(children: [
        Container(
          color: AppColors.appBarColor(),
          height: Get.height,
        ),
        // Image.asset(
        //   AppStr.imgProfile,
        //   fit: BoxFit.cover,
        //   width: Get.width,
        //   height: Get.height / 3,
        // ),
        Container(
          padding:
              const EdgeInsets.symmetric(horizontal: AppDimens.paddingSmall),
          child: Column(
            children: [
              Container(
                  padding: EdgeInsets.only(
                      top: Get.mediaQuery.padding.top * 1.0,
                      bottom: Get.mediaQuery.padding.top * 0.5),
                  child: Column(
                    children: [
                      // BaseWidget.buildChangLanguage(
                      //   loginController: loginController,
                      // ).paddingSymmetric(vertical: AppDimens.paddingMedium),
                      Text(
                        '${AppStr.companyName}\n${AppStr.companyTaxCode}',
                        style: Get.textTheme.headline6!
                            .copyWith(color: AppColors.textColor()),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 5,
                      ),
                    ],
                  )),
              // buildSearchInvoiceWidget(controller),
              // sizedBox,
              // _mainFeature(),
              // sizedBox,
              buildAccountWidget(controller),
              // sizedBox,
              // buildSettingWidget(controller),
              sizedBox,
              buildAppWidget(controller),
              sizedBox,
              buildInforAppWidget(controller),
              sizedBox,
              // _buildLinkToSocialMedia(),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ]),
    );
  }
}
