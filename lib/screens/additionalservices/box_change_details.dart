import 'dart:convert';

import 'package:apsfllmo/model/box_exchange_model.dart';
import 'package:apsfllmo/screens/additionalservices/box_exchange.dart';
import 'package:apsfllmo/screens/homescreen/home_screen.dart';
import 'package:apsfllmo/utils/apiservice.dart';
import 'package:apsfllmo/utils/constants.dart';
import 'package:apsfllmo/utils/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class BoxChangeDetails extends StatefulWidget {
  final BoxExchangeModel boxExchangeModel;
  BoxChangeDetails({
    super.key,
    required this.boxExchangeModel,
  });

  @override
  State<BoxChangeDetails> createState() => _BoxChangeDetailsState();
}

class _BoxChangeDetailsState extends State<BoxChangeDetails> {
  TextEditingController _controller = TextEditingController();
  TextEditingController mac_address_controller = TextEditingController();
  TextEditingController iptv_controller = TextEditingController();
  TextEditingController iptv_mac_address_controller = TextEditingController();
  TextEditingController comment_controller = TextEditingController();
  TextEditingController boxtype_controller = TextEditingController();

  bool _isVisible = false;
  bool _layout_visible = false;
  bool _text_visible = false;

  bool _isComboButtonEnabled = false;
  bool _isDoubleButtonEnabled = false;

  List<BoxExchangeModel> box_chng_refresh_list = [];

  int _selectedValue = 1; // Default selected value
  String _selectedLocation = 'Please choose a location';
  String? mac_address = "";
  String serial_num = '';

  final List<String> reasons_list = ['PRODUCT CHANGE', 'DEFECTIVE DEVICE'];
  String? selectedreason;
  var box_details_res = [];
  int? box_type;
  bool firstOption = true;
  String? caf_typee;
  var type_change;

  bool _isLoading = false;
  String? statusText = '';

  @override
  void initState() {
    super.initState();
    // Set the default selected value to the first name

    if (widget.boxExchangeModel.combobox_flag != 1) {
      _isVisible = true;
    } else {
      _isVisible = false;
    }

    if (widget.boxExchangeModel.enty_sts_id == 10 ||
        widget.boxExchangeModel.enty_sts_id == 11) {
      _layout_visible = false;
      _text_visible = true;
    } else {
      _layout_visible = true;
      _text_visible = false;
    }

    if (widget.boxExchangeModel.caf_type_id == 1) {
      caf_typee = 'Individual';
    } else {
      caf_typee = "Enterprise";
    }

    if (widget.boxExchangeModel.enty_sts_id == 10) {
      statusText =
          'Box Change is already initiated, wait till it \n succeed.  Please click refresh to check the status';
      ;
    }
    if (widget.boxExchangeModel.enty_sts_id == 11) {
      statusText =
          "PON Change is already initiated, wait till it \n succeed.  Please click refresh to check the status";
    }

    _controller.addListener(_checkButtonState);
    mac_address_controller.addListener(_checkButtonState);
    iptv_controller.addListener(_checkButtonState);
    iptv_mac_address_controller.addListener(_checkButtonState);

    selectedreason = reasons_list.first;
    box_type = widget.boxExchangeModel.combobox_flag;
    if (box_type == 1) {
      firstOption = true;
    } else {
      firstOption = false;
    }
  }

  void _checkButtonState() {
    setState(() {
      if (widget.boxExchangeModel.combobox_flag == 1) {
        _isComboButtonEnabled = _controller.text.isNotEmpty &&
            mac_address_controller.text.isNotEmpty &&
            iptv_controller.text.isNotEmpty &&
            iptv_mac_address_controller.text.isNotEmpty;
      } else {
        _isDoubleButtonEnabled = (_controller.text.isNotEmpty &&
                mac_address_controller.text.isNotEmpty) ||
            (iptv_controller.text.isNotEmpty &&
                iptv_mac_address_controller.text.isNotEmpty);
      }
    });
  }

