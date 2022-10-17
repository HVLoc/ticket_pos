import 'package:flutter/material.dart';

class AppColors {
  static AppColors _singleton = AppColors._internal();

  factory AppColors() {
    return _singleton;
  }

  AppColors._internal();

  //Hàm để trong baseTheme phải truyền giá trị vào để phân biệt giao diện
  static Color accentColorTheme(bool isDark) =>
      isDark ? darkAccentColor : lightAccentColor;

  // Những biến sử dụng trong app phải đảm bảo màu cho 2 giao diện sáng/tối
  static bool _isDarkMode() => false;

  static Color textColor() => _isDarkMode() ? Colors.white : Colors.black;
  static Color textHomeColor() =>
      _isDarkMode() ? Colors.white : darkAccentColor;
  static Color errorText() => _isDarkMode() ? errorTextColor : Colors.redAccent;
  static Color errorTextHistory() =>
      _isDarkMode() ? errorTextColor : Colors.redAccent;
  static Color selectedInvoice() =>
      _isDarkMode() ? calendarIconColor : orangeSelected;
  static Color? selectedInvoicePressed() =>
      _isDarkMode() ? null : orangeSelected;

  static Color leftBarChart() =>
      _isDarkMode() ? Colors.white30 : darkAccentColor;
  static Color titleDataBarChart() =>
      _isDarkMode() ? Colors.white30 : bgKeyBoardbtn;
  static Color textReColor() => _isDarkMode() ? Colors.black : Colors.white;
  static Color hintTextColor() =>
      _isDarkMode() ? Colors.white54 : Colors.black54;
  static Color dialogInvExtend() =>
      _isDarkMode() ? darkAccentColor : Colors.white;
  static Color appBarColor() =>
      _isDarkMode() ? darkAccentColor : lightAccentColor;
  static Color keyBoardColor() =>
      _isDarkMode() ? darkAccentColor : const Color(0xFFff7e5f);
  static Color splashColor() => _isDarkMode() ? darkAccentColor : orange;
  static Color subTextColor() =>
      _isDarkMode() ? Colors.white54 : Colors.black87;
  static Color statusBarColor() =>
      _isDarkMode() ? darkAccentColor : colorBackgroundLight;
  static Color dateTimeColor() =>
      _isDarkMode() ? darkPrimaryColor : const Color(0xFFf7f7f7);
  static Color cardBackgroundColor() =>
      _isDarkMode() ? darkPrimaryColor : Colors.white;
  static Color linkText() => _isDarkMode() ? colorBlueAccent : orange;
  static Color invoiceStickyHead() => _isDarkMode() ? colorBlueB1FF : orange;
  static Color cardBackgroundOrange() =>
      _isDarkMode() ? backgroundColor : const Color(0xffFF772E);
  static Color cardBorderColor() =>
      _isDarkMode() ? darkAccentColor : Colors.white70;
  static Color? dividerColor() => _isDarkMode() ? null : darkAccentColor;
  static Color cardColors() => _isDarkMode() ? cardColor : Colors.white;
  static Color iconHomeSelectColor() =>
      _isDarkMode() ? Colors.white : darkAccentColor;
  static Color backgroundHomeColor() =>
      _isDarkMode() ? darkAccentColor : Colors.white;
  static Color slideActionColor() =>
      _isDarkMode() ? darkAccentColor : bgSlideColorLight;
  static Color iconHomeColor() => _isDarkMode() ? Colors.white54 : Colors.grey;
  static Color inputText() =>
      _isDarkMode() ? darkPrimaryColor : lightAccentColor;
  static Color inputTextBottomSheet() =>
      _isDarkMode() ? darkPrimaryColor : const Color(0xffefefef);
  static Color inputQuickInvoice() =>
      _isDarkMode() ? darkAccentColor : const Color(0xffefefef);
  static Color inputInvExtra() =>
      _isDarkMode() ? darkAccentColor : lightAccentColor;
  static Color inputTextWhite() =>
      _isDarkMode() ? darkPrimaryColor : Colors.white;
  static Color bgInputText() =>
      _isDarkMode() ? bgInputTextColor : lightAccentColor;
  static Color bottomSheet() => _isDarkMode() ? buttonColor : Colors.white;
  static Color primaryColor() =>
      _isDarkMode() ? darkPrimaryColor : Colors.white;
  static Color chipColorTheme() =>
      _isDarkMode() ? backgroundColor : orangeShade;
  static Color iconEmpty() => _isDarkMode() ? Colors.white30 : orangeShade;
  static Color appBarInvoice() => _isDarkMode() ? darkAccentColor : orange;
  static Color selectedChip() => _isDarkMode() ? backgroundSearchColor : orange;
  static Color titleBarChart() =>
      _isDarkMode() ? Colors.white30 : darkAccentColor;
  static Color barChart() => _isDarkMode() ? backgroundSearchColor : chipColor;
  static Color stickyHead() =>
      _isDarkMode() ? backgroundColor : lightAccentColor;
  static Color dateTimeHistory() =>
      _isDarkMode() ? backgroundColor : const Color(0x40f0eff2);
  static Color invoiceStatusWait() =>
      _isDarkMode() ? const Color(0x6688c6ed) : const Color(0xff088aec);
  static Color invoiceStatusNewly() =>
      _isDarkMode() ? const Color(0x6682c341) : const Color(0xff44aca0);
  static Color invoiceStatusPublished() =>
      _isDarkMode() ? const Color(0x66009f75) : const Color(0xff34a853);
  static Color invoiceStatusTaxDeclared() =>
      _isDarkMode() ? const Color(0x66394BA0) : const Color(0xff394BA0);
  static Color invoiceStatusReplaced() =>
      _isDarkMode() ? const Color(0x80EF4444) : const Color(0xffEF4444);
  static Color invoiceStatusHandle() =>
      _isDarkMode() ? Colors.purple.shade300 : const Color(0xFFfd754a);
  static Color invoiceStatusCanceled() =>
      _isDarkMode() ? const Color(0x80EF4444) : const Color(0xffe73526);
  static Color invoiceStatusApproved() =>
      _isDarkMode() ? const Color(0xffD54799) : const Color(0xff690fbb);
  static Color invoiceList() => _isDarkMode() ? bgInputTextColor : Colors.white;
  static Color textSearchInvProfile() =>
      _isDarkMode() ? Colors.white : Colors.indigo.shade700;
  static Color borderColor() => _isDarkMode() ? darkAccentColor : Colors.white;
  static Color statusBarInvoice() => _isDarkMode() ? darkAccentColor : orange;

