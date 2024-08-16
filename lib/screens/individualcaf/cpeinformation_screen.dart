import 'package:apsfllmo/screens/individualcaf/datamodal/customerinformationdatamodal.dart';
import 'package:apsfllmo/screens/individualcaf/datamodal/installationaddressdatamodal.dart';
import 'package:apsfllmo/screens/homescreen/home_screen.dart';
// import 'package:apsfllmo/screens/homescreen/bbnlhome_screen.dart';
// import 'package:apsfllmo/screens/searchcafs/customerdetails_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../utils/pallete.dart';

class CpeinformationScreen extends StatefulWidget {
  final int? selectedPackageIndex;
  final InstallationAddress installationAddressDataFormat;
  final CustomerInformation customerInfoDataFormat;
  final String efcteDt;
  final String expryDt;
  final int pckgeId;
  final int srvcpk_id;
  final double bsePckPrice;
  final List<dynamic> srvcs;

  const CpeinformationScreen({
    Key? key,
    this.selectedPackageIndex,
    required this.installationAddressDataFormat,
    required this.customerInfoDataFormat,
    required this.efcteDt,
    required this.expryDt,
    required this.pckgeId,
    required this.srvcpk_id,
    required this.bsePckPrice,
    required this.srvcs,
  }) : super(key: key);

  @override
  State<CpeinformationScreen> createState() => _CpeinformationScreenState();
}

class _CpeinformationScreenState extends State<CpeinformationScreen> {
  final TextEditingController _buildingNameController =
      TextEditingController(); // Controller for first name
  final TextEditingController _oltNameController =
      TextEditingController(); // Controller for OLT name
  final TextEditingController _onuSerialNumberController =
      TextEditingController(); // Controller for OLT name
  final TextEditingController _onuModalNumberController =
      TextEditingController(); // Controller for OLT name
  final TextEditingController _onuMacIdController =
      TextEditingController(); // Controller for OLT name
  final TextEditingController _onuRentalController =
      TextEditingController(); // Controller for OLT name
  final TextEditingController _iptvModelController =
      TextEditingController(); // Controller for OLT name
  final TextEditingController _iptvMacIdController =
      TextEditingController(); // Controller for OLT name
  final TextEditingController _onuSerialNumber1Controller =
      TextEditingController(); // Controller for OLT name
  final TextEditingController _installationChargeController =
      TextEditingController(); // Controller for OLT name
  bool _isGetPackagesLoading = false;
  bool _isSlotDetailsLoading = false;

  List<Map<String, dynamic>> _slotDetailsData = [];
  List<Map<String, dynamic>> _oltDetails = [];
  List<Map<String, dynamic>> _oltPortDetails = [];
  List<String> _oltNames = [];
  List<String> _oltPortNames = [];
  String? _selectedOltName;
  String? _selectedOltId;
  String? _selectedolt_ip_addr_tx;
  String? _selectedolt_acs_nde_id;
  String? _selectedolt_srl_nu;
  String? _selectedOltPortName;
  String? _selectedOltPortId; // Added to store selected olt_prt_id
  String? _selectedsplt_id; // Added to store selected olt_prt_id
  String? _selectedolt_prt_nm; // Added to store selected olt_prt_id
  String? _selectedOltPortIdLevel1; // Added to store selected olt_prt_idLevel1
  String? _selectedSlotId; // Added to store selected slt1_id

  @override
  @override
  void initState() {
    super.initState();
    _getPckgesByAgntId();
    _getpckgeProperties();
    _oltNameController.text =
        widget.installationAddressDataFormat.popname ?? '';

    // Print specific properties from installationAddressDataFormat
    print('installationAddressDataFormat: {');
    print('  popname: ${widget.installationAddressDataFormat.popname}');
    print('  // Add other properties you want to print...');
    print('}');

    // Print specific properties from customerInfoDataFormat
    print('customerInfoDataFormat: {');
    print('  // Add properties from CustomerInformation you want to print...');
    print('  popname: ${widget.customerInfoDataFormat.aadharNumber}');
    print('}');
  }

  @override
  void dispose() {
    _onuModalNumberController.dispose();
    _onuMacIdController.dispose();
    super.dispose();
  }

  bool _isLoading = false;
  String? upStreamTrafficProfile;
  String? downStreamTrafficProfile;
  String? up_strm_trfficpfl_nm;

