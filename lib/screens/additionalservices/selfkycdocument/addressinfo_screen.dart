import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddressInfo extends StatefulWidget {
  @override
  State<AddressInfo> createState() => _AddressInfoState();
}

class _AddressInfoState extends State<AddressInfo> {
  final TextEditingController _buildinghouseController =
      TextEditingController();

  final TextEditingController _localityAreaController = TextEditingController();

  final TextEditingController _districtController = TextEditingController();

  final TextEditingController _mandalController = TextEditingController();

  final TextEditingController _villageController = TextEditingController();

  final TextEditingController _pinCodeController = TextEditingController();

  final TextEditingController _kycProofController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _dstrctlst();
  }

  Future<void> _dstrctlst() async {
    final apiUrl = 'http://bss.apsfl.co.in/apiv1/subscriberApp/dstrctlst';
    final storage = FlutterSecureStorage();
    final String? token = await storage.read(key: 'token');

    if (token == null) {
      return;
    }

    final Map<String, String> headers = {
      'x-access-token': token,
      'Content-Type': 'application/json'
    };

    try {
      final http.Response response = await http.get(
        Uri.parse(apiUrl),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> data = responseData['data'] ?? [];

        print('dstrctlst: $data');
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      print('Failed to fetch data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Material(
        elevation: 10,
        child: Container(
          padding: EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              const Text(
                'Address',
                style: TextStyle(fontSize: 18, fontFamily: 'Cera-Bold'),
              ),
              SizedBox(height: 20),
              const Text(
                'Building/House/Flat',
                style: TextStyle(fontSize: 14, fontFamily: 'Cera-Bold'),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _buildinghouseController,
                decoration: InputDecoration(
                  labelText: 'Enter Building/House/Flat',
                  labelStyle: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cera-Bold',
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40)),
                ),
                keyboardType: TextInputType.name,
              ),
              SizedBox(height: 10),
              const Text(
                'Locality/Area',
                style: TextStyle(fontSize: 14, fontFamily: 'Cera-Bold'),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _localityAreaController,
                decoration: InputDecoration(
                  labelText: 'Enter Locality/Area',
                  labelStyle: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cera-Bold',
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40)),
                ),
                keyboardType: TextInputType.name,
              ),
              SizedBox(height: 10),
              const Text(
                'District',
                style: TextStyle(fontSize: 14, fontFamily: 'Cera-Bold'),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _districtController,
                decoration: InputDecoration(
                  labelText: 'Enter District',
                  labelStyle: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cera-Bold',
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40)),
                ),
                keyboardType: TextInputType.name,
              ),
              SizedBox(height: 10),
              const Text(
                'Mandal',
                style: TextStyle(fontSize: 14, fontFamily: 'Cera-Bold'),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _mandalController,
                decoration: InputDecoration(
                  labelText: 'Enter Mandal',
                  labelStyle: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cera-Bold',
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40)),
                ),
                keyboardType: TextInputType.name,
              ),
              SizedBox(height: 10),
              const Text(
                'Village',
                style: TextStyle(fontSize: 14, fontFamily: 'Cera-Bold'),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _villageController,
                decoration: InputDecoration(
                  labelText: 'Enter Village',
                  labelStyle: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cera-Bold',
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40)),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10),
              const Text(
                'Pin Code',
                style: TextStyle(fontSize: 14, fontFamily: 'Cera-Bold'),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _pinCodeController,
                decoration: InputDecoration(
                  labelText: 'Enter Pin Code',
                  labelStyle: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cera-Bold',
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40)),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10),
              const Text(
                'KYC Proof Type',
                style: TextStyle(fontSize: 14, fontFamily: 'Cera-Bold'),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _kycProofController,
                decoration: InputDecoration(
                  labelText: 'Enter KYC Proof Type',
                  labelStyle: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cera-Bold',
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40)),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
