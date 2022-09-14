import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_invoice_qlhd/features/setup_realm/setup_realm.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../base/base.dart';
import '../../const/all_const.dart';
import '../change_account/change_account.dart';

class ConfigPrinterPage extends BaseGetWidget<SetupRealmController> {
  @override
  Widget buildWidgets() {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cấu hình vé in"),
      ),
      body: Center(
        child: TextButton(
          onPressed: () {
            Get.to(() => ChangeAccPage());
          },
          child: const AutoSizeText(
            AppStr.next,
          ),
        ),
      ),
    );
  }
}
