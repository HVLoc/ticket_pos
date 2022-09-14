import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import '../const/all_const.dart';
import 'service.dart';

void initServices() async {
  await Get.put(ConnectivityService(), permanent: true);
}

Future<void> initLocal() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings("@mipmap/ic_launcher");

  InitializationSettings initializationSettings = const InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String? payload) async {});
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> showNotiGetx(int id, [String? content]) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'your channel id',
    'your channel name',
    channelDescription: 'your channel description',
    importance: Importance.max,
    priority: Priority.high,
    icon: "@mipmap/ic_launcher",
    ticker: 'ticker',
    styleInformation: DefaultStyleInformation(true, true),
  );

  const NotificationDetails platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
  );
  await flutterLocalNotificationsPlugin.show(
    0,
    AppStr.notification,
    'Đồng bộ $id hóa đơn thành công',
    platformChannelSpecifics,
  );
}
