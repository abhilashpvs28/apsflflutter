import 'dart:convert';
import 'package:apsfllmo/screens/homescreen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:apsfllmo/screens/individualcaf/datamodal/customerinformationdatamodal.dart';
import 'package:apsfllmo/screens/individualcaf/installationaddress_screen.dart';

import 'package:apsfllmo/utils/pallete.dart';

class InCafCustomerinformationScreen extends StatefulWidget {
  const InCafCustomerinformationScreen({super.key});

  @override
  State<InCafCustomerinformationScreen> createState() =>
      _InCafCustomerinformationScreenState();
}

class _InCafCustomerinformationScreenState
    extends State<InCafCustomerinformationScreen> {
  int _selectedGenderIndex = -1; // Track the index of the selected gender
  bool _isLoading = false;
  List<Map<String, dynamic>> _dataList = [];
  final TextEditingController _adhrController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _surNameController = TextEditingController();
  final TextEditingController _guardianController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isFormValid = false; // Flag to track if form is valid

  @override
  void initState() {
    super.initState();
    _billingFrequencya(); // Initialize billing frequency data

    _adhrController.addListener(updateState);
    _firstNameController.addListener(updateState);
    // _middleNameController.addListener(updateState);
    _surNameController.addListener(updateState);
    // _guardianController.addListener(updateState);
    _dateOfBirthController.addListener(updateState);
    _emailController.addListener(updateState);
    // Initialize _selectedFrequencyId if needed
    _selectedFrequencyId = null; // Or any default value you prefer
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
              _firstNameController.text = _dataList[0]['FST_NM'] ?? '';
              _surNameController.text = _dataList[0]['SUR_NM'] ?? '';
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
        _dateOfBirthController.text = "${picked.toLocal()}".split(' ')[0];
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
      return 'Invalid Aadhar Number';
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

  // bool _validateForm() {
  //   return _formKey.currentState?.validate() ??
  //       false && _selectedGenderIndex != -1;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Pallete.backgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return const HomeScreen();
            }));
          },
        ),
        title: const Text('Customer Information',
            style: TextStyle(color: Colors.black, fontFamily: 'Cera-Bold')),
        centerTitle: true,
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
                    'Customer Information',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontFamily: 'Cera-Bold'),
                  ),
                ),
                const SizedBox(height: 15),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Aadhar Number *',
                              style: TextStyle(
                                  color: Colors.black, fontFamily: 'Cera-Bold'),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
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
                                      errorText:
                                          _validateAadhar(_adhrController.text),
                                    ),
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.02,
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    if (_adhrController.text.isNotEmpty) {
                                      _fetchDataRetrive(_adhrController.text);
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Pallete.backgroundColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(40),
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
                          const Text(
                            'First Name *',
                            style: TextStyle(
                                color: Colors.black, fontFamily: 'Cera-Bold'),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            child: TextFormField(
                              controller: _firstNameController,
                              decoration: InputDecoration(
                                labelText: 'Enter First Name',
                                labelStyle: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Cera-Bold'),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(40)),
                                errorText: _validateEmpty(
                                    _firstNameController.text, 'First Name'),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Middle Name',
                            style: TextStyle(
                                color: Colors.black, fontFamily: 'Cera-Bold'),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            child: TextFormField(
                              controller: _middleNameController,
                              decoration: InputDecoration(
                                labelText: 'Enter Middle Name',
                                labelStyle: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Cera-Bold'),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(40)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Surname Name *',
                            style: TextStyle(
                                color: Colors.black, fontFamily: 'Cera-Bold'),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            child: TextFormField(
                              controller: _surNameController,
                              decoration: InputDecoration(
                                labelText: 'Enter Surname Name',
                                labelStyle: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Cera-Bold'),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(40)),
                                errorText: _validateEmpty(
                                    _surNameController.text, 'Surname Name'),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Father/Husband Name ',
                            style: TextStyle(
                                color: Colors.black, fontFamily: 'Cera-Bold'),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            child: TextFormField(
                              controller: _guardianController,
                              decoration: InputDecoration(
                                labelText: 'Enter Father/Husband Name',
                                labelStyle: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Cera-Bold'),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(40)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Date of Birth *',
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Cera-Bold',
                            ),
                          ),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: () =>
                                _selectDate(context), // Call the date picker
                            child: SizedBox(
                              child: AbsorbPointer(
                                child: TextFormField(
                                  controller: _dateOfBirthController,
                                  decoration: InputDecoration(
                                    labelText: 'Enter Date of Birth',
                                    labelStyle: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Cera-Bold',
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                    errorText: _validateEmpty(
                                      _dateOfBirthController.text,
                                      'Date of Birth',
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
                          const Text(
                            'Gender *',
                            style: TextStyle(
                                color: Colors.black, fontFamily: 'Cera-Bold'),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedGenderIndex = 1;
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      color: _selectedGenderIndex == 1
                                          ? Colors.blue
                                          : Colors.grey[200],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        'Male',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'Cera-Bold'),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedGenderIndex = 2;
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      color: _selectedGenderIndex == 2
                                          ? Colors.blue
                                          : Colors.grey[200],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        'Female',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'Cera-Bold'),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedGenderIndex = 3;
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      color: _selectedGenderIndex == 3
                                          ? Colors.blue
                                          : Colors.grey[200],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        'Other',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'Cera-Bold'),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (_selectedGenderIndex == -1)
                            const Padding(
                              padding: EdgeInsets.only(left: 16.0, top: 8.0),
                              child: Text(
                                'Please select a gender',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Email *',
                            style: TextStyle(
                                color: Colors.black, fontFamily: 'Cera-Bold'),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            child: TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                labelText: 'Enter Email ',
                                labelStyle: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Cera-Bold'),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(40)),
                                errorText:
                                    _validateEmail(_emailController.text),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Bill Frequency *',
                            style: TextStyle(
                                color: Colors.black, fontFamily: 'Cera-Bold'),
                          ),
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
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate() &&
                          _selectedGenderIndex != -1) {
                        final customerInfo = CustomerInformation(
                          aadharNumber: _adhrController.text,
                          firstName: _firstNameController.text,
                          middleName: _middleNameController.text,
                          surname: _surNameController.text,
                          guardianName: _guardianController.text,
                          dateOfBirth: _dateOfBirthController.text,
                          email: _emailController.text,
                          selectedFrequencyId: _selectedFrequencyId,
                          selectedGenderIndex: _selectedGenderIndex,
                        );

                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => InstallationAddressScreen(
                              customerInfo: customerInfo,
                            ),
                          ),
                        );
                      } else {}
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor:
                          _isFormValid ? Pallete.buttonColor : Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
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
          ),
        ),
      ),
    );
  }
}



// sdahdioashkdhjakljdljsal