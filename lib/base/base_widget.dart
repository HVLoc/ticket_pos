import 'package:easy_invoice_qlhd/const/all_const.dart';
import 'package:easy_invoice_qlhd/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:get/get.dart';
import 'package:loading_overlay_pro/loading_overlay_pro.dart';

import 'base_controller.dart';

abstract class BaseGetWidget<T extends BaseGetxController> extends GetView<T> {
  const BaseGetWidget({Key? key}) : super(key: key);

  Widget buildWidgets();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // tắt tính năng vuốt trái để back lại màn hình trước đó trên iphone
      onWillPop: () async {
        // KeyBoard.hide();
        // await 300.milliseconds.delay();
        return !Navigator.of(context).userGestureInProgress;
      },
      child: buildWidgets(),
    );
  }

  Widget baseShowLoading(WidgetCallback child) {
    return Obx(
      () => controller.isShowLoading.value
          ? const Center(child: BaseWidget.buildLoading)
          : child(),
    );
  }

  /// Widget cài đặt phần widget chính của page gồm cả phần shimmer loading và phần body.
  Widget baseShimmerLoading(WidgetCallback child, {Widget? shimmer}) {
    return Obx(
      () => controller.isShowLoading.value
          ? shimmer ?? BaseWidget.buildShimmerLoading()
          : child(),
    );
  }

  Widget buildLoadingOverlay(WidgetCallback child) {
    return Obx(
      () => Stack(
        children: [
          LoadingOverlayPro(
            progressIndicator: !GetPlatform.isMobile
                ? const CupertinoActivityIndicator(
                    radius: 50,
                  )
                : const Icon(
                    Icons.print,
                    size: 50,
                  ),
            isLoading: controller.isLoadingOverlay.value,
            bottomLoading: controller.isLoadingOverlayIssue.value
                ? Text(
                    AppStr.invoicesIssueLoading,
                    style: GetPlatform.isMobile
                        ? Get.textTheme.bodyText1!.copyWith(
                            color: Colors.white,
                          )
                        : Get.textTheme.headline3!.copyWith(
                            color: Colors.white,
                          ),
                  )
                : null,
            child: child(),
          ),
          if (controller.isIssueSuccess.value)
            Stack(
              children: [
                Container(
                  color: Colors.black38,
                ),
                Center(
                  child: SlitInVertical(
                    preferences: AnimationPreferences(
                      autoPlay: AnimationPlayStates.Forward,
                      duration: 500.milliseconds,
                    ),
                    child: Icon(
                      Icons.check_circle,
                      color: Colors.lightGreenAccent,
                      size: Get.width / 2,
                    ),
                  ),
                )
              ],
            ),
        ],
      ),
    );
  }
}
