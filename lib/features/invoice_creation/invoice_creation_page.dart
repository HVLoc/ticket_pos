import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_invoice_qlhd/base/base.dart';
import 'package:easy_invoice_qlhd/const/all_const.dart';
import 'package:easy_invoice_qlhd/features/invoice_creation/invoice_creation.dart';
import 'package:easy_invoice_qlhd/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../application/app.dart';

part 'invoice_creation_widget.dart';

class InvoiceCreationPage extends BaseGetWidget<InvoiceCreationController> {
  @override
  InvoiceCreationController get controller =>
      Get.put(InvoiceCreationControllerImp());
  @override
  Widget buildWidgets() {
    return Obx(
      () => BaseWidget.buildSafeArea(
        Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: Get.arguments ?? true,
                backgroundColor: Colors.transparent,
                title: GestureDetector(
                  onTap: () {
                    controller.scrollController
                      ..animateTo(
                        0.0,
                        curve: Curves.easeOut,
                        duration: const Duration(milliseconds: 300),
                      );
                  },
                  child: BaseWidget.buildAppBarTitle(
                    AppStr.profileIssue,
                  ),
                ),
                centerTitle: true,
                actions: [
                  // TextButton(
                  //   onPressed: controller.isCreateOrEditInvoice()
                  //       ? controller.showDateTimePicker
                  //       : null,
                  //   child: Obx(() => Text(
                  //         convertDateToString(
                  //             controller.dateTime.value, PATTERN_1),
                  //         style: Get.textTheme.subtitle1!.copyWith(
                  //             color: controller.isCreateOrEditInvoice()
                  //                 ? AppColors.linkText()
                  //                 : AppColors.hintTextColor(),
                  //             fontWeight: FontWeight.bold),
                  //       )),
                  // )
                ],
              ),
              body: buildLoadingOverlay(
                () => Column(
                  children: [
                    Expanded(
                      child: listProduct(controller),
                    ),
                    // Obx(
                    //   () => Visibility(
                    //     visible: controller.isVisibleBtn.value,
                    //     child: buildBtn(controller),
                    //   ),
                    // ),
                  ],
                ),
              ),
              bottomNavigationBar: buildBtn(controller),
            ),
          ],
        ),
      ),
    );
  }
}
