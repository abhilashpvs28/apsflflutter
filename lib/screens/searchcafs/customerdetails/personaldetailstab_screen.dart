import 'dart:convert';

import 'package:apsfllmo/screens/searchcafs/customerdetails/customerdetailtab/hsiusagetab_screen.dart';
import 'package:apsfllmo/screens/searchcafs/customerdetails/customerdetailtab/invoicetab_screen.dart';
import 'package:apsfllmo/screens/searchcafs/customerdetails/customerdetailtab/ontdetailtab_screen.dart';
import 'package:apsfllmo/screens/searchcafs/customerdetails/customerdetailtab/packagedetailtab_screen.dart';
import 'package:apsfllmo/screens/searchcafs/customerdetails/customerdetailtab/voipusagetab_screen.dart';
import 'package:apsfllmo/utils/apiservice.dart';
import 'package:apsfllmo/utils/constants.dart';
import 'package:apsfllmo/utils/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class PersonaldetailstabScreen extends StatefulWidget {
  final int? caf_id; // Add a field to store caf_id
  const PersonaldetailstabScreen({super.key, this.caf_id});

  @override
  State<PersonaldetailstabScreen> createState() =>
      _PersonaldetailstabScreenState();
}

class _PersonaldetailstabScreenState extends State<PersonaldetailstabScreen>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _customer_details_names();
  }

  Future<void> _customer_details_names() async {
    final storage = FlutterSecureStorage();
    final String? token = await storage.read(key: 'token');

    if (token == null) {
      setState(() {
        //_isLoading = false;
      });
      print('Token is null');
      //return ;
    }

    final Map<String, String> headers = {
      'x-access-token': '$token',
      'Content-Type': 'application/json'
    };

    try {
      var url =
          Uri.parse(Constants.baseUrl + Apiservice.customer_details_names);
      print("url $url");
      final response = await http.get(url, headers: headers);

      print(' Response status: ${response.statusCode}');
      print(' Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> data = responseData['data'] ?? [];

        print('Data received from API: $data');
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Material(
                color: Colors.transparent,
                elevation: 20,
                child: Container(
                  // margin: EdgeInsets.symmetric(vertical: 6),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.07,
                  decoration: BoxDecoration(
                    color: Pallete.backgroundColor,
                    borderRadius: BorderRadius.circular(60),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    dividerColor: Colors.transparent,
                    indicatorColor: Pallete.buttonColor,
                    tabs: const [
                      Tab(
                        child: Column(
                          children: [
                            Icon(Icons.cloud_outlined),
                            Text(
                              'ONT DETAILS',
                              style: TextStyle(
                                fontSize: 8,
                                fontFamily: 'Cera-Bold',
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Tab(
                        child: Column(
                          children: [
                            Icon(Icons.beach_access_sharp),
                            Text(
                              'PACKAGE',
                              style: TextStyle(
                                fontSize: 8,
                                fontFamily: 'Cera-Bold',
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Tab(
                        child: Column(
                          children: [
                            Icon(Icons.cloud_outlined),
                            Text(
                              'VOIP USAGE',
                              style: TextStyle(
                                fontSize: 8,
                                fontFamily: 'Cera-Bold',
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Tab(
                        child: Column(
                          children: [
                            Icon(Icons.cloud_outlined),
                            Text(
                              'HSI USAGE',
                              style: TextStyle(
                                fontSize: 8,
                                fontFamily: 'Cera-Bold',
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Tab(
                        child: Column(
                          children: [
                            Icon(Icons.cloud_outlined),
                            Text(
                              'INVOICE',
                              style: TextStyle(
                                fontSize: 8,
                                fontFamily: 'Cera-Bold',
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              OntdetailtabScreen(caf_id: widget.caf_id),
              PackagedetailtabScreen(caf_id: widget.caf_id),
              VoipusagetabScreen(caf_id: widget.caf_id),
              HsiusagetabScreen(caf_id: widget.caf_id),
              InvoicetabScreen(caf_id: widget.caf_id),
            ],
          ),
        ),
      ],
    );
  }
}
