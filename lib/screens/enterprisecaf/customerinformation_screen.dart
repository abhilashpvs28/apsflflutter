import 'dart:convert';
import 'package:apsfllmo/screens/enterprisecaf/datamodal/customerinformationdatamodal.dart';
import 'package:apsfllmo/screens/enterprisecaf/installationaddress_screen.dart';
import 'package:apsfllmo/screens/homescreen/home_screen.dart';
import 'package:apsfllmo/utils/apiservice.dart';
import 'package:apsfllmo/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:apsfllmo/screens/individualcaf/datamodal/customerinformationdatamodal.dart';
import 'package:apsfllmo/screens/individualcaf/installationaddress_screen.dart';
import 'package:apsfllmo/utils/pallete.dart';

class EpCafCustomerinformationScreen extends StatefulWidget {
  final dynamic customerData;
  const EpCafCustomerinformationScreen({Key? key, required this.customerData})
      : super(key: key);

  @override
  State<EpCafCustomerinformationScreen> createState() =>
      _EpCafCustomerinformationScreenState();
}

class _EpCafCustomerinformationScreenState
    extends State<EpCafCustomerinformationScreen> {
  int _selectedGenderIndex = -1; // Track the index of the selected gender
  bool _isLoading = false;
  List<Map<String, dynamic>> _dataList = [];
  final TextEditingController _adhrController = TextEditingController();
  final TextEditingController _OrganisationNameController =
      TextEditingController();
  final TextEditingController _organisationPersonController =
      TextEditingController();
  final TextEditingController _organisationCodeController =
      TextEditingController();
  final TextEditingController _dateOfIncorporationController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isFormValid = false; // Flag to track if form is valid

  @override
  void initState() {
    super.initState();
    _billingFrequencya(); // Initialize billing frequency data
    _entDepartmentNames();

    // Set initial values from customerData
    if (widget.customerData != null) {
      _OrganisationNameController.text = widget.customerData['cstmr_nm'] ?? '';
      _organisationPersonController.text =
          widget.customerData['cntct_nm'] ?? '';
      final custmr_idVale = widget.customerData['cstmr_id'] ?? '';
      print('custmr_idVale $custmr_idVale');
    }

    _adhrController.addListener(updateState);
    _OrganisationNameController.addListener(updateState);
    _dateOfIncorporationController.addListener(updateState);
    _selectedFrequencyId = null; // Or any default value you prefer
    _selectedentDepartmentNamesId = null;
  }

  void updateState() {
    setState(() {
      _isFormValid = _validateForm();
    });
  }

  bool _validateForm() {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      return true;
    }
    return false;
  }

  Future<void> _fetchDataRetrive(String customerId) async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    final apiUrl = 'http://bss.apsfl.co.in/apiv1/caf/aadhaar/$customerId';
    final storage = FlutterSecureStorage();
    final String? token = await storage.read(key: 'token');

    if (token == null) {
      setState(() {
        _isLoading = false;
      });
      // Handle the case where token or caf_id is not available
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
        if (responseData['data'] is Map &&
            responseData['data']['res'] is List) {
          final List<dynamic> data = responseData['data']['res'];
          setState(() {
            _dataList.addAll(data.cast<Map<String, dynamic>>());
            if (_dataList.isNotEmpty) {
              _OrganisationNameController.text = _dataList[0]['FST_NM'] ?? '';
              // _surNameController.text = _dataList[0]['SUR_NM'] ?? '';
            }
            _isLoading = false;
          });
        } else {
          // Handle the case where 'data' or 'res' is not as expected
          setState(() {
            _isLoading = false;
          });
        }
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
      throw Exception('Failed to fetch data');
    }
  }

  List<dynamic> _billingFrequencyData = [];
  int? _selectedFrequencyId;

  Future<void> _billingFrequencya() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    const apiUrl = 'http://bss.apsfl.co.in/apiv1/crm/billingFrequency';
    final storage = FlutterSecureStorage();
    final String? token = await storage.read(key: 'token');

    if (token == null) {
      setState(() {
        _isLoading = false;
      });
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
        setState(() {
          _billingFrequencyData = data;
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<dynamic> _bentDepartmentNamesData = [];
  int? _selectedentDepartmentNamesId;

  Future<void> _entDepartmentNames() async {
    const apiUrl = 'http://bss.apsfl.co.in/apiv1/crm/entDepartmentNames';
    final storage = FlutterSecureStorage();
    final String? token = await storage.read(key: 'token');

    if (token == null) {
      setState(() {
        _isLoading = false;
      });
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
        setState(() {
          _bentDepartmentNamesData = data;
          print(' $_bentDepartmentNamesData ');
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(1900),
      lastDate: now, // Set lastDate to current date
    );
    if (picked != null) {
      setState(() {
        _dateOfIncorporationController.text =
            "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  String? _validateAadhar(String? value) {
    if (value == null || value.isEmpty || value.length != 12) {
      return 'Invalid Aadhar Number';
    }
    return null;
  }

  String? _validatefrequency(String? value) {
    if (value == null || value.isEmpty || value.length != 12) {
      return 'Invalid frequency Number';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || !value.contains('@gmail.c')) {
      return 'Invalid Email';
    }
    return null;
  }

  String? _validateFrequency(String? value) {
    if (value == null) {
      return 'Invalid Billing Frequency';
    }
    return null;
  }

  String? _validateEmpty(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.customerData);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Pallete.backgroundColor,
        title: const Text('Customer Information',
            style: TextStyle(color: Colors.black, fontFamily: 'Cera-Bold')),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => HomeScreen()));
              },
              icon: Icon(Icons.home))
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 15),
                Container(
                  width: double.infinity,
                  child: const Text(
                    'Customer Details',
                    style: TextStyle(
                        color: Color.fromARGB(255, 245, 148, 1),
                        fontSize: 20,
                        fontFamily: 'Cera-Bold'),
                  ),
                ),
                const SizedBox(height: 15),
                Material(
                  elevation: 10,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          SizedBox(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // const Text(
                                //   'Aadhar Number *',
                                //   style: TextStyle(
                                //       color: Colors.black,
                                //       fontFamily: 'Cera-Bold'),
                                // ),
                                const SizedBox(height: 8),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.7,
                                      child: TextFormField(
                                        controller: _adhrController,
                                        decoration: InputDecoration(
                                          labelText: 'Enter Aadhar Number',
                                          labelStyle: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Cera-Bold'),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(40)),
                                          errorText: _validateAadhar(
                                              _adhrController.text),
                                        ),
                                        keyboardType: TextInputType.number,
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.02,
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        if (_adhrController.text.isNotEmpty) {
                                          _fetchDataRetrive(
                                              _adhrController.text);
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Pallete.backgroundColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(40),
                                        ),
                                      ),
                                      child: const Text(
                                        'Fetch',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'Cera-Bold'),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // const Text(
                              //   'Organisation Name *',
                              //   style: TextStyle(
                              //       color: Colors.black,
                              //       fontFamily: 'Cera-Bold'),
                              // ),
                              const SizedBox(height: 8),
                              SizedBox(
                                child: TextFormField(
                                  controller: _OrganisationNameController,
                                  decoration: InputDecoration(
                                    labelText: 'Enter Organisation Name',
                                    labelStyle: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Cera-Bold'),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(40)),
                                    errorText: _validateEmpty(
                                        _OrganisationNameController.text,
                                        'Organisation Name'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // const Text(
                              //   'Enter Contact Person Name',
                              //   style: TextStyle(
                              //       color: Colors.black,
                              //       fontFamily: 'Cera-Bold'),
                              // ),
                              const SizedBox(height: 8),
                              SizedBox(
                                child: TextFormField(
                                  controller: _organisationPersonController,
                                  decoration: InputDecoration(
                                    labelText: 'Enter Contact Person Name',
                                    labelStyle: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Cera-Bold'),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(40)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // const Text(
                              //   'Date of Incorporation *',
                              //   style: TextStyle(
                              //     color: Colors.black,
                              //     fontFamily: 'Cera-Bold',
                              //   ),
                              // ),
                              const SizedBox(height: 8),
                              GestureDetector(
                                onTap: () => _selectDate(
                                    context), // Call the date picker
                                child: SizedBox(
                                  child: AbsorbPointer(
                                    child: TextFormField(
                                      controller:
                                          _dateOfIncorporationController,
                                      decoration: InputDecoration(
                                        labelText:
                                            'Enter Date of Incorporation',
                                        labelStyle: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Cera-Bold',
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(40),
                                        ),
                                        errorText: _validateEmpty(
                                          _dateOfIncorporationController.text,
                                          'Date of Incorporation',
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // const Text(
                              //   'Bill Frequency *',
                              //   style: TextStyle(
                              //       color: Colors.black,
                              //       fontFamily: 'Cera-Bold'),
                              // ),
                              const SizedBox(height: 8),
                              DropdownButtonFormField<int>(
                                decoration: InputDecoration(
                                  labelText: 'Select Bill Frequency',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                ),
                                items: _billingFrequencyData.map((item) {
                                  return DropdownMenuItem<int>(
                                    value: item['frqncy_id'],
                                    child: Text(item['frqncy_nm']),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedFrequencyId = value;
                                  });
                                  updateState(); // Update form state on change
                                },
                                value: _selectedFrequencyId,
                                validator: (value) {
                                  if (value == null) {
                                    return 'Please select a bill frequency';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 8),
                              // const Text(
                              //   'Department Names *',
                              //   style: TextStyle(
                              //       color: Colors.black,
                              //       fontFamily: 'Cera-Bold'),
                              // ),
                              const SizedBox(height: 8),
                              DropdownButtonFormField<int>(
                                decoration: InputDecoration(
                                  labelText: 'Select Department Names',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                ),
                                items: _bentDepartmentNamesData.map((item) {
                                  return DropdownMenuItem<int>(
                                    value: item['dprmnt_id'],
                                    child: Text(item['dprmnt_nm']),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedentDepartmentNamesId = value;
                                  });
                                  updateState(); // Update form state on change
                                },
                                value: _selectedentDepartmentNamesId,
                                validator: (value) {
                                  if (value == null) {
                                    return 'Please select a Department Names';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // const Text(
                                  //   'Enter Organisation Code',
                                  //   style: TextStyle(
                                  //       color: Colors.black,
                                  //       fontFamily: 'Cera-Bold'),
                                  // ),
                                  const SizedBox(height: 8),
                                  SizedBox(
                                    child: TextFormField(
                                      controller: _organisationCodeController,
                                      decoration: InputDecoration(
                                        labelText: 'Enter Organisation Code',
                                        labelStyle: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Cera-Bold'),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(40)),
                                      ),
                                    ),
                                  ),

                                  //
                                  const SizedBox(height: 16),
                                  Container(
                                    width: double.infinity,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        // if (_formKey.currentState!.validate() &&
                                        //     _selectedGenderIndex != -1) {

                                        final customerInfoepcaf =
                                            EpCafCustomerInformation(
                                          aadharNumber: _adhrController.text,
                                          organisationName:
                                              _OrganisationNameController.text,
                                          organisationPerson:
                                              _organisationPersonController
                                                  .text,
                                          dateOfIncorporation:
                                              _dateOfIncorporationController
                                                  .text,
                                          selectedFrequencyId:
                                              _selectedFrequencyId,
                                          selectedentDepartmentNamesId:
                                              _selectedentDepartmentNamesId,
                                          organisationCode:
                                              _organisationCodeController.text,
                                          custmr_id:
                                              widget.customerData['cstmr_id'] ??
                                                  '',
                                        );

                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                EpCafInstallationAddressScreen(
                                              customerInfo: customerInfoepcaf,
                                            ),
                                          ),
                                        );
                                        // } else {}
                                      },
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 16),
                                        backgroundColor: _isFormValid
                                            ? Pallete.buttonColor
                                            : Colors.grey,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(40),
                                        ),
                                      ),
                                      child: const Text(
                                        'Next',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontFamily: 'Cera-Bold'),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                ],
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
    );
  }
}
