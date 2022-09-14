import 'package:dio/dio.dart';
import 'package:easy_invoice_qlhd/base/base.dart';
import 'package:easy_invoice_qlhd/const/all_const.dart';
import 'package:easy_invoice_qlhd/utils/utils.dart';
import 'package:get/get.dart';

import '../search_invoice/model/invoice_model.dart';

class SearchInvoiceRepository extends BaseRepository {
  SearchInvoiceRepository(BaseGetxController controller) : super(controller);

  Future<List<int>> downloadWithQrCode(String code) async {
    var response = await baseSendRquest('', RequestMethod.GET,
        urlOther: AppConst.urlSearchInvoiceByQr,
        jsonMap: {'qrCode': code},
        isDownload: true, functionError: (error) {
      if (error is DioError) {
        if (error.type == DioErrorType.other) {
          ShowPopup.showErrorMessage(AppStr.errorConnectFailedStr.tr);
        } else {
          controller.showSnackBar(
            AppStr.profileSearchInvoiceError.tr,
            duration: 5.seconds,
          );
        }
      }
      return 1;
    });

    return response;
  }

  Future<List<int>> downloadFileWithFkey(
      SearchInvoiceModel invoiceModel) async {
    var response = await baseSendRquest('', RequestMethod.GET,
        urlOther: AppConst.urlSearchInvoicebyKey,
        jsonMap: invoiceModel.toJson(),
        isDownload: true, functionError: (error) {
      if (error is DioError) {
        if (error.type == DioErrorType.other) {
          ShowPopup.showErrorMessage(AppStr.errorConnectFailedStr.tr);
        } else {
          controller.showSnackBar(
            AppStr.profileSearchInvoiceError.tr,
            duration: 5.seconds,
          );
        }
      }
      return 1;
    });

    return response;
  }
}
