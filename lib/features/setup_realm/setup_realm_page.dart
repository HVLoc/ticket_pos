import 'package:easy_invoice_qlhd/features/setup_realm/setup_realm.dart';
import 'package:easy_invoice_qlhd/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';
import '../../application/app.dart';
import '../../base/base.dart';
import '../../const/all_const.dart';
import 'model/introduction_setting_model.dart';
part 'setup_realm_widget.dart';
part 'coach_ticket_widget.dart';
part 'bus_ticket_widget.dart';
part 'parking_ticket_widget.dart';
part 'game_ticket_widget.dart';
part 'custom_ticket_widget.dart';
part 'config_widget.dart';
part 'setting_widget.dart';

class SetupRealmPage extends BaseGetWidget<SetupRealmController> {
  @override
  SetupRealmController get controller => Get.put(SetupRealmControllerImp());
  @override
  Widget buildWidgets() {
    return Scaffold(
      //extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Obx(
          () => Text(
            _buildTitle(controller).toString().toUpperCase(),
            style: Get.textTheme.bodyText1,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        //elevation: 6,
        automaticallyImplyLeading: false,
      ),
      body: Obx(
        () => Column(
          //crossAxisAlignment: CrossAxisAlignment.center,
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildDotStepper(controller),
            Expanded(
              child: SingleChildScrollView(
                child: _viewCenterPage(controller)
                    .marginSymmetric(vertical: AppDimens.paddingSmall),
              ),
            ),
            _buildButton(controller),
          ],
        ),
      ),
    );
  }
}
