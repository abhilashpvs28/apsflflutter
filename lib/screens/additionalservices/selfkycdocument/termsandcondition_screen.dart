import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:apsfllmo/utils/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class TermsandconditionScreen extends StatefulWidget {
  const TermsandconditionScreen({super.key});

  @override
  State<TermsandconditionScreen> createState() =>
      _TermsandconditionScreenState();
}

class _TermsandconditionScreenState extends State<TermsandconditionScreen> {
  String _htmlContent = "";

  Future<void> _terms_cndtnRtr() async {
    print('Inside fetchData function');

    final apiUrl = 'http://bss.apsfl.co.in/apiv1/lmo/terms_cndtnRtr';
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
        print('Data received from cpe information: $data');

        if (data.isNotEmpty) {
          String htmlContent = data[0]['trms_html_tx'] ?? "";

          // Remove the image tag
          final imageTagRegex = RegExp(r'<img[^>]*>');
          htmlContent = htmlContent.replaceAll(imageTagRegex, '');

          setState(() {
            _htmlContent = htmlContent;
          });
        }
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      print('Failed to fetch data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _terms_cndtnRtr();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Pallete.backgroundColor,
          title: const Text(
            'Terms & Conditions ',
            style: TextStyle(
              fontFamily: 'Cera-Bold',
              fontSize: 18,
              color: Colors.black,
            ),
          ),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: const Icon(
                Icons.close,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
        bottomNavigationBar: Container(
          height: MediaQuery.of(context).size.height * 0.03,
          color: Pallete.backgroundColor,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'LMO2000825',
                style: TextStyle(fontSize: 10, fontFamily: 'Cera-Bold'),
              ),
              Text(
                'V 5.9',
                style: TextStyle(fontSize: 10, fontFamily: 'Cera-Bold'),
              ),
              Text(
                'Powered by Greenlantern IT Solutions @ BBNL',
                style: TextStyle(fontSize: 10, fontFamily: 'Cera-Bold'),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Material(
                  elevation: 10,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          HtmlWidget(_htmlContent),
                          // SizedBox(height: 10),
                        ]),
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
