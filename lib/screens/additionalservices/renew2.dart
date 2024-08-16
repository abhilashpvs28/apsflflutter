import 'dart:convert';

import 'package:apsfllmo/model/renew_model.dart';
import 'package:apsfllmo/screens/homescreen/home_screen.dart';
import 'package:apsfllmo/utils/apiservice.dart';
import 'package:apsfllmo/utils/constants.dart';
import 'package:apsfllmo/utils/pallete.dart';
import 'package:apsfllmo/utils/saveappdata.dart';
import 'package:apsfllmo/widgets/renew_list_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class Renew2 extends StatefulWidget {
  const Renew2({super.key});

  @override
  State<Renew2> createState() => _RenewState();
}

class _RenewState extends State<Renew2> {
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

  @override
  void initState() {
    super.initState();
    _fetchData("");
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
        'sts': 0,
        'todate': ""
      }
    });

    print("renew_payloads $body");

    var url = Uri.parse(Constants.baseUrl + Apiservice.renewdata);
    print("url $url");
    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('response_dataa $data');
      List<dynamic> lineItemsJson = [];
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
      appBar: AppBar(
        title: const Text(
          'Renew CAF',
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
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _renewList.length + (_hasMoreData ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _renewList.length) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return RenewListCard(renewModel: _renewList[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
