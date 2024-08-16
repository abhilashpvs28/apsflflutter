import 'package:apsfllmo/screens/individualcaf/basepackages_screen.dart';
import 'package:apsfllmo/screens/individualcaf/datamodal/customerinformationdatamodal.dart';
import 'package:apsfllmo/screens/individualcaf/datamodal/installationaddressdatamodal.dart';
import 'package:apsfllmo/screens/homescreen/home_screen.dart';
import 'package:apsfllmo/utils/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class InstallationAddressScreen extends StatefulWidget {
  final CustomerInformation customerInfo;

  const InstallationAddressScreen({super.key, required this.customerInfo});

  @override
  State<InstallationAddressScreen> createState() =>
      _InstallationAddressScreenState();
}

class _InstallationAddressScreenState extends State<InstallationAddressScreen> {
  int _selectedGenderIndex = 0; // Track the index of the selected gender
  bool _isLoading = false;
  List<Map<String, dynamic>> _dataList = [];
  final TextEditingController _buildingNameController =
      TextEditingController(); // Controller for first name
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _gpeDeviceLocationController =
      TextEditingController(); // Controller for middleName
  final TextEditingController _areaController =
      TextEditingController(); // Controller for Surname
  final TextEditingController _alternateMobileController =
      TextEditingController(); // Controller for DOb name
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _mandalController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _stdCodeController =
      TextEditingController(text: '866');
  final TextEditingController _enterLandlineController =
      TextEditingController();
  final TextEditingController _dummyController = TextEditingController();

  bool _isFormValid = false; // Flag to track if form is valid
  List<Map<String, dynamic>> _popData = [];
  List<Map<String, dynamic>> _popData1 = [];
  List<Map<String, dynamic>> _popDataDistrict = [];
  List<Map<String, dynamic>> _popDataMandal = [];

  @override
  void initState() {
    super.initState();
    // _mandals();
    _oltsbstndetails();
    // _district();

    _buildingNameController.addListener(updateState);
    _addressController.addListener(updateState);
    _gpeDeviceLocationController.addListener(updateState);
    _areaController.addListener(updateState);
    _alternateMobileController.addListener(updateState);
    _pincodeController.addListener(updateState);
    _mobileController.addListener(updateState);
    _stdCodeController.addListener(updateState);
    _enterLandlineController.addListener(updateState);
  }

  void updateState() {
    setState(() {
      _isFormValid = _validateForm();
    });
  }

  @override
  void dispose() {
    _buildingNameController.dispose();
    _addressController.dispose();
    _gpeDeviceLocationController.dispose();
    _areaController.dispose();
    _alternateMobileController.dispose();
    _pincodeController.dispose();
    _mobileController.dispose();
    _stdCodeController.dispose();
    _enterLandlineController.dispose();
    super.dispose();
  }

  // -------------------------------------------- start _oltsbstndetailsr --------------------------------------------
  List<dynamic> _billingFrequencyData = [];
  int? _selectedFrequencyId;
  int? _selectedSbstnId;
  String? _selectedSbstnName;
// bool _isLoading = false;
  Future<void> _oltsbstndetails() async {
    print('Inside fetchData function');
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    const apiUrl =
        'http://bss.apsfl.co.in/apiv1/olt/oltsbstndetails/103000730/4';
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
          _popData = List<Map<String, dynamic>>.from(data);
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

  // -------------------------------------------- end _oltsbstndetails --------------------------------------------

  int? _selectedMndlId;
  int? _selectedDstrtId;
  String? _selectedMndlName;
  // -------------------------------------------- start _fetchData --------------------------------------------
  Future<void> _fetchData() async {
    print('Inside fetchData function');
    if (_isLoading || _selectedSbstnId == null) return;

    setState(() {
      _isLoading = true;
    });

    const apiUrl = 'http://bss.apsfl.co.in/apiv1/olt/oltInstalAddr';
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
      "agnt_id": 103000730,
      "sbstn_id": _selectedSbstnId
    };

    print('Request headers: $headers');
    print('Request body: ${json.encode(requestBody)}');

    try {
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
          _popData1 = List<Map<String, dynamic>>.from(data);
          _selectedDstrtId = null; // Reset the selected value to avoid conflict
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        print('Failed to fetch data. Status code: ${response.statusCode}');
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Failed to fetch data: $e');
    }
  }

  // -------------------------------------------- end _fetchData --------------------------------------------

