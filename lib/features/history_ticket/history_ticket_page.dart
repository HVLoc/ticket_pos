import 'package:easy_invoice_qlhd/base/base.dart';
import 'package:easy_invoice_qlhd/features/history_ticket/controller/history_ticket_controller.dart';
import 'package:easy_invoice_qlhd/features/history_ticket/controller/history_ticket_coontroller_imp.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../const/all_const.dart';
import '../../utils/utils.dart';

part 'history_ticket_widget.dart';

class HistoryTicket extends BaseGetWidget<HistoryTicketController> {
  @override
  HistoryTicketControllerImp get controller =>
      Get.put(HistoryTicketControllerImp());
  @override
  Widget buildWidgets() {
    return _buildEmptyPage();
  }

  Widget _buildEmptyPage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppStr.dataEmpty,
          style: Get.textTheme.titleLarge!
              .copyWith(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        BaseWidget.sizedBox10,
        Text('ノへ￣、',
            style: Get.textTheme.titleSmall!
                .copyWith(color: Colors.black, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
