import 'package:flutter/material.dart';

import 'all_const.dart';

class AppStyle {
  static final TextStyle textStyleDefault =
      TextStyle(color: AppColors.textColor(), fontSize: AppDimens.fontMedium());
  static final TextStyle textHintStyle = TextStyle(
      color: AppColors.prefixIconColor, fontSize: AppDimens.fontMedium());
  static final TextStyle textTitleStyle =
      _textTitleStyle(AppDimens.fontBiggest());
  static final TextStyle textTitleMediumStyle =
      _textTitleStyle(AppDimens.fontBig());
  static final TextStyle textSubTitleStyle =
      _textTitleStyle(AppDimens.fontMedium());
  static final TextStyle textTitleWhiteStyle =
      _textTitleStyle(AppDimens.fontBiggest(), color: AppColors.textColor());
  static TextStyle _textTitleStyle(double fontSize,
      {Color color = Colors.white}) {
    return TextStyle(
        fontWeight: FontWeight.bold, color: color, fontSize: fontSize);
  }
}
