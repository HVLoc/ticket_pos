import 'package:easy_invoice_qlhd/base/base.dart';
import 'package:easy_invoice_qlhd/const/all_const.dart';
import 'package:easy_invoice_qlhd/features/invoice/model/invoice_list_response.dart';
import 'package:easy_invoice_qlhd/features/invoice_detail/invoice_detail.dart';

class InvoiceDetailRepository extends BaseRepository {
  InvoiceDetailRepository(BaseGetxController controller) : super(controller);

  /// Lấy thông tin chi tiết hóa đơn
  Future<InvoiceDetailResponse> getInvoiceDetail(
      InvoiceList invoiceList) async {
    var jsonMap = {
      "id": invoiceList.id,
      "pattern": invoiceList.pattern,
      "Ikey": invoiceList.ikey,
    };
    var response = await baseSendRquest(
        AppConst.urlInvoiceDetail, RequestMethod.POST,
        jsonMap: jsonMap);
    return InvoiceDetailResponse.fromJson(response);
  }

  ///	Hủy bỏ hóa đơn (ký server)
  Future<BaseResponse> cancelInvoice(
      InvoiceDetailModel invoiceDetailModel) async {
    var jsonMap = {
      "Pattern": invoiceDetailModel.invoicePattern,
      "Serial": invoiceDetailModel.serialNo,
      "Ikey": invoiceDetailModel.ikey
    };
    var res = await baseSendRquest(
        AppConst.urlCancelInvoice, RequestMethod.POST,
        jsonMap: jsonMap);
    return BaseResponse.fromJson(res);
  }
}
