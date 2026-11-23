import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:trip_cast/view/screens/auth/forgot_password_screen.dart';
import 'package:trip_cast/view/screens/auth/login_signup_screen.dart';
import 'package:trip_cast/view/screens/auth/onBoarding_screen.dart';
import 'package:trip_cast/view/screens/main_screens/bottom_nav_screens/bottom_nav_home.dart';
import 'package:trip_cast/view/screens/main_screens/date_time_screen.dart';
import 'package:trip_cast/view/screens/main_screens/journey_map.dart';
// import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:trip_cast/view/screens/auth/forgot_password_screen.dart';
import 'package:trip_cast/view/screens/auth/login_signup_screen.dart';
import 'package:trip_cast/view/screens/auth/onBoarding_screen.dart';
import 'package:trip_cast/view/screens/main_screens/bottom_nav_screens/bottom_nav_home.dart';
import 'package:trip_cast/view/screens/main_screens/date_time_screen.dart';
import 'package:trip_cast/view/screens/main_screens/journey_map.dart';
import 'package:trip_cast/utils/app_colors.dart';
import 'package:trip_cast/view/screens/main_screens/choose_location.dart';
import 'package:trip_cast/view/screens/main_screens/generating_journey.dart';
import 'package:trip_cast/view/screens/main_screens/notifications_screen.dart';
import 'package:get/get.dart';
import 'package:trip_cast/view/screens/main_screens/splash_screen.dart';
import 'dart:ui' as ui;
import 'firebase_options.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  MapboxOptions.setAccessToken(
      "pk.eyJ1IjoidHJpcGNhc3QxMiIsImEiOiJjbXduNHc3ZHQwNXJ3MnpzYTkzanYyeWxrIn0.ytI4JMyKghtcFG8NuigqEg"
  );

  await GetStorage.init();


  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await setupFCM();



  runApp(const MyApp());
}

Future<void> setupFCM() async {
  try {
    final messaging = FirebaseMessaging.instance;

    NotificationSettings settings =
    await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    debugPrint("Permission: ${settings.authorizationStatus}");

    String? token = await messaging.getToken();

    debugPrint("FCM Token: $token");

  } catch (e) {
    debugPrint("FCM Error: $e");
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const ui.Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      // Use builder only if you need to use library outside ScreenUtilInit context
      builder: (_ , child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Trip Cast App',
          theme: ThemeData(
            textTheme: GoogleFonts.plusJakartaSansTextTheme(),

            colorScheme: .fromSeed(seedColor: Colors.deepPurple),
          ),


          home: SplashScreen(),
        );
      },
    );
  }
}