  Future<void> get_OnuDetails(String onu_or_iptv_number, String type) async {
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

    print(_controller.text);
    final url = Uri.parse(
        Constants.baseUrl + Apiservice.box_details + onu_or_iptv_number);
    print("url $url");
    final response = await http.get(url, headers: headers);

    print("response_code ${response.statusCode}");
    if (response.statusCode == 200) {
      // Handle successful response
      print('onu details Response data: ${response.body}');
      final res = json.decode(response.body);

      if (res['status'] == 200) {
        setState(() {
          mac_address = res['data'][0]['mac_addr_cd'];
          serial_num = res['data'][0]['srl_nu'];
          box_details_res = res['data'];
          print('mac address $mac_address');
          if (type == 'onu') {
            mac_address_controller.text = mac_address!;
          } else if (type == 'iptv') {
            iptv_mac_address_controller.text = mac_address!;
          }
        });
      } else {
        showCustomSatusDialog(context, res['message']);
      }
    } else {
      // Handle error response
      final res = json.decode(response.body);
      print("faileddd");
      throw Exception('Failed to load posts');
    }
  }

  Future<void> submit_api_call(type_change) async {
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

    final body = jsonEncode({
      'data': {
        'aaa_cd': widget.boxExchangeModel.aaa_cd,
        'accessid': widget.boxExchangeModel.accessid,
        'caf_id': widget.boxExchangeModel.caf_id,
        'caf_nu': widget.boxExchangeModel.caf_nu,
        'card': widget.boxExchangeModel.olt_crd_nu,
        'change_comment': comment_controller.text,
        'changed': type_change,
        'id': widget.boxExchangeModel.aghra_cd,
        'iptv_stpbx_id': widget.boxExchangeModel.iptv_stpbx_id,
        'lagId': widget.boxExchangeModel.lagId,
        'new_iptv_mac_adrs': iptv_mac_address_controller.text,
        'new_iptv_srno': iptv_controller.text,
        'new_onu_mac_adrs': mac_address_controller.text,
        'new_onu_srno': _controller.text,
        'old_iptv_mac_adrs': widget.boxExchangeModel.iptv_mac_addr_tx,
        'old_iptv_srno': widget.boxExchangeModel.iptv_srl_nu,
        'old_onu_mac_adrs': widget.boxExchangeModel.onu_mac_addr_tx,
        'old_onu_srno': widget.boxExchangeModel.onu_srl_nu,
        'olt_ip_addr_tx': widget.boxExchangeModel.olt_ip_addr_tx,
        'onuId': widget.boxExchangeModel.olt_onu_id,
        'onu_stpbx_id': widget.boxExchangeModel.onu_stpbx_id,
        'pckge_id': widget.boxExchangeModel.onu_stpbx_id,
        'reason_change': selectedreason,
        'serialNumber': serial_num,
        'subscr_code': widget.boxExchangeModel.mdlwe_sbscr_id,
        'tp': widget.boxExchangeModel.olt_prt_nm,
        'type': '',
        'caf_type_id': widget.boxExchangeModel.caf_type_id,
      }
    });

    print('Payloads $body');

    final url = Uri.parse(Constants.baseUrl + Apiservice.box_chng_submit);
    print("url $url");
    final response = await http.post(url, headers: headers, body: body);

    print("response_code ${response.statusCode}");
    if (response.statusCode == 200) {
      // Handle successful response
      print('onu details Response data: ${response.body}');
      final res = json.decode(response.body);

      if (res['status'] == 200) {
        // Fluttertoast.showToast(
        //   msg: "Box Changed Successfully....",
        //                         toastLength: Toast.LENGTH_LONG,
        //                         gravity: ToastGravity.CENTER,
        //                         timeInSecForIosWeb: 2,
        //                         backgroundColor: Colors.red,
        //                        textColor: Colors.yellow,
        //                        fontSize: 18.0,
        //                        );

        showCustomSatusDialog(context, "Box Changed Successfully");
      } else {
        showCustomSatusDialog(context, res['message']);
      }
    } else {
      // Handle error response
      final res = json.decode(response.body);
      print("faileddd");
      showCustomSatusDialog(context, res['message']);
      throw Exception('Failed to load posts');
    }
  }

