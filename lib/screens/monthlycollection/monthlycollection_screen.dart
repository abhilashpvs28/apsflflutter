import 'package:apsfllmo/screens/homescreen/home_screen.dart';
import 'package:apsfllmo/utils/apiservice.dart';
import 'package:apsfllmo/utils/constants.dart';
import 'package:apsfllmo/utils/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:toastification/toastification.dart';

class MonthlycollectionScreen extends StatefulWidget {
  const MonthlycollectionScreen({super.key});

  @override
  State<MonthlycollectionScreen> createState() =>
      _MonthlycollectionScreenState();
}

class _MonthlycollectionScreenState extends State<MonthlycollectionScreen> {
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

  bool isFilterApplied = false;
  TextEditingController _dateController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

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

  Future<void> _fetchData() async {
    final storage = FlutterSecureStorage();
    final String? token = await storage.read(key: 'token');
    final String? agent_id = await storage.read(key: 'usr_ctgry_ky');

    print('Retrieved token: $token');
    print('usercategory_key $agent_id');

    if (token == null) {
      setState(() {
        //  _isLoading = false;
      });
      print('Token is null');
      //return ;
    }

    final Map<String, String> headers = {
      'x-access-token': '$token',
      'Content-Type': 'application/json'
    };

    print('Request headers: $headers');

    final DateTime currentDate = getDateTimeFromDateController();
    final int month = currentDate.month;
    final int year = currentDate.year;

    final body = jsonEncode({
      'data': {
        "agntID": agent_id,
        "lmt_pstn": _lmtPstn,
        "mm": month,
        "p_in": 1,
        "srch_txt": "",
        "srch_type": _selectedSearchIndex,
        "yr": year
      }
    });

    print("renew_payloads $body");

    var url = Uri.parse(Constants.baseUrl + Apiservice.monthly_collection_list);
    print("url $url");
    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<dynamic> data = responseData['data'] ?? [];

      double walletBalance = 0.0;
      if (data.isNotEmpty) {
        walletBalance = data[0]['balance'] != null
            ? double.tryParse(data[0]['balance'].toString()) ?? 0.0
            : 0.0;
      }

      setState(() {
        // Clear previous data
        _allData.clear();
        _data.clear();

        // Update with new data
        _allData.addAll(data);
        _data.addAll(data);
        _walletBalance = walletBalance;

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

  // Function to search in _allData based on _selectedSearchType and _searchController text
  void _searchInData() {
    String searchText = _searchController.text.toLowerCase();
    print('Search text: $searchText');
    print('Selected search type: $_selectedSearchType');

    List<dynamic> filteredData = _allData.where((item) {
      String? fieldValue;

      switch (_selectedSearchType) {
        case 'CAF':
          fieldValue = item['caf_id']?.toString();
          break;
        case 'Mobile':
          fieldValue = item['cntct_mble1_nu']?.toString();
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

      if (fieldValue != null) {
        return fieldValue
            .contains(searchText); // Basic filtering for numeric and text
      }

      return false;
    }).toList();

    setState(() {
      _data.clear(); // Clear existing data before adding filtered data
      _data.addAll(filteredData);
    });

    print('Filtered data: ${filteredData.length} items found');
  }

  TextInputType _getKeyboardType() {
    switch (_selectedSearchType) {
      case 'CAF':
        return TextInputType.text; // Numeric keyboard for Mobile
      case 'Mobile':
        return TextInputType.number; // Numeric keyboard for Mobile
      default:
        return TextInputType.text; // Default keyboard for other types
    }
  }

  String formatDateString(String dateStr) {
    try {
      // Convert date string in "MM/yyyy" format to DateTime
      final parts = dateStr.split('/');
      final month = int.parse(parts[0]);
      final year = int.parse(parts[1]);
      final dateTime = DateTime(year, month);

      // Format the date to "yyyy-MM-dd"
      DateFormat formatter = DateFormat('yyyy-MM-dd');
      return formatter.format(dateTime);
    } catch (e) {
      print('Error parsing date: $e');
      return '';
    }
  }

  DateTime getDateTimeFromDateController() {
    final parts = _dateController.text.split('/');
    final month = int.tryParse(parts[0]) ?? DateTime.now().month;
    final year = int.tryParse(parts[1]) ?? DateTime.now().year;
    return DateTime(year, month);
  }

  Future<void> _selectMonthYear(BuildContext context) async {
    final DateTime? picked = await showMonthYearPicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _dateController.text = "${picked.month}/${picked.year}";
      });
    }
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
          'Monthly Collection',
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
          Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.replay,
                  color: Colors.black,
                ),
                onPressed: () {
                  setState(() {
                    _fetchData();
                  });
                },
              ),
              IconButton(
                icon: Icon(
                  isFilterApplied
                      ? Icons.calendar_month_sharp
                      : Icons.search_sharp,
                  color: Colors.black,
                ),
                onPressed: () {
                  setState(() {
                    isFilterApplied = !isFilterApplied;
                  });
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.home,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const HomeScreen()));
                },
              ),
            ],
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          // The containers in the background
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * .09,
                color: Pallete.backgroundColor,
              ),
              SizedBox(
                height: isFilterApplied
                    ? MediaQuery.of(context).size.height * .12
                    : MediaQuery.of(context).size.height * .01,
              ),
              SingleChildScrollView(
                controller: _scrollController,
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    // color: Colors.amber,
                    child: _data.isEmpty
                        ? Container(
                            // color: Colors.blueAccent,
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 50,
                                ),
                                SizedBox(
                                  child: Column(
                                    children: [
                                      Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.2,
                                        width:
                                            MediaQuery.of(context).size.width *
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
                                          color:
                                              Color.fromARGB(255, 22, 116, 239),
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
                        : Container(
                            // width: MediaQuery.of(context).size.width,
                            height: isFilterApplied
                                ? MediaQuery.of(context).size.height * 0.7
                                : MediaQuery.of(context).size.height * 0.76,
                            // color: Colors.blue,
                            child: ListView.builder(
                              itemCount: _data.length,
                              itemBuilder: (context, index) {
                                var item = _data[index];
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Card(
                                    elevation: 20,
                                    child: Container(
                                      child: Row(
                                        children: [
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
                                                            '${item['frst_nm']} ${item['lst_nm'] ?? 'N/A'}',
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
                                                                item['cntct_mble1_nu']
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
                                                            item['caf_id']
                                                                    ?.toString() ??
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
                                                      _buildInfoRow(
                                                          'Agent Code',
                                                          item['agnt_cd']
                                                              ?.toString()),
                                                      _buildInfoRow(
                                                          'Aadhar',
                                                          item['adhr_nu']
                                                              ?.toString()),
                                                      _buildInfoRow(
                                                          'CAF Type',
                                                          item['caf_type_nm']
                                                              ?.toString()),
                                                      _buildInfoRow(
                                                          'Customer ID',
                                                          item['caf_id']
                                                              ?.toString()),
                                                      _buildInfoRow(
                                                          'Previous Balance',
                                                          item['prvs_blnc']
                                                              ?.toString()),
                                                      _buildInfoRow(
                                                          'Latest Invoice Date',
                                                          item['ltst_inv_dt']
                                                              ?.toString()),
                                                      _buildInfoRow(
                                                          'Latest Invoice Data',
                                                          item['ltst_inv_amnt']
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
                              },
                            ),
                          )),
              ),
            ],
          ),
          // The card widget with top padding,
          // incase if you wanted bottom padding to work,
          // set the `alignment` of container to Alignment.bottomCenter
          isFilterApplied
              ? Container(
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
                            child: TextField(
                              controller: _searchController,
                              keyboardType:
                                  _getKeyboardType(), // Dynamic keyboard type
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.search),
                                hintText: _selectedSearchType,
                                suffixIcon: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        print(
                                            'Search text: ${_searchController.text}');
                                        print(
                                            'Selected search type: $_selectedSearchType');
                                        _searchInData(); // Call search function
                                      },
                                      icon: const Icon(Icons.check),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        print('Search text cleared');
                                        _searchController.clear();
                                        print(
                                            'Selected search type: $_selectedSearchType');
                                        _searchInData(); // Call search function
                                      },
                                      icon: const Icon(Icons.close),
                                    ),
                                  ],
                                ),
                              ),
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
                                            fontSize:
                                                _selectedSearchType == 'CAF'
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
                                            color:
                                                _selectedSearchType == 'Mobile'
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
                                            color:
                                                _selectedSearchType == 'Aadhar'
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
                                            fontSize:
                                                _selectedSearchType == 'Name'
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
                                        color:
                                            _selectedSearchType == 'Serial No'
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
                                            color: _selectedSearchType ==
                                                    'Serial No'
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
              : Container(
                  alignment: Alignment.topCenter,
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.0,
                    right: 10.0,
                    left: 10.0,
                  ),
                  child: InkWell(
                    onTap: () {
                      _selectMonthYear(context);
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * .15,
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
                                'Month And Year',
                                style: TextStyle(
                                  fontFamily: 'Cera-Bold',
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    _selectMonthYear(context);
                                  },
                                  child: Container(
                                    height: 40,
                                    width: MediaQuery.of(context).size.width *
                                        0.35,
                                    margin: const EdgeInsets.only(
                                        left: 10, top: 5, right: 5, bottom: 5),
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(255, 240, 237,
                                          237), // Gray background color
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    child: TextField(
                                      controller: _dateController,
                                      enabled: false,
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        suffixIcon: Icon(
                                          Icons.calendar_month,
                                          size: 20,
                                          color: Colors.black,
                                        ),
                                      ),
                                      style: const TextStyle(
                                        fontFamily: 'Cera-Bold',
                                        // fontWeight: FontWeight
                                        //     .bold, // Set your desired fontWeight here
                                        color: Colors.black,
                                        fontSize:
                                            16, // Optional: Set the fontSize if needed
                                      ),
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                        foregroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.white),
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.red),
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),
                                                side: BorderSide(
                                                    color: Colors.red)))),
                                    onPressed: () {
                                      _fetchData();
                                    },
                                    child: Text('GET TRANSACTION'),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String title, String? value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.4,
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
