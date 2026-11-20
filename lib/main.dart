import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trip_cast/utils/app_colors.dart';
import 'package:trip_cast/view/screens/main_screens/choose_location.dart';
import 'package:trip_cast/view/screens/main_screens/generating_journey.dart';
import 'package:trip_cast/view/screens/main_screens/notifications_screen.dart';
import 'package:trip_cast/view/screens/main_screens/splash_screen.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();


  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );



  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      // Use builder only if you need to use library outside ScreenUtilInit context
      builder: (_ , child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Trip Cast App',
          theme: ThemeData(
            textTheme: GoogleFonts.plusJakartaSansTextTheme(),

            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.primary,
            ),
            scaffoldBackgroundColor: AppColors.background,
          ),


          home: ChooseLocation(),
        );
      },
    );
  }
}

