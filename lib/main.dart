import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'core/app_configs/screen_names.dart';
import 'core/app_configs/service_locator.dart';
import 'src/pages/error_screen.dart';
import 'src/pages/material_app_home.dart';
import 'src/pages/splash_screen.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (message.notification != null) {
    print("background background but opened: ${message.notification}");
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //Backgroun messages
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  _AppState createState() => _AppState();
}

class _AppState extends State<MyApp> {
  // Set default `_initialized` and `_error` state to false
  bool _initialized = false;
  bool _error = false;

  // Define an async function to initialize FlutterFire
  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      serviceLoactor();
      await _configureFirebaseMessaging();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
  }

  Future _configureFirebaseMessaging() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    // final _token = await messaging.getToken();
    // print(_token);
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    //Foreground messages
    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        print("Foreground message: ${message.notification}");
        final routeFromeMessage = message.data['route'];
        if (routeFromeMessage != null) {
          Navigator.of(context).pushNamed(routeFromeMessage);
        }
      }
    });

    //When app is in background but opened and user taps
    //on notification
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      final routeFromeMessage = message.data['route'];
      print("background background but opened: ${message.notification}");
      if (routeFromeMessage != null) {
        Navigator.of(context).pushNamed(routeFromeMessage);
      }
    });

    //Checks for iOS permissions
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
    print('User granted permission: ${settings.authorizationStatus}');
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
    //Give you message on which user taps
    //and it opened the app from terminated state
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        final routeFromeMessage = message.data['route'];
        if (routeFromeMessage != null) {
          Navigator.of(context).pushNamed(ScreenNames.callerScreen);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Show error message if initialization failed
    if (_error) {
      return ErrorScreen();
    }

    // Show a loader until FlutterFire is initialized
    if (!_initialized) {
      return const SplashScreen();
    }

    return const MaterialAppHome();
  }
}
