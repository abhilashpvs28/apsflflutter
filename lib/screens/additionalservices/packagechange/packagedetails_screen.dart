import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';
import 'package:apsfllmo/screens/additionalservices/packagechange_screen.dart';
import 'package:apsfllmo/utils/pallete.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/shared/types.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';

class PackagedetailsScreen extends StatefulWidget {
  final Map<String, dynamic> data;

  const PackagedetailsScreen({Key? key, required this.data}) : super(key: key);

  @override
  State<PackagedetailsScreen> createState() => _PackagedetailsScreenState();
}

class _PackagedetailsScreenState extends State<PackagedetailsScreen> {
  late ScrollController _scrollController;
  List<dynamic> packageData = [];
  List<dynamic> servicesData = [];
  int? _selectedpackageId;

  List<dynamic> _billingFrequencyData = [];
  List<dynamic> _oldServicesData = [];
  int? _selectedpackageIdOld;
  int? _selectedFrequencyId;
  bool _isLoading = false;
  int? _selectedPackageIndex;
  List<bool> _isSectionOpen = [];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _getCAFSelectdPackage();
    _getPckgesByAgntId();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _getCAFSelectdPackage() async {
    final apiUrl =
        'http://bss.apsfl.co.in/apiv1/addons/getCAFSelectdPackage/${widget.data['caf_nu']}';
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
        setState(() {
          packageData = responseData['data'] ?? [];
          _oldServicesData = packageData[0]['srvcs'] ?? [];
          _selectedpackageIdOld = packageData[0]['pckge_id'];
          print(' old services data: $_oldServicesData');
          print(' old packageid: $_selectedpackageIdOld');
        });
        print('dstrctlst: $packageData');
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      print('Failed to fetch data: $e');
    }
  }

  Future<void> _getPckgesByAgntId() async {
    print('Inside _getPckgesByAgntId function');
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    // 2 --> Apsfl , 1--> Bbnl
    final apiUrl =
        'http://bss.apsfl.co.in/apiv1/package/getPckgesByAgntId/103000730/${widget.data['caf_type_id']}';
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

  Future<void> _validate(packageid, srvcs) async {
    print('Inside fetchData function');
    // if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    const apiUrl =
        'http://bss.apsfl.co.in/apiv1/caf_operations/validate-base-plan-change';
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
        "new_pckge_id": packageid,
        "old_pckge_id": _selectedpackageIdOld,
        "new_pln_pkg_dtls": [
          {"srvcs": srvcs}
        ],
        "crnt_pln_pkg_dtls": [
          {"srvcs": _oldServicesData}
        ]
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
      final String message = responseData['message'] ?? 'Unknown error';
      _bottomDialog(message);
    } else {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final String message = responseData['message'] ?? 'Unknown error';
      _bottomDialog(message);
      print('Failed to fetch data. Status code: ${response.statusCode}');
      throw Exception('Failed to fetch data');
    }
  }

  void _bottomDialog(message) {
    return Dialogs.bottomMaterialDialog(
      customView: Container(
        // width: MediaQuery.of(context).size.width * 0.9,
        padding: EdgeInsets.all(10),
        child: Container(
          // color: Colors.blueGrey,
          height: MediaQuery.of(context).size.height * 0.4,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      // width: MediaQuery.of(context).size.width,
                      // color: Colors.amber,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: Icon(
                            Icons.close_rounded,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 170,
                        width: 170,
                        child: Lottie.asset(
                          'assets/images/logos/rocket.json',
                          fit: BoxFit.contain,
                        ),
                      ),
                      Card(
                        color: const Color.fromARGB(255, 194, 248, 209),
                        elevation: 8,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            message,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Cera-bold',
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: IconsButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          text: 'Close',
                          iconData: Icons.close,
                          color: Colors.blue,
                          textStyle: TextStyle(color: Colors.white),
                          iconColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                )
              ])
            ],
          ),
        ),
      ),
      color: Colors.white,
      customViewPosition: CustomViewPosition.BEFORE_ACTION,
      context: context,
    );
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Package Details',
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
          Column(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.replay,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const PackagechangeScreen()));
                },
              ),
            ],
          ),
        ],
      ),
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
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 1,
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 20,
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${widget.data['cstmr_nm'] ?? 'N/A'}',
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontFamily: 'Cera-bold'),
                                              ),
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.phone_iphone_rounded,
                                                    size: 20,
                                                    color: Colors.black,
                                                  ),
                                                  Text(
                                                    '${widget.data['mbl_nu'] ?? 'N/A'}',
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontFamily:
                                                            'Cera-bold'),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                '${widget.data['caf_nu'] ?? 'N/A'}',
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontFamily: 'Cera-bold'),
                                              ),
                                              Text(
                                                '${widget.data['pckge_nm'] ?? 'N/A'}',
                                                style: const TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 21, 137, 190),
                                                    fontFamily: 'Cera-bold'),
                                              ),
                                              Text(
                                                '${widget.data['sts_nm'] ?? 'N/A'}',
                                                style: const TextStyle(
                                                    color: Colors.green,
                                                    fontFamily: 'Cera-bold'),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          top: BorderSide(
                                            color: Colors.grey,
                                            width: 1.0,
                                          ),
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          _buildInfoRow('Aadhar',
                                              '${widget.data['adhr_nu'] ?? 'N/A'}'),
                                          _buildInfoRow('Billing Frequency',
                                              '${widget.data['frqncy_nm'] ?? 'N/A'}'),
                                          _buildInfoRow('ONU Serial No',
                                              '${widget.data['onu_srl_nu'] ?? 'N/A'}'),
                                          _buildInfoRow('Telephone Allocated',
                                              '${widget.data['termn_req_sts'] ?? 'N/A'}'),
                                          _buildInfoRow('CAF Activated On',
                                              '${widget.data['actvnDt'] ?? 'N/A'}'),
                                          _buildInfoRow('Renewed On',
                                              '${widget.data['pack_strt'] ?? 'N/A'}'),
                                          _buildInfoRow('Valid Till',
                                              '${widget.data['pack_expry'] ?? 'N/A'}'),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          _buildAccordion(),
                                          SingleChildScrollView(
                                              child: _changePackage()),
                                          const SizedBox(
                                            height: 50,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccordion() {
    return Accordion(
      sectionOpeningHapticFeedback: SectionHapticFeedback.heavy,
      sectionClosingHapticFeedback: SectionHapticFeedback.light,
      scaleWhenAnimating: true,
      openAndCloseAnimation: true,
      maxOpenSections: 2,
      rightIcon: Icon(
        Icons.arrow_circle_down,
        color: Colors.white,
      ),
      headerBackgroundColor: Colors.blueAccent,
      headerPadding: const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
      children: packageData.map((package) {
        String formattedDate = _formatDate(package['efcte_dt']);
        return AccordionSection(
          isOpen: false,
          header: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${package['pckge_nm']}',
                      style: const TextStyle(
                          color: Colors.white, fontFamily: 'Cera-bold'),
                    ),
                    Text(
                      formattedDate,
                      style: const TextStyle(
                          color: Colors.white, fontFamily: 'Cera-bold'),
                    ),
                  ],
                ),
              ),
              const Divider(
                color: Colors.white,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(
                          '₹ ${package['total']}',
                          style: const TextStyle(
                              color: Colors.white, fontFamily: 'Cera-bold'),
                        ),
                        Text(
                          'Total',
                          style: const TextStyle(
                              color: Colors.white, fontFamily: 'Cera-bold'),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          '₹ ${package['chrg_at']}',
                          style: const TextStyle(
                              color: Colors.white, fontFamily: 'Cera-bold'),
                        ),
                        Text(
                          'Charge',
                          style: const TextStyle(
                              color: Colors.white, fontFamily: 'Cera-bold'),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          '₹ ${package['gst_at']}',
                          style: const TextStyle(
                              color: Colors.white, fontFamily: 'Cera-bold'),
                        ),
                        Text(
                          'Others',
                          style: const TextStyle(
                              color: Colors.white, fontFamily: 'Cera-bold'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          content: Column(
            children: (package['srvcs'] as List).map((service) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service['srvcpk_nm'],
                    style: const TextStyle(
                        color: Colors.black, fontFamily: 'Cera-bold'),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Charge',
                        style: const TextStyle(
                            color: Colors.grey, fontFamily: 'Cera-bold'),
                      ),
                      Text(
                        '₹ ${service['chrge_at']}',
                        style: const TextStyle(
                            color: Colors.grey, fontFamily: 'Cera-bold'),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Others',
                        style: const TextStyle(
                            color: Colors.grey, fontFamily: 'Cera-bold'),
                      ),
                      Text(
                        '₹ ${service['gst_at']}',
                        style: const TextStyle(
                            color: Colors.grey, fontFamily: 'Cera-bold'),
                      ),
                    ],
                  ),
                ],
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }

  Widget _changePackage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(
          color: Colors.black,
        ),
        const Text(
          "Please Select to change package",
          style: TextStyle(color: Colors.black, fontFamily: 'Cera-bold'),
        ),
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Accordion(
                maxOpenSections: 1,
                headerBackgroundColor: Colors.white,
                children: _billingFrequencyData
                    .asMap()
                    .entries
                    .map<AccordionSection>((entry) {
                  int index = entry.key;
                  var packages = entry.value;
                  final services = packages['srvcs'] as List<dynamic>;
                  return AccordionSection(
                    isOpen: _isSectionOpen[index],
                    header: GestureDetector(
                      onTap: () {
                        print('Accordion header tapped for index: $index');
                        setState(() {
                          _isSectionOpen[index] = !_isSectionOpen[index];
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '${packages['pckge_nm']}',
                                            style: const TextStyle(
                                              fontFamily: 'Cera-Bold',
                                              // fontSize: 16,
                                            ),
                                          ),
                                          Text(
                                            _formatDate(packages['efcte_dt']),
                                            style: const TextStyle(
                                              fontFamily: 'Cera-Bold',
                                              // fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        'MSP: ${packages['agnt_nm']}',
                                        style: const TextStyle(
                                          fontFamily: 'Cera-Bold',
                                          // fontSize: 16,
                                        ),
                                      ),
                                      Container(
                                        decoration: const BoxDecoration(
                                          border: Border(
                                            top: BorderSide(
                                                width: 1, color: Colors.grey),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              children: [
                                                Text(
                                                  '₹ ${packages['total']}',
                                                  style: const TextStyle(
                                                    fontFamily: 'Cera-Bold',
                                                    // fontSize: 16,
                                                  ),
                                                ),
                                                const Text(
                                                  'Total',
                                                  style: TextStyle(
                                                    fontFamily: 'Cera-Bold',
                                                    // fontSize: 16,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                Text(
                                                  '₹ ${packages['chrg_at']}',
                                                  style: const TextStyle(
                                                    fontFamily: 'Cera-Bold',
                                                    // fontSize: 16,
                                                  ),
                                                ),
                                                const Text(
                                                  'Charge',
                                                  style: TextStyle(
                                                    fontFamily: 'Cera-Bold',
                                                    // fontSize: 16,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                Text(
                                                  '₹ ${packages['gst_at']}',
                                                  style: const TextStyle(
                                                    fontFamily: 'Cera-Bold',
                                                    // fontSize: 16,
                                                  ),
                                                ),
                                                const Text(
                                                  'Others',
                                                  style: TextStyle(
                                                    fontFamily: 'Cera-Bold',
                                                    // fontSize: 16,
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
                                  margin: EdgeInsets.symmetric(horizontal: 4),
                                  width:
                                      MediaQuery.of(context).size.width * 0.05,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Transform.scale(
                                      scale:
                                          1.4, // Increase the size of the radio button
                                      child: Radio<int>(
                                        value: index,
                                        groupValue: _selectedPackageIndex,
                                        onChanged: (int? value) {
                                          print(
                                              'Selected package index: $value');
                                          if (value != null) {
                                            var selectedPackage =
                                                _billingFrequencyData[value];
                                            print(
                                                'Selected package data: $selectedPackage');

                                            // Extract the `srvcs` data
                                            servicesData =
                                                selectedPackage['srvcs'];
                                            _selectedpackageId =
                                                selectedPackage['pckge_id'];
                                            print(
                                                'Selected package services data: $servicesData');
                                            print(
                                                'Selected package ID data: $_selectedpackageId');
                                          }
                                          setState(() {
                                            print(
                                                ' this is value of selected $_selectedPackageIndex');
                                            _selectedPackageIndex = value;
                                            _validate(_selectedpackageId,
                                                servicesData);
                                          });
                                        },
                                      ),
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
                              padding:
                                  const EdgeInsets.symmetric(vertical: 0.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${service['srvcpk_nm']}',
                                    style: const TextStyle(
                                      fontFamily: 'Cera-Bold',
                                      // fontSize: 16,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Charge'),
                                      Text('₹ ${service['chrge_at']}'),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Others'),
                                      Text('₹ ${service['gst_at']}'),
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
              Card(
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.45,
                            child: const Text(
                              'APSFL Share',
                              style: TextStyle(fontFamily: 'Cera-Bold'),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.1,
                            child: const Text(
                              ':',
                              style: TextStyle(fontFamily: 'Cera-Bold'),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.2,
                            child: const Text(
                              '-312.0',
                              style: TextStyle(fontFamily: 'Cera-Bold'),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.45,
                            child: const Text(
                              'LMO Share',
                              style: TextStyle(fontFamily: 'Cera-Bold'),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.1,
                            child: const Text(
                              ':',
                              style: TextStyle(fontFamily: 'Cera-Bold'),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.2,
                            child: const Text(
                              '-130.0',
                              style: TextStyle(fontFamily: 'Cera-Bold'),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.45,
                            child: const Text(
                              'Total Collectable Amount',
                              style: TextStyle(fontFamily: 'Cera-Bold'),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.1,
                            child: const Text(
                              ':',
                              style: TextStyle(fontFamily: 'Cera-Bold'),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.2,
                            child: const Text(
                              '-442.0',
                              style: TextStyle(fontFamily: 'Cera-Bold'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20), // Add some space before the button
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
                      width: MediaQuery.of(context).size.width * 0.35,
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
                    onTap: () {},
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width * 0.35,
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
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String title, String? value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.39,
          child: Text(
            title,
            style:
                const TextStyle(color: Colors.black, fontFamily: 'Cera-bold'),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.05,
          child: const Text(
            ":",
            style: TextStyle(color: Colors.black, fontFamily: 'Cera-bold'),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.4,
          child: Text(
            value ?? 'N/A',
            style:
                const TextStyle(color: Colors.black, fontFamily: 'Cera-bold'),
          ),
        ),
      ],
    );
  }
}
