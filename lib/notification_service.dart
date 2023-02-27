import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:riyym/login_screen.dart';

class LocalNotifications extends StatefulWidget {

  String title;

  LocalNotifications({required this.title});

  @override
  _LocalNotificationsState createState() => _LocalNotificationsState();
}

class _LocalNotificationsState extends State<LocalNotifications> {

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    requestPermissions();
    var androidSettings = const AndroidInitializationSettings('app_icon');
    var iOSSettings = const DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    var initSetttings = InitializationSettings(android: androidSettings, iOS: iOSSettings);
    flutterLocalNotificationsPlugin.initialize(initSetttings);

  }

  void requestPermissions() {
    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future? onClickNotification(String? payload) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return const LoginScreen(
      );
    }));
  }

  showSimpleNotification() async {
    var androidDetails = const AndroidNotificationDetails('id', 'channel ',
        priority: Priority.high, importance: Importance.max);
    var iOSDetails = const DarwinNotificationDetails();
    var platformDetails = new NotificationDetails(android: androidDetails, iOS: iOSDetails);
    await flutterLocalNotificationsPlugin.show(0, 'Flutter Local Notification', 'Flutter Simple Notification',
        platformDetails, payload: 'Destination Screen (Simple Notification)');
  }

  Future<void> showScheduleNotification() async {
    var scheduledNotificationDateTime = DateTime.now().add(const Duration(seconds: 5));
    var androidDetails = const AndroidNotificationDetails(
      'channel_id',
      'Channel Name',
      icon: 'app_icon',
      largeIcon: const DrawableResourceAndroidBitmap('app_icon'),
    );
    var iOSDetails = const DarwinNotificationDetails();
    var platformDetails = NotificationDetails(android: androidDetails, iOS: iOSDetails);
    await flutterLocalNotificationsPlugin.schedule(0, 'Flutter Local Notification', 'Flutter Schedule Notification',
        scheduledNotificationDateTime, platformDetails, payload: 'Destination Screen(Schedule Notification)');
  }

  Future<void> showPeriodicNotification() async {
    const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails('channel_id', 'Channel Name');
    const NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.periodicallyShow(0, 'Flutter Local Notification', 'Flutter Periodic Notification',
        RepeatInterval.everyMinute, notificationDetails, payload: 'Destination Screen(Periodic Notification)');
  }

  Future<void> showBigPictureNotification() async {
    var bigPictureStyleInformation = const BigPictureStyleInformation(
      const DrawableResourceAndroidBitmap("cover_image"),
      largeIcon: const DrawableResourceAndroidBitmap("app_icon"),
      contentTitle: 'Flutter Big Picture Notification Title',
      summaryText: 'Flutter Big Picture Notification Summary Text',
    );
    var androidDetails = AndroidNotificationDetails(
        'channel_id',
        'Channel Name',
        styleInformation: bigPictureStyleInformation);
    var platformDetails = NotificationDetails(android: androidDetails);
    await flutterLocalNotificationsPlugin.show(0, 'Flutter Local Notification', 'Flutter Big Picture Notification',
        platformDetails, payload: 'Destination Screen(Big Picture Notification)');
  }

  Future<void> showBigTextNotification() async {
    const BigTextStyleInformation bigTextStyleInformation =
    BigTextStyleInformation(
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
      htmlFormatBigText: true,
      contentTitle: 'Flutter Big Text Notification Title',
      htmlFormatContentTitle: true,
      summaryText: 'Flutter Big Text Notification Summary Text',
      htmlFormatSummaryText: true,
    );
    const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails('channel_id', 'Channel Name', styleInformation: bigTextStyleInformation);
    const NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(0, 'Flutter Local Notification', 'Flutter Big Text Notification',
        notificationDetails, payload: 'Destination Screen(Big Text Notification)');
  }

  Future<void> showInsistentNotification() async {
    const int insistentFlag = 4;
    final AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails('channel_id', 'Channel Name',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
        additionalFlags: Int32List.fromList(<int>[insistentFlag]));
    final NotificationDetails notificationDetails = NotificationDetails(android: androidPlatformChannelSpecifics,);
    await flutterLocalNotificationsPlugin.show(0, 'Flutter Local Notification', 'Flutter Insistent Notification',
        notificationDetails, payload: 'Destination Screen(Insistent Notification)');
  }

  Future<void> showOngoingNotification() async {
    const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails('channel_id', 'Channel Name',
        importance: Importance.max,
        priority: Priority.high,
        ongoing: true,
        autoCancel: false);
    const NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(0, 'Flutter Local Notification', 'Flutter Ongoing Notification',
        notificationDetails, payload: 'Destination Screen(Ongoing Notification)');
  }

  Future<void> showProgressNotification() async {
    const int maxProgress = 5;
    for (int i = 0; i <= maxProgress; i++) {
      await Future<void>.delayed(const Duration(seconds: 1), () async {
        final AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails('channel_id', 'Channel Name',
            channelShowBadge: false,
            importance: Importance.max,
            priority: Priority.high,
            onlyAlertOnce: true,
            showProgress: true,
            maxProgress: maxProgress,
            progress: i);
        final NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails);
        await flutterLocalNotificationsPlugin.show(0, 'Flutter Local Notification', 'Flutter Progress Notification',
            notificationDetails, payload: 'Destination Screen(Progress Notification)');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RaisedButton(
                child: const Text('Simple Notification'),
                onPressed: () => showSimpleNotification(),
              ),
              const SizedBox(height: 15),
              RaisedButton(
                child: const Text('Schedule Notification'),
                onPressed: () => showScheduleNotification(),
              ),
              const SizedBox(height: 15),
              RaisedButton(
                child: const Text('Periodic Notification'),
                onPressed: () => showPeriodicNotification(),
              ),
              const SizedBox(height: 15),
              RaisedButton(
                child: const Text('Big Picture Notification'),
                onPressed: () => showBigPictureNotification(),
              ),
              const SizedBox(height: 15),
              RaisedButton(
                child: const Text('Big Text Notification'),
                onPressed: () => showBigTextNotification(),
              ),
              const SizedBox(height: 15),
              RaisedButton(
                child: const Text('Insistent Notification'),
                onPressed: () => showInsistentNotification(),
              ),
              const SizedBox(height: 15),
              RaisedButton(
                child: const Text('OnGoing Notification'),
                onPressed: () => showOngoingNotification(),
              ),
              const SizedBox(height: 15),
              RaisedButton(
                child: const Text('Progress Notification'),
                onPressed: () => showProgressNotification(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}