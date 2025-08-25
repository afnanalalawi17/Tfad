import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tfad_app/basic.dart';
import 'package:tfad_app/editProfile.dart';
import 'package:tfad_app/homeScreen.dart';
import 'package:tfad_app/loginScreen.dart';
import 'package:tfad_app/multiStep.dart';
import 'package:tfad_app/notfication.dart';
import 'package:tfad_app/settings.dart';

void main() async{
  HttpOverrides.global = _InsecureHttpOverrides(); // DEBUG ONLY

  await GetStorage.init();
  runApp( 
    GetMaterialApp(
     theme: ThemeData(
      
  dividerColor: Colors.transparent,
  primaryColor: Color(0xff17726D), // This sets the primary color
  colorScheme: ColorScheme.fromSwatch(
    primarySwatch: Colors.grey, // or custom if you want
  ).copyWith(
    primary:Color.fromARGB(255, 167, 56, 16), // Custom primary color
    secondary: Colors.deepOrange, // Secondary (accent) color
  ),
  scaffoldBackgroundColor: Colors.white,
  shadowColor: Colors.white,
  fontFamily: 'IBMPlexSansArabic',
),

      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        //  Locale('en'),

        Locale('ar')
      ],
      home:

      LoginScreen(),
      locale: const Locale('ar'),
      fallbackLocale: const Locale('ar'),
      getPages: [
 
      ],
    ),
  );
}
class _InsecureHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    final client = super.createHttpClient(context);
    client.badCertificateCallback = (X509Certificate cert, String host, int port) {
      // احذري: هذا يقبل أي شهادة! استخدميه مؤقتًا فقط أثناء التطوير
      return host == 'report.daamup.sa';
    };
    return client;
  }
}