  Future<void> double_box_submit_api_call(String body) async {
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

    //  final body = jsonEncode({
    //       'data':{
    //         'aaa_cd': widget.boxExchangeModel.aaa_cd,
    //         'accessid': widget.boxExchangeModel.accessid ,
    //         'caf_id': widget.boxExchangeModel.caf_id,
    //         'caf_nu':widget.boxExchangeModel.caf_nu,
    //         'card':widget.boxExchangeModel.olt_crd_nu,
    //         'change_comment':comment_controller.text,
    //         'changed': type_change,
    //         'id': widget.boxExchangeModel.aghra_cd,
    //         'iptv_stpbx_id': widget.boxExchangeModel.iptv_stpbx_id,
    //         'lagId': widget.boxExchangeModel.lagId,
    //         'new_iptv_mac_adrs':iptv_mac_address_controller.text,
    //         'new_iptv_srno':iptv_controller.text,
    //         'new_onu_mac_adrs':mac_address_controller.text,
    //         'new_onu_srno':_controller.text,
    //         'old_iptv_mac_adrs':widget.boxExchangeModel.iptv_mac_addr_tx,
    //         'old_iptv_srno':widget.boxExchangeModel.iptv_srl_nu,
    //         'old_onu_mac_adrs':widget.boxExchangeModel.onu_mac_addr_tx,
    //         'old_onu_srno':widget.boxExchangeModel.onu_srl_nu,
    //         'olt_ip_addr_tx':widget.boxExchangeModel.olt_ip_addr_tx,
    //         'onuId':widget.boxExchangeModel.olt_onu_id,
    //         'onu_stpbx_id':widget.boxExchangeModel.onu_stpbx_id,
    //         'pckge_id':widget.boxExchangeModel.onu_stpbx_id,
    //         'reason_change':selectedreason,
    //         'serialNumber': serial_num,
    //         'subscr_code': widget.boxExchangeModel.mdlwe_sbscr_id,
    //         'tp':widget.boxExchangeModel.olt_prt_nm,
    //         'type':'',
    //         'caf_type_id':widget.boxExchangeModel.caf_type_id,

    //       }

    //     });

    print('Payloads $body');

    final url = Uri.parse(Constants.baseUrl + Apiservice.double_box_chng);
    print("url $url");
    final response = await http.post(url, headers: headers, body: body);

    print("response_code ${response.statusCode}");
    if (response.statusCode == 200) {
      // Handle successful response
      print('onu double box details Response data: ${response.body}');
      final res = json.decode(response.body);

      if (res['status'] == 200) {
        // Fluttertoast.showToast(
        //   msg: "Box Changed Successfully....",
        //                         toastLength: Toast.LENGTH_LONG,
        //                         gravity: ToastGravity.BOTTOM,
        //                         timeInSecForIosWeb: 2,
        //                         backgroundColor: Colors.red,
        //                        textColor: Colors.white,
        //                        fontSize: 18.0,
        //                        );

        showCustomSatusDialog(context, "Box Changed Successfully..");
      } else {
        showCustomSatusDialog(context, res['message']);
      }
    } else {
      // Handle error response
      final res = json.decode(response.body);
      print("faileddd");
      showCustomSatusDialog(context, res['message']);
      throw Exception('Failed to load posts');
    }
  }

  Future<void> olt_boxchng_refresh_api() async {
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

    print('refresh_api_headers $headers');

    final url = Uri.parse(Constants.baseUrl +
        Apiservice.box_change_refresh +
        widget.boxExchangeModel.caf_id.toString());
    print("url $url");
    final response = await http.get(url, headers: headers);
    _isLoading = true;
    print("response_code ${response.statusCode}");
    if (response.statusCode == 200) {
      // Handle successful response
      _isLoading = false;
      print('box_chng_refresh data: ${response.body}');
      final res = json.decode(response.body);

      List<dynamic> data_array = res['data'];

      if (res['status'] == 200) {
        box_chng_refresh_list =
            data_array.map((json) => BoxExchangeModel.fromJson(json)).toList();
      } else {
        print("failedd..");
        showCustomSatusDialog(context, res['message']);
      }
    } else {
      // Handle error response
      _isLoading = false;
      final res = json.decode(response.body);
      print("faileddd");
      showCustomSatusDialog(context, res['message']);
      throw Exception('Failed to load posts');
    }
  }

