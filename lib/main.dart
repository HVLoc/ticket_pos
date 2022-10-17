import 'package:easy_invoice_qlhd/features/change_account/change_account.dart';
import 'package:easy_invoice_qlhd/utils/translation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';

import 'application/app.dart';
import 'base/base.dart';
import 'const/all_const.dart';
import 'features/home/home_page.dart';
import 'features/invoice_creation/invoice_creation.dart';
import 'features/login/login.dart';
import 'features/qrcode/qr_code.dart';
import 'features/search_invoice/search_invoice.dart';
import 'features/setup_realm/setup_realm_page.dart';
import 'features/splash/splash_page.dart';
import 'features/ticket/ticket_page.dart';
import 'utils/utils.dart';

void main() {
  _init();
}

void _init() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(Application());
}

class Application extends StatefulWidget {
  @override
  _ApplicationState createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> {
  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //     systemNavigationBarColor: AppColors.statusBarColor(),
    //     statusBarColor: AppColors.statusBarColor(),
    //     statusBarBrightness: Brightness.dark,
    //     statusBarIconBrightness: Brightness.light));

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        systemNavigationBarColor: AppColors.darkAccentColor,
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light));
    SunmiPrinter.bindingPrinter().then((value) {
      canPrint = value ?? false;
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// Application
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: KeyBoard.hide,
      child: GetMaterialApp(
        translations: Translator(),
        locale: const Locale('vi', 'VN'),
        localizationsDelegates: [
          GlobalCupertinoLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          DefaultCupertinoLocalizations.delegate
        ],
        supportedLocales: [const Locale('vi'), const Locale('en')],
        builder: (context, child) {
          return ScrollConfiguration(
            behavior: MyBehavior(),
            child: child!,
          );
        },
        debugShowCheckedModeBanner: false,
        title: AppStr.appName.tr,
        getPages: route,
        theme: getThemeByAppTheme(false),
        // darkTheme: getThemeByAppTheme(),
        // themeMode: ThemeMode.light,
        logWriterCallback: localLogWriter,
        initialRoute: '/',
        // routes: routes,
        navigatorObservers: [GetBack((_) {}, Get.routing)],
      ),
    );
  }

  var route = [
    GetPage(
      name: '/',
      page: () => SplashPage(),
    ),
    GetPage(
      name: AppConst.routeHome,
      page: () => HomePage(),
    ),
    GetPage(
      name: AppConst.routeLogin,
      page: () => LoginPage(),
    ),
    GetPage(
      name: AppConst.routeChangeAccount,
      page: () => ChangeAccPage(),
    ),
    GetPage(
      name: AppConst.routeInvoiceCreation,
      page: () => InvoiceCreationPage(),
    ),

    GetPage(
      name: AppConst.routeQrCode,
      page: () => QRInvoicePage(),
    ),
    GetPage(
      name: AppConst.routeSearchInvoice,
      page: () => SearchInvoicePage(),
    ),
    GetPage(
      name: AppConst.routeTicketPage,
      page: () => TicketPage(),
    ),
    GetPage(
      name: AppConst.routeSetupPage,
      page: () => SetupRealmPage(),
    ),
  ];

  void localLogWriter(String text, {bool isError = false}) {
    print('** ' + text + ' [' + isError.toString() + ']');
  }
}

// Widget _buildError() {
//   return SafeArea(
//     child: Scaffold(
//         body: Stack(
//       children: [
//         Container(
//           width: double.infinity,
//           height: double.infinity,
//           child: Image.asset(
//             AppStr.imgError,
//             fit: BoxFit.cover,
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.only(top: 60.0),
//           child: Container(
//             alignment: Alignment.center,
//             padding: EdgeInsets.all(35),
//             child: RichText(
//               textAlign: TextAlign.center,
//               text: TextSpan(
//                   text: AppStr.errorSystem1,
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0),
//                   children: [
//                     TextSpan(
//                         text: AppStr.errorSystem2,
//                         style: TextStyle(
//                             height: 1.8,
//                             wordSpacing: 2,
//                             fontWeight: FontWeight.bold,
//                             fontSize: AppDimens.fontBig()))
//                   ]),
//             ),
//           ),
//         ),
//       ],
//     )),
//   );
// }

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

class GetBack extends GetObserver {
  final Function(Routing?)? routing;
  // ignore: unused_field
  final Routing? _routeSend;

  GetBack([this.routing, this._routeSend]) : super(routing, _routeSend);

  @override
  Future<void> didPop(Route route, Route? previousRoute) async {
    // KeyBoard.hide();
    // await 300.milliseconds.delay();
    super.didPop(route, previousRoute);
  }
}
