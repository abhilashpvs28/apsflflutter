import 'package:apsfllmo/screens/individualcaf/cpeinformation_screen.dart';
import 'package:apsfllmo/screens/individualcaf/datamodal/customerinformationdatamodal.dart';
import 'package:apsfllmo/screens/individualcaf/datamodal/installationaddressdatamodal.dart';
import 'package:apsfllmo/screens/homescreen/home_screen.dart';

import 'package:apsfllmo/screens/notificationscreen/bbnlnotifications_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:accordion/accordion.dart';
import 'package:intl/intl.dart';
import '../../utils/pallete.dart';

class BaseBackages extends StatefulWidget {
  final InstallationAddress installationAddressInfo;
  final CustomerInformation customerInfoDataFormat;
  const BaseBackages(
      {super.key,
      required this.installationAddressInfo,
      required this.customerInfoDataFormat});

  @override
  State<BaseBackages> createState() => _BaseBackagesState();
}

class _BaseBackagesState extends State<BaseBackages> {
  List<dynamic> _billingFrequencyData = [];
  int? _selectedFrequencyId;
  bool _isLoading = false;
  int? _selectedPackageIndex;
  List<bool> _isSectionOpen = [];

  @override
  void initState() {
    super.initState();
    _getPckgesByAgntId();
  }