  static Color selectedProduct() =>
      _isDarkMode() ? calendarIconColor : const Color(0x77f88754);
  static Color spinboxColor() => _isDarkMode() ? Colors.white : chipColor;
  static Color invoiceListOver() =>
      _isDarkMode() ? Colors.redAccent : Colors.white;
  static Color borderCard() =>
      _isDarkMode() ? Colors.transparent : prefixIconColor;
  static Color noSerialCert() =>
      _isDarkMode() ? chipColor : const Color(0xff1390e5);

  static List<Color> searchInvoice() =>
      _isDarkMode() ? colorGradientOrange : [Colors.white, Colors.white];
  static List<Color> barChartEmpty() =>
      _isDarkMode() ? colorGradientGrey : colorGradientGrey;
  static List<Color> barChartData() =>
      _isDarkMode() ? colorGradientBlue : colorGradientIconHome;
  static List<Color> barReChartData() =>
      _isDarkMode() ? colorGradientIconHome : colorGradientBlue;
  static List<Color> removeFilter() =>
      _isDarkMode() ? colorGradientGray : colorGradientGrey;

  // for Light Theme
  static const lightPrimaryColor = Color(0xFFeff6ff);
  static const lightAccentColor = Color(0xFFf0eff2);
  static const stickyHeadLight = Color(0xFFffffff);

  // for Light Theme
  static const darkPrimaryColor = Color(0xFF3e4161);
  static const darkAccentColor = Color(0xFF25273f);

  static const Color colorLoading = Color(0xFF58a0ff);
  static const Color colorBackgroundLight = Color(0xFFf7f7f7);
  static const Color chipDisable = Color(0xFFefefef);
  static const Color orange = Color(0xFFe2530c);
  static const Color orangeShade = Color(0xFFfee0d6);

