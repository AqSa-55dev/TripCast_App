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
import 'package:trip_cast/view/screens/main_screens/notifications_screen.dart';
import 'package:get/get.dart';
import 'package:trip_cast/view/screens/main_screens/splash_screen.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();


  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await setup();

  runApp(const MyApp());
}


Future<void>setup()async{
  await dotenv.load(fileName: ".env");
  MapboxOptions.setAccessToken(dotenv.env["MAPBOX_ACCESS_TOKEN"]!);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      //designSize: Size( width: 200, height: 200),
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


          home: JourneyMap(),
        );
      },
    );
  }
}

