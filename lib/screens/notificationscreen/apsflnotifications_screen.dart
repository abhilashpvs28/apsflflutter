import 'dart:convert';

import 'package:apsfllmo/screens/homescreen/home_screen.dart';
import 'package:apsfllmo/utils/apiservice.dart';
import 'package:apsfllmo/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../utils/pallete.dart';

class ApsflNotificationsScreen extends StatefulWidget {
  const ApsflNotificationsScreen({super.key});

  @override
  State<ApsflNotificationsScreen> createState() =>
      _ApsflNotificationsScreenState();
}

class _ApsflNotificationsScreenState extends State<ApsflNotificationsScreen> {
  List<Map<String, dynamic>> _dataList = [];
  bool _isLoading = false;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _fetchData();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchData() async {
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
        "lmo_agnt_id": agent_id,
        "app_id": 1,
        "app_vrsn": "",
        "ntfy_id": ""
      }
    });

    print("renew_payloads $body");

    var url = Uri.parse(Constants.baseUrl + Apiservice.notification);
    print("url $url");
    final response = await http.post(url, headers: headers, body: body);

    print("payment_status_code ${response.statusCode}");

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<dynamic> data = responseData['data'] ?? [];
      print('Data received: $data');
      setState(() {
        _dataList = data.cast<Map<String, dynamic>>();
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

  Future<void> _updateNotificationData(int ntfyId, int index) async {
    print('Inside updateNotificationData function');
    final storage = FlutterSecureStorage();
    final String? token = await storage.read(key: 'token');
    print('Retrieved token: $token');

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
      'data': {"ntfy_id": ntfyId, "seen": 1}
    });

    print("renew_payloads $body");
    print('Request headers: $headers');

    setState(() {
      _dataList[index]['seen'] = 1;
    });

    print("renew_payloads $body");

    var url = Uri.parse(Constants.baseUrl + Apiservice.notification_update);
    print("url $url");
    final response = await http.post(url, headers: headers, body: body);

    print("payment_status_code ${response.statusCode}");

    if (response.statusCode != 200) {
      print(
          'Failed to update notification. Status code: ${response.statusCode}');
      setState(() {
        _dataList[index]['seen'] = 0;
      });
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _fetchData();
    }
  }

  String _formatDateTime(String dateTime) {
    final DateTime parsedDate = DateTime.parse(dateTime);
    final DateFormat formatter = DateFormat('dd-MMM-yyyy h:mm a');
    return formatter.format(parsedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Pallete.backgroundColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return HomeScreen();
            }));
          },
        ),
        title: const Text(
          'Notification',
          style: TextStyle(
            fontFamily: 'Cera-Bold',
            color: Colors.white,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: _dataList.length + (_isLoading ? 1 : 0),
        itemBuilder: (context, index) {
          if (index < _dataList.length) {
            final Map<String, dynamic> item = _dataList[index];
            final bool isSeen = item['seen'] == 1;
            return GestureDetector(
              onTap: () async {
                await _updateNotificationData(item['ntfy_id'], index);
              },
              child: ListTile(
                title: Column(
                  children: [
                    Card(
                      color: isSeen
                          ? Colors.white
                          : Color.fromARGB(255, 198, 220, 181),
                      elevation: 6,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '${item['ntfy_hdr'] ?? 'Unknown'}',
                                style: const TextStyle(
                                  fontFamily: 'Cera-Bold',
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '${item['ntfy_bdy'] ?? 'Unknown'}',
                                style: const TextStyle(
                                  fontFamily: 'Cera-Medium',
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                '${item['date_time'] != null ? _formatDateTime(item['date_time']) : 'Unknown'}',
                                style: const TextStyle(
                                  fontFamily: 'Cera-Medium',
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
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
        controller: _scrollController,
      ),
    );
  }
}
