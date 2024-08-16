import 'package:apsfllmo/utils/apiservice.dart';
import 'package:apsfllmo/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:apsfllmo/screens/additionalservices/bulkrenew_screen.dart';
import 'package:apsfllmo/screens/additionalservices/packagechange/packagedetails_screen.dart';
import 'package:apsfllmo/utils/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:toastification/toastification.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class AllocatedcafScreen extends StatefulWidget {
  final int oltId;
  final int oltPartNm;
  const AllocatedcafScreen({
    Key? key,
    required this.oltId,
    required this.oltPartNm,
  }) : super(key: key);
  @override
  State<AllocatedcafScreen> createState() => _AllocatedcafScreenState();
}

class _AllocatedcafScreenState extends State<AllocatedcafScreen> {
  bool? isChecked = true;
  bool _isLoading = false;
  double _walletBalance = 0.0;
  double _Amount = 0.0;
  List<dynamic> _data = [];
  List<dynamic> _allData = [];
  String _selectedSearchType = 'CAF';
  int _selectedSearchIndex = 0;
  TextEditingController _searchController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  int _lmtPstn = 0;

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

    print('Retrieved token: $token');

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
        "olt_id": widget.oltId,
        "olt_prt_nm": widget.oltPartNm,
        "sts": 0,
        "lmt_pstn": 0,
        "srch_txt": "",
        "srch_type": ""
      }
    });

    print("renew_payloads $body");
    print('Request headers: $headers');

    var url =
        Uri.parse(Constants.baseUrl + Apiservice.pon_connection_allocated_caf);
    print("url $url");
    final response = await http.post(url, headers: headers, body: body);

    print('Response status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<dynamic> data = responseData['data'] ?? [];

      setState(() {
        _data.addAll(data);
        _allData.addAll(data); // Add fetched data to _allData

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
          fieldValue = item['frst_nm']?.toString();
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
          "Allocated CAFs ",
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
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const BulkrenewScreen()));
                },
              ),
            ],
          ),
        ],
      ),
      body: _isLoading
          ? Dialog.fullscreen(
              child: Container(
                // height: MediaQuery.of(context).size.height,
                color: const Color.fromARGB(23, 0, 0, 0),
                child: Center(
                  child: LoadingAnimationWidget.discreteCircle(
                    color: Colors.blue,
                    size: 50,
                  ),
                ),
              ),
            )
          : Expanded(
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
                      Container(
                        // color: Colors.blue,
                        height: MediaQuery.of(context).size.height * .09,
                      ),
                      Container(
                        // color: Colors.deepOrangeAccent,
                        height: MediaQuery.of(context).size.height * .1,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {});
                                    },
                                    child: const Row(
                                      children: [
                                        SizedBox(
                                            height: 15,
                                            width: 15,
                                            child:
                                                ColoredBox(color: Colors.grey)),
                                        SizedBox(width: 4),
                                        Text(
                                          'All',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'Cera-Bold',
                                            // fontSize: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: InkWell(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        SizedBox(
                                            height: 15,
                                            width: 15,
                                            child: ColoredBox(
                                                color: Colors.green)),
                                        SizedBox(width: 4),
                                        Text(
                                          'Active',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'Cera-Bold',
                                            // fontSize: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: () {},
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        SizedBox(
                                            height: 15,
                                            width: 15,
                                            child: ColoredBox(
                                                color: Colors.black)),
                                        SizedBox(width: 4),
                                        Text(
                                          'Blacklisted',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'Cera-Bold',
                                            // fontSize: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: () {},
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        SizedBox(
                                            height: 15,
                                            width: 15,
                                            child:
                                                ColoredBox(color: Colors.blue)),
                                        SizedBox(width: 4),
                                        Text(
                                          'Pending Activation',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'Cera-Bold',
                                            // fontSize: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: () {},
                                    child: const Row(
                                      children: [
                                        SizedBox(
                                            height: 15,
                                            width: 15,
                                            child: ColoredBox(
                                                color: Colors.orange)),
                                        SizedBox(width: 4),
                                        Text(
                                          'Suspended',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'Cera-Bold',
                                            // fontSize: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: () {},
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        SizedBox(
                                            height: 15,
                                            width: 15,
                                            child:
                                                ColoredBox(color: Colors.red)),
                                        SizedBox(width: 4),
                                        Text(
                                          'Terminated',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'Cera-Bold',
                                            // fontSize: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.61,
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
                                    children:
                                        _data.asMap().entries.map((entry) {
                                      int index = entry.key;
                                      var item = entry.value;
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          // height: MediaQuery.of(context).size.height * .25,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                  child: Column(
                                                children: _data
                                                    .asMap()
                                                    .entries
                                                    .map((entry) {
                                                  int index = entry.key;
                                                  var item = entry.value;
                                                  final String cafActOn =
                                                      '${item['olt_id']} - ${item['olt_prt_nm']} ${item['olt_prt_splt_tx']}';

                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Card(
                                                      elevation: 20,
                                                      child: Container(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(10),
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
                                                                        '${item['frst_nm'] ?? 'N/A'} ${item['lst_nm'] ?? ''}',
                                                                        style: const TextStyle(
                                                                            color:
                                                                                Colors.black,
                                                                            fontFamily: 'Cera-bold'),
                                                                      ),
                                                                      Row(
                                                                        children: [
                                                                          const Icon(
                                                                            Icons.phone_iphone_rounded,
                                                                            size:
                                                                                20,
                                                                            color:
                                                                                Colors.black,
                                                                          ),
                                                                          Text(
                                                                            item['mbl_nu']?.toString() ??
                                                                                'N/A',
                                                                            style:
                                                                                const TextStyle(color: Colors.black, fontFamily: 'Cera-bold'),
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
                                                                        item['caf_nu']?.toString() ??
                                                                            'N/A',
                                                                        style: const TextStyle(
                                                                            color:
                                                                                Colors.black,
                                                                            fontFamily: 'Cera-bold'),
                                                                      ),
                                                                      Text(
                                                                        item['sts_nm'] ??
                                                                            'N/A',
                                                                        style: item['sts_nm'] ==
                                                                                'Active'
                                                                            ? const TextStyle(
                                                                                color: Colors.green,
                                                                                fontFamily: 'Cera-bold')
                                                                            : const TextStyle(color: Colors.red, fontFamily: 'Cera-bold'),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(10),
                                                              decoration:
                                                                  const BoxDecoration(
                                                                border: Border(
                                                                  top:
                                                                      BorderSide(
                                                                    color: Colors
                                                                        .grey,
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
                                                                      'Aadhar',
                                                                      item[
                                                                          'adhr_nu']),
                                                                  _buildInfoRow(
                                                                      'Billing Frequency',
                                                                      item[
                                                                          'frqncy_nm']),
                                                                  _buildInfoRow(
                                                                      'ONU Serial No',
                                                                      item[
                                                                          'onu_srl_nu']),
                                                                  _buildInfoRow(
                                                                      'IPTV Serial No',
                                                                      item[
                                                                          'iptv_srl_nu']),
                                                                  _buildInfoRow(
                                                                      'Subscriber Code',
                                                                      item[
                                                                          'mdlwe_sbscr_id']),
                                                                  _buildInfoRow(
                                                                      'Telephone Allocated',
                                                                      item[
                                                                          'phne_nu']),
                                                                  _buildInfoRow(
                                                                      'CAF Activated On',
                                                                      cafActOn),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }).toList(),
                                              )),
                                            ],
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                          ),
                        ),
                      ),

                      // ?
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
                      height: MediaQuery.of(context).size.height * .21,
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
                                leading: const Icon(Icons.search),
                                hintText: _selectedSearchType,
                                trailing: [
                                  IconButton(
                                    onPressed: () {
                                      print(
                                          'Search text: ${_searchController.text}');
                                      print(
                                          'Selected search type: $_selectedSearchType');
                                      _searchInData(); // Call search function
                                    },
                                    icon: const Icon(
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
                                    icon: const Icon(
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  InkWell(
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
                                          size: 20,
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
                                                      ? 15
                                                      : 11,
                                              color:
                                                  _selectedSearchType == 'CAF'
                                                      ? Colors.black
                                                      : Colors.grey,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  InkWell(
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
                                          size: 20,
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
                                              fontSize: _selectedSearchType ==
                                                      'Mobile'
                                                  ? 15
                                                  : 11,
                                              color: _selectedSearchType ==
                                                      'Mobile'
                                                  ? Colors.black
                                                  : Colors.grey,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  InkWell(
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
                                          size: 20,
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
                                              fontSize: _selectedSearchType ==
                                                      'Aadhar'
                                                  ? 15
                                                  : 11,
                                              color: _selectedSearchType ==
                                                      'Aadhar'
                                                  ? Colors.black
                                                  : Colors.grey,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  InkWell(
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
                                          size: 20,
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
                                                      ? 15
                                                      : 11,
                                              color:
                                                  _selectedSearchType == 'Name'
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