  // static const Color textColor = Colors.white;
  static const Color backgroundSearchColor = Color(0xFF596AFE);
  static const Color bgSlideColorLight = Color(0xFFf9f9f9);
  static const Color errorTextLogin = Colors.white;
  static const Color cardColor = Color(0xFF414465);
  static const Color systemIconColor = Color(0xFF77EDFE);
  static const Color calendarIconColor = Color(0xFF464E88);
  static const Color calendarIconColord = Color(0xFF281F1C);
  static const Color appBarColor1 = Color(0xFF333754);
  static const Color buttonColor = Color(0xFF25273f);
  static const Color buttonColor2 = Color(0xFF3FFFF);
  static const Color backgroundColor = Color(0xFF333753);
  static const Color bgInputTextColor = Color(0xFF3e4161);
  static const Color bgHighLight = Color(0x60FFFFFF);
  static const Color bgKeyBoard = Color(0xFF1f212d);
  static const Color bgKeyBoardbtn = Color(0xFF65686f);

  static const Color errorTextColor = Color(0xFFFFD54F);
  static const Color textColorWhite = Colors.white;
  // static const Color hintTextColor = Colors.white30;
  static const Color hintTextSolidColor = Color(0xCCFFFFFF);
  static final Color prefixIconColor = Colors.grey.shade500;
  static const Color prefixIconLogin = Colors.white;
  static const Color bgItemColor = Color(0xFF9ca4bc);
  static const Color textColorDefault = Color(0xFF111111);
  static const Color chipColor = Color(0xfff36f21);
  static const Color colorBlue67ff = Color(0xFF5967ff);
  static const Color colorBlueAccent = Colors.blueAccent;
  static const Color titleText = Colors.white54;
  static const Color colorShowCaseIcon = Colors.white;
  static const Color colorShowCaseText = Colors.white;
  static const Color colorBackgroundShowCase = Colors.white30;
  static const Color colorError = Color(0xFFff5f6d);

  static const Color textColorIncrease = Color(0xFF06beb6);
  static const Color textColorDecrease = Color(0xFFd66d75);
  static const Color colorInvoicesReplaced = Color(0xffecbb00);
  static const Color orangeSelected = Color(0xFFff7e5f);
  static const Color colorInvoicesAdjust = Color(0xFFff7e5f);
  static const Color colorGreenLight = Color(0xFF82c341);
  static const Color colorRed444 = Color(0xccEF4444);
  static const Color colorBlueB1FF = Color(0xE682B1FF);

  static Color colorInvoicesReplace = const Color(0xffffd751);
  static Color colorInvoicesAdjusted = orangeSelected;

  static const List<Color> colorGradientOrange = [
    Color(0xFFff7e5f),
    Color(0xFFff5f6d),
  ];

  static const List<Color> colorGradientBlue = [
    Color(0xFF58a0ff),
    Color(0xFF5967ff),
  ];
  static const List<Color> colorGradientBlueLogin = [
    Color(0xFF5967ff),
    Color(0xFF596AFE),
  ];
  static const List<Color> colorGradientBlack = [
    Colors.black,
    Colors.black87,
  ];
  static const List<Color> colorGradientGrey = [
    Color(0xFF9ca4bc),
    Color(0xFF9ca4bc)
  ];

  static const List<Color> colorGradientGray = [
    Color(0x20FFFFFF),
    Color(0x20FFFFFF),
  ];

  static const List<List<Color>> colorGradientList = [
    [Color(0xFFD4145A), Color(0xFFFBB03B)],
    [Color(0xFF4568dc), Color(0xFFb06ab3)],
    [Color(0xFF588be5), Color(0xFF3ac9dd)],
  ];
  static const List<Color> colorPieDashboard = [
    Color(0xFF2697fe),
    Color(0xffbf5efe),
    Color(0xFF19eaaa),
    Color(0xFFffcf27),
    Color(0xFFff6057),
  ];

  static const List<Color> colorStatusHistoryTitle = [
    Color(0xFF03A9F4),
    Color(0xFFff6057),
    Color(0xFF8DBD26),
  ];

  static const List<Color> colorGradientIconHome = [
    Color(0xFFfd754a),
    Color(0xFFfd8058),
  ];
}
