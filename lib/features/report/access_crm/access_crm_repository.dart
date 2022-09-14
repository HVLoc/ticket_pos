import 'package:easy_invoice_qlhd/base/base.dart';
import 'package:easy_invoice_qlhd/const/all_const.dart';
import 'package:easy_invoice_qlhd/features/report/access_crm/access_crn_respone.dart';

class AccessCRMRepository extends BaseRepository {
  AccessCRMRepository(BaseGetxController controller) : super(controller);
  
  Future<AccessCrmRespone> accessTOCRM() async {
    var res = await baseSendRquest('', RequestMethod.POST,
        urlOther: AppConst.accessToCRM,
        jsonMap: {"account": "mobile", "password": r"Sds#$2019"});
    return AccessCrmRespone.fromJson(res);
  }
}
