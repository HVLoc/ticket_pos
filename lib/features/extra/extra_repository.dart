import 'package:easy_invoice_qlhd/base/base.dart';
import 'package:easy_invoice_qlhd/const/all_const.dart';
import 'package:easy_invoice_qlhd/features/extra/extra_respone.dart';

class ExtraRepository extends BaseRepository {
  ExtraRepository(BaseGetxController controller) : super(controller);

  Future<ExtraInfoRespone> getExtraInfo() async {
    var response = await baseSendRquest(
      AppConst.urlExtraInfo,
      RequestMethod.POST,
    );
    return ExtraInfoRespone.fromJson(response);
  }
}
