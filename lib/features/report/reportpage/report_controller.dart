import 'dart:convert';

import 'package:easy_invoice_qlhd/application/app.dart';
import 'package:easy_invoice_qlhd/base/base.dart';
import 'package:easy_invoice_qlhd/const/all_const.dart';
import 'package:easy_invoice_qlhd/features/report/access_crm/access_crm_repository.dart';
import 'package:easy_invoice_qlhd/features/report/access_crm/access_crn_respone.dart';
import 'package:easy_invoice_qlhd/features/report/screenshot/screenShot_model.dart';
import 'package:easy_invoice_qlhd/features/report/screenshot/screenShot_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ReportController extends BaseGetxController {
  TextEditingController inputTextReport = TextEditingController();
  FeedbackRequest feedback = FeedbackRequest();
  late SendFeedbackImgRepo sendFeedbackImgRepo;
  late AccessCRMRepository accessCRMRepository;
  AccessCrmResponeData? accessCrmResponeData;
  String? base64Img;

  ReportController() {
    this.sendFeedbackImgRepo = SendFeedbackImgRepo(this);
    this.accessCRMRepository = AccessCRMRepository(this);
  }
  @override
  void onInit() {
    base64Img = base64Encode(Get.arguments);
    getTokenCRM();
    super.onInit();
  }

  Future<void> addFeedbackInfo() async {
    feedback.taxcode = HIVE_APP.get(AppConst.keyTaxCodeCompany);
    feedback.customerName = HIVE_APP.get(AppConst.keyComName);
    feedback.fileFeedback = base64Img;
    feedback.content = inputTextReport.text;
  }

  void sendFeedBack() {
    addFeedbackInfo();
    sendFeedbackImgRepo
        .sendFeedback(feedback, accessCrmResponeData!)
        .then((value) {
      value.status == 1
          ? {Get.close(2), showSnackBar(value.message ?? '')}
          : showSnackBar(value.message ?? '');
    });
  }

  void getTokenCRM() {
    accessCRMRepository.accessTOCRM().then((value) {
      accessCrmResponeData = value.data;
    });
  }
}
