import 'dart:async';

import 'package:apsfllmo/screens/homescreen/home_screen.dart';
import 'package:apsfllmo/screens/loginscreen/LoginScreen.dart';
import 'package:apsfllmo/utils/constants.dart';
import 'package:apsfllmo/utils/saveappdata.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _storage = const FlutterSecureStorage();
  final SaveAppData saveAppData = SaveAppData();
  String? flag_type='';
  @override
   initState()  {
    super.initState();
  
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);
    super.initState();
    Timer(const Duration(seconds: 2), () {
      _checkTokenAndNavigate();
    });
  }

  Future<void> _checkTokenAndNavigate() async {
    final token = await _storage.read(key: 'token');
    final flag = await _storage.read(key: 'flag');
    print("Splash_token $token");
    print("splash_flag$flag");
    if (token != null) {
      // if (flag == '0') {
      //   Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => const HomeScreen(),
      //     ),
      //   );
      // }
      //  else {
      //   Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => const LoginScreen(),
      //     ),
      //   );
      // }

       Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
       Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration:  BoxDecoration(
          image: DecorationImage(
            image:(Constants.splash_token=="1")? AssetImage(
              'assets/images/background/apsflsplashscreen.png',
            ): AssetImage(
              'assets/images/background/bbnlspalshnew.jpeg',
            ),
            fit: BoxFit.cover,
          ),
        ),
      )
    );
  }
}