  @override
  void dispose() {
    // Step 4: Dispose of the controller when the widget is disposed
    _controller.dispose();
    mac_address_controller.dispose();
    iptv_controller.dispose();
    iptv_mac_address_controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    //throw UnimplementedError();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Box Exchange',
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
          margin: EdgeInsets.all(10),
          child: Column(
            children: [
              Card(
                  elevation: 25,
                  color: Colors.white,
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            _buildInfoRow(
                                "Name",
                                widget.boxExchangeModel.frst_nm +
                                    widget.boxExchangeModel.lst_nm,
                                Pallete.lightgrey),
                            _buildInfoRow(
                                "CAF No",
                                widget.boxExchangeModel.caf_nu.toString(),
                                Colors.white),
                            _buildInfoRow(
                                "CAF Type", caf_typee!, Pallete.lightgrey),
                            _buildInfoRow(
                                "Mobile No",
                                widget.boxExchangeModel.mbl_nu.toString(),
                                Colors.white),
                            _buildInfoRow(
                                "Aadhaar No",
                                widget.boxExchangeModel.adhr_nu.toString(),
                                Pallete.lightgrey),
                            _buildInfoRow(
                                "Locality",
                                widget.boxExchangeModel.instl_lcly_tx
                                    .toString(),
                                Colors.white),
                            _buildInfoRow(
                                "ONU Serial No",
                                widget.boxExchangeModel.onu_srl_nu.toString(),
                                Pallete.lightgrey),
                            _buildInfoRow(
                                "ONU MAC Address",
                                widget.boxExchangeModel.onu_mac_addr_tx
                                    .toString(),
                                Colors.white),
                            _buildInfoRow(
                                "IPTV Serial No",
                                widget.boxExchangeModel.iptv_srl_nu.toString(),
                                Pallete.lightgrey),
                            _buildInfoRow(
                                "IPTV MAC Address",
                                widget.boxExchangeModel.iptv_mac_addr_tx
                                    .toString(),
                                Colors.white),
                          ],
                        ),
                      ),
                    ],
                  )),
              const SizedBox(
                height: 10,
              ),
              Column(
                children: [
                  Visibility(
                    visible: _layout_visible,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Radio<int>(
                              value: 1,
                              groupValue: firstOption ? 1 : 2,
                              onChanged: null,
                            ),
                            Text('Combo Box Change'),
                            SizedBox(width: 20), // Space between radio buttons
                            Radio<int>(
                              value: 2,
                              groupValue: firstOption ? 1 : 2,
                              onChanged: (int? value) {
                                setState(() {
                                  // Do nothing to disable change
                                });
                              },
                            ),
                            Text('Double Box Change'),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Card(
                          elevation: 25,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Update Combo Box Change",
                                      style: TextStyle(
                                          color: Pallete.buttonColor,
                                          fontSize: 15),
                                    ),
                                    Text(
                                      "New ONU Serial Number",
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            //  height: 30,
                                            margin: EdgeInsets.only(
                                                left: 0,
                                                top: 5,
                                                right: 0,
                                                bottom: 5),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            decoration: BoxDecoration(
                                                color: Pallete
                                                    .lightgrey // Gray background color
                                                //  borderRadius: BorderRadius.circular(8.0),
                                                ),
                                            child: TextField(
                                              controller: _controller,
                                              decoration: InputDecoration(
                                                //  hintText: 'Enter text',
                                                border: InputBorder.none,
                                              ),
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          icon: Icon(
                                              Icons.qr_code_scanner_outlined),
                                          onPressed: () {
                                            // Handle scanner icon press
                                          },
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.done),
                                          onPressed: () {
                                            // Handle done icon press
                                            get_OnuDetails(
                                                _controller.text, "onu");
                                          },
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "New ONU MAC Address",
                                    ),
                                    Container(
                                      // height: 30,
                                      margin: EdgeInsets.only(
                                          left: 0, top: 5, right: 0, bottom: 5),
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 8.0),
                                      decoration: BoxDecoration(
                                        color: Pallete
                                            .lightgrey, // Gray background color
                                        //  borderRadius: BorderRadius.circular(8.0),
                                      ),
                                      child: TextField(
                                        controller: mac_address_controller,
                                        //readOnly: true,
                                        decoration: InputDecoration(
                                          //  hintText: 'Enter text',
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Visibility(
                                      visible: _isVisible,
                                      child: Text(
                                        '(OR)',
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "New IPTV Serial Number",
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            // height: 30,
                                            margin: EdgeInsets.only(
                                                left: 0,
                                                top: 5,
                                                right: 0,
                                                bottom: 5),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            decoration: BoxDecoration(
                                              color: Pallete
                                                  .lightgrey, // Gray background color
                                              //  borderRadius: BorderRadius.circular(8.0),
                                            ),
                                            child: TextField(
                                              controller: iptv_controller,
                                              decoration: InputDecoration(
                                                //  hintText: 'Enter text',
                                                border: InputBorder.none,
                                              ),
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          icon: Icon(
                                              Icons.qr_code_scanner_outlined),
                                          onPressed: () {
                                            // Handle scanner icon press
                                          },
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.done),
                                          onPressed: () {
                                            // Handle done icon press
                                            get_OnuDetails(
                                                iptv_controller.text, "iptv");
                                          },
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "New IPTV MAC Address",
                                    ),
                                    Container(
                                      // height: 30,
                                      margin: EdgeInsets.only(
                                          left: 0, top: 5, right: 0, bottom: 5),
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 8.0),
                                      decoration: BoxDecoration(
                                        color: Pallete
                                            .lightgrey, // Gray background color
                                        //  borderRadius: BorderRadius.circular(8.0),
                                      ),
                                      child: TextField(
                                        controller: iptv_mac_address_controller,
                                        //  readOnly: true,
                                        decoration: InputDecoration(
                                          //  hintText: 'Enter text',
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "Reason for Change",
                                    ),
                                    Container(
                                      // height: 30,
                                      margin: EdgeInsets.only(
                                          left: 0, top: 5, right: 0, bottom: 5),
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 8.0),
                                      decoration: BoxDecoration(
                                        color: Pallete
                                            .lightgrey, // Gray background color
                                        //  borderRadius: BorderRadius.circular(8.0),
                                      ),

                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          value: selectedreason,
                                          icon: const Icon(Icons
                                              .arrow_drop_down), // Right facing icon
                                          // iconSize: 16,
                                          // elevation: 16,
                                          isExpanded: true,
                                          // underline: Container(
                                          //   height: 2,
                                          //   color: Colors.deepPurpleAccent,
                                          // ),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              selectedreason = newValue!;
                                            });
                                          },
                                          items: reasons_list
                                              .map<DropdownMenuItem<String>>(
                                                  (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "Change Comment",
                                    ),
                                    Container(
                                      // height: 30,
                                      margin: EdgeInsets.only(
                                          left: 0, top: 5, right: 0, bottom: 5),
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 8.0),
                                      decoration: BoxDecoration(
                                        color: Colors
                                            .grey[200], // Gray background color
                                        //  borderRadius: BorderRadius.circular(8.0),
                                      ),
                                      child: TextField(
                                        controller: comment_controller,
                                        decoration: InputDecoration(
                                          //  hintText: 'Enter text',
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('CANCEL'),
                                        ),
                                        SizedBox(
                                          height: 30,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  _isComboButtonEnabled
                                                      ? Pallete.buttonColor
                                                      : Pallete.lightorange,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  5),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  5))),
                                            ),
                                            onPressed: () {
                                              if (widget.boxExchangeModel
                                                      .combobox_flag ==
                                                  1) {
                                                if (widget.boxExchangeModel
                                                            .caf_type_id ==
                                                        1 &&
                                                    iptv_controller.text ==
                                                        widget.boxExchangeModel
                                                            .iptv_srl_nu &&
                                                    _controller.text !=
                                                        widget.boxExchangeModel
                                                            .onu_srl_nu) {
                                                  type_change = 'onu';
                                                }
                                                if (widget.boxExchangeModel
                                                            .caf_type_id ==
                                                        1 &&
                                                    iptv_controller.text !=
                                                        widget.boxExchangeModel
                                                            .iptv_srl_nu &&
                                                    _controller.text ==
                                                        widget.boxExchangeModel
                                                            .onu_srl_nu) {
                                                  type_change = 'iptv';
                                                }
                                                if (widget.boxExchangeModel
                                                            .caf_type_id ==
                                                        1 &&
                                                    iptv_controller.text ==
                                                        widget.boxExchangeModel
                                                            .iptv_srl_nu &&
                                                    _controller.text ==
                                                        widget.boxExchangeModel
                                                            .onu_srl_nu) {
                                                  type_change = 'same';
                                                }
                                                if (type_change == "same") {
                                                  Fluttertoast.showToast(
                                                    msg:
                                                        "Existing CAF Serial Numbers are same.Please enter another serial number to change",
                                                    toastLength:
                                                        Toast.LENGTH_LONG,
                                                    gravity:
                                                        ToastGravity.CENTER,
                                                    timeInSecForIosWeb: 2,
                                                    backgroundColor: Colors.red,
                                                    textColor: Colors.yellow,
                                                    fontSize: 18.0,
                                                  );
                                                } else {
                                                  if (_isComboButtonEnabled) {
                                                    submit_api_call(
                                                        type_change);
                                                  }
                                                }
                                              } else {
                                                type_change = '';
                                                var iptvSerialNumber = "";
                                                var iPTVmacAddressCode = "";
                                                if (iptv_controller
                                                        .text.length !=
                                                    0) {
                                                  iptvSerialNumber =
                                                      iptv_controller.text;
                                                  iPTVmacAddressCode =
                                                      iptv_mac_address_controller
                                                          .text;
                                                }

                                                var oNUSerialNumber = "";
                                                var oNUSmacAddressCode = "";
                                                if (_controller.text.length !=
                                                    0) {
                                                  oNUSerialNumber =
                                                      _controller.text;
                                                  oNUSmacAddressCode =
                                                      mac_address_controller
                                                          .text;
                                                }

                                                if (oNUSerialNumber
                                                        .isNotEmpty &&
                                                    oNUSmacAddressCode
                                                        .isNotEmpty &&
                                                    iPTVmacAddressCode
                                                        .isNotEmpty &&
                                                    iptvSerialNumber
                                                        .isNotEmpty) {
                                                  if (widget.boxExchangeModel
                                                              .caf_type_id ==
                                                          1 &&
                                                      iptvSerialNumber
                                                              .toLowerCase() !=
                                                          widget
                                                              .boxExchangeModel
                                                              .iptv_srl_nu
                                                              .toLowerCase() &&
                                                      _controller.text
                                                              .toLowerCase() !=
                                                          widget
                                                              .boxExchangeModel
                                                              .onu_srl_nu
                                                              .toLowerCase()) {
                                                    type_change = "both";
                                                  }
                                                } else if (oNUSmacAddressCode
                                                        .isNotEmpty &&
                                                    oNUSerialNumber
                                                        .isNotEmpty) {
                                                  if (widget.boxExchangeModel
                                                              .caf_type_id ==
                                                          1 &&
                                                      oNUSerialNumber
                                                              .toLowerCase() !=
                                                          widget
                                                              .boxExchangeModel
                                                              .onu_srl_nu
                                                              .toLowerCase()) {
                                                    type_change = "onu";
                                                    iptvSerialNumber = "";
                                                    iPTVmacAddressCode = "";
                                                  }
                                                } else if (iPTVmacAddressCode
                                                        .isNotEmpty &&
                                                    iptvSerialNumber
                                                        .isNotEmpty) {
                                                  if (widget.boxExchangeModel
                                                              .caf_type_id ==
                                                          1 &&
                                                      iptvSerialNumber
                                                              .toLowerCase() !=
                                                          widget
                                                              .boxExchangeModel
                                                              .iptv_srl_nu
                                                              .toLowerCase()) {
                                                    type_change = "iptv";
                                                    oNUSerialNumber = "";
                                                    oNUSmacAddressCode = "";
                                                  }
                                                } else {
                                                  type_change = "error";
                                                }

                                                if (oNUSerialNumber
                                                        .isNotEmpty &&
                                                    iptvSerialNumber
                                                        .isNotEmpty) {
                                                  if (widget.boxExchangeModel
                                                              .caf_type_id ==
                                                          1 &&
                                                      iptvSerialNumber
                                                              .toLowerCase() ==
                                                          widget
                                                              .boxExchangeModel
                                                              .iptv_srl_nu
                                                              .toLowerCase() &&
                                                      _controller.text
                                                              .toLowerCase() ==
                                                          widget
                                                              .boxExchangeModel
                                                              .onu_srl_nu
                                                              .toLowerCase()) {
                                                    type_change = "same";
                                                  }
                                                }
                                                if (type_change == "same") {
                                                  Fluttertoast.showToast(
                                                    msg:
                                                        "Existing CAF Serial Numbers are same.Please enter another serial number to change",
                                                    toastLength:
                                                        Toast.LENGTH_LONG,
                                                    gravity:
                                                        ToastGravity.CENTER,
                                                    timeInSecForIosWeb: 2,
                                                    backgroundColor: Colors.red,
                                                    textColor: Colors.yellow,
                                                    fontSize: 18.0,
                                                  );
                                                } else {
                                                  final body = jsonEncode({
                                                    'data': {
                                                      'aaa_cd': widget
                                                          .boxExchangeModel
                                                          .aaa_cd,
                                                      'accessid': widget
                                                          .boxExchangeModel
                                                          .accessid,
                                                      'caf_id': widget
                                                          .boxExchangeModel
                                                          .caf_id,
                                                      'caf_nu': widget
                                                          .boxExchangeModel
                                                          .caf_nu,
                                                      'card': widget
                                                          .boxExchangeModel
                                                          .olt_crd_nu,
                                                      'change_comment':
                                                          comment_controller
                                                              .text,
                                                      'changed': type_change,
                                                      'id': widget
                                                          .boxExchangeModel
                                                          .aghra_cd,
                                                      'iptv_stpbx_id': widget
                                                          .boxExchangeModel
                                                          .iptv_stpbx_id,
                                                      'lagId': widget
                                                          .boxExchangeModel
                                                          .lagId,
                                                      'new_iptv_mac_adrs':
                                                          iPTVmacAddressCode,
                                                      'new_iptv_srno':
                                                          iptvSerialNumber,
                                                      'new_onu_mac_adrs':
                                                          oNUSmacAddressCode,
                                                      'new_onu_srno':
                                                          oNUSerialNumber,
                                                      'old_iptv_mac_adrs':
                                                          widget
                                                              .boxExchangeModel
                                                              .iptv_mac_addr_tx,
                                                      'old_iptv_srno': widget
                                                          .boxExchangeModel
                                                          .iptv_srl_nu,
                                                      'old_onu_mac_adrs': widget
                                                          .boxExchangeModel
                                                          .onu_mac_addr_tx,
                                                      'old_onu_srno': widget
                                                          .boxExchangeModel
                                                          .onu_srl_nu,
                                                      'olt_ip_addr_tx': widget
                                                          .boxExchangeModel
                                                          .olt_ip_addr_tx,
                                                      'onuId': widget
                                                          .boxExchangeModel
                                                          .olt_onu_id,
                                                      'onu_stpbx_id': widget
                                                          .boxExchangeModel
                                                          .onu_stpbx_id,
                                                      'pckge_id': widget
                                                          .boxExchangeModel
                                                          .onu_stpbx_id,
                                                      'reason_change':
                                                          selectedreason,
                                                      'serialNumber':
                                                          serial_num,
                                                      'subscr_code': widget
                                                          .boxExchangeModel
                                                          .mdlwe_sbscr_id,
                                                      'tp': widget
                                                          .boxExchangeModel
                                                          .olt_prt_nm,
                                                      'type': '',
                                                      'caf_type_id': widget
                                                          .boxExchangeModel
                                                          .caf_type_id,
                                                    }
                                                  });

                                                  if (_isDoubleButtonEnabled) {
                                                    double_box_submit_api_call(
                                                        body);
                                                  }
                                                }
                                              }
                                            },
                                            child: const Text(
                                              "SUBMIT",
                                              style: TextStyle(
                                                color: Colors.white,
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
                      ],
                    ),
                  ),
                  Visibility(
                      visible: _text_visible,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Note: $statusText",
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Pallete.buttonColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(5),
                                      bottomRight: Radius.circular(5))),
                            ),
                            onPressed: () {
                              olt_boxchng_refresh_api();
                            },
                            child: const Text(
                              "REFRESH",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, Color color) {
    return Container(
      color: color,
      padding: EdgeInsets.all(5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(":"),
          Text(value),
        ],
      ),
    );
  }

  //  void updateTextField() {
  //   setState(() {
  //     if (box_type==1) {
  //       boxtype_controller.text = 'Update Combo Box Change';
  //     } else {
  //       boxtype_controller.text = 'Update Double Box';
  //     }
  //   });
  // }

  void showCustomSatusDialog(BuildContext context, String s) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Container(
            width: 100,
            height: 130,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5), topRight: Radius.circular(5))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  height: 25,
                  color: Pallete.lightorange,
                  child: Text(
                    "Renew Status",
                    textAlign: TextAlign.start,
                    style: TextStyle(color: Color.fromARGB(255, 1, 43, 116)),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                SizedBox(
                  child: Container(
                    padding:
                        EdgeInsets.only(left: 10, top: 5, right: 10, bottom: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("$s"),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => BoxExchange()));
                              },
                              child: Text('Ok'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
