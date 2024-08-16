import 'package:accordion/accordion.dart'; // Import the accordion package
import 'package:apsfllmo/screens/additionalservices/addonpackage/addtoiptvcaf_screen.dart';
import 'package:apsfllmo/utils/apiservice.dart';
import 'package:apsfllmo/utils/constants.dart';
import 'package:apsfllmo/utils/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class StandardPurchaseaddonsScreen extends StatefulWidget {
  const StandardPurchaseaddonsScreen({super.key});

  @override
  State<StandardPurchaseaddonsScreen> createState() =>
      _StandardPurchaseaddonsScreenState();
}

class _StandardPurchaseaddonsScreenState
    extends State<StandardPurchaseaddonsScreen> {
  Future<List<dynamic>>? _dataFuture;
  List<int> _selectedIndices = [];
  List<Map<String, dynamic>> _selectedPackages =
      []; // Updated to store full package details
  Map<String, List<dynamic>> _channelsCache = {};
  double _totalPrice = 0.0;
  int _addonsCount = 0;

  @override
  void initState() {
    super.initState();
    _dataFuture = _fetchData();
  }

  Future<List<dynamic>> _fetchData() async {
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
      "data": {
        "srch_txt": "",
        "srch_ldng": false,
        "lmt_pstn": 0,
        "pcge_mde": "1",
        "agntId": 103000730
      }
    });

    print("renew_payloads $body");

    try {
      var url =
          Uri.parse(Constants.baseUrl + Apiservice.add_on_package_channels);
      print("url $url");
      final response = await http.post(url, headers: headers, body: body);
      ;

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> data = responseData['data'] ?? [];
        print('Data received: $data');
        return data;
      } else {
        print('Failed to fetch data. Status code: ${response.statusCode}');
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      print('Failed to fetch data: $e');
      return [];
    }
  }

  List<Map<String, dynamic>> _getSelectedPackages(List<dynamic> data) {
    return _selectedIndices.map((index) {
      final package = data[index];
      return {
        'srvcpk_id': package['srvcpk_id'],
        'pckge_nm': package['pckge_nm'],
        'ttl_cst': package['ttl_cst'],
        // Add more fields as needed
      };
    }).toList();
  }

  Future<void> _getChannels(String srvcpkId) async {
    final apiUrl = 'http://bss.apsfl.co.in/apiv1/package/getChannels/$srvcpkId';
    final storage = FlutterSecureStorage();
    final String? token = await storage.read(key: 'token');

    print('Retrieved token: $token');

    if (token == null) {
      print('Token is null');
      return;
    }

    final Map<String, String> headers = {
      'x-access-token': token,
      'Content-Type': 'application/json'
    };

    print('Request headers: $headers');

    try {
      final http.Response response = await http.get(
        Uri.parse(apiUrl),
        headers: headers,
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

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

  String _formatDate(String dateString) {
    final DateTime parsedDate = DateTime.parse(dateString);
    final DateFormat formatter = DateFormat('MMM dd, yyyy');
    return formatter.format(parsedDate);
  }

  void _updateSelection(
      int index, bool selected, double price, Map<String, dynamic> package) {
    setState(() {
      if (selected) {
        _selectedPackages.add(package); // Add full package details
        _totalPrice += price;
        _addonsCount += 1;
      } else {
        _selectedPackages.removeWhere((p) =>
            p['srvcpk_id'] == package['srvcpk_id']); // Remove package details
        _totalPrice -= price;
        _addonsCount -= 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Card(
        elevation: 10,
        shadowColor: Colors.amber,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.14,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        '$_addonsCount',
                        style: const TextStyle(
                            fontFamily: 'Cera-Bold', fontSize: 18),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Addons',
                        style: TextStyle(fontFamily: 'Cera-Bold', fontSize: 18),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        '₹ ${_totalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                            fontFamily: 'Cera-Bold', fontSize: 18),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Price',
                        style: TextStyle(fontFamily: 'Cera-Bold', fontSize: 18),
                      ),
                    ],
                  ),
                ],
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Pallete.buttonColor,
                ),
                onPressed: _totalPrice > 0
                    ? () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => AddtoiptvcafScreen(
                              selectedPackages:
                                  _selectedPackages, // Pass selected packages
                            ),
                          ),
                        );
                      }
                    : null,
                child: const Text(
                  'PURCHASE',
                  style: TextStyle(
                    fontFamily: 'Cera-Bold',
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _dataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available'));
          } else {
            final data = snapshot.data!;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final package = data[index];
                final isSelected = _selectedPackages
                    .any((p) => p['srvcpk_id'] == package['srvcpk_id']);
                final srvcpkId = package['srvcpk_id'].toString();
                final packagePrice = package['ttl_cst'];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            '${package['pckge_nm']}',
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
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        const Flexible(
                                          child: Text(
                                            'Total Channels :-',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: 'Cera-bold',
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Flexible(
                                          child: Text(
                                            '${package['chnls_cnt']}',
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
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '₹ ${package['ttl_cst']}',
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
                                          children: [
                                            Text(
                                              '₹ ${package['chrge_at']}',
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
                                          children: [
                                            Text(
                                              '₹ ${package['gst_at']}',
                                              style: const TextStyle(
                                                fontFamily: 'Cera-bold',
                                              ),
                                            ),
                                            const Text(
                                              'GST',
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
                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Checkbox(
                                    value: isSelected,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        _updateSelection(
                                          index,
                                          value!,
                                          packagePrice,
                                          package, // Pass full package details
                                        );
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
