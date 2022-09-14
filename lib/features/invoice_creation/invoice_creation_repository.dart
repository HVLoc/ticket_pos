import 'package:dio/dio.dart';
import 'package:easy_invoice_qlhd/base/base.dart';
import 'package:easy_invoice_qlhd/const/all_const.dart';
import 'package:easy_invoice_qlhd/utils/utils.dart';

import 'invoice_creation.dart';

class InvoiceCreationRepository extends BaseRepository {
  InvoiceCreationRepository(BaseGetxController controller) : super(controller);

  ///	Tạo hóa đơn (bản nháp, chưa ký số, chưa có số hóa đơn)
  Future<BaseResponse> importInvoice(
      InvoiceCreationRequest invoiceCreationRequest) async {
    var res = await baseSendRquest(
        AppConst.urlPublishImportInvoice, RequestMethod.POST,
        jsonMap: invoiceCreationRequest.toJson());
    return BaseResponse.fromJson(res);
  }

  ///	Tạo và phát hành hóa đơn (ký server)
  Future<BaseResponse> importAndIssueInvoice(
      InvoiceCreationRequest invoiceCreationRequest) async {
    var res = await baseSendRquest(
        AppConst.urlPublishImportAndIssueInvoice, RequestMethod.POST,
        jsonMap: invoiceCreationRequest.toJson());
    return BaseResponse.fromJson(
      res,
      isInvoice: true,
    );
  }

  ///	Điều chỉnh hóa đơn
  /// `url`: url api điều chỉnh ký server hoặc bản nháp
  Future<BaseResponse> adjustInvoice(
    InvoiceHandleReplaceRequest invoiceHanldeReplaceRequest,
    String url,
  ) async {
    var res = await baseSendRquest(url, RequestMethod.POST,
        jsonMap: invoiceHanldeReplaceRequest.toJson());
    return BaseResponse.fromJson(res);
  }

  ///	Thay thế hóa đơn
  /// `url`: url api thay thế ký server hoặc bản nháp
  Future<BaseResponse> replaceInvoice(
    InvoiceHandleReplaceRequest invoiceHandleReplaceRequest,
    String url,
  ) async {
    var res = await baseSendRquest(url, RequestMethod.POST,
        jsonMap: invoiceHandleReplaceRequest.toJson());
    return BaseResponse.fromJson(res);
  }

  Future<dynamic> searchTaxCode(String taxCode) async {
    var response = await baseSendRquest("", RequestMethod.GET,
        headersUrlOther: {"Authorization": "easyinvoice@sds@123"},
        urlOther: AppConst.checkTaxCode,
        jsonMap: {"taxCode": taxCode},
        dioOptions: BaseOptions()
          ..connectTimeout = 5000
          ..receiveTimeout = 5000, functionError: (error) {
      if (error is DioError) {
        if (error.type == DioErrorType.other) {
          ShowPopup.showErrorMessage(AppStr.errorConnectFailedStr);
        } else {
          controller.showSnackBar(AppStr.customerErrorTaxCode);
        }
      }
      return 1;
    });
    return response;
  }
}
