import 'dart:convert';
import 'package:apsfllmo/utils/apiservice.dart';
import 'package:apsfllmo/utils/constants.dart';
import 'package:apsfllmo/utils/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class PersonaldetailsScreen extends StatefulWidget {
  final int? caf_id; // Add a field to store caf_id
  const PersonaldetailsScreen({super.key, this.caf_id});

  @override
  State<PersonaldetailsScreen> createState() => _PersonaldetailsScreenState();
}

class _PersonaldetailsScreenState extends State<PersonaldetailsScreen>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  bool isShow = true;
  bool _isLoading = false;
  List<dynamic> data_array = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    customer_details_profile();
  }

  Future<void> customer_details_profile() async {
    final storage = FlutterSecureStorage();
    final String? token = await storage.read(key: 'token');
    final String? agent_id = await storage.read(key: 'usr_ctgry_ky');

    print('Retrieved token: $token');
    print('usercategory_key $agent_id');

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

    print('refresh_api_headers $headers');

    final url = Uri.parse(Constants.baseUrl +
        Apiservice.customer_details_profile +
        widget.caf_id.toString());
    // final url = Uri.parse(Constants.baseUrl+Apiservice.customer_details_profile+widget.boxExchangeModel.caf_id.toString());
    print("url $url");
    final response = await http.get(url, headers: headers);
    _isLoading = true;
    print("response_code ${response.statusCode}");
    if (response.statusCode == 200) {
      // Handle successful response
      setState(() {
        _isLoading = false;
        print('box_chng_refresh data: ${response.body}');
        final res = json.decode(response.body);
        data_array = res['data']; // Ensure data_array is a class-level variable
        print('$data_array');
      });
    } else {
      // Handle error response
      setState(() {
        _isLoading = false;
      });
      final res = json.decode(response.body);
      print('Error: ${res['message']}');
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : ListView.builder(
            shrinkWrap: true, // Add this to prevent layout issues
            physics:
                NeverScrollableScrollPhysics(), // Prevent scrolling inside ListView
            itemCount: data_array.length,
            itemBuilder: (context, index) {
              final item = data_array[index];
              return Material(
                  elevation: 10,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        Container(
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 208, 236, 248),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.44,
                                // color: Colors.blue,
                                child: const Text(
                                  'Name',
                                  style: TextStyle(
                                      fontSize: 14, fontFamily: 'Cera-Bold'),
                                ),
                              ),
                              Container(
                                // color: Colors.greenAccent,
                                width: MediaQuery.of(context).size.width * 0.01,
                                child: const Text(
                                  ':',
                                  style: TextStyle(
                                      fontSize: 14, fontFamily: 'Cera-Bold'),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(left: 10),
                                // color: Colors.greenAccent,
                                width: MediaQuery.of(context).size.width * 0.46,
                                child: Text(
                                  '${item['cstmr_nm']}',
                                  style: TextStyle(
                                      fontSize: 14, fontFamily: 'Cera-Bold'),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 255, 255, 255),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.44,
                                // color: Colors.blue,
                                child: const Text(
                                  'CAF NO',
                                  style: TextStyle(
                                      fontSize: 14, fontFamily: 'Cera-Bold'),
                                ),
                              ),
                              Container(
                                // color: Colors.greenAccent,
                                width: MediaQuery.of(context).size.width * 0.01,
                                child: const Text(
                                  ':',
                                  style: TextStyle(
                                      fontSize: 14, fontFamily: 'Cera-Bold'),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(left: 10),
                                // color: Colors.greenAccent,
                                width: MediaQuery.of(context).size.width * 0.46,
                                child: Text(
                                  '${item['caf_id']}',
                                  style: TextStyle(
                                      fontSize: 14, fontFamily: 'Cera-Bold'),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 208, 236, 248),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.44,
                                // color: Colors.blue,
                                child: const Text(
                                  'Connection Type',
                                  style: TextStyle(
                                      fontSize: 14, fontFamily: 'Cera-Bold'),
                                ),
                              ),
                              Container(
                                // color: Colors.greenAccent,
                                width: MediaQuery.of(context).size.width * 0.01,
                                child: const Text(
                                  ':',
                                  style: TextStyle(
                                      fontSize: 14, fontFamily: 'Cera-Bold'),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 10),
                                // color: Colors.greenAccent,
                                width: MediaQuery.of(context).size.width * 0.46,
                                child: Text(
                                  '${item['caf_type_nm']}',
                                  style: TextStyle(
                                      fontSize: 14, fontFamily: 'Cera-Bold'),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 255, 255, 255),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.44,
                                // color: Colors.blue,
                                child: const Text(
                                  'Connection Status',
                                  style: TextStyle(
                                      fontSize: 14, fontFamily: 'Cera-Bold'),
                                ),
                              ),
                              Container(
                                // color: Colors.greenAccent,
                                width: MediaQuery.of(context).size.width * 0.01,
                                child: const Text(
                                  ':',
                                  style: TextStyle(
                                      fontSize: 14, fontFamily: 'Cera-Bold'),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(left: 10),
                                // color: Colors.greenAccent,
                                width: MediaQuery.of(context).size.width * 0.46,
                                child: Text(
                                  '${item['sts_nm']}',
                                  style: TextStyle(
                                      fontSize: 14, fontFamily: 'Cera-Bold'),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 208, 236, 248),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.44,
                                // color: Colors.blue,
                                child: const Text(
                                  'Caf Activated On',
                                  style: TextStyle(
                                      fontSize: 14, fontFamily: 'Cera-Bold'),
                                ),
                              ),
                              Container(
                                // color: Colors.greenAccent,
                                width: MediaQuery.of(context).size.width * 0.01,
                                child: const Text(
                                  ':',
                                  style: TextStyle(
                                      fontSize: 14, fontFamily: 'Cera-Bold'),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(left: 10),
                                // color: Colors.greenAccent,
                                width: MediaQuery.of(context).size.width * 0.46,
                                child: Text(
                                  '${item['actvn_ts']}',
                                  style: TextStyle(
                                      fontSize: 14, fontFamily: 'Cera-Bold'),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 255, 255, 255),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.44,
                                // color: Colors.blue,
                                child: Text(
                                  'Mobile No',
                                  style: TextStyle(
                                      fontSize: 14, fontFamily: 'Cera-Bold'),
                                ),
                              ),
                              Container(
                                // color: Colors.greenAccent,
                                width: MediaQuery.of(context).size.width * 0.01,
                                child: const Text(
                                  ':',
                                  style: TextStyle(
                                      fontSize: 14, fontFamily: 'Cera-Bold'),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 10),
                                // color: Colors.greenAccent,
                                width: MediaQuery.of(context).size.width * 0.46,
                                child: Text(
                                  '${item['mbl_nu']}',
                                  style: TextStyle(
                                      fontSize: 14, fontFamily: 'Cera-Bold'),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 255, 255, 255),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.44,
                                // color: Colors.blue,
                                child: const Text(
                                  'Subscribe Code',
                                  style: TextStyle(
                                      fontSize: 14, fontFamily: 'Cera-Bold'),
                                ),
                              ),
                              Container(
                                // color: Colors.greenAccent,
                                width: MediaQuery.of(context).size.width * 0.01,
                                child: const Text(
                                  ':',
                                  style: TextStyle(
                                      fontSize: 14, fontFamily: 'Cera-Bold'),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 10),
                                // color: Colors.greenAccent,
                                width: MediaQuery.of(context).size.width * 0.46,
                                child: Text(
                                  '${item['mdlwe_sbscr_id']}',
                                  style: TextStyle(
                                      fontSize: 14, fontFamily: 'Cera-Bold'),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 208, 236, 248),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.44,
                                // color: Colors.blue,
                                child: const Text(
                                  'Olt Name',
                                  style: TextStyle(
                                      fontSize: 14, fontFamily: 'Cera-Bold'),
                                ),
                              ),
                              Container(
                                // color: Colors.greenAccent,
                                width: MediaQuery.of(context).size.width * 0.01,
                                child: const Text(
                                  ':',
                                  style: TextStyle(
                                      fontSize: 14, fontFamily: 'Cera-Bold'),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(left: 10),
                                // color: Colors.greenAccent,
                                width: MediaQuery.of(context).size.width * 0.46,
                                child: Text(
                                  '${item['olt_nm']}',
                                  style: TextStyle(
                                      fontSize: 14, fontFamily: 'Cera-Bold'),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.44,
                                // color: Colors.blue,
                                child: Text(
                                  'OLT Port Name',
                                  style: TextStyle(
                                      fontSize: 14, fontFamily: 'Cera-Bold'),
                                ),
                              ),
                              Container(
                                // color: Colors.greenAccent,
                                width: MediaQuery.of(context).size.width * 0.01,
                                child: const Text(
                                  ':',
                                  style: TextStyle(
                                      fontSize: 14, fontFamily: 'Cera-Bold'),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 10),
                                // color: Colors.greenAccent,
                                width: MediaQuery.of(context).size.width * 0.46,
                                child: Text(
                                  '${item['olt_prt_nm']}',
                                  style: TextStyle(
                                      fontSize: 14, fontFamily: 'Cera-Bold'),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 208, 236, 248),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.44,
                                // color: Colors.blue,
                                child: const Text(
                                  'OLT Card Number',
                                  style: TextStyle(
                                      fontSize: 14, fontFamily: 'Cera-Bold'),
                                ),
                              ),
                              Container(
                                // color: Colors.greenAccent,
                                width: MediaQuery.of(context).size.width * 0.01,
                                child: const Text(
                                  ':',
                                  style: TextStyle(
                                      fontSize: 14, fontFamily: 'Cera-Bold'),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 10),
                                // color: Colors.greenAccent,
                                width: MediaQuery.of(context).size.width * 0.46,
                                child: Text(
                                  '${item['olt_crd_nu']}',
                                  style: TextStyle(
                                      fontSize: 14, fontFamily: 'Cera-Bold'),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.44,
                                // color: Colors.blue,
                                child: Text(
                                  'OLT Split',
                                  style: TextStyle(
                                      fontSize: 14, fontFamily: 'Cera-Bold'),
                                ),
                              ),
                              Container(
                                // color: Colors.greenAccent,
                                width: MediaQuery.of(context).size.width * 0.01,
                                child: const Text(
                                  ':',
                                  style: TextStyle(
                                      fontSize: 14, fontFamily: 'Cera-Bold'),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 10),
                                // color: Colors.greenAccent,
                                width: MediaQuery.of(context).size.width * 0.46,
                                child: Text(
                                  '${item['olt_prt_splt_tx']}',
                                  style: TextStyle(
                                      fontSize: 14, fontFamily: 'Cera-Bold'),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        isShow
                            ? Container()
                            : Column(children: [
                                Container(
                                  padding: EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 208, 236, 248),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.44,
                                        // color: Colors.blue,
                                        child: Text(
                                          'CPE Rental',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: 'Cera-Bold'),
                                        ),
                                      ),
                                      Container(
                                        // color: Colors.greenAccent,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.01,
                                        child: const Text(
                                          ':',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: 'Cera-Bold'),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(left: 10),
                                        // color: Colors.greenAccent,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.46,
                                        child: const Text(
                                          '₹ 50',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: 'Cera-Bold'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10),
                                Container(
                                  padding: EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.44,
                                        // color: Colors.blue,
                                        child: Text(
                                          'Telephone Connection',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: 'Cera-Bold'),
                                        ),
                                      ),
                                      Container(
                                        // color: Colors.greenAccent,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.01,
                                        child: const Text(
                                          ':',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: 'Cera-Bold'),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(left: 10),
                                        // color: Colors.greenAccent,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.46,
                                        child: Text(
                                          '${item['phne_nu_cnt']}',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: 'Cera-Bold'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10),
                                Container(
                                  padding: EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 208, 236, 248),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.44,
                                        // color: Colors.blue,
                                        child: Text(
                                          'Telephone Number',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: 'Cera-Bold'),
                                        ),
                                      ),
                                      Container(
                                        // color: Colors.greenAccent,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.01,
                                        child: const Text(
                                          ':',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: 'Cera-Bold'),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(left: 10),
                                        // color: Colors.greenAccent,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.46,
                                        child: Text(
                                          '${item['phne_nu']}',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: 'Cera-Bold'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10),
                                Container(
                                  padding: EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.44,
                                        // color: Colors.blue,
                                        child: Text(
                                          'Address',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: 'Cera-Bold'),
                                        ),
                                      ),
                                      Container(
                                        // color: Colors.greenAccent,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.01,
                                        child: const Text(
                                          ':',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: 'Cera-Bold'),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(left: 10),
                                        // color: Colors.greenAccent,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.46,
                                        child: Text(
                                          '${item['adrss']}',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: 'Cera-Bold'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10),
                                Container(
                                  padding: EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 208, 236, 248),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.44,
                                        // color: Colors.blue,
                                        child: Text(
                                          'Email',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: 'Cera-Bold'),
                                        ),
                                      ),
                                      Container(
                                        // color: Colors.greenAccent,

                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.01,
                                        child: const Text(
                                          ':',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: 'Cera-Bold'),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(left: 10),
                                        // color: Colors.greenAccent,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.46,
                                        child: Text(
                                          '${item['email']}',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: 'Cera-Bold'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10),
                                Container(
                                  padding: EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.44,
                                        // color: Colors.blue,
                                        child: Text(
                                          'ONU Serial Number',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: 'Cera-Bold'),
                                        ),
                                      ),
                                      Container(
                                        // color: Colors.greenAccent,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.01,
                                        child: const Text(
                                          ':',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: 'Cera-Bold'),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(left: 10),
                                        // color: Colors.greenAccent,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.46,
                                        child: Text(
                                          '${item['onu_srl_nu']}',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: 'Cera-Bold'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10),
                                Container(
                                  padding: EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 208, 236, 248),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.44,
                                        // color: Colors.blue,
                                        child: Text(
                                          'ONU MAC Address',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: 'Cera-Bold'),
                                        ),
                                      ),
                                      Container(
                                        // color: Colors.greenAccent,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.01,
                                        child: const Text(
                                          ':',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: 'Cera-Bold'),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(left: 10),
                                        // color: Colors.greenAccent,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.46,
                                        child: Text(
                                          '${item['onu_mac_addr_tx']}',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: 'Cera-Bold'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10),
                                Container(
                                  padding: EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.44,
                                        // color: Colors.blue,
                                        child: Text(
                                          'IPTV Serial Number',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: 'Cera-Bold'),
                                        ),
                                      ),
                                      Container(
                                        // color: Colors.greenAccent,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.01,
                                        child: const Text(
                                          ':',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: 'Cera-Bold'),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(left: 10),
                                        // color: Colors.greenAccent,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.46,
                                        child: Text(
                                          '${item['iptv_srl_nu']}',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: 'Cera-Bold'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10),
                                Container(
                                  padding: EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 208, 236, 248),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.44,
                                        // color: Colors.blue,
                                        child: Text(
                                          'IPTV MAC Address',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: 'Cera-Bold'),
                                        ),
                                      ),
                                      Container(
                                        // color: Colors.greenAccent,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.01,
                                        child: const Text(
                                          ':',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: 'Cera-Bold'),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(left: 10),
                                        // color: Colors.greenAccent,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.46,
                                        child: Text(
                                          '${item['iptv_mac_addr_tx']}',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: 'Cera-Bold'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ]),
                        Container(
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 255, 255, 255),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                // color: Colors.greenAccent,
                                // width: MediaQuery.of(context).size.width * 0.01,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Pallete.buttonColor),
                                  onPressed: () {},
                                  child: const Text(
                                    'Box Reboot',
                                    style: TextStyle(
                                      fontFamily: 'Cera-Bold',
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 10),
                                // color: Colors.greenAccent,
                                // width: MediaQuery.of(context).size.width * 0.46,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue),
                                  onPressed: () {
                                    setState(() {
                                      isShow = !isShow;
                                    });
                                  },
                                  child: Text(
                                    isShow ? 'Show More' : 'Show Less',
                                    style: const TextStyle(
                                      fontFamily: 'Cera-Bold',
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ));
            });
  }
}
