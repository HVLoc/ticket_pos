import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_invoice_qlhd/features/setup_realm/setup_realm.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../base/base.dart';
import '../../const/all_const.dart';
import '../config_printer/config_printer.dart';

class SetupSessionPage extends BaseGetWidget<SetupRealmController> {
  @override
  Widget buildWidgets() {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cài đặt phiên làm việc"),
      ),
      body: Center(
        child: TextButton(
          onPressed: () {
            Get.to(() => ConfigPrinterPage());
          },
          child: const AutoSizeText(
            AppStr.next,
          ),
        ),
      ),
    );
  }
}
