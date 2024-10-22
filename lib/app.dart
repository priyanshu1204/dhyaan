//import 'package:dhyan/screens/home_screen.dart';
import 'package:dhyan/screens/login_screen.dart';
import 'package:dhyan/screens/registration_screen.dart';
import 'package:dhyan/screens/splash_screen.dart';
import 'package:dhyan/theme.dart';
import 'package:flutter/material.dart';

import 'screens/dashboard.dart';
import 'screens/home_screen.dart';

class DhyaanApp extends StatelessWidget {
  const DhyaanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dhyaan Meditation App',
      debugShowCheckedModeBanner: false,
      theme: CustomTheme(),
      // theme: ThemeData(
      //   primarySwatch: Colors.blue,
      //   visualDensity: VisualDensity.adaptivePlatformDensity,
      // ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegistrationScreen(),
        '/home': (context) => const HomeScreen(),
        '/dashboard': (context) => DashboardScreen(),
      },
    );
  }
}
