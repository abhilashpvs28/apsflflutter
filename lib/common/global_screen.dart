import 'dart:async';
import 'dart:convert';

import 'package:apsfllmo/screens/splashscreen/splash_screen.dart';
import 'package:apsfllmo/utils/constants.dart';
import 'package:apsfllmo/utils/saveappdata.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class GlobalScreen extends StatefulWidget {
  const GlobalScreen({super.key});

  @override
  State<GlobalScreen> createState() => _GlobalScreenState();
}

class _GlobalScreenState extends State<GlobalScreen> {
  final SaveAppData saveAppData = SaveAppData();
  final storageee = FlutterSecureStorage();

  Future<void> bbnl_business_info_api_call() async {
    final storage = FlutterSecureStorage();
    final String? token = await storage.read(key: 'token');
    final String? agent_id = await storage.read(key: 'usr_ctgry_ky');

    print('Retrieved token: $token');
    print('usercategory_key $agent_id');

    if (token == null) {
      setState(() {
        //  _isLoading = false;
      });
      print('Token is null');
      //return ;
    }

    final Map<String, String> headers = {
      'x-access-token': '$token',
      'Content-Type': 'application/json'
    };

    print('Request headers: $headers');
    var url = Uri.parse(
        "https://bbnlbss.apsfl.co.in/apiv1/lmoprepaid/prepaid_business_info_version");
    print("url $url");
    final response = await http.get(url);

    print("mtd_revenue_code ${response.statusCode}");
    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      setState(() {
        Constants.baseUrl = "https://bbnlbss.apsfl.co.in/apiv1/";
        Constants.splash_token = "0";
        saveAppData.save_flag_type("0");
        print("flagg_typee ${saveAppData.get_flag_type}");
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const SplashScreen()));
      });
    } else {
      print("faileddd");
      throw Exception('Failed to load posts');
    }
  }

  Future<void> apsfl_business_info_api_call() async {
    final storage = FlutterSecureStorage();
    final String? token = await storage.read(key: 'token');
    final String? agent_id = await storage.read(key: 'usr_ctgry_ky');

    print('Retrieved token: $token');
    print('usercategory_key $agent_id');

    if (token == null) {
      setState(() {
        //  _isLoading = false;
      });
      print('Token is null');
      //return ;
    }

    final Map<String, String> headers = {
      'x-access-token': '$token',
      'Content-Type': 'application/json'
    };

    print('Request headers: $headers');
    var url = Uri.parse(
        "http://bss.apsfl.co.in/apiv1/lmoprepaid/prepaid_business_info_version");
    print("url $url");
    final response = await http.get(url);

    print("bussiness_st_code ${response.statusCode}");
    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      setState(() async {
        Constants.baseUrl = "http://bss.apsfl.co.in/apiv1/";
        Constants.splash_token = "1";
        saveAppData.saveToken("1");
        await storage.write(key: 'flag_type', value: '1');
        print("flagg_typee ${saveAppData.get_flag_type}");
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const SplashScreen()));
      });
    } else {
      print("faileddd");
      throw Exception('Failed to load posts');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        body: Container(
          // width: 100,
          // height: 100,
          decoration: const BoxDecoration(
            color: Colors.lightBlue,
            image: DecorationImage(
              image: AssetImage('assets/images/globalscreen/globalscreen.jpeg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            width: double.maxFinite,
            padding: const EdgeInsets.symmetric(horizontal: 57),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 86),
                Padding(
                  padding: const EdgeInsets.only(right: 7),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          const Text(
                            "Login To",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'Cera-Bold',
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 9),
                          SizedBox(
                            width: 120,
                            child: ElevatedButton(
                              onPressed: () {
                                bbnl_business_info_api_call();

                                // Navigator.of(context).push(MaterialPageRoute(
                                //     builder: (context) =>
                                //         const BbnlsplashScreen()));
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromRGBO(
                                    7, 23, 146, 1), // background color
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      8), // Adjust the radius as needed
                                ),
                              ),
                              child: const Text(
                                "BBNL",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontFamily: 'Cera-Bold',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const Text(
                            "Login To",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              fontFamily: 'Cera-Bold',
                            ),
                          ),
                          const SizedBox(height: 9),
                          SizedBox(
                            // height: 120,
                            width: 120,
                            child: ElevatedButton(
                              onPressed: () {
                                apsfl_business_info_api_call();

                                // Navigator.of(context).push(MaterialPageRoute(
                                //     builder: (context) =>
                                //         const ApsflSplashScreen()));
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromRGBO(
                                    244, 87, 37, 1), // background color
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      8), // Adjust the radius as needed
                                ),
                              ),
                              child: const Text(
                                "APSFL",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontFamily: 'Cera-Bold',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
