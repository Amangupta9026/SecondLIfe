import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';
import 'global/color.dart';
import 'global/theme.dart';
import 'global/utils.dart';
import 'multiprovider_name.dart';
import 'push_notification/firebase_messaging.dart';
import 'screen/auth/boarding_screen.dart';
import 'screen/home/home_screen.dart';
import 'screen/listner_app_ui/listner_homescreen.dart';
import 'sharedpreference/sharedpreference.dart';

Future<void> backgroundHandler(RemoteMessage message) async {
  log(message.data.toString(), name: 'main.dart');
  log(message.notification!.title.toString(), name: 'main.dart notifi');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await SharedPreference.init();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  await AppUtils.handleCameraAndMic(Permission.microphone);

  runApp(MultiProvider(providers: multiProviderNames, child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget? home = const OnBoarding();

  @override
  void initState() {
    super.initState();
    Messaging.showMessage();

    checkLogin();

    FirebaseMessaging.instance.getInitialMessage().then(
      (message) {
        log("FirebaseMessaging.instance.getInitialMessage");
        if (message != null) {
          log("New Notification");
          // if (message.data['_id'] != null) {
          //   Navigator.of(context).push(
          //     MaterialPageRoute(
          //       builder: (context) => DemoScreen(
          //         id: message.data['_id'],
          //       ),
          //     ),
          //   );
          // }
        }
      },
    );

    // 2. This method only call when App in forground it mean app must be opened
    FirebaseMessaging.onMessage.listen(
      (message) {
        log("FirebaseMessaging.onMessage.listen");
        if (message.notification != null) {
          log(message.notification!.title.toString());
          log(message.notification!.body.toString());
          log("message.data11 ${message.data}");
          // LocalNotificationService.display(message);
        }
      },
    );

    // 3. This method only call when App in background and not terminated(not closed)
    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) {
        log("FirebaseMessaging.onMessageOpenedApp.listen");
        if (message.notification != null) {
          log(message.notification!.title.toString());
          log(message.notification!.body.toString());
          log("message.data22 ${message.data['_id']}");
        }
      },
    );
  }

  void checkLogin() async {
    if (FirebaseAuth.instance.currentUser != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool? isListener = prefs.getBool("isListener");
      if (!isListener!) {
        home = const HomeScreen();
      } else {
        home = const ListnerHomeScreen();
      }
    } else {
      home = const OnBoarding();
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return
        
        GetMaterialApp(
      color: primaryColor,
      debugShowCheckedModeBanner: false,
      title: 'SecondLife',
      theme: themeData,
      home: home,
      builder: EasyLoading.init(),
    );
  }
}
