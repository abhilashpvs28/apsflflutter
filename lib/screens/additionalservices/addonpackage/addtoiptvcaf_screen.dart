import 'package:apsfllmo/utils/apiservice.dart';
import 'package:apsfllmo/utils/constants.dart';
import 'package:apsfllmo/utils/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class AddtoiptvcafScreen extends StatefulWidget {
  final List selectedPackages;

  const AddtoiptvcafScreen({super.key, required this.selectedPackages});

  @override
  State<AddtoiptvcafScreen> createState() => _AddtoiptvcafScreenState();
}

class _AddtoiptvcafScreenState extends State<AddtoiptvcafScreen> {
  final TextEditingController _cafController = TextEditingController();
  Map<String, List<dynamic>> _channelsCache = {};
  Map<String, dynamic>? _customerData; // Added to store customer data

  @override
  void initState() {
    super.initState();
    // Log selected packages
    print('Selected Packages: ${widget.selectedPackages}');
  }

  Future<void> _getChannels(String srvcpkId) async {
    print('Inside _getChannels function for srvcpk_id: $srvcpkId');

    // final apiUrl = 'http://bss.apsfl.co.in/apiv1/package/getChannels/$srvcpkId';
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

    print('Request headers: $headers');

    try {
      var url = Uri.parse(Constants.baseUrl +
          Apiservice.add_on_package_get_cafs +
          '/$srvcpkId');
      print("url $url");
      final response = await http.get(url, headers: headers);

      print(' Response status: ${response.statusCode}');
      print(' Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> data = responseData['data'] ?? [];
        print('Channel data received: $data');
        setState(() {
          _channelsCache[srvcpkId] = data;
        });
      } else {
        print(
            'Failed to fetch channels data. Status code: ${response.statusCode}');
        throw Exception('Failed to fetch channels data');
      }
    } catch (e) {
      print('Failed to fetch channels data: $e');
    }
  }

  Future<void> _getCafCstmrDtls() async {
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
    print('Request headers: $headers');

    final body = jsonEncode({
      'data': {
        "agntId": agent_id,
        "caf_id": _cafController.text,
      },
    });

    print("renew_payloads $body");

    try {
      var url = Uri.parse(
          Constants.baseUrl + Apiservice.add_on_package_get_cstmrdtls);
      print("url $url");
      final response = await http.post(url, headers: headers, body: body);

      print("payment_status_code ${response.statusCode}");

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> data = responseData['data'] ?? [];
        print('Data received: $data');
        if (data.isNotEmpty) {
          setState(() {
            _customerData =
                data[0]; // Assuming you want the first customer in the list
          });
        }
      } else {
        print('Failed to fetch data. Status code: ${response.statusCode}');
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      print('Failed to fetch data: $e');
    }
  }

