import 'package:easy_invoice_qlhd/base/base.dart';
import 'package:easy_invoice_qlhd/const/all_const.dart';
import 'package:easy_invoice_qlhd/features/extra/extra_respone.dart';
import 'package:easy_invoice_qlhd/features/invoice/model/invoice_strip_response.dart';
import 'package:easy_invoice_qlhd/features/invoice_creation/model/bank_model.dart';
import 'login.dart';

class LoginRepository extends BaseRepository {
  LoginRepository(BaseGetxController controller) : super(controller);
  //Lấy domain của từng mst riêng để ký hóa đơn cho TT78, chỉ dùng ở prod
  Future<CompanyResponse> checkTaxCode(
    String taxCode,
    Function(Object error)? functionError,
  ) async {
    var response = await baseSendRquest(
      "",
      RequestMethod.GET,
      urlOther: AppConst.urlCheckTaxCode,
      jsonMap: {
        "taxcode": taxCode,
        "username": "Hieult",
        "password": "Lehieu@270495"
      },
      functionError: functionError,
    );
    return CompanyResponse.fromJson(response);
  }

  Future<LoginResponse> loginUser(LoginModel user) async {
    var response = await baseSendRquest(AppConst.urlLogin, RequestMethod.POST,
        jsonMap: user.toJson());
    return LoginResponse.fromJson(response);
  }

  Future<BankModel> getBank() async {
    var res = await baseSendRquest("", RequestMethod.GET,
        urlOther: AppConst.urlGetListBank);
    return BankModel.fromJson(res);
  }

  Future<List<InvoicePattern>> getInvoiceStrip() async {
    var invoiceStrip = await baseSendRquest(
        AppConst.urlInvoiceStrip, RequestMethod.POST,
        jsonMap: {"page": 1, "pageSize": 0, "status": 3});
    List<InvoicePattern> list = invoiceStrip != null
        ? List<InvoicePattern>.from(
            invoiceStrip.map((x) => InvoicePattern.fromJson(x)))
        : [];
    return _convertList(list);
  }

  Future<ExtraInfoRespone> getExtraInfo() async {
    // var response = await baseSendRquest(
    //   AppConst.urlExtraInfo,
    //   RequestMethod.POST,
    // );
    Map<String, dynamic> response = {
      "Status": 2,
      "Message": "Ok",
      "Data": [
        {
          "Pattern": "5C22TYY",
          "InvExtra": "[]",
          "ProExtra":
              "[{\"Label\":\"Số xe\",\"Name\":\"CarNo\",\"Visibility\":true}, \r\n{\"Label\":\"Số ghế\",\"Name\":\"seats\",\"Visibility\":true}]"
        },
      ],
      "ErrorCode": 0
    };
    return ExtraInfoRespone.fromJson(response);
  }

  List<InvoicePattern> _convertList(List<InvoicePattern> list) {
    // bỏ mẫu số ký hiệu chưa được chấp nhận, và mẫu phiếu xuất kho khỏi danh sách.
    list.removeWhere((element) =>
        element.status == 0 ||
        element.pattern.startsWith("03XKNB") ||
        element.pattern.startsWith("04HGDL") ||
        element.pattern.startsWith("6"));
    // sắp xếp theo thời gian, dải hóa đơn mua sau lên trước
    // list.sort((a, b) => convertDMYToTimeStamps(b.startDate, pattern: PATTERN_8)
    //     .compareTo(convertDMYToTimeStamps(a.startDate, pattern: PATTERN_8)));
    // sắp xếp list theo Serial
    // list.sort(
    //     (a, b) => a.serial.toLowerCase().compareTo(b.serial.toLowerCase()));
    // // sắp xếp list theo Pattern
    // list.sort(
    //     (a, b) => a.pattern.toLowerCase().compareTo(b.pattern.toLowerCase()));
    // list.forEach((element) {
    //   element.fromNo = list
    //       .lastWhere((findElement) =>
    //           element.pattern == findElement.pattern &&
    //           element.serial == findElement.serial)
    //       .fromNo;
    //   // element.status = list
    //   //     .lastWhere((findElement) =>
    //   //         element.pattern == findElement.pattern &&
    //   //         element.serial == findElement.serial)
    //   //     .status;
    //   element.startDate = list
    //       .lastWhere((findElement) =>
    //           element.pattern == findElement.pattern &&
    //           element.serial == findElement.serial)
    //       .startDate;
    // });
    return list;
  }
}