  Future<void> _getPckgesByAgntId() async {
    print('Inside _getPckgesByAgntId function');
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    const apiUrl =
        'http://bss.apsfl.co.in/apiv1/package/getPckgesByAgntId/103000730/1';
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
        print('Data received: $data');
        setState(() {
          _billingFrequencyData = data;
          _isSectionOpen = List<bool>.filled(data.length, false);
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Failed to fetch data: $e');
    }
  }

  String _formatDate(String dateStr) {
    try {
      final DateTime date = DateTime.parse(dateStr);
      final DateFormat formatter = DateFormat('MMM dd, yyyy');
      return formatter.format(date);
    } catch (e) {
      print('Date formatting error: $e');
      return dateStr; // Return original string if parsing fails
    }
  }

  @override
  Color _buttonColor =
      Color.fromARGB(255, 234, 206, 166); // Initial color for the button
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Customer Information',
          style: TextStyle(color: Colors.black, fontFamily: 'Cera-Bold'),
        ),
        backgroundColor: Pallete.backgroundColor,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.home,
              color: Colors.black,
            ),
            onPressed: () {
              print('Home button pressed');
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => const HomeScreen()));
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: const Text(
                      'Base Packages',
                      style: TextStyle(fontFamily: 'Cera-Bold', fontSize: 20),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: Container(
                      color: Colors.amber,
                      margin: const EdgeInsets.all(10),
                      child: Material(
                        elevation: 8,
                        child: Accordion(
                          maxOpenSections: 1,
                          headerBackgroundColor: Colors.white,
                          children: _billingFrequencyData
                              .asMap()
                              .entries
                              .map<AccordionSection>((entry) {
                            int index = entry.key;
                            var package = entry.value;
                            final services = package['srvcs'] as List<dynamic>;
                            return AccordionSection(
                              isOpen: _isSectionOpen[index],
                              header: GestureDetector(
                                onTap: () {
                                  print(
                                      'Accordion header tapped for index: $index');
                                  setState(() {
                                    _isSectionOpen[index] =
                                        !_isSectionOpen[index];
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      '${package['pckge_nm']}',
                                                      style: const TextStyle(
                                                        fontFamily: 'Cera-Bold',
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                    Text(
                                                      _formatDate(
                                                          package['expry_dt']),
                                                      style: const TextStyle(
                                                        fontFamily: 'Cera-Bold',
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Text(
                                                  'MSP: ${package['agnt_nm']}',
                                                  style: const TextStyle(
                                                    fontFamily: 'Cera-Bold',
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                Container(
                                                  decoration:
                                                      const BoxDecoration(
                                                    border: Border(
                                                      top: BorderSide(
                                                          width: 1,
                                                          color: Colors.grey),
                                                    ),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Column(
                                                        children: [
                                                          Text(
                                                            '₹ ${package['total']}',
                                                            style:
                                                                const TextStyle(
                                                              fontFamily:
                                                                  'Cera-Bold',
                                                              fontSize: 16,
                                                            ),
                                                          ),
                                                          const Text(
                                                            'Total',
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Cera-Bold',
                                                              fontSize: 16,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Column(
                                                        children: [
                                                          Text(
                                                            '₹ ${package['chrg_at']}',
                                                            style:
                                                                const TextStyle(
                                                              fontFamily:
                                                                  'Cera-Bold',
                                                              fontSize: 16,
                                                            ),
                                                          ),
                                                          const Text(
                                                            'Charge',
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Cera-Bold',
                                                              fontSize: 16,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Column(
                                                        children: [
                                                          Text(
                                                            '₹ ${package['gst_at']}',
                                                            style:
                                                                const TextStyle(
                                                              fontFamily:
                                                                  'Cera-Bold',
                                                              fontSize: 16,
                                                            ),
                                                          ),
                                                          const Text(
                                                            'Others',
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Cera-Bold',
                                                              fontSize: 16,
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
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: Transform.scale(
                                              scale:
                                                  1.5, // Increase the size of the radio button
                                              child: Radio<int>(
                                                value: index,
                                                groupValue:
                                                    _selectedPackageIndex,
                                                onChanged: (int? value) {
                                                  print(
                                                      'Selected package index: $value');
                                                  if (value != null) {
                                                    var selectedPackage =
                                                        _billingFrequencyData[
                                                            value];
                                                    print(
                                                        'Selected package data: $selectedPackage');
                                                  }
                                                  setState(() {
                                                    _selectedPackageIndex =
                                                        value;
                                                  });
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Icon(
                                          _isSectionOpen[index]
                                              ? Icons.arrow_drop_up
                                              : Icons.arrow_drop_down,
                                          color: Colors.black,
                                          size: 30,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              content: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ...services.map((service) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 0.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${service['srvcpk_nm']}',
                                              style: const TextStyle(
                                                fontFamily: 'Cera-Bold',
                                                fontSize: 16,
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                const Text('Charge'),
                                                Text(
                                                    '₹ ${service['chrge_at']}'),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                const Text('Others'),
                                                Text('${service['gst_at']}'),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Note: Additional Activation charges: Rs. 60/- Applicable',
                      style: TextStyle(fontFamily: 'Cera-Bold', fontSize: 16),
                    ),
                  ),
                  const SizedBox(
                      height: 20), // Add some space before the button
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          print('Previous button pressed');
                          Navigator.pop(context);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: MediaQuery.of(context).size.height * 0.05,
                          decoration: BoxDecoration(
                            color: Pallete.backgroundColor,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: const Text(
                            'Previous',
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Cera-Bold',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      InkWell(
                        onTap: () {
                          if (_selectedPackageIndex != null) {
                            print(
                                'Next button pressed with selected package index: $_selectedPackageIndex');
                            var selectedPackage =
                                _billingFrequencyData[_selectedPackageIndex!];
                            print('Selected package data: $selectedPackage');

                            // Extract required values
                            String efcteDt = selectedPackage['efcte_dt'];
                            String expryDt = selectedPackage['expry_dt'];
                            int pckgeId = selectedPackage['pckge_id'];
                            int srvcpk_id =
                                selectedPackage['srvcs'][0]['srvcpk_id'];
                            double bsePckPrice =
                                selectedPackage['bse_pck_price'].toDouble();
                            List<dynamic> srvcs = selectedPackage['srvcs'];

                            // Print extracted values
                            print('efcteDt: $efcteDt');
                            print('expryDt: $expryDt');
                            print('pckgeId: $pckgeId');
                            print('bsePckPrice: $bsePckPrice');
                            print('srvcs: $srvcs');
                            print('this is selectedsrvcpk_id: $srvcpk_id');

                            // Navigate to the next screen with the extracted values
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return CpeinformationScreen(
                                selectedPackageIndex: _selectedPackageIndex,
                                installationAddressDataFormat:
                                    widget.installationAddressInfo,
                                customerInfoDataFormat:
                                    widget.customerInfoDataFormat,
                                efcteDt: efcteDt,
                                expryDt: expryDt,
                                pckgeId: pckgeId,
                                bsePckPrice: bsePckPrice,
                                srvcs: srvcs,
                                srvcpk_id: srvcpk_id,
                              );
                            }));
                          } else {
                            print(
                                'Next button pressed with no package selected');
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: MediaQuery.of(context).size.height * 0.05,
                          decoration: BoxDecoration(
                            color: _selectedPackageIndex != null
                                ? Pallete.buttonColor
                                : Colors.grey, // Use the dynamic button color
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: const Text(
                            'Next',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Cera-Bold',
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20), // Add some space after the button
                  Container(
                    height: 20,
                    color: Pallete.backgroundColor,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'LMO2000825',
                          style:
                              TextStyle(fontSize: 12, fontFamily: 'Cera-Bold'),
                        ),
                        Text(
                          'V 5.9',
                          style:
                              TextStyle(fontSize: 12, fontFamily: 'Cera-Bold'),
                        ),
                        Text(
                          'Powered by Greenlantern IT Solutions @ BBNL',
                          style:
                              TextStyle(fontSize: 12, fontFamily: 'Cera-Bold'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