  // -------------------------------------------- start getpckgeProperties --------------------------------------------
  Future<void> _getpckgeProperties() async {
    print('Inside _getpckgeProperties function');

    setState(() {
      _isLoading = true;
    });

    const apiUrl = 'http://bss.apsfl.co.in/apiv1/caf/getpckgeProperties';
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
      "data": [
        {
          "srvcpk_id": widget.srvcpk_id,
          "pckge_id": widget.pckgeId,
        }
      ],
      "0": {
        "srvcpk_id": widget.srvcpk_id,
        "pckge_id": widget.pckgeId,
      }
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

        if (data.isNotEmpty) {
          final Map<String, dynamic> firstItem = data[0];

          // Combine aaa_up_nrml and aaa_dw_nrml
          String upSpeed = firstItem['aaa_up_nrml'] ?? '';
          String downSpeed = firstItem['aaa_dw_nrml'] ?? '';

          // Format the combined string
          String combinedSpeeds = '$upSpeed\_$downSpeed';

          setState(() {
            up_strm_trfficpfl_nm = firstItem['up_strm_trfficpfl_nm'] ?? '';
            upStreamTrafficProfile = combinedSpeeds;
            downStreamTrafficProfile = firstItem['dwn_strm_trfficpfl_nm'];
            _isLoading = false;
          });

          print('Updated up_strm_trfficpfl_nm: $up_strm_trfficpfl_nm');
          print('Updated upStreamTrafficProfile: $upStreamTrafficProfile');
          print('Updated downStreamTrafficProfile: $downStreamTrafficProfile');
        }
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

  // -------------------------------------------- end getpckgeProperties --------------------------------------------

  Future<void> _getPckgesByAgntId() async {
    print('Inside fetchData function');
    if (_isGetPackagesLoading) return;

    setState(() {
      _isGetPackagesLoading = true;
    });

    final apiUrl =
        'http://bss.apsfl.co.in/apiv1/olt/getOltdtls/${widget.installationAddressDataFormat.popid}';
    final storage = FlutterSecureStorage();
    final String? token = await storage.read(key: 'token');

    print('Retrieved token: $token');

    if (token == null) {
      setState(() {
        _isGetPackagesLoading = false;
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
        print('Data received from cpe information: $data');

        // Log each item to verify structure
        data.forEach((item) {
          print('Item: $item');
        });

        // Update the state after the widget has fully initialized
        WidgetsBinding.instance!.addPostFrameCallback((_) {
          setState(() {
            _oltDetails = data.map<Map<String, dynamic>>((item) {
              return {
                'olt_id': item['olt_id'].toString(),
                'olt_nm': item['olt_nm'],
                'olt_ip_addr_tx': item['olt_ip_addr_tx'],
                'olt_acs_nde_id':
                    item['olt_acs_nde_id'], // Ensure this field is included
                'olt_srl_nu':
                    item['olt_srl_nu'] // Ensure this field is included
              };
            }).toList();

            _oltNames = _oltDetails
                .map<String>((item) => item['olt_nm'] as String)
                .toList();

            _selectedOltId =
                _oltDetails.isNotEmpty ? _oltDetails[0]['olt_id'] : null;
            _selectedolt_ip_addr_tx = _oltDetails.isNotEmpty
                ? _oltDetails[0]['olt_ip_addr_tx']
                : null;
            _selectedolt_acs_nde_id = _oltDetails.isNotEmpty
                ? _oltDetails[0]['olt_acs_nde_id']
                : null;
            _selectedolt_srl_nu =
                _oltDetails.isNotEmpty ? _oltDetails[0]['olt_srl_nu'] : null;
            _selectedOltName = _oltNames.isNotEmpty ? _oltNames[0] : null;
            _isGetPackagesLoading = false;

            print('Selected OLT ID: $_selectedOltId');
            print('Selected OLT IP Address: $_selectedolt_ip_addr_tx');
            print('Selected OLT ACS NDE ID: $_selectedolt_acs_nde_id');
            print('Selected OLT SRL Number: $_selectedolt_srl_nu');
          });
        });
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      setState(() {
        _isGetPackagesLoading = false;
      });
      print('Failed to fetch data: $e');
    }
  }

  Future<void> _getOltPortDetails(String oltId) async {
    final apiUrl = 'http://bss.apsfl.co.in/apiv1/olt/slotDetails/$oltId';
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

        print('OLT Port Details: $data');

        setState(() {
          _oltPortDetails = data
              .map<Map<String, dynamic>>((item) => {
                    'olt_prt_nm': item['olt_prt_nm'].toString(),
                    'olt_prt_id': item['olt_prt_id'].toString(),
                  })
              .toList();
          _oltPortNames = _oltPortDetails
              .map<String>((item) => item['olt_prt_nm'] as String)
              .toList();
          _selectedOltPortName =
              _oltPortNames.isNotEmpty ? _oltPortNames[0] : null;
          _selectedOltPortName =
              _oltPortNames.isNotEmpty ? _oltPortNames[0] : null;

          print('OLT Port Names: $_oltPortNames');
          print('Selected OLT Port Name: $_selectedOltPortName');
        });
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      print('Failed to fetch data: $e');
    }
  }

  Future<void> _getSlotDetailsForPort(String oltPortId) async {
    final apiUrl =
        'http://bss.apsfl.co.in/apiv1/olt/slotDetailsForPort/$oltPortId';
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

        setState(() {
          _slotDetailsData = data
              .map<Map<String, dynamic>>((item) => {
                    'slt1_id': item['slt1_id'].toString(),
                    'olt_prt_id': item['olt_prt_id'].toString(),
                  })
              .toList();

          // Assuming you want to set the first slt1_id by default
          _selectedSlotId = _slotDetailsData.isNotEmpty
              ? _slotDetailsData[0]['slt1_id']
              : null;

          print('Slot Details for Port: $data');
        });
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      print('Failed to fetch data: $e');
    }
  }

  List<Map<String, dynamic>> _slotTwoDetailsData = [];

  void _slottwoDetailsForPort(String slt1Id, String oltPortId) async {
    print('this is oltPortId in slot two $_selectedOltPortId');
    final String apiUrl =
        'http://bss.apsfl.co.in/apiv1/olt/slottwoDetailsForPort';
    final storage = FlutterSecureStorage();
    final String? token = await storage.read(key: 'token');

    if (token == null) {
      return;
    }

    final Map<String, String> headers = {
      'x-access-token': token,
      'Content-Type': 'application/json'
    };

    final Map<String, dynamic> requestBody = {
      "data": [
        {
          "level1": slt1Id,
          "olt_prt_id": oltPortId,
        }
      ]
    };

    print('Slot two details request: $requestBody');
    // working oltPortId

    try {
      final http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        // Handle response data here
        print('Slot two details response: $responseData');
        setState(() {
          _slotTwoDetailsData = List<Map<String, dynamic>>.from(
            responseData['data'].map((item) => item as Map<String, dynamic>),
          );
        });
      } else {
        throw Exception('Failed to fetch slot two details');
      }
    } catch (e) {
      print('Failed to fetch data: $e');
    }
  }

