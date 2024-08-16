import 'dart:convert';

import 'package:apsfllmo/utils/apiservice.dart';
import 'package:apsfllmo/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class InvoicetabScreen extends StatefulWidget {
  final int? caf_id; // Add a field to store caf_id
  const InvoicetabScreen({super.key, this.caf_id});

  @override
  State<InvoicetabScreen> createState() => _InvoicetabScreenState();
}

class _InvoicetabScreenState extends State<InvoicetabScreen> {
  void initState() {
    super.initState();
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
      var url = Uri.parse(Constants.baseUrl +
          Apiservice.customer_details_voipusage +
          widget.caf_id.toString() +
          '2024');
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
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        elevation: 10,
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      child: const Text(
                        'Operational State',
                        style: TextStyle(fontSize: 14, fontFamily: 'Cera-Bold'),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      child: const Text(
                        'Virat Kohli',
                        style: TextStyle(fontSize: 14, fontFamily: 'Cera-Bold'),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
