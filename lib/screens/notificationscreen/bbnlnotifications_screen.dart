import 'dart:convert';

import 'package:apsfllmo/screens/homescreen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../utils/pallete.dart';

class BbnlNotificationsScreen extends StatefulWidget {
  const BbnlNotificationsScreen({super.key});

  @override
  State<BbnlNotificationsScreen> createState() => _BbnlNotificationsScreenState();
}

class _BbnlNotificationsScreenState extends State<BbnlNotificationsScreen> {
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
    print('Inside fetchData function');
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    const apiUrl = 'https://bbnlbss.apsfl.co.in/apiv1/lmoprepaid/getnotificationdata';
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

    final Map<String, dynamic> requestBody = {
      "data": {
        "lmo_agnt_id": 103000730,
        "app_id": 1,
        "app_vrsn": "",
        "ntfy_id": ""
      }
    };

    print('Request headers: $headers');
    print('Request body: ${json.encode(requestBody)}');

    final http.Response response = await http.post(
      Uri.parse(apiUrl),
      headers: headers,
      body: json.encode(requestBody),
    );

    print('Response status code: ${response.statusCode}');
    print('Response body: ${response.body}');

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
    const apiUrl = 'https://bbnlbss.apsfl.co.in/apiv1/lmoprepaid/updatenotificationdata';
    final storage = FlutterSecureStorage();
    final String? token = await storage.read(key: 'token');

    if (token == null) {
      print('Token is null');
      return;
    }

    final Map<String, String> headers = {
      'x-access-token': token,
      'Content-Type': 'application/json'
    };

    final Map<String, dynamic> requestBody = {
      "data": {
        "ntfy_id": ntfyId,
        "seen": 1
      }
    };

    print('Request headers: $headers');
    print('Request body: ${json.encode(requestBody)}');

    setState(() {
      _dataList[index]['seen'] = 1;
    });

    final http.Response response = await http.post(
      Uri.parse(apiUrl),
      headers: headers,
      body: json.encode(requestBody),
    );

    print('Response status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode != 200) {
      print('Failed to update notification. Status code: ${response.statusCode}');
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
                      color: isSeen ? Colors.white : Color.fromARGB(255, 198, 220, 181),
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
