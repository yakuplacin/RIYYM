import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';
import 'app/app.locator.dart';
import 'login_screen.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  await Firebase.initializeApp();
  runApp(const MaterialApp(
    home: Splash(),
    debugShowCheckedModeBanner: false,
  ));
}

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  bool? _jailbroken;
  bool? _developerMode;
  @override
  void initState() {
    super.initState();
    initPlatformState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));
    });
  }
  Future<void> initPlatformState() async {
    bool jailbroken;
    bool developerMode;
    try {
      jailbroken = await FlutterJailbreakDetection.jailbroken;
      developerMode = await FlutterJailbreakDetection.developerMode;
    } on PlatformException {
      jailbroken = true;
      developerMode = true;
    }

    if (!mounted) return;

    setState(() {
      _jailbroken = jailbroken;
      _developerMode = developerMode;
    });
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Container(
            decoration:  const BoxDecoration(
                image: DecorationImage(image: AssetImage('images/RIYYMmusic.png'))),
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Jailbroken: ${_jailbroken == null ? "Unknown" : _jailbroken! ? "YES" : "NO"}', style: const TextStyle(fontSize: 20),),
                Text('Developer mode: ${_developerMode == null ? "Unknown" : _developerMode! ? "YES" : "NO"}', style: const TextStyle(fontSize: 20),),

                Center(
                  child: ShaderMask(
                    blendMode: BlendMode.srcIn,
                    shaderCallback: (Rect bounds) {
                      return const LinearGradient(
                        colors: [Colors.red, Colors.blue],
                        tileMode: TileMode.mirror,
                      ).createShader(bounds);
                    },
                    child: const Text(
                      '',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 50,
                      ),
                    ),
                  ),
                ),
const SizedBox(height: 35,),
                const CircularProgressIndicator(
                  color: Colors.white,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatefulWidget {

  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  late FirebaseMessaging messaging;
  late Future<FirebaseApp> _ryapp;
  @override
  void initState() {
     _ryapp= Firebase.initializeApp();
     Firebase.initializeApp().whenComplete(() {
       setState(() {});
     });
    super.initState();
    messaging = FirebaseMessaging.instance;
    messaging.getToken().then((value){
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
    });
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _ryapp,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const LoginScreen();
        } else {
          return const Scaffold(
              body: Center(
            child: CircularProgressIndicator(),
          ));
        }
      },
    );
  }
}
