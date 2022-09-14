import 'dart:convert';

import 'package:easy_invoice_qlhd/features/home/home_controller.dart';
import 'package:easy_invoice_qlhd/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../features/invoice_detail/invoice_detail.dart';
import '../../features/product/model/product_extra.dart';

Widget buildExtra(
  HomeController homeController,
  ProductItem item,
) {
  if (item.extra == null || item.extra.toString() == "{}") {
    return Container();
  }
  return ListView.builder(
    physics: const NeverScrollableScrollPhysics(),
    shrinkWrap: true,
    itemBuilder: (context, index) {
      return buildInvExtraResponeViewItem(
        homeController,
        index,
        item.extra,
      );
    },
    itemCount: homeController.extraInfoRespone.data?.first.proExtra?.length,
  );
}

Widget buildInvExtraResponeViewItem(
  HomeController homeController,
  int index,
  dynamic extra,
) {
  String? _val = List<ProductExtra>.from(
          jsonDecode(extra).map((x) => ProductExtra.fromJson(x)))[index]
      .value;
  return _val.isStringNotEmpty
      ? Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
              Text(
                (homeController.extraInfoRespone.data?.first.proExtra?[index]
                            .label ??
                        '') +
                    ": ",
                style: Get.textTheme.bodyText2,
              ),
              const SizedBox(width: 10),
              Text(
                extra.isNotEmpty
                    ? List<ProductExtra>.from(jsonDecode(extra)
                                .map((x) => ProductExtra.fromJson(x)))[index]
                            .value ??
                        ''
                    : '',
                style: Get.textTheme.bodyText1,
              )
            ]).paddingOnly(left: 2)
      : Container();
}
