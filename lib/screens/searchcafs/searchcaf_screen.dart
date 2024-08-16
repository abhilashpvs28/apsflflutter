import 'dart:convert';
import 'package:apsfllmo/model/renew_model.dart';
import 'package:apsfllmo/screens/homescreen/home_screen.dart';
import 'package:apsfllmo/utils/apiservice.dart';
import 'package:apsfllmo/utils/constants.dart';
import 'package:apsfllmo/utils/pallete.dart';
import 'package:apsfllmo/utils/saveappdata.dart';
import 'package:apsfllmo/widgets/nodatafound_screen.dart';
import 'package:apsfllmo/widgets/renew_list_card.dart';
import 'package:apsfllmo/widgets/search_caf_list_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class SearchcafScreen extends StatefulWidget {
  const SearchcafScreen({super.key});

  @override
  State<SearchcafScreen> createState() => _SearchcafScreenState();
}

class _SearchcafScreenState extends State<SearchcafScreen> {
  bool _isLoading = false;
  late Future<List<RenewModel>> futurePosts;
  final SaveAppData saveAppData = SaveAppData();
  String? tokenn;
  String? usercategorykeyyy;
  // RenewModel renewModel=new RenewModel;
  //int? limit_position=0;

  bool _showIcons = false;

  static List<RenewModel> _renewList = [];
  final ScrollController _scrollController = ScrollController();
  TextEditingController _searchcontroller = TextEditingController();
  int _currentPage = 0;
  final int _itemsPerPage = 20;
  bool _hasMoreData = true;
  bool _isFetching = false;

  static List<RenewModel> fetchedData = [];
  String hint_text = "CAF";
  int search_type = 1;
  int? ttlCafs; // State variable to store ttl_cafs
  int sts = 0; // State variable for sts

  @override
  void initState() {
    super.initState();
    _fetchData("");
    _total_search_caf();

    _scrollController.addListener(_scrollListener);
    // _searchcontroller.addListener(_scrollListener);

    // setState(() {
    //    _showIcons = _searchcontroller.text.isNotEmpty;
    // });

    _searchcontroller.addListener(() {
      setState(() {
        _showIcons = _searchcontroller.text.isNotEmpty;
      });
    });
  }

  // Update the sts value dynamically in the onTap method
  void _onTerminatedTap() {
    setState(() {
      sts = 8; // Update sts to 8 for the terminated status
      _currentPage = 0; // Reset to first page
      _renewList.clear(); // Clear the current list to show new results
    });
    _fetchData(""); // Fetch new data with the updated sts value
  }

  void _onActiveTap() {
    setState(() {
      sts = 6;
      _currentPage = 0; // Reset to first page
      _renewList.clear(); // Clear the current list to show new results
    });
    _fetchData(""); // Call _fetchData to reload data with the new sts value
  }

  void _onSuspendedTap() {
    setState(() {
      sts = 7;
      _currentPage = 0; // Reset to first page
      _renewList.clear(); // Clear the current list to show new results
    });
    _fetchData(""); // Call _fetchData to reload data with the new sts value
  }

  void _onPendingActivationTap() {
    setState(() {
      sts = 1;
      _currentPage = 0; // Reset to first page
      _renewList.clear(); // Clear the current list to show new results
    });
    _fetchData(""); // Call _fetchData to reload data with the new sts value
  }

  void _onBlacklistedTap() {
    setState(() {
      sts = 41;
      _currentPage = 0; // Reset to first page
      _renewList.clear(); // Clear the current list to show new results
    });
    _fetchData(""); // Call _fetchData to reload data with the new sts value
  }

  void _onIndividualTap() {
    setState(() {
      sts = 16;
      _currentPage = 0; // Reset to first page
      _renewList.clear(); // Clear the current list to show new results
    });
    _fetchData(""); // Call _fetchData to reload data with the new sts value
  }

  void _onEnterpriseTap() {
    setState(() {
      sts = 15;
      _currentPage = 0; // Reset to first page
      _renewList.clear(); // Clear the current list to show new results
    });
    _fetchData(""); // Call _fetchData to reload data with the new sts value
  }

