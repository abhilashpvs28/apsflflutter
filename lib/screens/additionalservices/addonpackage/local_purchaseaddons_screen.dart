import 'package:apsfllmo/utils/apiservice.dart';
import 'package:apsfllmo/utils/constants.dart';
import 'package:apsfllmo/utils/pallete.dart';
import 'package:apsfllmo/widgets/nodatafound_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LocalPurchaseAddonsScreen extends StatefulWidget {
  const LocalPurchaseAddonsScreen({super.key});

  @override
  State<LocalPurchaseAddonsScreen> createState() =>
      _LocalPurchaseAddonsScreenState();
}

class _LocalPurchaseAddonsScreenState extends State<LocalPurchaseAddonsScreen> {
  List<dynamic> _data = [];
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchData();
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
        "agntId": agent_id,
        "lmt_pstn": 0,
        "pcge_mde": 1,
        "srch_ldng": false,
        "srch_txt": ""
      }
    });

    print("renew_payloads $body");

    try {
      var url = Uri.parse(
          Constants.baseUrl + Apiservice.add_on_package_channels_local);
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
          _hasError = true;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
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
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        '₹ 0',
                        style: TextStyle(fontFamily: 'Cera-Bold', fontSize: 18),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        'Addons',
                        style: TextStyle(fontFamily: 'Cera-Bold', fontSize: 18),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        '₹ 0',
                        style: TextStyle(fontFamily: 'Cera-Bold', fontSize: 18),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        'Price',
                        style: TextStyle(fontFamily: 'Cera-Bold', fontSize: 18),
                      )
                    ],
                  ),
                ],
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Pallete.buttonColor,
                ),
                onPressed: () {},
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
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _data.isEmpty
              ? Center(child: NodatafoundScreen())
              : SingleChildScrollView(
                  child: Container(
                    color: Pallete.backgroundColor,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'Standard Add On Package',
                          style: TextStyle(
                            fontFamily: 'Cera-Bold',
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: _data.length,
                          itemBuilder: (context, index) {
                            final item = _data[index];
                            return ListTile(
                              title: Text(item['name'] ?? 'No Name'),
                              subtitle:
                                  Text('Price: ₹${item['price'] ?? 'N/A'}'),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
