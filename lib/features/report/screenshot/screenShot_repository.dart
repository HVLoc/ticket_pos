import 'package:easy_invoice_qlhd/base/base.dart';
import 'package:easy_invoice_qlhd/const/all_const.dart';
import 'package:easy_invoice_qlhd/features/report/access_crm/access_crn_respone.dart';
import 'package:easy_invoice_qlhd/features/report/reportpage/feedback_respone.dart';
import 'package:easy_invoice_qlhd/features/report/screenshot/screenShot_model.dart';

class SendFeedbackImgRepo extends BaseRepository {
  SendFeedbackImgRepo(BaseGetxController controller) : super(controller);

  Future<FeedbackRespone> sendFeedback(FeedbackRequest feedbackRequest,
      AccessCrmResponeData accessCrmResponeData) async {
    var res = await baseSendRquest(
      '',
      RequestMethod.POST,
      urlOther: AppConst.sendFeedback,
      jsonMap: feedbackRequest.toJson(),
      headersUrlOther: {
        "Authorization": accessCrmResponeData.token ?? '',
      },
    );
    return FeedbackRespone.fromJson(res);
  }
}
