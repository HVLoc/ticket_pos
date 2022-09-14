import 'dart:convert';

import 'package:easy_invoice_qlhd/const/all_const.dart';

BaseRequestListModel productRequestFromJson(String str) =>
    BaseRequestListModel.fromJson(json.decode(str));

String productRequestToJson(BaseRequestListModel data) =>
    json.encode(data.toJson());

class BaseRequestListModel {
  BaseRequestListModel({
    required this.key,
    required this.page,
    this.pagesize = AppConst.pageSize,
  });

  String key;
  int page;
  int pagesize = AppConst.pageSize;

  factory BaseRequestListModel.fromJson(Map<String, dynamic> json) =>
      BaseRequestListModel(
        key: json["key"],
        page: json["page"],
        pagesize: json["pagesize"],
      );

  Map<String, dynamic> toJson() => {
        "key": key,
        "page": page,
        "pagesize": pagesize,
      };
}