  void _onAllTap() {
    setState(() {
      sts = 0;
      _currentPage = 0; // Reset to first page
      _renewList.clear(); // Clear the current list to show new results
    });
    _fetchData(""); // Call _fetchData to reload data with the new sts value
  }

  Future<void> _total_search_caf() async {
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
        "agntId": agent_id,
        "sts": 0,
        "lmt_pstn": 0,
        "frm_dt": null,
        "to_dt": null
      }
    });

    print("renew_payloads $body");

    var url = Uri.parse(Constants.baseUrl + Apiservice.total_search_caf);
    print("url $url");
    final response = await http.post(url, headers: headers, body: body);

    print('Response status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<dynamic> data = responseData['data'] ?? [];

      if (data.isNotEmpty) {
        setState(() {
          ttlCafs = data[0]['ttl_cafs'];
        });
        print('Total CAFs: $ttlCafs');
      } else {
        print('No data found in response');
      }

      setState(() {});
    } else {
      print('Failed to fetch data. Status code: ${response.statusCode}');
      throw Exception('Failed to fetch data');
    }
  }

  Future<void> _fetchData(String search_text) async {
    if (_isFetching) return;
    _isFetching = true;

    setState(() {
      _isLoading = true;
    });

    fetchedData = await renew_data(_currentPage, search_text);

    print("fetchedData $fetchedData");

    // setState(() {

    //    _isLoading = false;
    //   _isFetching = false;
    //   if (fetchedData.length < _itemsPerPage) {
    //     _hasMoreData = false;
    //   }
    //   _renewList.addAll(fetchedData);

    //   _currentPage++;

    // });

    setState(() {
      _isLoading = false;
      _isFetching = false;
      if (fetchedData.length < _itemsPerPage) {
        _hasMoreData = false;
      } else {
        _currentPage++;
      }
      if (_currentPage == 0) {
        _renewList = fetchedData; // Reset list for new search
      } else {
        _renewList.addAll(fetchedData); // Append to existing list
      }
    });
  }

  Future<List<RenewModel>> renew_data(
      int limit_position, String search_text) async {
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
      'data': {
        'adhar_nu': 0,
        'agntID': int.parse(agent_id!),
        'caf_nu': 0,
        'frmdate': "",
        'lmt_pstn': limit_position,
        'mbl_nu': 0,
        'srch_txt': search_text,
        'srch_type': search_type,
        'sts': sts, // Use the dynamic sts value here
        'todate': ""
      }
    });

    print("renew_payloads $body");

    var url = Uri.parse(Constants.baseUrl + Apiservice.list_search_caf);
    print("url $url");
    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('response_dataa $data');
      List<dynamic> lineItemsJson = [];
      // if (lineItemsJson == []) {
      //   return NodatafoundScreen();
      // }
      lineItemsJson = data['data'];
      print("lineItemsJson $lineItemsJson");
      return lineItemsJson.map((json) => RenewModel.fromJson(json)).toList();
    } else {
      print("faileddd");
      throw Exception('Failed to load posts');
    }
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !_isLoading &&
        _hasMoreData) {
      _fetchData("");
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    // throw UnimplementedError();

    return Scaffold(
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
      appBar: AppBar(
        backgroundColor: Pallete.backgroundColor,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Search CAF',
              style: TextStyle(
                fontFamily: 'Cera-Bold',
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            ttlCafs != null
                ? Text(
                    'Total CAFs: $ttlCafs',
                    style: TextStyle(
                      fontFamily: 'Cera-Bold',
                      fontSize: 12,
                      color: Colors.black,
                    ),
                  )
                : const Text(''),
          ],
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.replay,
              color: Colors.black,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(
              Icons.filter_list,
              color: Colors.black,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(
              Icons.home,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => const HomeScreen(),
                ),
              );
            },
          ),
        ],
      ),

