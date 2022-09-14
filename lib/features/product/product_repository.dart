import 'package:easy_invoice_qlhd/base/base.dart';
import 'package:easy_invoice_qlhd/const/all_const.dart';
import 'package:easy_invoice_qlhd/features/invoice_detail/invoice_detail.dart';

import 'product.dart';

class ProductRepository extends BaseRepository {
  ProductRepository(BaseGetxController controller) : super(controller);

  Future<ProductResponse> productSearch(
      BaseRequestListModel productRequest) async {
    var response = await baseSendRquest(
        AppConst.urlProductSearch, RequestMethod.POST,
        jsonMap: productRequest.toJson());
    return ProductResponse.fromJson(response);
  }

  Future<BaseResponse> updateProduct(String xmlData) async {
    var jsonMap = {
      "XmlData": xmlData,
    };
    var response = await baseSendRquest(
        AppConst.urlUpdateProduct, RequestMethod.POST,
        jsonMap: jsonMap);

    return BaseResponse.fromJson(response);
  }

  Future<DeleteResponse> deleteProduct(List<ProductItem> productItems) async {
    List<String> codes = [];
    codes.addAll(productItems.map((element) => element.code ?? '').toList());
    var jsonMap = {
      "productCode": codes.join(","),
    };
    var response = await baseSendRquest(
        AppConst.urlDeleteProduct, RequestMethod.POST,
        isQueryParametersPost: true, jsonMap: jsonMap);
    return DeleteResponse.fromJson(response);
  }
}
