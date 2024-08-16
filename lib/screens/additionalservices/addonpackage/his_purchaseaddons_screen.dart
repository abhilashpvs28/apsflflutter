import 'package:apsfllmo/utils/apiservice.dart';
import 'package:apsfllmo/utils/constants.dart';
import 'package:apsfllmo/utils/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class HisPurchaseaddonsScreen extends StatefulWidget {
  const HisPurchaseaddonsScreen({super.key});

  @override
  State<HisPurchaseaddonsScreen> createState() =>
      _HisPurchaseaddonsScreenState();
}

class _HisPurchaseaddonsScreenState extends State<HisPurchaseaddonsScreen> {
  bool _isLoading = false;
  List<dynamic> _data = [];
  int? _selectedIndex; // To track the index of the selected checkbox
  double _totalPrice = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final storage = FlutterSecureStorage();
    final String? token = await storage.read(key: 'token');
    final String? agent_id = await storage.read(key: 'usr_ctgry_ky');

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
        "srch_txt": "",
        "srch_ldng": false,
        "lmt_pstn": 0,
        "pcge_mde": "1",
        "agntId": agent_id
      }
    });

    print("renew_payloads $body");
    print('Request headers: $headers');

    try {
      var url = Uri.parse(Constants.baseUrl + Apiservice.add_on_package_list);
      print("url $url");
      final response = await http.post(url, headers: headers, body: body);

      print("payment_status_code ${response.statusCode}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> data = responseData['data'] ?? [];
        setState(() {
          _data = data;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Failed to fetch data: $e');
    }
  }

  Future<void> _addHSICafPckgs_newversion() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });

    final storage = FlutterSecureStorage();
    final String? token = await storage.read(key: 'token');
    final String? agent_id = await storage.read(key: 'usr_ctgry_ky');

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

    final body = jsonEncode({
      "data": {
        "aaa_cd": "lag:193013:1:1:112",
        "aaa_prfl_nm": "20Mbps_UP_50Mbps_DOWN",
        "add_on_hsi_pckg": "30",
        "agntId": agent_id,
        "caf_id": 200132645,
        "caf_type_id": 1,
        "crnt_pln_id": 3000106,
        "extrnl_api_post_json": {
          "servicepacks": [
            {"expirydate": "99991231", "servicepack": "Data Mini"}
          ],
          "subscribercode": "KRI1065888"
        },
        "nw_hsi_pckge": 10030,
        "pckg_lst": [
          {
            "agent_id": agent_id,
            "caf_id": 200132645,
            "chrge_at": 49.0,
            "efcte_dt": "2020-07-07",
            "expanded": false,
            "expry_dt": "9999-12-31",
            "extrnl_api_expry_dt": "99991231",
            "gst_at": 8.8,
            "iptv_mac_addr_tx": "9C:65:EE:4C:4E:AC",
            "isChecked": false,
            "pckge_id": 3000007,
            "pckge_nm": "Data Mini",
            "pkcge_idnty": 1,
            "prpry_nm": "Data Mini",
            "s_no": 2,
            "srvcpk_id": 3000003,
            "srvcpk_nm": "Data Mini",
            "ttl_cst": 57.8,
            "vle_tx": "30"
          }
        ],
        "prsnt_hsi_pckge": 10000
      }
    });

    print("renew_payloads $body");

    try {
      var url = Uri.parse(Constants.baseUrl + Apiservice.add_on_package_submit);
      print("url $url");
      final response = await http.post(url, headers: headers, body: body);

      print("payment_status_code ${response.statusCode}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> data = responseData['data'] ?? [];
        setState(() {
          _data = data;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Failed to fetch data: $e');
    }
  }

  String _formatDate(String dateString) {
    final DateTime parsedDate = DateTime.parse(dateString);
    final DateFormat formatter = DateFormat('MMM dd, yyyy');
    return formatter.format(parsedDate);
  }

  void _onCheckboxChanged(int index, bool selected) {
    setState(() {
      if (selected) {
        _selectedIndex = index;
        _totalPrice = _data[index]['ttl_cst'];
      } else {
        _selectedIndex = null;
        _totalPrice = 0.0;
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
          height: MediaQuery.of(context).size.height * 0.13,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      SizedBox(height: 10),
                      Text(
                        '₹ $_totalPrice',
                        style: TextStyle(fontFamily: 'Cera-Bold', fontSize: 18),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Addons',
                        style: TextStyle(fontFamily: 'Cera-Bold', fontSize: 18),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        _selectedIndex != null ? '1' : '0',
                        style: TextStyle(fontFamily: 'Cera-Bold', fontSize: 18),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Selected',
                        style: TextStyle(fontFamily: 'Cera-Bold', fontSize: 18),
                      ),
                    ],
                  ),
                ],
              ),
              _selectedIndex != null
                  ? ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Pallete.buttonColor,
                      ),
                      onPressed: () {
                        // Handle purchase action
                        _addHSICafPckgs_newversion();
                      },
                      child: const Text(
                        'PURCHASE',
                        style: TextStyle(
                          fontFamily: 'Cera-Bold',
                          color: Colors.white,
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _data.length,
              itemBuilder: (context, index) {
                final package = _data[index];
                final bool isSelected = _selectedIndex == index;
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.75,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${package['pckge_nm']}',
                                      style: const TextStyle(
                                        color: Color.fromARGB(255, 17, 10, 162),
                                        fontFamily: 'Cera-bold',
                                      ),
                                    ),
                                    Text(
                                      '${_formatDate(package['efcte_dt'])}',
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontFamily: 'Cera-bold',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(),
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
                                          'Others',
                                          style: TextStyle(
                                            fontFamily: 'Cera-bold',
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
                        Container(
                          child: Checkbox(
                            value: isSelected,
                            onChanged: (bool? value) {
                              _onCheckboxChanged(index, value!);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