  String? _selectedSlotTwoId;
  String? _selectedSlotThreeId; // To store selected Level-3 slot
  List<String> _slotThreeDetailsData = []; // To store Level-3 slot details

  // Declare _onuId as a state variable in your State class
  int? _onuId; // Change int to the appropriate type if onu_id is not an integer

  void _slotthreeDetailsForPort(String slt1Id, String splt2Nu) async {
    print('this is oltPortId in slot three $_selectedOltPortId');
    final String apiUrl =
        'http://bss.apsfl.co.in/apiv1/olt/slotthreeDetailsForPort';
    final storage = FlutterSecureStorage();
    final String? token = await storage.read(key: 'token');

    if (token == null) {
      return;
    }

    final Map<String, String> headers = {
      'x-access-token': token,
      'Content-Type': 'application/json'
    };

    final Map<String, dynamic> requestBody = {
      "data": [
        {
          "level1": slt1Id,
          "level2": splt2Nu,
          "olt_prt_id": _selectedOltPortId,
        }
      ]
    };

    print('Slot three details request: $requestBody');

    try {
      final http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        // Handle response data here
        print('Slot three details response: $responseData');

        // Parse and update the state with Level-3 slot details
        List<dynamic> data = responseData['data'];
        setState(() {
          _slotThreeDetailsData =
              data.map<String>((item) => item['splt3_nu'].toString()).toList();
          _selectedSlotThreeId = null; // Reset selected Level-3 slot

          // Store onu_id
          _onuId = data.isNotEmpty ? data[0]['onu_id'] : null;
          print('Stored onu_id: $_onuId');
        });
      } else {
        throw Exception('Failed to fetch slot three details');
      }
    } catch (e) {
      print('Failed to fetch data: $e');
    }
  }

  String? _errorMessage;
  String? stpbx_id;
  int? emi_at;
  int? up_frnt_chrgs_at;

  Future<void> _boxdtls(String onuSerialNo) async {
    print('Onu Serial No: $onuSerialNo');
    final apiUrl = 'http://bss.apsfl.co.in/apiv1/caf/boxdtls/$onuSerialNo';
    final storage = FlutterSecureStorage();
    final String? token = await storage.read(key: 'token');

    if (token == null) {
      setState(() {
        _errorMessage = 'Token not found';
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
        print('Response data from _boxdtls: $responseData');
        if (responseData['status'] == 200 &&
            responseData['data'] != null &&
            responseData['data'].isNotEmpty) {
          final data = responseData['data'][0];
          setState(() {
            _iptvModelController.text = data['mdle_nm'] ?? '';
            _iptvMacIdController.text = data['mac_addr_cd'] ?? '';
            stpbx_id = data['stpbx_id']?.toString(); // Convert int to String
            emi_at = data['emi_at'] ?? 0; // Ensure emi_at is an integer
            up_frnt_chrgs_at =
                data['up_frnt_chrgs_at'] ?? 0; // Ensure emi_at is an integer

            print('stpbx_id: $stpbx_id');
            print('emi_at: $emi_at');
            print('up_frnt_chrgs_at: $up_frnt_chrgs_at');

            print(
                '_onuModalNumberController: ${_onuModalNumberController.text}');
            _errorMessage = 'Successfully fetched data';
          });
        } else {
          setState(() {
            _errorMessage = 'Failed to fetch data';
          });
          throw Exception('Invalid response data');
        }
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
      print('Failed to fetch data: $e');
    }
  }

  String? _errorMessage1;
  String? onu_srl_nu;
  String? mac_addr_cd;
  int? onu_stpbx_id;
  String? emi_ct;
  String? emi_ctData;
  List<String> mdl_dtls_tx = [];

  Future<void> _boxdtls1(String onuSerialNo) async {
    final apiUrl = 'http://bss.apsfl.co.in/apiv1/caf/boxdtls/$onuSerialNo';
    final storage = FlutterSecureStorage();
    final String? token = await storage.read(key: 'token');

    if (token == null) {
      setState(() {
        _errorMessage1 = 'Token not found';
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
        print('Response data from _boxdtls: $responseData');
        if (responseData['status'] == 200 &&
            responseData['data'] != null &&
            responseData['data'].isNotEmpty) {
          final data = responseData['data'][0];
          setState(() {
            _onuModalNumberController.text = data['mdle_cd'];
            _onuMacIdController.text = data['mac_addr_cd'];
            mac_addr_cd = data['mac_addr_cd'];
            _onuRentalController.text = data['emi_at'].toString();
            emi_ctData = data['emi_at'].toString();
            emi_ct = data['emi_ct'].toString();
            onu_srl_nu = data['srl_nu'];
            onu_stpbx_id = data['stpbx_id'];

            // Handle mdl_dtls_tx conversion with double quotes
            String mdlDtlsTxString = data['mdl_dtls_tx'] ?? '';
            List<String> mdl_dtls_tx =
                mdlDtlsTxString.split(',').map((e) => '"$e"').toList();
            print('this is the mdl_dtls_tx: $mdl_dtls_tx');
            print(' this is the mdlDtlsTxString: $mdlDtlsTxString');

            print(
                '_onuModalNumberController: ${_onuModalNumberController.text}');
            _errorMessage = 'Successfully fetched data';
          });
        } else {
          setState(() {
            _errorMessage = (responseData['message'] ?? 'Failed to fetch data');
          });
          throw Exception('Invalid response data');
        }
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      print('Failed to fetch data: $e');
      setState(() {
        _errorMessage1 = 'Failed to fetch data: $e';
      });
    }
  }

  final _formKey = GlobalKey<FormState>();

  String? _validateEmpty(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  String selectIptvValue = '';
  String selectOnuValue = '';

  Future<void> _provision() async {
    // Extract data from controllers
    String onuSerialNumber = _onuSerialNumberController.text;
    String onuModalNumber = _onuModalNumberController.text;
    String onuMacId = _onuMacIdController.text;
    String onuRental = _onuRentalController.text;
    String installationCharge = _installationChargeController.text;
    String onuSerialNumber1 = _onuSerialNumber1Controller.text;
    String iptvModel = _iptvModelController.text;
    String iptvMacId = _iptvMacIdController.text;
    print('onuRental: $onuRental');
    print(' onuSerialNumber : $onuSerialNumber');
    print(' onuModalNumber : $onuModalNumber');
    print(' onuSerialNumber1 : $onuSerialNumber1');
    print(' iptvMacId : $onuMacId');
    bool _isLoading = false;
    print('Inside fetchData function provision');
    // if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    const apiUrl = 'http://bss.apsfl.co.in/apiv1/caf_operations/provision';
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
        "adhr_nu":
            '${widget.customerInfoDataFormat.aadharNumber}', // * COMPLETED
        "actvn_dt": null, // * COMPLETED
        "agnt_id": 103000730, // TODO : CHANGE AGENT ID
        "apsf_unq_id": 0, // * COMPLETED
        "apsfl_bbnl": 3, // * COMPLETED
        "blng_cntct_nm": "",
        "blng_cycle_id": 0, // * COMPLETED
        "blng_dstrct_id":
            '${widget.installationAddressDataFormat.district}', // * COMPLETED
        "blng_eml1_tx": '${widget.customerInfoDataFormat.email}', // * COMPLETED
        "blng_house_flat_no":
            '${widget.installationAddressDataFormat.buildingName}', // * COMPLETED
        "blng_lnd_nu": null, // * COMPLETED
        "blng_lcly_tx":
            '${widget.installationAddressDataFormat.gpeDeviceLocation}', // * COMPLETED
        "blng_mndl_id":
            '${widget.installationAddressDataFormat.villageorCity}', // * COMPLETED
        "blng_buildingname":
            '${widget.installationAddressDataFormat.area}', // * COMPLETED
        "blng_pn_cd":
            '${widget.installationAddressDataFormat.pincode}', // * COMPLETED
        "blng_ste_id": 0, // * COMPLETED
        "blng_std_cd":
            '${widget.installationAddressDataFormat.stdCode}', // * COMPLETED
        "blng_streetname":
            '${widget.installationAddressDataFormat.address}', // * COMPLETED
        "blng_vlge_id":
            '${widget.installationAddressDataFormat.villagecode} ', // * COMPLETED
        "blble_caf_in": 0, // * COMPLETED
        "caf_type_id": 1, // * COMPLETED caf --> 1 , enterprice caf --> 2
        "cnctn_sts_id": 1, // * COMPLETED
        "cst_at": "${widget.bsePckPrice}", // * COMPLETED
        "cpe_pop_id":
            '${widget.installationAddressDataFormat.popid}', // * COMPLETED
        "crnt_caf_sts_id": 1, // * COMPLETED
        "crnt_pckge_id": "${widget.pckgeId}", // * COMPLETED
        "custInfo": {
          "adhr_nu":
              '${widget.customerInfoDataFormat.aadharNumber}', // * COMPLETED
          "actvn_dt": null, // * COMPLETED
          "apsfl_bbnl": 3, // * COMPLETED
          "blng_cntct_nm": "", // * COMPLETED
          "blng_dstrct_id":
              '${widget.installationAddressDataFormat.district}', // * COMPLETED
          "blng_eml1_tx":
              '${widget.customerInfoDataFormat.email}', // * COMPLETED
          "blng_house_flat_no":
              '${widget.installationAddressDataFormat.buildingName}', // * COMPLETED
          "blng_lnd_nu": null, // * COMPLETED
          "blng_lcly_tx":
              '${widget.installationAddressDataFormat.gpeDeviceLocation}', // * COMPLETED
          "blng_mndl_id":
              '${widget.installationAddressDataFormat.villageorCity}', // * COMPLETED
          "blng_buildingname":
              '${widget.installationAddressDataFormat.area}', // * COMPLETED
          "blng_pn_cd":
              '${widget.installationAddressDataFormat.pincode}', // * COMPLETED
          "blng_ste_id": 1, // * COMPLETED
          "blng_std_cd":
              '${widget.installationAddressDataFormat.stdCode}', // * COMPLETED
          "blng_streetname":
              '${widget.installationAddressDataFormat.address}', // * COMPLETED
          "blng_vlge_id":
              '${widget.installationAddressDataFormat.villagecode}', // * COMPLETED
          "custmrTyp": "", // * COMPLETED
          "dob_dt":
              '${widget.customerInfoDataFormat.dateOfBirth} ', // * COMPLETED
          "frst_nm":
              '${widget.customerInfoDataFormat.firstName}', // * COMPLETED
          "frqncy_id":
              '${widget.customerInfoDataFormat.selectedFrequencyId}', // * COMPLETED
          "gndr_id":
              '${widget.customerInfoDataFormat.selectedGenderIndex}', // * COMPLETED
          "instl_buildingname":
              '${widget.installationAddressDataFormat.area}', // * COMPLETED
          "instl_chk_ind": false, // * COMPLETED
          "instl_house_flat_no":
              '${widget.installationAddressDataFormat.buildingName}', // * COMPLETED
          "instl_pincode":
              '${widget.installationAddressDataFormat.pincode}', // * COMPLETED
          "instl_state": 1, // ! not completed
          "instl_streetname":
              '${widget.installationAddressDataFormat.address}', // * COMPLETED
          "lst_nm": '${widget.customerInfoDataFormat.surname}', // * COMPLETED
          "loc_dstrct_id":
              '${widget.installationAddressDataFormat.district}', // * COMPLETED
          "loc_eml1_tx":
              '${widget.customerInfoDataFormat.email}', // * COMPLETED
          "loc_lnd_nu": null, // * COMPLETED
          "loc_lmdle1_nu":
              '${widget.installationAddressDataFormat.mobile}', // * COMPLETED
          "loc_lcly_tx":
              '${widget.installationAddressDataFormat.gpeDeviceLocation}', // * COMPLETED
          "loc_mndl_id":
              '${widget.installationAddressDataFormat.villageorCity}',
          "loc_std_cd": '${widget.installationAddressDataFormat.stdCode}',
          "loc_vlge_id": '${widget.installationAddressDataFormat.villagecode}',
          "mdlr_nm": "${widget.customerInfoDataFormat.middleName}",
          "mbl_nu": '${widget.installationAddressDataFormat.mobile}',
          "pan_nu": "", // * COMPLETED
          "pop_id": '${widget.installationAddressDataFormat.popid}',
          "rltve_nm": "", // * COMPLETED //enterprise caf
          "tle_nm": "Mr" // * COMPLETED
        },
        "custmrTyp": "", // * COMPLETED
        "dob_dt": '${widget.customerInfoDataFormat.dateOfBirth}', // * COMPLETED
        "dprmnt_id": 0, // * COMPLETED 0 --> individual , 1 --> enterprise
        "efcte_dt": "${widget.efcteDt}", // * COMPLETED
        "enty_sts_id": 1, // * COMPLETED
        "expry_dt": "${widget.expryDt}", // * COMPLETED
        "frst_nm": '${widget.customerInfoDataFormat.firstName}', // * COMPLETED
        "frqncy_id":
            '${widget.customerInfoDataFormat.selectedFrequencyId}', // * COMPLETED
        "gndr_id":
            '${widget.customerInfoDataFormat.selectedGenderIndex}', // * COMPLETED
        "inst_amt":
            onuRental, // * COMPLETED  // installation charge in last page
        "instl_buildingname":
            '${widget.installationAddressDataFormat.area}', // * COMPLETED
        "instl_chk_ind": true, // * COMPLETED
        "instl_house_flat_no":
            '${widget.installationAddressDataFormat.buildingName}', // * COMPLETED
        "instl_pincode":
            '${widget.installationAddressDataFormat.pincode}', // * COMPLETED
        "instl_state": 1, // ! not completed FIXME:   TODO:
        "instl_streetname":
            '${widget.installationAddressDataFormat.address}', // * COMPLETED
        "iptv_bx_amt": null, // * COMPLETED
        "iptv_bx_emi": emi_at, // * COMPLETED
        "iptv_bx_own": selectIptvValue, // * COMPLETED
        "iptv_bx_srl_num": onuSerialNumber1, // * COMPLETED
        "iptv_bx_up_amt": up_frnt_chrgs_at, // * COMPLETED //up_frnt_chrgs_at #7
        "iptv_mac_addr_tx": iptvMacId, // * COMPLETED
        "iptv_mdl": iptvModel, // * COMPLETED
        "iptv_stpbx_id": stpbx_id, // * COMPLETED
        "lst_nm": '${widget.customerInfoDataFormat.surname}', // * COMPLETED
        "lat": 0.0, // * COMPLETED
        "lvl1_slt": _selectedSlotId, // * COMPLETED
        "lvl2_slt": _selectedSlotTwoId, // * COMPLETED
        "lvl3_slt": _selectedSlotThreeId, // * COMPLETED
        "lg_id": "lag::", // * COMPLETED
        "loc_eml1_tx": '${widget.customerInfoDataFormat.email}', // * COMPLETED
        "loc_lmdle1_nu":
            '${widget.installationAddressDataFormat.mobile}', // * COMPLETED
        "loc_lcly_tx":
            '${widget.installationAddressDataFormat.gpeDeviceLocation}', // * COMPLETED
        "loc_dstrct_id":
            '${widget.installationAddressDataFormat.district}', // * COMPLETED
        "loc_lnd_nu": null, // * COMPLETED
        "loc_mndl_id":
            '${widget.installationAddressDataFormat.villageorCity}', // * COMPLETED
        "loc_std_cd":
            '${widget.installationAddressDataFormat.stdCode}', // * COMPLETED
        "loc_vlge_id":
            '${widget.installationAddressDataFormat.villagecode}', // * COMPLETED
        "lng": 0.0, // * COMPLETED
        "mdlr_nm": "${widget.customerInfoDataFormat.middleName}", // * COMPLETED
        "mbl_nu":
            '${widget.installationAddressDataFormat.mobile}', // * COMPLETED
        "olt_acs_nde_id": _selectedolt_acs_nde_id, // * COMPLETED
        "olt_crd_nu": 1, // ! NOT COMPLETED
        "olt_id": _selectedOltId, // * COMPLETED
        "olt_ip_addr_tx": _selectedolt_ip_addr_tx, // * COMPLETED
        "olt_prt_nm": _selectedolt_prt_nm, // * COMPLETED
        "olt_prt_id": _selectedOltPortId, // * COMPLETED
        "olt_prt_splt_tx": "3-3-3", // ! NOT COMPLETED
        "olt_srl_nu": _selectedolt_srl_nu, // * COMPLETED
        "onu_amt": emi_ct, // * COMPLETED
        "onu_emi": emi_ctData, // * COMPLETED
        "onu_id": _onuId, // * COMPLETED
        "onu_mac_addr_tx": mac_addr_cd, // * COMPLETED
        "onu_mdl": onuModalNumber, // * COMPLETED
        "onu_own": selectOnuValue, // * COMPLETED
        "onu_srl_nu": onu_srl_nu, // * COMPLETED
        "onu_stpbx_id": onu_stpbx_id, // * COMPLETED
        "onu_up_frmt_amt":
            up_frnt_chrgs_at, // * COMPLETED  # 6 "up_frnt_chrgs_at":
        "orgsn_cd": "", // * COMPLETED only enterprise
        "pan_nu": "", // * COMPLETED
        "pop_id":
            '${widget.installationAddressDataFormat.popid}', // * COMPLETED
        "prnt_cstmr_id": 0, // * COMPLETED
        "prv_Dtls": {
          "accessId": onuMacId, // * COMPLETED
          "address":
              "${widget.installationAddressDataFormat.buildingName}, ${widget.installationAddressDataFormat.address}, ${widget.installationAddressDataFormat.gpeDeviceLocation}", // * COMPLETED
          "admin": "1", // * COMPLETED
          "card": 1, // ? DOUBT
          "contactno":
              '${widget.installationAddressDataFormat.mobile}', // * COMPLETED
          "countryCode": "INDIA", // * COMPLETED
          "countryISO2": "IN", // * COMPLETED
          "districtCode":
              "${widget.installationAddressDataFormat.mandalName}", // * COMPLETED
          "downstreamTrafficProfileName":
              downStreamTrafficProfile, // * COMPLETED
          "emailid": "", // * COMPLETED
          "fec": "true", // * COMPLETED
          "firstname":
              '${widget.customerInfoDataFormat.firstName}', // * COMPLETED
          "fup": upStreamTrafficProfile, // * COMPLETED
          "identityProofId": 0, // * COMPLETED entrprise --> 0
          "ipAddress": _selectedolt_ip_addr_tx, // * COMPLETED
          "lastname": '${widget.customerInfoDataFormat.surname}', // * COMPLETED
          "mandal": '${widget.installationAddressDataFormat.villagename}',
          "name": "", // * COMPLETED
          "nativeVlan": false, // * COMPLETED
          "networkServiceName": "HSI", // * COMPLETED
          "olt_srl_nu": _selectedolt_srl_nu, // * COMPLETED
          "onuId": _onuId, // * COMPLETED
          "partnerCode": "LMO2000825", // TODO : CHANGE AGENT ID
          "profileName": onuModalNumber, // * COMPLETED
          "registerType": "1", // * COMPLETED
          "serialNumber": _selectedolt_srl_nu, // * COMPLETED
          "srvcs": '${widget.srvcs}', // * COMPLETED
          "stateCode": "AP", // * COMPLETED
          "swUpgradeMode": "2", // * COMPLETED
          "tp": _selectedOltPortName,
          "tps": mdl_dtls_tx, // ? NOT CORRECTLY FIGURED
          "upstreamTrafficProfileName": up_strm_trfficpfl_nm,
          "village": '${widget.installationAddressDataFormat.villagename}',
        },
        "rltve_nm": "", // * COMPLETED //enterprise caf
        "splt_id": _selectedsplt_id, // * COMPLETED  #5  --> splt_id
        "status": 1, // * COMPLETED
        "tel_cns": "0", // * COMPLETED
        "tle_nm": "Mr" // * COMPLETED
      }
    };

    print('Request headers of provision : $headers');
    print(
        'Request body of POST request of provision :  ${json.encode(requestBody)}');

    final http.Response response = await http.post(
      Uri.parse(apiUrl),
      headers: headers,
      body: json.encode(requestBody),
    );

    print('Response status code in provision: ${response.statusCode}');
    print('Response body in provision: ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      // Check if the 'message' field is a string and not empty
      if (responseData.containsKey('message') &&
          responseData['message'] is String) {
        String message = responseData['message'];

        // Show toast message for 'message'
        Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        Fluttertoast.showToast(
          msg: 'No message received',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey[600],
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }

      // Check if the 'data' field is present
      if (responseData.containsKey('data')) {
        String data = responseData['data'].toString();

        // Show toast message for 'data'
        Fluttertoast.showToast(
          msg: 'Data: $data',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );

        // ! please enable this for submit api routing
        // Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        //   return const CustomerdetailsScreen();
        // }));
      } else {
        Fluttertoast.showToast(
          msg: 'No data received',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey[600],
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      print('Failed to fetch data. Status code: ${response.statusCode}');
      throw Exception('Failed to fetch data');
    }
  }

  @override
  Widget build(BuildContext context) {
    // print('this is efcteDt ${widget.efcteDt}');
    // print('this is expryDt ${widget.expryDt}');
    // print('this is pckgeId ${widget.pckgeId}');
    // print('this is bsePckPrice ${widget.bsePckPrice}');
    // print('this is srvcs ${widget.srvcs}');
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
          // color: Colors.amber,
          // padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Material(
                  elevation: 8,
                  child: Container(
                    // color: Colors.cyan,
                    // padding: EdgeInsets.all(8),
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(10),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'CPE Information',
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Cera-Bold',
                                fontSize: 22,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              const SizedBox(height: 20),
                              if (_isGetPackagesLoading ||
                                  _isSlotDetailsLoading)
                                const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              if (!_isGetPackagesLoading &&
                                  !_isSlotDetailsLoading)
                                SizedBox(
                                  child: TextFormField(
                                    controller: _oltNameController,
                                    decoration: InputDecoration(
                                      labelText: 'Pop Name',
                                      labelStyle: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Cera-Bold',
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(40),
                                      ),
                                    ),
                                    readOnly: true,
                                  ),
                                ),
                              const SizedBox(height: 20),
                              SizedBox(
                                width: double.infinity,
                                child: DropdownButtonFormField<String>(
                                  value: _selectedOltName,
                                  items: _oltNames.map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _selectedOltName = newValue;
                                      _selectedOltId = _oltDetails.firstWhere(
                                          (item) =>
                                              item['olt_nm'] ==
                                              newValue)['olt_id'];
                                    });
                                    _getOltPortDetails(_selectedOltId!);
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'OLT ID',
                                    labelStyle: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Cera-Bold',
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                width: double.infinity,
                                child: DropdownButtonFormField<String>(
                                  value: _selectedOltPortName,
                                  items: _oltPortNames.map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _selectedOltPortName = newValue;
                                      var selectedPort =
                                          _oltPortDetails.firstWhere((port) =>
                                              port['olt_prt_nm'] == newValue);
                                      _selectedOltPortId =
                                          selectedPort['olt_prt_id'];
                                      _selectedolt_prt_nm =
                                          selectedPort['olt_prt_nm'];
                                    });

                                    print(
                                        ' this is port name from $_selectedolt_prt_nm ');
                                    print(
                                        ' this is port id from $_selectedOltPortId ');
                                    _getSlotDetailsForPort(_selectedOltPortId!);
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'OLT Port - ID',
                                    labelStyle: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Cera-Bold',
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                width: double.infinity,
                                child: DropdownButtonFormField<String>(
                                  value: _selectedSlotId,
                                  items: _slotDetailsData
                                      .map((Map<String, dynamic> item) {
                                    return DropdownMenuItem<String>(
                                      value: item['slt1_id'],
                                      child: Text(item['slt1_id']),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _selectedSlotId = newValue;
                                      print(
                                          ' this is port id from _selectedSlotId  $_selectedSlotId');

                                      // Check if _slotDetailsData is not empty
                                      if (_slotDetailsData.isNotEmpty) {
                                        var selectedSlot =
                                            _slotDetailsData.firstWhere(
                                          (slot) => slot['slt1_id'] == newValue,
                                          orElse: () => <String,
                                              dynamic>{}, // Return an empty Map in case of 'orElse'
                                        );

                                        // Set _selectedOltPortId to selectedSlot['olt_prt_id']
                                        _selectedOltPortId =
                                            selectedSlot['olt_prt_id'];
                                        print(
                                            'this is port id from _selectedOltPortId$_selectedOltPortId');

                                        // Call _slottwoDetailsForPort with slt1_id and olt_prt_id
                                        _slottwoDetailsForPort(
                                            selectedSlot['slt1_id'],
                                            selectedSlot['olt_prt_id']);
                                      } else {
                                        _selectedOltPortId =
                                            null; // Handle case where _slotDetailsData is empty
                                      }
                                    });
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Level-1 Slot',
                                    labelStyle: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Cera-Bold',
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                width: double.infinity,
                                child: DropdownButtonFormField<String>(
                                  value:
                                      _selectedSlotTwoId, // Use the variable to store selected value
                                  items: _slotTwoDetailsData
                                      .map((Map<String, dynamic> item) {
                                    return DropdownMenuItem<String>(
                                      value: item['splt2_nu'].toString(),
                                      child: Text(item['splt2_nu'].toString()),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _selectedSlotTwoId = newValue;
                                      print(
                                          'This is port id from _selectedSlotTwoId $_selectedSlotTwoId');

                                      // Check if _slotTwoDetailsData is not empty
                                      if (_slotTwoDetailsData.isNotEmpty) {
                                        var selectedSlot =
                                            _slotTwoDetailsData.firstWhere(
                                          (slot) =>
                                              slot['splt2_nu'].toString() ==
                                              newValue,
                                          orElse: () => <String,
                                              dynamic>{}, // Return an empty Map in case of 'orElse'
                                        );

                                        // Set _selectedsplt_id to selectedSlot['splt_id']
                                        _selectedsplt_id =
                                            selectedSlot['splt_id']?.toString();

                                        print(
                                            'This is port id from _selectedsplt_id $_selectedsplt_id');
                                        print(
                                            'This is port id from _selectedOltPortId $_selectedOltPortId');
                                      }

                                      // Call _slotthreeDetailsForPort with the appropriate values
                                      if (_selectedSlotId != null &&
                                          newValue != null) {
                                        _slotthreeDetailsForPort(
                                            _selectedSlotId!, newValue);
                                      }
                                    });
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Level-2 Slot',
                                    labelStyle: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Cera-Bold',
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                width: double.infinity,
                                child: DropdownButtonFormField<String>(
                                  value: _selectedSlotThreeId,
                                  items:
                                      _slotThreeDetailsData.map((String item) {
                                    return DropdownMenuItem<String>(
                                      value: item,
                                      child: Text(item),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _selectedSlotThreeId = newValue;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Level-3 Slot',
                                    labelStyle: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Cera-Bold',
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
                                    child: TextFormField(
                                      controller: _onuSerialNumberController,
                                      decoration: InputDecoration(
                                        labelText: 'Enter Onu Serial Number',
                                        labelStyle: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Cera-Bold'),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(40)),
                                        errorText: _errorMessage ??
                                            _validateEmpty(
                                                _onuSerialNumberController.text,
                                                'Onu Serial Number'),
                                      ),
                                    ),
                                  ),
                                  // IconButton(
                                  //   onPressed: () {},
                                  //   icon: Icon(Icons.qr_code_scanner),
                                  //   color: Colors.black,
                                  //   iconSize: 30,
                                  // ),
                                  IconButton(
                                    onPressed: () {
                                      _boxdtls1(
                                          _onuSerialNumberController.text);
                                    },
                                    icon: Icon(Icons.check),
                                    color: Colors.black,
                                    iconSize: 30,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                // width: MediaQuery.of(context).size.width * 0.75,
                                child: TextFormField(
                                  readOnly: true,
                                  controller: _onuModalNumberController,
                                  decoration: InputDecoration(
                                    labelText: 'Enter Onu Modal Number',
                                    labelStyle: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Cera-Bold'),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(40)),
                                    errorText: _validateEmpty(
                                        _onuModalNumberController.text,
                                        'Enter Onu Modal Number'),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                // width: MediaQuery.of(context).size.width * 0.75,
                                child: TextFormField(
                                  readOnly: true,
                                  controller: _onuMacIdController,
                                  decoration: InputDecoration(
                                    labelText: 'Enter Onu Mac-ID ',
                                    labelStyle: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Cera-Bold'),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(40)),
                                    errorText: _validateEmpty(
                                        _onuMacIdController.text,
                                        'Enter Onu Mac-ID Number'),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Container(
                                width: double.infinity,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "ONU Own",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontFamily: 'Cera-Bold',
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.4,
                                          child: RadioListTile(
                                            title: const Text(
                                              'Yes',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontFamily: 'Cera-Bold',
                                              ),
                                            ),
                                            groupValue: selectOnuValue,
                                            value: 'Yes',
                                            onChanged: (value) {
                                              setState(() {
                                                selectOnuValue =
                                                    value.toString();
                                              });
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.4,
                                          child: RadioListTile(
                                            title: const Text(
                                              'No',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontFamily: 'Cera-Bold',
                                              ),
                                            ),
                                            groupValue: selectOnuValue,
                                            value: 'No',
                                            onChanged: (value) {
                                              setState(() {
                                                selectOnuValue =
                                                    value.toString();
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                // width: MediaQuery.of(context).size.width * 0.75,
                                child: TextFormField(
                                  controller: _onuRentalController,
                                  decoration: InputDecoration(
                                    labelText: 'Enter Onu Rental',
                                    labelStyle: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Cera-Bold'),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(40)),
                                    errorText: _validateEmpty(
                                        _onuRentalController.text,
                                        'Enter Onu Rental'),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                // width: MediaQuery.of(context).size.width * 0.75,
                                child: TextFormField(
                                  controller: _installationChargeController,
                                  decoration: InputDecoration(
                                    labelText: 'Enter Installation Charge ',
                                    labelStyle: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Cera-Bold'),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(40)),
                                    errorText: _validateEmpty(
                                        _installationChargeController.text,
                                        'Enter Installation Charge'),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
                                    child: TextFormField(
                                      controller: _onuSerialNumber1Controller,
                                      decoration: InputDecoration(
                                        labelText: 'Enter IPTV Serial Number',
                                        labelStyle: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Cera-Bold'),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(40)),
                                        errorText: _errorMessage1 ??
                                            _validateEmpty(
                                                _onuSerialNumberController.text,
                                                'Onu Serial Number'),
                                      ),
                                    ),
                                  ),
                                  // IconButton(
                                  //   onPressed: () {},
                                  //   icon: Icon(Icons.qr_code_scanner),
                                  //   color: Colors.black,
                                  //   iconSize: 30,
                                  // ),
                                  IconButton(
                                    onPressed: () {
                                      _boxdtls(
                                          _onuSerialNumber1Controller.text);
                                    },
                                    icon: Icon(Icons.check),
                                    color: Colors.black,
                                    iconSize: 30,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                // width: MediaQuery.of(context).size.width * 0.75,
                                child: TextFormField(
                                  controller: _iptvModelController,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    labelText: 'Enter IPTV Model',
                                    labelStyle: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Cera-Bold'),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(40)),
                                    errorText: _validateEmpty(
                                        _iptvModelController.text,
                                        'Enter IPTV Model'),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                // width: MediaQuery.of(context).size.width * 0.75,
                                child: TextFormField(
                                  controller: _iptvMacIdController,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    labelText: 'Enter IPTV Mac-ID ',
                                    labelStyle: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Cera-Bold'),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(40)),
                                    errorText: _validateEmpty(
                                        _iptvMacIdController.text,
                                        'Enter IPTV Mac-ID'),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Container(
                                width: double.infinity,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "IPTV Own",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontFamily: 'Cera-Bold',
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.4,
                                          child: RadioListTile(
                                            title: const Text(
                                              'Yes',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontFamily: 'Cera-Bold',
                                              ),
                                            ),
                                            groupValue: selectIptvValue,
                                            value: 'Yes',
                                            onChanged: (value) {
                                              setState(() {
                                                selectIptvValue =
                                                    value.toString();
                                              });
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.4,
                                          child: RadioListTile(
                                            title: const Text(
                                              'No',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontFamily: 'Cera-Bold',
                                              ),
                                            ),
                                            groupValue: selectIptvValue,
                                            value: 'No',
                                            onChanged: (value) {
                                              setState(() {
                                                selectIptvValue =
                                                    value.toString();
                                              });
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
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
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.05,
                                      decoration: BoxDecoration(
                                        color: Pallete.backgroundColor,
                                        borderRadius:
                                            BorderRadius.circular(20.0),
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
                                      _provision();
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.05,
                                      decoration: BoxDecoration(
                                        color: Pallete.buttonColor,
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      child: const Text(
                                        'Submit',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Cera-Bold',
                                        ),
                                      ),
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
