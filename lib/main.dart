import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:voting_app/view/screens/home_screen.dart';
import 'package:voting_app/view/screens/login_screen.dart';
import 'package:voting_app/view/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash_screen',
      getPages: [
        GetPage(name: '/splash_screen', page: () => const SplashScreen()),
        GetPage(name: '/login_screen', page: () => const LoginScreen()),
        GetPage(name: '/', page: () => const HomeScreen()),
      ],
    ),
  );
}
