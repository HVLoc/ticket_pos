import 'package:easy_invoice_qlhd/const/all_const.dart';
import 'package:easy_invoice_qlhd/utils/widgets/base_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ItemUtils {
  static Widget itemLine({
    required String title,
    Function()? func,
    bool hasLeadingBg = false,
    IconData? leading,
    Widget? trailing = const Icon(
      Icons.chevron_right,
      size: 25,
      color: Colors.black,
    ),
    Widget? subtitle,
    List<Color>? iconColors,
    String? imgAsset,
  }) {
    return BaseWidget.baseOnAction(
      onTap: func ?? () {},
      child: Ink(
        child: ListTile(
          leading: SizedBox(
            width: 35,
            height: 35,
            child: leading != null
                ? Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(120))),
                    padding: const EdgeInsets.all(10),
                    child: iconColors != null
                        ? Icon(leading, color: Colors.blue,)
                        //     // ShaderMask(
                        //     //     blendMode: BlendMode.srcIn,
                        //     //     shaderCallback: (Rect bounds) {
                        //     //       return ui.Gradient.linear(
                        //     //         const Offset(4.0, 24.0),
                        //     //         const Offset(24.0, 4.0),
                        //     //         iconColors,
                        //     //       );
                        //     //     },
                        //     //     child: Icon(leading))
                        : Icon(leading, color: AppColors.textColor()))
                : Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(120)),
                      border: Border.all(
                        color: Colors.grey.shade700,
                        width: 0.2,
                      ),
                    ),
                    child: Image.asset(
                      imgAsset ?? AppStr.iconSDS,
                    ),
                  ),
          ),
          title: Text(
            title,
            style:
                Get.textTheme.bodyText2!.copyWith(color: AppColors.textColor()),
          ),
          subtitle: subtitle,
          trailing: trailing,
        ),
      ),
    );
  }

  static Widget buildDivider({double height = 1.0}) {
    return Container(
      color: Get.theme.cardColor,
      height: 0,
      width: Get.width,
      child: Divider(
        thickness: height,
        indent: 20,
        endIndent: 20,
      ),
    );
  }

  static Widget partItem({
    required IconData icons,
    required String title,
    required Color color,
    int flex = 1,
  }) {
    return Expanded(
      flex: flex,
      child: Row(
        children: [
          Expanded(
              child: Icon(
            icons,
            color: color,
          )),
          Expanded(
              flex: 4,
              child: Text(title,
                  style: Get.textTheme.subtitle1!.copyWith(color: color))),
        ],
      ),
    );
  }
}
