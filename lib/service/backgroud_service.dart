// import 'dart:async';

// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:easy_invoice_qlhd/features/invoice_detail/invoice_detail.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_background_service/flutter_background_service.dart';
// import 'package:flutter_background_service_android/flutter_background_service_android.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';


// final service = FlutterBackgroundService();

// Future<void> initializeService() async {
//   await service.configure(
//     androidConfiguration: AndroidConfiguration(
//       // this will executed when app is in foreground or background in separated isolate
//       onStart: onStart,

//       // auto start service
//       autoStart: true,
//       isForegroundMode: false,
//     ),
//     iosConfiguration: IosConfiguration(
//       autoStart: false,
//       onForeground: onStart,
//       onBackground: onIosBackground,
//     ),
//   );
// }

// // to ensure this executed
// // run app from xcode, then from xcode menu, select Simulate Background Fetch
// bool onIosBackground(ServiceInstance service) {
//   WidgetsFlutterBinding.ensureInitialized();

//   return true;
// }

// Future<void> onStart(ServiceInstance service) async {
//   List listInvoice = [];
//   if (service is AndroidServiceInstance) {
//     service.on('setAsBackground').listen((event) {
//       service.setAsBackgroundService();
//     });
//   }
//   WidgetsFlutterBinding.ensureInitialized();
//   service.on('stopService').listen((event) {
//     service.stopSelf();
//   });
//   service.on('update').listen((event) {
//     showNoti(event!['current_date'].toString());
//     listInvoice = event['hive'];
//   });

//   // print('FLUTTER BACKGROUND SERVICE: ${DateTime.now()}');

//   // Get.put(AppController());
//   // await initHive();
//   Connectivity().onConnectivityChanged.listen((event) async {
//     if (event == ConnectivityResult.wifi ||
//         event == ConnectivityResult.mobile) {
//       showNoti(listInvoice.length.toString());
//       // if (HIVE_INVOICE.isNotEmpty) {
//       // var listInvoice =
//       //     HIVE_INVOICE.toMap().entries.map((e) => e.value).toList();
//       for (var i = 0; i < listInvoice.length; i++) {
//         if (listInvoice[i].invoiceNo == null || listInvoice[i].invoiceNo == 0) {
//           showNoti((i + 1).toString());
//           // HIVE_INVOICE.put(listInvoice[i].ikey,
//           //     listInvoice[i]..invoiceNo = i.toDouble());
//         }
//       }
//       // }
//     }
//   });
// }

// // Future<void> initLocal() async {
// //   const AndroidInitializationSettings initializationSettingsAndroid =
// //       AndroidInitializationSettings("@mipmap/ic_launcher_round");

// //   InitializationSettings initializationSettings = const InitializationSettings(
// //     android: initializationSettingsAndroid,
// //   );

// //   await flutterLocalNotificationsPlugin.initialize(initializationSettings,
// //       onSelectNotification: (String? payload) async {});
// // }

// Future<void> showNoti(String id) async {
//   const AndroidNotificationDetails androidPlatformChannelSpecifics =
//       AndroidNotificationDetails(
//     'your channel id',
//     'your channel name',
//     channelDescription: 'your channel description',
//     importance: Importance.max,
//     priority: Priority.high,
//     icon: "@mipmap/ic_launcher_round",
//     ticker: 'ticker',
//     styleInformation: DefaultStyleInformation(true, true),
//   );

//   const NotificationDetails platformChannelSpecifics = NotificationDetails(
//     android: androidPlatformChannelSpecifics,
//   );
//   await flutterLocalNotificationsPlugin.show(
//     0,
//     'Đồng bộ $id hóa đơn thành công',
//     '',
//     platformChannelSpecifics,
//   );
// }
