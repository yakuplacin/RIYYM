import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:riyym/dataBase/authentication.dart';
import 'package:riyym/homepage.dart';

import 'package:flutter_native_timezone/flutter_native_timezone.dart';

import 'forgot_password_screen.dart';
import 'registration_screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:developer' as developer;
import 'package:flutter/services.dart';

import 'package:battery_info/battery_info_plugin.dart';
import 'package:battery_info/model/android_battery_info.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {



  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  void config() async{
    await _configureLocalTimeZone();
  }
  @override
  void initState(){
    secureScreen();
    super.initState();
    config();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
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

  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String? timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName!));
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
    var platformDetails = NotificationDetails(android: androidDetails, iOS: iOSDetails);
    await flutterLocalNotificationsPlugin.show(0, 'Flutter Local Notification', 'Flutter Simple Notification',
        platformDetails, payload: 'Destination Screen (Simple Notification)');
  }

  Future<void> showScheduleNotification() async {
    var androidDetails = const AndroidNotificationDetails(
      'channel_id',
      'Channel Name',
      icon: 'app_icon',
      largeIcon: DrawableResourceAndroidBitmap('app_icon'),
    );
    var iOSDetails = const DarwinNotificationDetails();
    var platformDetails = NotificationDetails(android: androidDetails, iOS: iOSDetails);
    await flutterLocalNotificationsPlugin.zonedSchedule(0, 'Flutter Local Notification', 'Flutter Schedule Notification',
        tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)), platformDetails, payload: 'Destination Screen(Schedule Notification)', androidAllowWhileIdle: true, uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime);
  }

  Future<void> showPeriodicNotification() async {
    const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails('channel_id', 'Channel Name');
    const NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.periodicallyShow(0, 'Flutter Local Notification', 'Flutter Periodic Notification',
        RepeatInterval.everyMinute, notificationDetails, payload: 'Destination Screen(Periodic Notification)');
  }

  Future<void> showBigPictureNotification() async {
    var bigPictureStyleInformation = const BigPictureStyleInformation(
      DrawableResourceAndroidBitmap("cover_image"),
      largeIcon: DrawableResourceAndroidBitmap("app_icon"),
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

  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;


  @override
  Future<void> dispose()async  {
    await FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
    _connectivitySubscription.cancel();
    myController.dispose();
    super.dispose();
  }
  Future<void> secureScreen() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }


  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      developer.log('Couldn\'t check connectivity status', error: e);
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
  }



  final myController = TextEditingController();
  final myControllerPw = TextEditingController();
  // String username = "name";
  // String password = "123";


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus &&
              currentFocus.focusedChild != null) {
            FocusManager.instance.primaryFocus?.unfocus();
          }
        },
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                const CircleAvatar(
                  radius: 80,
                  backgroundImage: AssetImage('images/RIYYMmusic.png'),
                ),

                SizedBox(
                  width: double.infinity,
                  child: Container(
                    color: Colors.red,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,

                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(onPressed: (){
                                  showScheduleNotification();
                                }, child: Row(

                                  children: const[
                                    Text("Click button and \nwait 5 seconds  -> \nfor the surprise",maxLines: 3,style: TextStyle(fontWeight: FontWeight.w400,color: Colors.black),),
                                    Icon(Icons.circle_notifications,color: Colors.black,size: 28,),
                                  ],

                                )),
                              ],
                            ),
                            Tooltip(
                              preferBelow: false,
                              message: 'Please, connect via wifi for a better experience',
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const Text("Connection Status: ",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w400,)),
                                  Icon(_connectionStatus.name=='wifi'?Icons.wifi
                                      :Icons.signal_cellular_alt ,size: 28,
                                  ),
                                ],
                              ),
                            ),
                            FutureBuilder<AndroidBatteryInfo?>(
                                future: BatteryInfoPlugin().androidBatteryInfo,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return Text(
                                        'Battery Health: ${snapshot.data!.health!.toUpperCase()}');
                                  }
                                  return const CircularProgressIndicator();
                                }),
                          ],
                        ),
                      ),
                      TextField(
                        controller: myController,
                        autofocus: false,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(
                            Icons.mail,
                          ),
                          labelText: 'e-mail',
                          border: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(10.0)),
                          ),
                        ),
                      ),
                      const Divider(
                        thickness: 1,
                      ),
                      TextField(
                        controller: myControllerPw,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.number,
                        obscureText: true,
                        autofocus: false,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(
                            Icons.vpn_key,
                          ),
                          labelText: 'Password',
                          border: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(10.0)),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Icon(Icons.login),
                          TextButton(
                            child: const Text(
                              'login',
                              style: TextStyle(
                                fontFamily: 'Pacifico',
                                fontSize: 20,
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: TextButton.styleFrom(primary: Colors.purple),
                            onPressed: () async {
                              var signing = await Authentication().logIn(
                                  myController.text, myControllerPw.text);
                              if (signing == 'true') {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return HomePage(num:3);
                                    },
                                  ),
                                      (route) => true,
                                );
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      content: Text(signing),
                                    );
                                  },
                                );
                              }
                            },
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text('Don\'t have an account?'),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return const RegistrationScreen();
                                  },
                                ),
                              );
                            },
                            child: const Text(
                              ' SignUp',
                              style: TextStyle(
                                fontFamily: 'Pacifico',
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.pink,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text('Forgot password?'),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return ForgotPassword();
                                  },
                                ),
                                    (route) => false,
                              );
                            },
                            child: const Text(
                              ' Click Here ',
                              style: TextStyle(
                                fontFamily: 'Pacifico',
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.teal,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