//
      body: Column(
        children: [
          Container(
            // child: SearchCard(serch_flag: "Renew"),

            child: Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    //  color: Pallete.backgroundColor,
                    child: Stack(
                  alignment: Alignment.topLeft,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(
                          left: 10, top: 0, right: 10, bottom: 5),
                      child: Card(
                        elevation: 25,
                        shadowColor: Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        color: Colors.white,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Choose Search Type Before Enter",
                                    textAlign: TextAlign.left,
                                    textDirection: TextDirection.rtl,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                    height: 35,
                                    child: Center(
                                      child:

                                          //       Container(
                                          //         decoration: BoxDecoration(
                                          //           border: Border.all(
                                          //              width: 2.0,
                                          //           )
                                          //         ),
                                          //         child: Row(
                                          //           children: [

                                          //                   TextField(
                                          //                     controller: _searchcontroller,
                                          //      decoration: InputDecoration(
                                          //      prefixIcon: Icon(Icons.search,color: Colors.grey,),
                                          //        //_showIcons
                                          //     //  suffixIcon: ,

                                          //      hintText: "CAF",

                                          //      border: OutlineInputBorder(
                                          //      borderRadius: BorderRadius.all(Radius.circular(20)),
                                          //     ),
                                          //   ),

                                          // ),

                                          //              Visibility(
                                          //               visible: (_showIcons)?true:false,
                                          //               child:
                                          //               Row(

                                          //     children: [
                                          //       IconButton(
                                          //         icon: Icon(Icons.done),
                                          //         onPressed: () {
                                          //           // Handle done action
                                          //           _fetchData();
                                          //         },
                                          //       ),
                                          //       IconButton(
                                          //         icon: Icon(Icons.clear),
                                          //         onPressed: () {
                                          //           _searchcontroller.clear();
                                          //         },
                                          //       ),
                                          //     ],
                                          //   )
                                          //               )
                                          //           ],
                                          //         ),

                                          //       ),

                                          Container(
                                        height: 40,
                                        // padding: EdgeInsets.all(16.0),
                                        decoration: BoxDecoration(
                                          // shape: BoxShape.circle,
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: TextField(
                                                controller: _searchcontroller,
                                                decoration: InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                    hintText: hint_text),
                                              ),
                                            ),
                                            // SizedBox(width: 8.0),
                                            Visibility(
                                              visible: _showIcons,
                                              // child: Icon(Icons.done, color: Colors.green),
                                              child: IconButton(
                                                icon: Icon(Icons.done),
                                                onPressed: () {
                                                  // Handle done action
                                                  _currentPage = 0;
                                                  _renewList.clear();
                                                  _fetchData(
                                                      _searchcontroller.text);

                                                  //  renew_data(0,_searchcontroller.text);
                                                },
                                              ),
                                            ),
                                            //   SizedBox(width: 8.0),
                                            Visibility(
                                              visible: _showIcons,
                                              //  child: Icon(Icons.clear, color: Colors.red),
                                              child: IconButton(
                                                icon: Icon(Icons.clear),
                                                onPressed: () {
                                                  _searchcontroller.clear();
                                                  // _fetchData("");
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Column(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                hint_text = "CAF";
                                                search_type = 1;
                                              });
                                            },
                                            child: Column(
                                              children: [
                                                Icon(
                                                  Icons.list_alt_outlined,
                                                  color: Colors.grey,
                                                  size: 20,
                                                ),
                                                Text(
                                                  "CAF",
                                                  style: TextStyle(
                                                    fontFamily: 'Cera-Bold',
                                                    fontSize: 12,
                                                    decoration:
                                                        hint_text == "CAF"
                                                            ? TextDecoration
                                                                .underline
                                                            : TextDecoration
                                                                .none,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                hint_text = "Mobile";
                                                search_type = 3;
                                              });
                                            },
                                            child: Column(
                                              children: [
                                                Icon(
                                                  Icons.mobile_friendly,
                                                  color: Colors.grey,
                                                  size: 20,
                                                ),
                                                Text(
                                                  "Mobile",
                                                  style: TextStyle(
                                                    fontFamily: 'Cera-Bold',
                                                    fontSize: 12,
                                                    decoration: hint_text ==
                                                            "Mobile"
                                                        ? TextDecoration
                                                            .underline
                                                        : TextDecoration.none,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                hint_text = "Aadhar";
                                                search_type = 2;
                                              });
                                            },
                                            child: Column(
                                              children: [
                                                Icon(
                                                  Icons.file_copy,
                                                  color: Colors.grey,
                                                  size: 20,
                                                ),
                                                Text(
                                                  "Aadhar",
                                                  style: TextStyle(
                                                    fontFamily: 'Cera-Bold',
                                                    fontSize: 12,
                                                    decoration: hint_text ==
                                                            "Aadhar"
                                                        ? TextDecoration
                                                            .underline
                                                        : TextDecoration.none,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                hint_text = "Name";
                                                search_type = 4;
                                              });
                                            },
                                            child: Column(
                                              children: [
                                                Icon(
                                                  Icons.person,
                                                  color: Colors.grey,
                                                  size: 20,
                                                ),
                                                Text(
                                                  "Name",
                                                  style: TextStyle(
                                                    fontFamily: 'Cera-Bold',
                                                    fontSize: 12,
                                                    decoration: hint_text ==
                                                            "Name"
                                                        ? TextDecoration
                                                            .underline
                                                        : TextDecoration.none,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                hint_text = "Serial No";

                                                search_type = 5;
                                              });
                                            },
                                            child: Column(
                                              children: [
                                                Icon(
                                                  Icons.file_copy,
                                                  color: Colors.grey,
                                                  size: 20,
                                                ),
                                                Text(
                                                  "Serial No",
                                                  style: TextStyle(
                                                    fontFamily: 'Cera-Bold',
                                                    fontSize: 12,
                                                    decoration: hint_text ==
                                                            "Serial No"
                                                        ? TextDecoration
                                                            .underline
                                                        : TextDecoration.none,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
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
                )),
              ],
            ),
          ),
          // SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Column(
                children: [
                  Row(
                    // crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: _onAllTap, // Trigger the sts update on tap
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Container(
                            height: 30,
                            width: 40,
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.purple, width: 2),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                "All",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Cera-Bold'),
                              ),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap:
                            _onEnterpriseTap, // Trigger the sts update on tap
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Container(
                            height: 30,
                            width: 80,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 158, 136, 239),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                "Enterprise",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Cera-Bold'),
                              ),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap:
                            _onIndividualTap, // Trigger the sts update on tap
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Container(
                            height: 30,
                            width: 80,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 53, 7, 64),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                "Individual",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Cera-Bold'),
                              ),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: _onActiveTap, // Trigger the sts update on tap
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Container(
                            height: 30,
                            width: 60,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 28, 131, 19),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                "Active",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Cera-Bold'),
                              ),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap:
                            _onBlacklistedTap, // Trigger the sts update on tap
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Container(
                            height: 30,
                            width: 90,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 129, 123, 123),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                "Blacklisted",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Cera-Bold'),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    // crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap:
                            _onPendingActivationTap, // Trigger the sts update on tap
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Container(
                            height: 30,
                            width: 150,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 26, 130, 233),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                "Pending Activation",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Cera-Bold'),
                              ),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: _onSuspendedTap, // Trigger the sts update on tap
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Container(
                            height: 30,
                            width: 90,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 233, 160, 26),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                "Suspended",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Cera-Bold'),
                              ),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap:
                            _onTerminatedTap, // Trigger the sts update on tap
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Container(
                            height: 30,
                            width: 90,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 230, 44, 44),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                "Terminated",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Cera-Bold'),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // SizedBox(height: 10),
          Expanded(
            child: _renewList.isEmpty && !_isLoading
                ? Center(
                    child:
                        NodatafoundScreen(), // Show this widget when no data is found
                  )
                : ListView.builder(
                    controller: _scrollController,
                    itemCount: _renewList.length + (_hasMoreData ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == _renewList.length) {
                        // Show a loading indicator at the end of the list if more data is available
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      // Display the list item
                      return SearchCafListCard(renewModel: _renewList[index]);
                    },
                  ),
          )
        ],
      ),
    );
  }
}
