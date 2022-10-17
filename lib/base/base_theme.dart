import 'package:easy_invoice_qlhd/const/all_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// [isDarkMode] hiện tại để 2 Theme dark và light
ThemeData getThemeByAppTheme([bool isDarkMode = true]) {
  ThemeData base = isDarkMode ? ThemeData.dark() : ThemeData.light();
  IconThemeData _buildIconTheme() {
    Color iconColor = isDarkMode ? Colors.white : Colors.black;

    return IconThemeData(
      color: iconColor,
      size: 20.0,
    );
  }

  AppBarTheme _buildAppBarTheme() {
    return base.appBarTheme.copyWith(
        elevation: 0.0,
        systemOverlayStyle: SystemUiOverlayStyle(
            systemNavigationBarColor: AppColors.appBarColor(),
            statusBarColor: AppColors.appBarColor(),
            statusBarBrightness:
                isDarkMode ? Brightness.dark : Brightness.light,
            statusBarIconBrightness:
                isDarkMode ? Brightness.dark : Brightness.light),
        color: AppColors.accentColorTheme(isDarkMode),
        iconTheme: _buildIconTheme());
  }

  TextTheme _basicTextTheme() {
    final TextTheme _textTheme = base.textTheme;

    Color textColor = isDarkMode ? Colors.white : Colors.black87;
    Color subTextColor = isDarkMode ? Colors.white54 : Colors.black54;
    return TextTheme(
      // headline
      headline1: _textTheme.headline1!.copyWith(
          fontSize: 36, fontWeight: FontWeight.bold, color: textColor),
      headline2: _textTheme.headline2!.copyWith(
          fontSize: 32, fontWeight: FontWeight.bold, color: textColor),
      headline3: _textTheme.headline3!.copyWith(
          fontSize: 26, fontWeight: FontWeight.bold, color: textColor),
      headline4: _textTheme.headline4!.copyWith(
          fontSize: 24, fontWeight: FontWeight.bold, color: textColor),
      headline5: _textTheme.headline5!.copyWith(fontSize: 22, color: textColor),
      headline6: _textTheme.headline6!.copyWith(fontSize: 20, color: textColor),
      // subtitle
      subtitle1: TextStyle(fontSize: 14, color: textColor),
      subtitle2:
          _textTheme.subtitle2!.copyWith(fontSize: 12, color: subTextColor),
      // body
      bodyText1: _textTheme.bodyText1!.copyWith(fontSize: 16, color: textColor),
      bodyText2:
          _textTheme.bodyText2!.copyWith(fontSize: 14, color: subTextColor),
      // caption - chú thích trong app
      caption: _textTheme.caption!.copyWith(fontSize: 12, color: textColor),
      // button
      button: _textTheme.button!.copyWith(fontSize: 14, color: textColor),
    ).apply(
      fontFamily: 'RobotoMono',
    );
  }

  return base.copyWith(
      // themes

      textTheme: _basicTextTheme(),
      iconTheme: _buildIconTheme(),
      appBarTheme: _buildAppBarTheme(),
      brightness: isDarkMode ? Brightness.dark : Brightness.light,
      bottomAppBarTheme: _buildBottomAppBarTheme(base),
      bottomSheetTheme: _buildBottomSheetTheme(base),
      tabBarTheme: base.tabBarTheme.copyWith(
        labelColor: isDarkMode ? AppColors.darkAccentColor : Colors.white60,
        unselectedLabelColor: AppColors.darkPrimaryColor,
      ),
      buttonTheme: _buildButtonTheme(base),
      cardTheme: _buildCardTheme(base, isDarkMode: isDarkMode),
      dialogTheme: _buildDialogTheme(base),
      // colors
      primaryColor: isDarkMode ? AppColors.cardColor : Colors.pink[50],
      indicatorColor: Colors.grey,
      textButtonTheme: _textButtonThemeData(base),
      scaffoldBackgroundColor: AppColors.accentColorTheme(isDarkMode),
      cardColor: isDarkMode ? AppColors.cardColor : Colors.pink[50],
      secondaryHeaderColor: isDarkMode ? AppColors.buttonColor2 : Colors.grey,
      backgroundColor: isDarkMode ? AppColors.backgroundColor : Colors.white54,
      dialogBackgroundColor: AppColors.darkPrimaryColor);
}

ButtonThemeData _buildButtonTheme(ThemeData base) {
  return base.buttonTheme.copyWith(
      height: 50,
      minWidth:
          5, // Them vao de context menu copy, paste tren Samsung khong bi soc vang
      buttonColor: AppColors.buttonColor,
      textTheme: ButtonTextTheme.accent,
      colorScheme: base.colorScheme
          .copyWith(primary: Colors.white, secondary: Colors.white),
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
      ));
}

TextButtonThemeData _textButtonThemeData(ThemeData base) {
  return TextButtonThemeData(
    style: ButtonStyle(
      textStyle: MaterialStateProperty.all(base.textTheme.subtitle1),
      overlayColor: MaterialStateProperty.all(Colors.white38),
    ),
  );
}

BottomAppBarTheme _buildBottomAppBarTheme(ThemeData base) {
  return base.bottomAppBarTheme.copyWith(color: Colors.white);
}

BottomSheetThemeData _buildBottomSheetTheme(ThemeData base) {
  return base.bottomSheetTheme.copyWith(
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(25.0)),
    ),
  );
}

CardTheme _buildCardTheme(ThemeData base, {bool isDarkMode = true}) {
  return base.cardTheme.copyWith(
      color: isDarkMode ? AppColors.darkPrimaryColor : Colors.grey[50],
      elevation: 0.0);
}

DialogTheme _buildDialogTheme(ThemeData base) {
  return base.dialogTheme
      .copyWith(backgroundColor: AppColors.cardBackgroundColor());
}
