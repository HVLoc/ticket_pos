import 'package:easy_invoice_qlhd/application/app.dart';
import 'package:easy_invoice_qlhd/const/all_const.dart';
import 'package:easy_invoice_qlhd/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashPage extends GetView<AppController> {
  @override
  Widget build(BuildContext context) {
    Get.put(AppController(), permanent: true);
    return Container(
      color: AppColors.splashColor(),
      alignment: Alignment.center,
      child: BaseWidget.buildLogo(AppStr.imgLoginLogo, AppDimens.sizeImage),
    );
  }
}