  String _formatDate(String dateString) {
    final DateTime parsedDate = DateTime.parse(dateString);
    final DateFormat formatter = DateFormat('MMM dd, yyyy');
    return formatter.format(parsedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        height: 20,
        color: Pallete.backgroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'LMO2000825',
              style: TextStyle(fontSize: 12, fontFamily: 'Cera-Bold'),
            ),
            Text(
              'V 5.9',
              style: TextStyle(fontSize: 12, fontFamily: 'Cera-Bold'),
            ),
            Text(
              'Powered by Greenlantern IT Solutions @ BBNL',
              style: TextStyle(fontSize: 12, fontFamily: 'Cera-Bold'),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text(
          'ADD TO IPTV CAF',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Cera-Bold',
            fontSize: 20,
          ),
        ),
        backgroundColor: Pallete.backgroundColor,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.replay,
              color: Colors.black,
            ),
            onPressed: () {
              // Add any relevant functionality here
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              elevation: 10,
              child: Column(
                children: [
                  SizedBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.05,
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: TextFormField(
                                controller: _cafController,
                                decoration: InputDecoration(
                                  labelText: 'Enter CAF No',
                                  labelStyle: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Cera-Bold'),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(40)),
                                  errorText: null,
                                ),
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.02,
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.05,
                              width: MediaQuery.of(context).size.width * 0.25,
                              child: ElevatedButton(
                                onPressed: () {
                                  // Fetch functionality
                                  _getCafCstmrDtls();
                                },
                                style: ButtonStyle(
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.red),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      side: const BorderSide(
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ),
                                child: const Text(
                                  'Fetch',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Cera-Bold'),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Customer details',
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Color.fromARGB(255, 31, 34, 169),
                                fontFamily: 'Cera-Bold'),
                          ),
                        ),
                        _customerData != null
                            ? Card(
                                elevation: 8,
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          _buildInfoRow(
                                              'Name',
                                              _customerData?['frst_nm'] ??
                                                  '' +
                                                      ' ' +
                                                      (_customerData?[
                                                              'lst_nm'] ??
                                                          'N/A'),
                                              Colors.grey[200]),
                                          _buildInfoRow(
                                              'Status',
                                              _customerData?['sts_nm'] ?? 'N/A',
                                              Colors.grey[50]),
                                          _buildInfoRow(
                                              'CAF No',
                                              _customerData?['caf_id']
                                                      .toString() ??
                                                  'N/A',
                                              Colors.grey[200]),
                                          _buildInfoRow(
                                              'Package',
                                              _customerData?['pkg_nm'] ?? 'N/A',
                                              Colors.grey[50]),
                                          _buildInfoRow(
                                              'Mobile No',
                                              _customerData?['mbl_nu']
                                                      .toString() ??
                                                  'N/A',
                                              Colors.grey[200]),
                                          _buildInfoRow(
                                              'Aadhaar',
                                              _customerData?['adhr_nu'] ??
                                                  'N/A',
                                              Colors.grey[50]),
                                          _buildInfoRow(
                                              'CAF Activated On',
                                              _customerData?['actvn_dt'] != null
                                                  ? _formatDate(_customerData![
                                                      'actvn_dt'])
                                                  : 'N/A',
                                              Colors.grey[200]),
                                        ],
                                      ),
                                    ),

                                    // enter the button here.
                                    const SizedBox(
                                      height: 10,
                                    ),

                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.05,
                                      width: MediaQuery.of(context).size.width *
                                          0.31,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          // Fetch functionality
                                          _getCafCstmrDtls();
                                        },
                                        style: ButtonStyle(
                                          foregroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.white),
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.red),
                                          shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              side: const BorderSide(
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                        ),
                                        child: const Text(
                                          'ADD TO CAF',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'Cera-Bold'),
                                        ),
                                      ),
                                    ),

                                    const SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Card(
              elevation: 10,
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Selected Packages',
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Color.fromARGB(255, 31, 34, 169),
                          fontFamily: 'Cera-Bold'),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.selectedPackages.length,
                      itemBuilder: (context, index) {
                        final package = widget.selectedPackages[index];
                        final packageName = package['pckge_nm'] ??
                            'Package Name'; // Adjusted key
                        final packagePrice =
                            package['ttl_cst'] ?? 'N/A'; // Adjusted key
                        final srvcpkId = package['srvcpk_id'].toString();
                        // Log package data
                        print('Package $index: $package');

                        return Card(
                          margin: const EdgeInsets.all(10),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          packageName,
                                          style: const TextStyle(
                                            color: Color.fromARGB(
                                                255, 17, 10, 162),
                                            fontFamily: 'Cera-bold',
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(
                                          '${_formatDate(package['efcte_dt'])}',
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontFamily: 'Cera-bold',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Row(
                                    children: [
                                      const Flexible(
                                        child: Text(
                                          'Total Channels:',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'Cera-bold',
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Flexible(
                                        child: Text(
                                          '${package['chnls_cnt'] ?? 'N/A'}', // Adjusted key
                                          style: const TextStyle(
                                            color: Colors.blue,
                                            fontFamily: 'Cera-bold',
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Divider(),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            '₹ ${package['ttl_cst'] ?? 'N/A'}', // Adjusted key
                                            style: const TextStyle(
                                              fontFamily: 'Cera-bold',
                                            ),
                                          ),
                                          const Text(
                                            'Total',
                                            style: TextStyle(
                                              fontFamily: 'Cera-bold',
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            '₹ ${package['chrge_at'] ?? 'N/A'}', // Adjusted key
                                            style: const TextStyle(
                                              fontFamily: 'Cera-bold',
                                            ),
                                          ),
                                          const Text(
                                            'Charge',
                                            style: TextStyle(
                                              fontFamily: 'Cera-bold',
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            '₹ ${package['gst_at'] ?? 'N/A'}', // Adjusted key
                                            style: const TextStyle(
                                              fontFamily: 'Cera-bold',
                                            ),
                                          ),
                                          const Text(
                                            'others',
                                            style: TextStyle(
                                              fontFamily: 'Cera-bold',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.blue.shade200,
                                  ),
                                  child: ExpansionTile(
                                    shape: const Border(),
                                    title: const Text(
                                      'Channels',
                                      style: TextStyle(
                                        fontFamily: 'Cera-Bold',
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    onExpansionChanged: (expanded) {
                                      if (expanded) {
                                        _getChannels(srvcpkId);
                                      }
                                    },
                                    children: _channelsCache
                                            .containsKey(srvcpkId)
                                        ? _channelsCache[srvcpkId]!
                                            .map<Widget>((channel) {
                                            return Container(
                                              color: Colors.white,
                                              child: ListTile(
                                                title:
                                                    Text(channel['chnle_nm']),
                                              ),
                                            );
                                          }).toList()
                                        : [
                                            const Center(
                                                child:
                                                    CircularProgressIndicator())
                                          ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String? value, Color? colorValue) {
    return Container(
      color: colorValue,
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            // color: Colors.green,
            width: MediaQuery.of(context).size.width * 0.3,
            child: Text(
              title,
              style:
                  const TextStyle(color: Colors.black, fontFamily: 'Cera-bold'),
            ),
          ),
          Container(
            // color: Colors.blue,
            // width: MediaQuery.of(context).size.width * 0.3,
            child: Flexible(
              child: Text(
                ":",
                style: const TextStyle(
                    color: Colors.black, fontFamily: 'Cera-bold'),
              ),
            ),
          ),
          Container(
            // color: Colors.yellow,
            // width: MediaQuery.of(context).size.width * 0.3,
            child: Expanded(
              child: Text(
                value ?? 'N/A',
                textAlign: TextAlign.right,
                style: const TextStyle(
                    color: Colors.black, fontFamily: 'Cera-bold'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
