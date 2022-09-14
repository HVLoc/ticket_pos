import 'package:easy_invoice_qlhd/base/base.dart';
import 'package:easy_invoice_qlhd/const/all_const.dart';
import 'package:easy_invoice_qlhd/utils/widgets/base_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class BaseRefreshWidget<T extends BaseRefreshGetxController>
    extends BaseGetWidget<T> {
  const BaseRefreshWidget({Key? key}) : super(key: key);

  Widget buildPage(
      {PreferredSizeWidget? appBar,
      required Widget body,
      double miniumBottom = 0,
      RxBool? isShowSupportCus,
      Color? statusBarColor,
      bool isNeedUpToPage = false}) {
    // Rx<Offset> position = Offset(Get.width - 50, Get.height / 2 + 100).obs;
    // RxBool? isDraging = false.obs;

    return Container(
      color: AppColors.orange,
      child: BaseWidget.buildSafeArea(
        Obx(() => Stack(
              alignment: Alignment.bottomRight,
              children: [
                Scaffold(
                  appBar: appBar,
                  body: body,
                  extendBody: true,
                  floatingActionButton: isNeedUpToPage &&
                          controller.showBackToTopButton.value
                      ? Container(
                          padding: EdgeInsets.only(bottom: Get.height / 5),
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: SizedBox(
                                height: 45,
                                width: 45,
                                child: FittedBox(
                                  child: FloatingActionButton(
                                    heroTag: null,
                                    onPressed: () {
                                      controller.scrollControllerUpToTop
                                          .animateTo(
                                              0,
                                              duration:
                                                  const Duration(seconds: 1),
                                              curve: Curves.fastOutSlowIn);
                                    },
                                    backgroundColor: AppColors.linkText(),
                                    child: const Icon(
                                      Icons.keyboard_arrow_up,
                                      size: AppDimens.sizeIconSpinner,
                                    ),
                                  ),
                                )),
                          ))
                      : null,
                ),
                // Positioned(
                //   top: position.value.dy,
                //   left: position.value.dx,
                //   child: Draggable(
                //     data: 1,
                //     feedback: BaseWidget.buildButtonIcon(
                //       sizeIcon: 30,
                //       icons: Icons.headset_off_rounded,
                //       iconColor: Colors.white,
                //       func: () {},
                //       colors: AppColors.colorRed444,
                //       title: '',
                //       imgAsset: AppStr.iconSup,
                //     ),
                //     childWhenDragging: Container(),
                //     onDraggableCanceled: (Velocity velocity, Offset offset) {
                //       position.value = offset;
                //       isDraging.value = false;
                //     },
                //     onDragStarted: () {
                //       isDraging.value = true;
                //     },
                //     onDragEnd: (drag) {
                //       isDraging.value = false;
                //     },
                //     child: Obx(
                //       () => Visibility(
                //         visible: isShowSupportCus?.value ?? false,
                //         child: Container(
                //           color: Colors.transparent,
                //           height: 65,
                //           child: BaseWidget.buildButtonIcon(
                //             sizeIcon: 30,
                //             icons: Icons.headset_mic,
                //             func: () {
                //               ShowPopup.openSupport();
                //             },
                //             colors: AppColors.orange,
                //             title: '',
                //             imgAsset: AppStr.iconSup,
                //           ),
                //         ).paddingOnly(right: AppDimens.paddingSmall),
                //       ),
                //     ),
                //   ),
                // ),
                // Container(
                //   height: 120,
                //   alignment: AlignmentDirectional.bottomCenter,
                //   child: Obx(
                //     () => Visibility(
                //       visible: isDraging.value,
                //       child: DragTarget(
                //         builder: (
                //           BuildContext context,
                //           List<dynamic> accepted,
                //           List<dynamic> rejected,
                //         ) {
                //           return Container(
                //             padding: const EdgeInsetsDirectional.only(
                //                 bottom: AppDimens.paddingHuge),
                //             child: CircleAvatar(
                //               backgroundColor: AppColors.hintTextColor(),
                //               child: const Icon(
                //                 Icons.close,
                //                 color: Colors.white,
                //               ),
                //             ),
                //           ).paddingOnly(bottom: 20);
                //         },
                //         onAccept: (data) {
                //           isShowSupportCus?.value = false;
                //         },
                //       ),
                //     ),
                //   ),
                // ),
              ],
            )),
        miniumBottom: miniumBottom,
        color: statusBarColor,
      ),
    );
  }
}
