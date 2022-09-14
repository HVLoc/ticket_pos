import 'dart:convert';

import 'package:easy_invoice_qlhd/features/invoice_detail/invoice_detail.dart';

ProductResponse productResponseFromJson(String str) =>
    ProductResponse.fromJson(json.decode(str));

String productResponseToJson(ProductResponse data) =>
    json.encode(data.toJson());

class ProductResponse {
  ProductResponse({
    required this.page,
    required this.pageSize,
    required this.totalRecords,
    required this.data,
  });

  late int page;
  late int pageSize;
  late int totalRecords;
  late List<ProductItem> data;

  factory ProductResponse.fromJson(Map<String, dynamic> json) =>
      ProductResponse(
        page: json["page"],
        pageSize: json["pageSize"],
        totalRecords: json["totalRecords"],
        data: json["data"] != null
            ? List<ProductItem>.from(
                json["data"].map((x) => ProductItem.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "page": page,
        "pageSize": pageSize,
        "totalRecords": totalRecords,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}
