import 'dart:io';

import 'package:get/get.dart';

class AppDimens {
  static double fontSize10() => 10.divSF;
  static double fontSmallest() => 12.divSF;
  static double fontSmall() => 14.divSF;
  static double fontMedium() => 16.divSF;
  static double fontBig() => 18.divSF;
  static double fontBiggest() => 20.divSF;
  static double fontSize24() => 24.divSF;

  static const double sizeImage = 50;
  static const double sizeImageMedium = 70;
  static const double sizeImageBig = 90;
  static const double sizeImageLarge = 200;

  static const double sizeTextSmall = 12;
  static const double btnSmall = 20;
  static const double btnMedium = 50;
  static const double btnLarge = 70;

  static const double sizeIcon = 20;
  static const double sizeIconMedium = 24;
  static const double sizeIconSpinner = 30;
  static const double sizeIconLarge = 36;
  static const double sizeIconExtraLarge = 200;
  static const double sizeDialogNotiIcon = 40;

  static const double heightChip = 30;
  static const double widthChip = 100;

  static const int maxLengthDescription = 250;

  static const double defaultPadding = 16.0;
  static const double paddingVerySmall = 8.0;
  static const double paddingSmall = 12.0;
  static const double paddingMedium = 20.0;
  static const double paddingHuge = 32.0;
  static const double paddingItemList = 18.0;

  static const double showAppBarDetails = 200;
  static const double sizeAppBarBig = 120;
  static const double sizeAppBarMedium = 92;
  static const double sizeAppBar = 72;
  static const double sizeAppBarSmall = 44;

  // radiusBorder
  static const double radius8 = 8;
  static const double radius20 = 20;

  // home
  static const double sizeItemNewsHome = 110;
  static const double heightImageLogoHome = 50;
  // divider
  static const double paddingDivider = 15.0;

  // appbar
  static const double paddingSearchBarBig = 50;
  static const double paddingSearchBar = 45;
  static const double paddingSearchBarMedium = 30;
  static const double paddingSearchBarSmall = 10;

  //other
  static const double paddingTitleAndTextForm = 3;
  static double bottomPadding() {
    return Platform.isIOS ? AppDimens.paddingMedium : AppDimens.paddingSmall;
  }
}

extension GetSizeScreen on num {
  /// Tỉ lệ fontSize của các textStyle
  double get divSF {
    return this / Get.textScaleFactor;
  }

  // Tăng chiều dài theo font size
  double get mulSF {
    return this * Get.textScaleFactor;
  }
}
