import 'dart:async';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:apsfllmo/common/global_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        MonthYearPickerLocalizations.delegate,
      ],
      home: GlobalScreen(), // Set the initial screen to SplashScreen
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      _checkTokenAndNavigate();
    });
  }

  Future<void> _checkTokenAndNavigate() async {
    final token = await _storage.read(key: 'token');
    final flag = await _storage.read(key: 'flag');
    print("Splashhhhh_tokennn $token");
    print("Splashhh_flagggg $flag");
    if (token != null) {
      // if (flag == '1') {
      //   Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => const SplashScreen(),
      //     ),
      //   );
      // }
      //  else if (flag == '0') {
      //   Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => const SplashScreen(),
      //     ),
      //   );
      // }

      print("token not null");
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SplashScreen(),
        ),
      );
    } else {
      print("token null");
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GlobalScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
