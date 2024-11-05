import 'dart:developer';

import 'package:baladna_go/controller/reviews_controller.dart';
import 'package:baladna_go/firebase_options.dart';
import 'package:baladna_go/views/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'controller/homecontroller.dart';
import 'controller/maincontroller.dart';
import 'views/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Get.put(HomeController());
  Get.put(MainController());
  Get.put(Reviewcontroller());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: GoogleFonts.cairoTextTheme(Theme.of(context).textTheme),
        cardTheme: const CardTheme(
          color: Colors.white,
        ),
        useMaterial3: true,
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return const Text("there Error");
          }
          // ignore: unnecessary_null_comparison
          if (snapshot.data == null) {
            return const LoginScreen();
          }
          if (snapshot.hasData) {
            log(snapshot.data.toString());
            return const HomeScreen();
          }
          return const Text("");
        },
      ),
      builder: EasyLoading.init(),
    );
  }
}
