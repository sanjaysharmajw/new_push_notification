
import 'dart:async';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    AndroidInitializationSettings initializationSettingsAndroid =
    const AndroidInitializationSettings('flutter_logo');

    var initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
    );
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await notificationsPlugin.initialize(initializationSettings, onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {});
  }


  notificationDetails() {
    return const NotificationDetails(
        android: AndroidNotificationDetails('channelId', 'channelName',
            importance: Importance.high,
            playSound: true,
            enableVibration: true,
            usesChronometer: false,
            sound: RawResourceAndroidNotificationSound('notification_sound'),
        priority: Priority.high),
        iOS: DarwinNotificationDetails());
  }



  Future showNotification({int id = 3, String? title, String? body, String? payLoad}) async {
    return notificationsPlugin.show(id, title, body, await notificationDetails());
  }

  Future scheduleNotification({
    int id = 0,
    String? title,
    String? body,
    String? payLoad,
  }) async {
    return notificationsPlugin.periodicallyShow(
      id,
      title,
      body,
      RepeatInterval.everyMinute,
      await notificationDetails(),
      androidScheduleMode: AndroidScheduleMode.exact, // Add this parameter
    );
  }


  Future<void> zonedScheduleNotification({
    required int secondOrMin,
    required int id,
    String? title,
    String? body,
    String? payLoad,
  }) async {
    // Schedule the notification
    await notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.now(tz.local).add(Duration(seconds: secondOrMin)),
      await notificationDetails(),
      androidScheduleMode: AndroidScheduleMode.exact,
    );

    print('Notification scheduled');
  }


  // void scheduleNotification(String title, String body)async{
  //   AndroidNotificationDetails androidNotificationDetails=const
  //   AndroidNotificationDetails("channelId", "channelName",
  //       importance: Importance.max,
  //       priority: Priority.high);
  //
  //   NotificationDetails notificationDetails = NotificationDetails(android:androidNotificationDetails);
  //   await notificationsPlugin.periodicallyShow(0, title, body,RepeatInterval.everyMinute ,notificationDetails);
  //
  // }

  void cancelScheduleNotification()async{
    await notificationsPlugin.cancelAll();
  }

  void cancelScheduleNotificationId(int id)async{
    await notificationsPlugin.cancel(id);
  }


}