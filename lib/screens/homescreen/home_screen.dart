import 'dart:convert';

import 'package:apsfllmo/drawernavigationscreen/bbnldrawernavigation_screen.dart';
import 'package:apsfllmo/screens/additionalservices/additionalservices_screen.dart';
import 'package:apsfllmo/screens/cpeinventoryscreen/cpeinventory_screen.dart';
import 'package:apsfllmo/screens/individualcaf/customerinformation_screen.dart';
import 'package:apsfllmo/screens/enterprisecaf/selectenterprise_screen.dart';
import 'package:apsfllmo/screens/monthlycollection/monthlycollection_screen.dart';
import 'package:apsfllmo/screens/notificationscreen/apsflnotifications_screen.dart';
import 'package:apsfllmo/screens/notificationscreen/bbnlnotifications_screen.dart';
import 'package:apsfllmo/screens/payments/payments.dart';
import 'package:apsfllmo/screens/revenue_sharing/revenue_sharing.dart';
import 'package:apsfllmo/screens/searchcafs/customerdetails_screen.dart';
import 'package:apsfllmo/screens/searchcafs/searchcaf_screen.dart';
import 'package:apsfllmo/utils/apiservice.dart';
import 'package:apsfllmo/utils/constants.dart';
import 'package:apsfllmo/utils/saveappdata.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../../utils/pallete.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SaveAppData saveAppData = SaveAppData();
  final storage = FlutterSecureStorage();
  List<Map<String, dynamic>> _dataList = [];
  bool _isLoading = false;
  int _notificationCount = 0;

  double? balance;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    print('Inside fetchData function');
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    // const apiUrl = 'http://bss.apsfl.co.in/apiv1/lmoprepaid/chckblncelmo';

    final storage = FlutterSecureStorage();
    final String? token = await storage.read(key: 'token');

    print('Retrieved token: $token');

    if (token == null) {
      setState(() {
        _isLoading = false;
      });
      print('Token is null');
      return;
    }

    final Map<String, String> headers = {
      'x-access-token': token,
      'Content-Type': 'application/json'
    };

    print('Request headers: $headers');

    final http.Response response = await http.get(
      Uri.parse(Constants.baseUrl + Apiservice.check_balance),
      headers: headers,
    );

    print('Response status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<dynamic> data = responseData['data'] ?? [];
      print('Data received: $data');
      setState(() {
        balance = data[0]['balance'];
        _notificationCount = data[0]['count']; // Update notification count
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      print('Failed to fetch data. Status code: ${response.statusCode}');
      throw Exception('Failed to fetch data');
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
          appBar: PreferredSize(
            preferredSize:
                const Size.fromHeight(100.0), // Adjust the height as needed
            child: Container(
              color:
                  Color.fromRGBO(255, 255, 52, 1), // Set the background color
              padding: const EdgeInsets.only(top: 20), // Add top padding here
              child: AppBar(
                backgroundColor: Color.fromRGBO(
                    255, 255, 52, 1), // Ensure the AppBar background matches
                actions: [
                  Center(
                      child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: (Constants.splash_token == "1")
                        ? Image.asset(
                            'assets/images/background/apsfl_image.png',
                          )
                        : Image.asset(
                            'assets/images/background/bbnl_logo_dashboard3.png',
                          ),
                  )),
                  badges.Badge(
                    position: badges.BadgePosition.custom(end: 20),
                    badgeContent: Text(
                      '$_notificationCount',
                      style: const TextStyle(color: Colors.black),
                    ),
                    showBadge: _notificationCount > 0,
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const ApsflNotificationsScreen()),
                        );
                      },
                      icon: const Icon(
                        Icons.notifications,
                        size: 30,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
                iconTheme: const IconThemeData(
                  size: 30,
                  color: Color.fromARGB(255, 204, 85, 45),
                ),
                elevation: 0, // Remove the shadow if needed
              ),
            ),
          ),
          drawer: const BbnlDrawerNavigationScreen(),
          body: Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  child: Container(
                    height: MediaQuery.of(context).size.width * 0.4,
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
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  'V 5.8',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Cera-Bold',
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Welcome LMO2000825',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Cera-Bold',
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  'English',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Cera-Medium',
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Icon(
                                  Icons.wallet,
                                  color: Colors.black,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  '₹ $balance /-',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Cera-Bold',
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                // color: Colors.grey,
                height: MediaQuery.of(context).size.height * 0.66,
                width: MediaQuery.of(context).size.width * 0.66,
                child: GridView.count(
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 5,
                  crossAxisCount: 2,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const InCafCustomerinformationScreen()),
                        );
                      },
                      child: Container(
                        child: Column(
                          children: [
                            Material(
                              elevation: 20,
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.14,
                                width: MediaQuery.of(context).size.width * 0.9,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Colors.white, spreadRadius: 3),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.1,
                                      width: MediaQuery.of(context).size.width *
                                          0.7,
                                      child: const Image(
                                        image: AssetImage(
                                          'assets/images/background/individual_caf.png',
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    const Text(
                                      'Indiviual CAF',
                                      style: TextStyle(
                                          fontFamily: 'Cera-Bold',
                                          fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SelectenterpriseScreen()));
                      },
                      child: Container(
                        child: Column(
                          children: [
                            Material(
                              elevation: 20,
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.14,
                                width: MediaQuery.of(context).size.width * 0.9,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Colors.white, spreadRadius: 3),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.1,
                                      width: MediaQuery.of(context).size.width *
                                          0.7,
                                      child: const Image(
                                        image: AssetImage(
                                          'assets/images/background/enterprice_customers.png',
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    const Text(
                                      'Enterprise CAF',
                                      style: TextStyle(
                                          fontFamily: 'Cera-Bold',
                                          fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const SearchcafScreen()));
                      },
                      child: Container(
                        child: Column(
                          children: [
                            Material(
                              elevation: 20,
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.14,
                                width: MediaQuery.of(context).size.width * 0.9,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Colors.white, spreadRadius: 3),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.1,
                                      width: MediaQuery.of(context).size.width *
                                          0.7,
                                      child: const Image(
                                        image: AssetImage(
                                          'assets/images/background/search_caf.png',
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    const Text(
                                      'Search CAF',
                                      style: TextStyle(
                                          fontFamily: 'Cera-Bold',
                                          fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                const MonthlycollectionScreen()));
                      },
                      child: Container(
                        child: Column(
                          children: [
                            Material(
                              elevation: 20,
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.14,
                                width: MediaQuery.of(context).size.width * 0.9,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Colors.white, spreadRadius: 3),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.1,
                                      width: MediaQuery.of(context).size.width *
                                          0.7,
                                      child: const Image(
                                        image: AssetImage(
                                          'assets/images/background/monthly_collection.png',
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    const Text(
                                      'Monthly Collection',
                                      style: TextStyle(
                                        fontFamily: 'Cera-Bold',
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    RevenueSharing()));
                      },
                      child: Container(
                        child: Column(
                          children: [
                            Material(
                              elevation: 20,
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.14,
                                width: MediaQuery.of(context).size.width * 0.9,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Colors.white, spreadRadius: 3),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.1,
                                      width: MediaQuery.of(context).size.width *
                                          0.7,
                                      child: const Image(
                                        image: AssetImage(
                                          'assets/images/background/revenue_sharing.png',
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    const Text(
                                      'Revenue Sharing',
                                      style: TextStyle(
                                          fontFamily: 'Cera-Bold',
                                          fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) => Payments()));
                      },
                      child: Container(
                        child: Column(
                          children: [
                            Material(
                              elevation: 20,
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.14,
                                width: MediaQuery.of(context).size.width * 0.9,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Colors.white, spreadRadius: 3),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.1,
                                      width: MediaQuery.of(context).size.width *
                                          0.7,
                                      child: const Image(
                                        image: AssetImage(
                                          'assets/images/background/payment.png',
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    const Text(
                                      'Payments',
                                      style: TextStyle(
                                          fontFamily: 'Cera-Bold',
                                          fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const CpeInventoryScreen()));
                      },
                      child: Container(
                        child: Column(
                          children: [
                            Material(
                              elevation: 20,
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.14,
                                width: MediaQuery.of(context).size.width * 0.9,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Colors.white, spreadRadius: 3),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.1,
                                      width: MediaQuery.of(context).size.width *
                                          0.7,
                                      child: const Image(
                                        image: AssetImage(
                                          'assets/images/background/inventory.png',
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    const Text(
                                      'CPE inventory',
                                      style: TextStyle(
                                          fontFamily: 'Cera-Bold',
                                          fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const AdditionalservicesScreen()));
                      },
                      child: Container(
                        child: Column(
                          children: [
                            Material(
                              elevation: 20,
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.14,
                                width: MediaQuery.of(context).size.width * 0.9,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Colors.white, spreadRadius: 3),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.1,
                                      width: MediaQuery.of(context).size.width *
                                          0.7,
                                      child: const Image(
                                        image: AssetImage(
                                          'assets/images/background/additional_services.png',
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    const Text(
                                      'Additional Services',
                                      style: TextStyle(
                                        fontFamily: 'Cera-Bold',
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  padding: const EdgeInsets.all(20),
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
                          ? const Text(
                              'Powered By APSFL',
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Cera-Bold',
                                fontSize: 16,
                              ),
                            )
                          : const Text(
                              'Powered By BBNL',
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Cera-Bold',
                                fontSize: 16,
                              ),
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
