import 'package:easy_invoice_qlhd/base/base.dart';
import 'package:easy_invoice_qlhd/const/all_const.dart';
import 'package:easy_invoice_qlhd/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'reportpage/report_controller.dart';

class FeedbackPage extends BaseGetWidget<ReportController> {
  @override
  ReportController get controller => Get.put(ReportController());
  @override
  Widget buildWidgets() {
    return Scaffold(
      appBar: AppBar(
        title: BaseWidget.buildAppBarTitle(
          AppStr.report,
        ),
        actions: [
          Center(
            child: BaseWidget.baseOnAction(
                onTap: () {
                  controller.sendFeedBack();
                },
                child: Text(AppStr.send,
                        style: Get.textTheme.button!
                            .copyWith(color: AppColors.linkText()))
                    .paddingOnly(
                  right: 20,
                )),
          )
        ],
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: AppColors.textColorWhite,
                height: Get.height / 3,
                child: Image.memory(
                  Get.arguments,
                  fit: BoxFit.scaleDown,
                ).paddingAll(5),
              ),
              BaseWidget.sizedBox10,
              Container(
                constraints: const BoxConstraints(maxHeight: 200),
                child: SingleChildScrollView(
                  child: BuildInputText(InputTextModel(
                    textInputType: TextInputType.text,
                    controller: controller.inputTextReport,
                    fillColor: AppColors.inputTextWhite(),
                    maxLines: 5,
                    hintText: AppStr.reportSendHint,
                    hintTextColor: AppColors.hintTextColor(),
                    currentNode: FocusNode()..requestFocus(),
                  )..isShowCounterText = false)
                      .paddingSymmetric(horizontal: AppDimens.paddingVerySmall),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
