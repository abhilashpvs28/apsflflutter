import 'package:apsfllmo/screens/additionalservices/bulkrenew_screen.dart';
import 'package:apsfllmo/screens/homescreen/home_screen.dart';
import 'package:apsfllmo/utils/apiservice.dart';
import 'package:apsfllmo/utils/constants.dart';
import 'package:apsfllmo/utils/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:toastification/toastification.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class AdvancebulkrenewScreen extends StatefulWidget {
  const AdvancebulkrenewScreen({super.key});

  @override
  State<AdvancebulkrenewScreen> createState() => _AdvancebulkrenewScreenState();
}

class _AdvancebulkrenewScreenState extends State<AdvancebulkrenewScreen> {
  bool? isChecked = true;
  bool _isLoading = false;
  double _totalMoneyToDeduct = 0.0;
  int _selectedCount = 0;
  double _walletBalance = 0.0;
  double _Amount = 0.0;
  List<dynamic> _data = [];
  List<dynamic> _allData = [];
  List<int> _selectedItems = []; // Change type to List<int>
  String _selectedSearchType = 'CAF';
  int _selectedSearchIndex = 1;
  TextEditingController _searchController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  int _lmtPstn = 0;
  bool _submitButtonDisabled = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !_isLoading) {
      setState(() {
        _lmtPstn++;
      });
      _fetchData();
    }
  }

  Future<void> _bulkResume() async {
    print('Inside _bulkResume');
    if (_selectedItems.isEmpty) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: LoadingAnimationWidget.fourRotatingDots(
            color: Colors.blue,
            size: 50,
          ),
        );
      },
    );

    final storage = FlutterSecureStorage();
    final String? token = await storage.read(key: 'token');

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

    // Prepare the request body with selected items
    List<Map<String, dynamic>> selectedItemsData = _selectedItems.map((cafId) {
      var item = _data.firstWhere((item) => item['caf_id'] == cafId);
      return {
        'caf_id': item['caf_id'],
        'caf_type_id': item['caf_type_id'],
        'pckge_id': item['crnt_pln_id']
      };
    }).toList();

    final Map<String, dynamic> requestBody = {"data": selectedItemsData};

    final body = jsonEncode({"data": selectedItemsData});

    print("renew_payloads $body");

    var url =
        Uri.parse(Constants.baseUrl + Apiservice.advance_bulk_renewal_submit);
    print("url $url");
    final response = await http.post(url, headers: headers, body: body);

    print("payment_status_code ${response.statusCode}");

    print('SelectedItemData :-  $selectedItemsData');
    print('requestBody :- $requestBody');
    print('response :- $response');

    Navigator.pop(context); // Close the loading dialog

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      print('responseData :- $responseData ');

      // Check if status is 200 for success
      if (responseData['status'] == 200) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: 'Bulk Resume Successful',
          onConfirmBtnTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const HomeScreen(),
              ),
            );
          },
        );
      } else {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Oops...',
          text: 'Bulk Resume Failed: ${responseData['message']}',
        );
      }
    } else {
      print(
          'Failed to perform bulk resume. Status code: ${response.statusCode}');
      throw Exception('Failed to perform bulk resume');
    }
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
      "data": {
        "adhar_nu": 0,
        "agntID": agent_id,
        "caf_nu": 0,
        "frmdate": "",
        "lmt_pstn": _lmtPstn,
        "mbl_nu": 0,
        "srch_txt": "",
        "srch_type": 0,
        "sts": 0,
        "todate": ""
      }
    });

    print("renew_payloads $body");

    var url =
        Uri.parse(Constants.baseUrl + Apiservice.advance_bulk_renewal_list);
    print("url $url");
    final response = await http.post(url, headers: headers, body: body);

    print('Response status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<dynamic> data = responseData['data'] ?? [];

      double? walletBalance = responseData['data'][0]['balance'] != null
          ? double.tryParse(responseData['data'][0]['balance'].toString())
          : null;
      if (walletBalance == null) {
        walletBalance = 0.0;
      }

      setState(() {
        _data.addAll(data);
        _allData.addAll(data); // Add fetched data to _allData
        _walletBalance = walletBalance!;

        _isLoading = false;

        print('Wallet balance: $_walletBalance');
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      print('Failed to fetch data. Status code: ${response.statusCode}');
      throw Exception('Failed to fetch data');
    }
  }

  // Function to update total money, wallet balance, and selected count
  // Function to update total money, wallet balance, and selected count
// Function to update total money, wallet balance, and selected count
// Function to update total money, wallet balance, and selected count
  void _updateSelectedItems(int cafId, bool isSelected) {
    setState(() {
      if (isSelected) {
        if (_selectedItems.length >= 20) {
          toastification.show(
            context: context,
            title: const Text(
              'Validation',
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'Cera-Bold',
                fontSize: 14,
              ),
            ),
            description: const Text(
              'Resume Selection Below 20',
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'Cera-Bold',
                fontSize: 14,
              ),
            ),
            backgroundColor: const Color.fromARGB(255, 245, 241, 116),
            type: ToastificationType.warning,
          );
          return;
        }
        _selectedItems.add(cafId);
      } else {
        _selectedItems.remove(cafId);
      }

      double itemMoney = double.tryParse(_data
                  .firstWhere((item) => item['caf_id'] == cafId)['money']
                  ?.toString() ??
              '0.0') ??
          0.0;

      if (isSelected) {
        _totalMoneyToDeduct += itemMoney;
        _selectedCount++;
        _Amount += itemMoney;
      } else {
        _totalMoneyToDeduct -= itemMoney;
        _selectedCount--;
        _Amount -= itemMoney;
      }

      // Calculate the new wallet balance
      _walletBalance =
          (_walletBalance ?? 0.0) - itemMoney * (isSelected ? 1 : -1);
    });
  }

  // Function to search in _allData based on _selectedSearchType and _searchController text
  void _searchInData() {
    String searchText = _searchController.text.toLowerCase();
    print('Search text: $searchText');
    print('Selected search type: $_selectedSearchType');

    List<dynamic> filteredData = _allData.where((item) {
      String? fieldValue;

      switch (_selectedSearchType) {
        case 'CAF':
          fieldValue = item['caf_nu']?.toString();
          break;
        case 'Mobile':
          fieldValue = item['mbl_nu']?.toString();
          break;
        case 'Aadhar':
          fieldValue = item['adhr_nu']?.toString();
          break;
        case 'Name':
          fieldValue = item['cstmr_nm']?.toString();
          break;
        case 'Serial No':
          fieldValue = item['onu_srl_nu']?.toString();
          break;
        default:
          fieldValue = null;
      }

      print('Field value for item: $fieldValue');

      return fieldValue != null &&
          fieldValue.toLowerCase().contains(searchText);
    }).toList();

    setState(() {
      _data.clear(); // Clear existing data before adding filtered data
      _data.addAll(filteredData);
    });

    print('Filtered data: ${filteredData.length} items found');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      appBar: AppBar(
        title: const Text(
          'Advanced Bulk Renew',
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
                      builder: (context) => const BulkrenewScreen()));
                },
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            // The containers in the background
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height * .08,
                  color: Pallete.backgroundColor,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .14,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .57,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      // color: Colors.amber,
                      child: _data.isEmpty
                          ? Container(
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 50,
                                  ),
                                  SizedBox(
                                    child: Column(
                                      children: [
                                        Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.2,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.3,
                                          decoration: const BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage(
                                                'assets/images/background/data_error_image.png',
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        const Text(
                                          'No Data Found!',
                                          style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 22, 116, 239),
                                            fontFamily: 'Cera-Bold',
                                            fontSize: 22,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )
                          : Column(
                              children: _data.asMap().entries.map((entry) {
                                int index = entry.key;
                                var item = entry.value;
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Card(
                                    elevation: 20,
                                    child: Container(
                                      // height: MediaQuery.of(context).size.height * .25,
                                      child: Row(
                                        children: [
                                          Checkbox(
                                            value: _selectedItems
                                                .contains(item['caf_id']),
                                            onChanged: (bool? value) {
                                              if (value == true &&
                                                  _selectedItems.length >= 20) {
                                                toastification.show(
                                                  style: ToastificationStyle
                                                      .flatColored,
                                                  context: context,
                                                  title: const Text(
                                                    'Validation',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontFamily: 'Cera-Bold',
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  description: const Text(
                                                    'Resume Selection Below 20',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontFamily: 'Cera-Bold',
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  alignment: Alignment.topRight,
                                                  primaryColor:
                                                      const Color.fromARGB(
                                                          255, 250, 194, 10),
                                                  backgroundColor:
                                                      const Color.fromARGB(
                                                          255, 245, 241, 116),
                                                  foregroundColor: Colors.black,

                                                  // backgroundColor: Color.fromARGB(
                                                  //     255, 245, 241, 116),
                                                  type: ToastificationType
                                                      .warning,
                                                  autoCloseDuration:
                                                      const Duration(
                                                          seconds: 4),
                                                );
                                                return;
                                              }

                                              _updateSelectedItems(
                                                  item['caf_id'],
                                                  value ?? false);
                                              _submitButtonDisabled =
                                                  _selectedItems.isEmpty;
                                            },
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            item['cstmr_nm'] ??
                                                                'N/A',
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontFamily:
                                                                    'Cera-bold'),
                                                          ),
                                                          Row(
                                                            children: [
                                                              const Icon(
                                                                Icons
                                                                    .phone_iphone_rounded,
                                                                size: 20,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                              Text(
                                                                item['mbl_nu']
                                                                        ?.toString() ??
                                                                    'N/A',
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontFamily:
                                                                        'Cera-bold'),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            item['caf_nu']
                                                                    ?.toString() ??
                                                                'N/A',
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontFamily:
                                                                    'Cera-bold'),
                                                          ),
                                                          Text(
                                                            item['sts_nm'] ??
                                                                'N/A',
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .green,
                                                                fontFamily:
                                                                    'Cera-bold'),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  decoration:
                                                      const BoxDecoration(
                                                    border: Border(
                                                      top: BorderSide(
                                                        color: Colors.grey,
                                                        width: 1.0,
                                                      ),
                                                    ),
                                                  ),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      _buildInfoRow('Aadhar',
                                                          item['adhr_nu']),
                                                      _buildInfoRow(
                                                          'Suspended On',
                                                          item['spnd_dt']),
                                                      _buildInfoRow(
                                                          'ONU Serial No',
                                                          item['onu_srl_nu']),
                                                      _buildInfoRow(
                                                          'IPTV Serial No',
                                                          item['iptv_srl_nu']),
                                                      _buildInfoRow(
                                                          'Current Package',
                                                          item['pckge_nm']),
                                                      _buildInfoRow(
                                                          'Money',
                                                          item['money']
                                                              ?.toString()),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                    ),
                  ),
                ),

                // ?
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: SizedBox(
                    // height: MediaQuery.of(context).size.height * .08,
                    child: Card(
                      elevation: 10,
                      child: Container(
                        // height: MediaQuery.of(context).size.height * .12,
                        child: Column(
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Wallet Balance',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Cera-Bold',
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      '\₹${_walletBalance!.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Cera-Bold',
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "Selected CAF'S ",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Cera-Bold',
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      '$_selectedCount/20',
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Cera-Bold',
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Amount',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Cera-Bold',
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      '${_Amount.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Cera-Bold',
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          _submitButtonDisabled
                                              ? Colors.grey
                                              : Pallete.buttonColor)),
                              onPressed:
                                  _submitButtonDisabled ? null : _bulkResume,
                              child: const Text(
                                'Bulk Renew',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Cera-Bold',
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 4,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // The card widget with top padding,
            // incase if you wanted bottom padding to work,
            // set the `alignment` of container to Alignment.bottomCenter
            Container(
              alignment: Alignment.topCenter,
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.0,
                right: 10.0,
                left: 10.0,
              ),
              child: Container(
                height: MediaQuery.of(context).size.height * .221,
                width: MediaQuery.of(context).size.width,
                child: Card(
                  color: Colors.white,
                  elevation: 4.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        child: const Text(
                          'Choose Search Type Before Enter',
                          style: TextStyle(
                            fontFamily: 'Cera-Bold',
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * .075,
                        padding: const EdgeInsets.all(8.0),
                        child: SearchBar(
                          controller: _searchController,
                          leading: Icon(Icons.search),
                          hintText: _selectedSearchType,
                          trailing: [
                            IconButton(
                              onPressed: () {
                                print('Search text: ${_searchController.text}');
                                print(
                                    'Selected search type: $_selectedSearchType');
                                _searchInData(); // Call search function
                              },
                              icon: Icon(
                                Icons.check,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                print('Search text cleared');
                                _searchController.clear();
                                print(
                                    'Selected search type: $_selectedSearchType');
                                _searchInData(); // Call search function
                              },
                              icon: Icon(
                                Icons.close,
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedSearchType = 'CAF';
                                  _selectedSearchIndex = 1;
                                });
                                print('Search type set to CAF');
                              },
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.list_alt_rounded,
                                    size: 23,
                                    color: _selectedSearchType == 'CAF'
                                        ? Colors.black
                                        : Colors.grey,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'CAF',
                                      style: TextStyle(
                                        fontFamily: 'Cera-Bold',
                                        fontSize: _selectedSearchType == 'CAF'
                                            ? 16
                                            : 13,
                                        color: _selectedSearchType == 'CAF'
                                            ? Colors.black
                                            : Colors.grey,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedSearchType = 'Mobile';
                                  _selectedSearchIndex = 2;
                                });
                                print('Search type set to Mobile');
                              },
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.phone_iphone_rounded,
                                    size: 23,
                                    color: _selectedSearchType == 'Mobile'
                                        ? Colors.black
                                        : Colors.grey,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Mobile',
                                      style: TextStyle(
                                        fontFamily: 'Cera-Bold',
                                        fontSize:
                                            _selectedSearchType == 'Mobile'
                                                ? 16
                                                : 13,
                                        color: _selectedSearchType == 'Mobile'
                                            ? Colors.black
                                            : Colors.grey,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedSearchType = 'Aadhar';
                                  _selectedSearchIndex = 3;
                                });
                                print('Search type set to Aadhar');
                              },
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.document_scanner_outlined,
                                    size: 23,
                                    color: _selectedSearchType == 'Aadhar'
                                        ? Colors.black
                                        : Colors.grey,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Aadhar',
                                      style: TextStyle(
                                        fontFamily: 'Cera-Bold',
                                        fontSize:
                                            _selectedSearchType == 'Aadhar'
                                                ? 16
                                                : 13,
                                        color: _selectedSearchType == 'Aadhar'
                                            ? Colors.black
                                            : Colors.grey,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedSearchType = 'Name';
                                  _selectedSearchIndex = 4;
                                });
                                print('Search type set to Name');
                              },
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.person_2_sharp,
                                    size: 23,
                                    color: _selectedSearchType == 'Name'
                                        ? Colors.black
                                        : Colors.grey,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Name',
                                      style: TextStyle(
                                        fontFamily: 'Cera-Bold',
                                        fontSize: _selectedSearchType == 'Name'
                                            ? 16
                                            : 13,
                                        color: _selectedSearchType == 'Name'
                                            ? Colors.black
                                            : Colors.grey,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedSearchType = 'Serial No';
                                  _selectedSearchIndex = 5;
                                });
                                print('Search type set to Serial No');
                              },
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.credit_card,
                                    size: 23,
                                    color: _selectedSearchType == 'Serial No'
                                        ? Colors.black
                                        : Colors.grey,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Serial No',
                                      style: TextStyle(
                                        fontFamily: 'Cera-Bold',
                                        fontSize: _selectedSearchType ==
                                                'Serial No'
                                            ? 16
                                            : 13, // Adjusted fontsize conditionally,
                                        color:
                                            _selectedSearchType == 'Serial No'
                                                ? Colors.black
                                                : Colors.grey,
                                      ),
                                    ),
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
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String? value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.3,
          child: Text(
            title,
            style: TextStyle(color: Colors.black, fontFamily: 'Cera-bold'),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.01,
          child: Text(
            ":",
            style: TextStyle(color: Colors.black, fontFamily: 'Cera-bold'),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.4,
          child: Text(
            value ?? 'N/A',
            style: TextStyle(color: Colors.black, fontFamily: 'Cera-bold'),
          ),
        ),
      ],
    );
  }
}


// ! submit button left and submit feature left.