  // -------------------------------------------- start _oltsbstndetailsr --------------------------------------------

// bool _isLoading = false;
// List to hold the mandal names and numbers
  List<Map<String, dynamic>> _mandalList = [];
  List<Map<String, dynamic>> _districtList = [];
  int? _selectedVlgeId;
  String? _selectedVlgeName;

  // int? _selectedMndlId; // Changed type to int?

  Future<void> _mandals() async {
    print('Inside fetchData function 1356');
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    final apiUrl =
        'http://bss.apsfl.co.in/apiv1/admin/districts/$_selectedDstrtId/mandals';
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
        print('Data received dsadsa: $data');
        setState(() {
          _mandalList = List<Map<String, dynamic>>.from(
              data); // Store data in _mandalList
          print('this is district data $_mandalList');
          _isLoading = false;
        });

        // Check if _selectedMndlId matches any mndl_nu and update _mandalController.text
        if (_selectedMndlId != null && _mandalList.isNotEmpty) {
          final selectedMandal = _mandalList.firstWhere(
            (mandal) => mandal['mndl_nu'] == _selectedMndlId,
            orElse: () => {},
          );
          if (selectedMandal != null) {
            _mandalController.text = selectedMandal['mndl_nm'].toString();
          }
        }
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

  Future<void> _district() async {
    print('Inside fetchData function Data received district data from api: ');
    // if (_isLoading) return;

    // setState(() {
    //   _isLoading = true;
    // });

    final apiUrl = 'http://bss.apsfl.co.in/apiv1/admin/states/1/districts';
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
        print('Data received district data from api: $data');
        setState(() {
          _districtList = List<Map<String, dynamic>>.from(
              data); // Store data in _mandalList
          print('Data received district data from api:  $_districtList');
          _isLoading = false;
        });

        // Check if _selectedMndlId matches any mndl_nu and update _mandalController.text
        if (_selectedDstrtId != null && _districtList.isNotEmpty) {
          final selectedDistrict = _districtList.firstWhere(
            (mandal) => mandal['dstrt_id'] == _selectedDstrtId,
            orElse: () => {},
          );
          if (selectedDistrict != null) {
            _districtController.text = selectedDistrict['dstrt_nm'].toString();
          }
        }
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

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _validateEmpty(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  bool _validateForm() {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      return true;
    }
    return false;
  }

  String? _validateBuilding(String? value) {
    if (value == null || value.isEmpty) {
      return 'Building/House/Flat';
    }
    return null;
  }

  String? _validateArea(String? value) {
    if (value == null || value.isEmpty) {
      return 'Invalid locality/Area';
    }
    return null;
  }

  String? _validateCpeDeviceLocation(String? value) {
    if (value == null || value.isEmpty) {
      return 'Invalid Cpe Device Location';
    }
    return null;
  }

  String? _validateAddress(String? value) {
    if (value == null || value.isEmpty) {
      return 'Invalid Address';
    }
    return null;
  }

  String? _validateMandal(String? value) {
    if (value == null || value.isEmpty) {
      return 'Invalid mandal';
    }
    return null;
  }

  String? _validateDistrict(String? value) {
    if (value == null || value.isEmpty) {
      return 'Invalid District';
    }
    return null;
  }

  String? _validatePincode(String? value) {
    if (value == null || value.isEmpty || value.length != 6) {
      return 'Invalid Pin Code';
    }
    return null;
  }

  String? _validateMobileNo(String? value) {
    if (value == null || value.isEmpty || value.length != 10) {
      return 'Invalid Mobile No';
    }
    return null;
  }

  String? _validateAlternateMobileNo(String? value) {
    if (value == null || value.isEmpty || value.length != 10) {
      return 'Invalid Mobile No';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    bool _isFormFilled = _buildingNameController.text.isNotEmpty &&
        _gpeDeviceLocationController.text.isNotEmpty &&
        _areaController.text.isNotEmpty &&
        _pincodeController.text.isNotEmpty &&
        _mobileController.text.isNotEmpty &&
        _alternateMobileController.text.isNotEmpty;
    // _selectedSbstnId != null &&
    // _selectedMndlId != null;

    // Enable Next Button and change color if form is filled
    if (_isFormFilled) {
      _isFormValid = true;
    } else {
      _isFormValid = false;
    }

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
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => const HomeScreen()));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      'Installation Address',
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Cera-Bold',
                        fontSize: 25,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Building/House/Flat *',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Cera-Bold',
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      SizedBox(
                        // height: MediaQuery.of(context).size.height * 0.06,
                        child: TextFormField(
                          controller: _buildingNameController,
                          decoration: InputDecoration(
                            labelText: 'Enter Building/House/Flat',
                            labelStyle: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Cera-Bold',
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                            errorText:
                                _validateBuilding(_buildingNameController.text),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Street Name*',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Cera-Bold',
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      SizedBox(
                        // height: MediaQuery.of(context).size.height * 0.06,
                        child: TextFormField(
                          controller: _addressController,
                          decoration: InputDecoration(
                            labelText: 'Enter Street Name',
                            labelStyle: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Cera-Bold',
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                            errorText:
                                _validateAddress(_addressController.text),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Locality/Area *',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Cera-Bold',
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      SizedBox(
                        // height: MediaQuery.of(context).size.height * 0.06,
                        child: TextFormField(
                          controller: _areaController,
                          decoration: InputDecoration(
                            labelText: 'Enter Locality/Area',
                            labelStyle: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Cera-Bold',
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                            errorText: _validateArea(_areaController.text),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'CPE Device Location *',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Cera-Bold',
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      SizedBox(
                        // height: MediaQuery.of(context).size.height * 0.06,
                        child: TextFormField(
                          controller: _gpeDeviceLocationController,
                          decoration: InputDecoration(
                            labelText: 'Enter CPE Device Location ',
                            labelStyle: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Cera-Bold',
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                            errorText: _validateCpeDeviceLocation(
                                _gpeDeviceLocationController.text),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'POP Name *',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Cera-Bold',
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      _isLoading
                          ? CircularProgressIndicator()
                          : DropdownButtonFormField<int>(
                              decoration: InputDecoration(
                                labelText: 'Select POP Name',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(40),
                                ),
                              ),
                              items: _popData.map((item) {
                                return DropdownMenuItem<int>(
                                  value: item['sbstn_id'],
                                  child: Text(item['sbstn_nm']),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedSbstnId = value;
                                  _selectedSbstnName = _popData.firstWhere(
                                      (element) =>
                                          element['sbstn_id'] ==
                                          value)['sbstn_nm'];
                                  _fetchData(); // Fetch data when a new POP is selected
                                });
                              },
                              value: _selectedSbstnId,
                              validator: (value) {
                                if (value == null) {
                                  return 'Select POP Name';
                                }
                                return null;
                              },
                            ),
                      const SizedBox(
                        height: 8,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Installation City/Village *',
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Cera-Bold',
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            _popData1.isEmpty
                                ? const SizedBox(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.warning,
                                          color: Colors.amber,
                                        ),
                                        SizedBox(width: 8),
                                        Text('Village details not found'),
                                      ],
                                    ),
                                  )
                                : DropdownButtonFormField<int>(
                                    decoration: InputDecoration(
                                      labelText:
                                          'Select Installation City/Village',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(40),
                                      ),
                                    ),
                                    items: _popData1.map((item) {
                                      return DropdownMenuItem<int>(
                                        value: item['dstrt_id'],
                                        child: Text(item['vlge_nm']),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedDstrtId = value;
                                        if (value != null) {
                                          final selectedVillage =
                                              _popData1.firstWhere(
                                            (item) => item['dstrt_id'] == value,
                                            orElse: () => {},
                                          );
                                          if (selectedVillage != null) {
                                            _selectedMndlId =
                                                selectedVillage['mndl_id'];
                                            _selectedVlgeId =
                                                selectedVillage['vlge_id'];
                                            _selectedVlgeName =
                                                selectedVillage['vlge_nm'];
                                            print(
                                                'Selected dstrt_id: $_selectedDstrtId');
                                            print(
                                                'Stored mndl_id: $_selectedMndlId');
                                            print(
                                                'Stored vlge_id: $_selectedVlgeId');
                                            _mandals();
                                            _district();
                                          }

                                          // Update _mandalController.text here
                                          if (_selectedMndlId != null) {
                                            var mandal = _mandalList.firstWhere(
                                              (element) =>
                                                  element['mndl_nu'] ==
                                                  _selectedMndlId,
                                              orElse: () => {},
                                            );
                                            _mandalController.text =
                                                mandal != null
                                                    ? mandal['mndl_nm'] ?? ''
                                                    : '';
                                          } else {
                                            _mandalController.text = '';
                                          }
                                          // Update _districtController.text here
                                          if (_selectedDstrtId != null) {
                                            var mandal = _mandalList.firstWhere(
                                              (element) =>
                                                  element['dstrt_id'] ==
                                                  _selectedDstrtId,
                                              orElse: () => {},
                                            );
                                            _districtController.text =
                                                mandal != null
                                                    ? mandal['dstrt_nm'] ?? ''
                                                    : '';
                                          } else {
                                            _districtController.text = '';
                                          }
                                        }
                                      });
                                    },
                                    value: _selectedDstrtId,
                                    validator: (value) {
                                      if (value == null) {
                                        return 'Select Installation City/Village';
                                      }
                                      return null;
                                    },
                                  )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Show mndl_nm based on _selectedMndlId
                      const Text(
                        'Installation Mandal *',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Cera-Bold',
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _mandalController,
                        // readOnly: true, // Ensure this is read-only
                        decoration: InputDecoration(
                          labelText: 'Installation Mandal',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                          errorText: _validateMandal(_mandalController.text),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Installation District *',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Cera-Bold',
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _districtController,
                        decoration: InputDecoration(
                          labelText: ' Installation District ',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                          errorText:
                              _validateDistrict(_districtController.text),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Pin Code *',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Cera-Bold',
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      SizedBox(
                        // height: MediaQuery.of(context).size.height * 0.06,
                        child: TextFormField(
                          controller: _pincodeController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Enter Pin Code ',
                            labelStyle: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Cera-Bold',
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                            errorText:
                                _validatePincode(_pincodeController.text),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                //
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Mobile Number *',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Cera-Bold',
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      SizedBox(
                        // height: MediaQuery.of(context).size.height * 0.06,
                        child: TextFormField(
                          controller: _mobileController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Enter Mobile Number ',
                            labelStyle: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Cera-Bold',
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                            errorText:
                                _validateMobileNo(_mobileController.text),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Alternate Mobile Number *',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Cera-Bold',
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      SizedBox(
                        // height: MediaQuery.of(context).size.height * 0.06,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: _alternateMobileController,
                          decoration: InputDecoration(
                            labelText: 'Enter Alternate Mobile Number ',
                            labelStyle: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Cera-Bold',
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                            errorText: _validateAlternateMobileNo(
                                _alternateMobileController.text),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Landline *',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Cera-Bold',
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.3,
                            // height: MediaQuery.of(context).size.height * 0.06,
                            child: TextFormField(
                              controller: _stdCodeController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Enter STD Code',
                                labelStyle: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Cera-Bold',
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                // errorText: _validateAadhar(_adhrController.text),
                                // errorText:_validateAlternateMobileNo(_alternateMobileController.text),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.03,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.6,
                            // height: MediaQuery.of(context).size.height * 0.06,
                            child: TextFormField(
                              controller: _enterLandlineController,
                              decoration: InputDecoration(
                                labelText: 'Enter Landline Number',
                                labelStyle: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Cera-Bold',
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                // errorText: _validateAadhar(_adhrController.text),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width * 0.42,
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
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.02,
                    ),
                    InkWell(
                      onTap: () {
                        if (_validateForm()) {
                          final installationAddressInfo = InstallationAddress(
                            buildingName: _buildingNameController.text,
                            address: _addressController.text,
                            gpeDeviceLocation:
                                _gpeDeviceLocationController.text,
                            area: _areaController.text,
                            alternateMobile: _alternateMobileController.text,
                            pincode: _pincodeController.text,
                            mobile: _mobileController.text,
                            stdCode: _stdCodeController.text,
                            enterLandline: _enterLandlineController.text,
                            popid: _selectedSbstnId,
                            popname: _selectedSbstnName,
                            villageorCity: _selectedMndlId,
                            district: _selectedDstrtId,
                            villagecode: _selectedVlgeId,
                            villagename: _selectedVlgeName,
                            mandalName:
                                _districtController.text, // Add this line
                          );

                          print(
                              'this is village name ${_selectedVlgeName}'); //VIJAYAWADA(URBAN)
                          print(
                              'this is mandal name ${_mandalController.text}'); // Print mandal name

                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => BaseBackages(
                                installationAddressInfo:
                                    installationAddressInfo,
                                customerInfoDataFormat: widget.customerInfo,
                              ),
                            ),
                          );
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: MediaQuery.of(context).size.height * 0.05,
                        decoration: BoxDecoration(
                          color:
                              _isFormValid ? Pallete.buttonColor : Colors.grey,
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
                    ),
                  ],
                ),
                Container(
                  height: 20,
                  margin: EdgeInsets.only(top: 20),
                  color: Pallete.backgroundColor,
                  padding: EdgeInsets.symmetric(horizontal: 10),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
