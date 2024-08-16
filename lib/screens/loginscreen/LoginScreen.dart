import 'dart:convert';

import 'package:apsfllmo/screens/homescreen/home_screen.dart';
import 'package:apsfllmo/utils/apiservice.dart';
import 'package:apsfllmo/utils/constants.dart';
import 'package:apsfllmo/utils/pallete.dart';
import 'package:apsfllmo/utils/saveappdata.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  //final String _apiUrl = Constants.baseUrl+Apiservice.login;
  final _storage = FlutterSecureStorage();

  bool _isPasswordVisible = false;
  final SaveAppData saveAppData = SaveAppData();

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showToastNotification(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  Future<void> _handleLogin(BuildContext context) async {
    final String username = _usernameController.text.trim();
    final String password = _passwordController.text.trim();

    if (username.isEmpty) {
      _showToastNotification("Please Enter Mobile No or CAF No");
      return;
    }
    if (password.isEmpty) {
      _showToastNotification("Please Enter Password");
      return;
    }

    // Password length validation
    if (username.length < 3 || username.length > 20) {
      _showToastNotification("username must be between 3 to 20 characters.");
      return;
    }

    // Password length validation
    if (password.length < 8 || password.length > 12) {
      _showToastNotification("Password must be between 8 to 12 characters.");
      return;
    }

    final Map<String, dynamic> postData = {
      'app': 'app',
      'fcm_id': '',
      'username': username,
      'password': password,
    };

    try {
      print("Login_url ${Constants.baseUrl + Apiservice.login}");
      final response = await http.post(
        Uri.parse(Constants.baseUrl + Apiservice.login),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(postData),
      );

      print('Login Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print("login_res $responseData");
        final token = response.headers['x-access-token'];
        int usr_ctgry_ky = responseData['data']['user']['usr_ctgry_ky'];
        print('UserCategoryKeyyy $usr_ctgry_ky');

        if (token != null) {
          const flag = '0';
          await _storage.write(key: 'token', value: token);
          await _storage.write(key: 'flag', value: flag);
          if (usr_ctgry_ky != null) {
            await _storage.write(
                key: 'usr_ctgry_ky', value: usr_ctgry_ky.toString());
            await saveAppData.saveUserCategorykey(usr_ctgry_ky.toString());
          }

          await saveAppData.saveToken(token);
          await saveAppData.saveflag(flag);

          print('Token from BBNL login: $token');
          print('Flag from BBNL login: $flag');
          print('UserCategoryKey $usr_ctgry_ky');
          print('UserCategoryKey_saveAppdata $usr_ctgry_ky');
          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (context) {
            return const HomeScreen();
          }));
        } else {
          _showToastNotification("Token not found in response.");
        }
      } else {
        _showToastNotification("Server error, please try again later.");
      }
    } catch (error) {
      print('Login Error: $error');
      _showToastNotification("Something went wrong. Please try again.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AnnotatedRegion(
        value: const SystemUiOverlayStyle(
          statusBarColor: Pallete.backgroundColor,
          statusBarIconBrightness: Brightness.dark,
        ),
        child: Scaffold(
          body: Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  child: Container(
                    height: 300,
                    width: MediaQuery.of(context).size.width * 1,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          'assets/images/background/top_background.png',
                        ),
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: SizedBox(
                      height: 400,
                      width: 400,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 40,
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.1,
                            width: MediaQuery.of(context).size.width * 0.7,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: (Constants.splash_token == "1")
                                    ? AssetImage(
                                        "assets/images/logos/apsfllogoblack.png",
                                      )
                                    : AssetImage(
                                        "assets/images/background/bbnl_logo_dashboard3.png",
                                      ),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            'MORE THAN 10 LAKHS HAPPY USERS SERVED EVERYDAY.',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w900,
                              fontFamily: 'Cera-Bold',
                              // fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 180.0, // Adjust these values as needed
                // left: 50.0, // Adjust these values as needed
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Card(
                    color: Colors.white,
                    elevation: 20, // Set elevation property
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          const Text(
                            'Operator Name',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Cera-Bold',
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _usernameController,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.smartphone),
                              labelText: 'Enter LMO No',
                              labelStyle: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Cera-Bold',
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Password',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Cera-Bold',
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: !_isPasswordVisible,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.lock),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                                icon: Icon(
                                  _isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                              ),
                              labelText: 'Password',
                              labelStyle: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Cera-Bold',
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 480.0,
                child: Container(
                  // color: Colors.red,
                  width: MediaQuery.of(context).size.width * 0.9,
                  // margin: EdgeInsets.only(bottom: 80),
                  // padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'Cera-Bold',
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 120,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            onPressed: () => _handleLogin(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromRGBO(244, 87, 37, 1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              "SIGN IN",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontFamily: 'Cera-Bold',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  padding: EdgeInsets.all(20),
                  height: MediaQuery.of(context).size.height * 0.07,
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        "assets/images/background/bottom_background.png",
                      ),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(right: 20.0),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: (Constants.splash_token == "1")
                          ? Text(
                              'Powered By APSFL',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Cera-Bold',
                                  fontSize: 16),
                            )
                          : Text(
                              'Powered By BBNL',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Cera-Bold',
                                  fontSize: 16),
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
