import 'dart:convert';

import 'package:apsfllmo/model/payment_model.dart';
import 'package:apsfllmo/screens/homescreen/home_screen.dart';
import 'package:apsfllmo/utils/apiservice.dart';
import 'package:apsfllmo/utils/constants.dart';
import 'package:apsfllmo/utils/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Payments extends StatefulWidget {
  @override
  State<Payments> createState() => _PaymentsState();
}

class _PaymentsState extends State<Payments> {
  TextEditingController _FromdateController = TextEditingController();
  TextEditingController _todateController = TextEditingController();
  DateTime _selected_FromDate = DateTime.now();
  DateTime _selected_ToDate = DateTime.now();
  List<PaymentModel> payments_list = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // _FromdateController.text = '${_selected_FromDate.year}-${_selected_FromDate.month}-${_selected_FromDate.day}';
    // _todateController.text = '${_selected_ToDate.year}-${_selected_ToDate.month}-${_selected_ToDate.day}';
  }

  Future<void> payments_list_api_call() async {
    final storage = FlutterSecureStorage();
    final String? token = await storage.read(key: 'token');
    final String? agent_id = await storage.read(key: 'usr_ctgry_ky');
    _isLoading = true;

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
    print("FromDate ${formatDateString(_FromdateController.text)}");

    final body = jsonEncode({
      'data': {
        'frmdate': _FromdateController.text,
        'todate': _todateController.text,
        'type': 1,
      }
    });

    print("renew_payloads $body");

    var url = Uri.parse(Constants.baseUrl + Apiservice.payment_sharing);
    print("url $url");
    final response = await http.post(url, headers: headers, body: body);

    print("payment_status_code ${response.statusCode}");
    if (response.statusCode == 200) {
      _isLoading = false;
      final data = json.decode(response.body);
      print('payments_data$data');
      // return <List<RenewModel>>.fromJson(json.decode(response.body));

      List<dynamic> data_array = data['data'];
      print("payment_data_array $data_array");

      setState(() {
        payments_list =
            data_array.map((json) => PaymentModel.fromJson(json)).toList();
        print("payments_list $payments_list");
      });
    } else {
      _isLoading = false;
      print("faileddd");
      throw Exception('Failed to load posts');
    }
  }

  String formatDateString(String dateStr) {
    // Parse the original date string
    DateTime dateTime = DateTime.parse(dateStr);
    // Format the date with leading zeros for month and day
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(dateTime);
  }

  Future<void> _selectFromDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selected_FromDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selected_FromDate) {
      setState(() {
        _selected_FromDate = picked;
        if (_selected_FromDate.month < 10) {
          print("selected month lessthan 10");
          _FromdateController.text =
              '${_selected_FromDate.year}-${_selected_FromDate.month.toString().padLeft(2, '0')}-${_selected_FromDate.day}';
        }
        _FromdateController.text =
            '${_selected_FromDate.year}-${_selected_FromDate.month.toString().padLeft(2, '0')}-${_selected_FromDate.day}';
      });
    }
  }

  Future<void> _selectToDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selected_ToDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selected_ToDate) {
      setState(() {
        _selected_ToDate = picked;
        if (_selected_ToDate.month < 10) {
          _todateController.text =
              '${_selected_ToDate.year}-0${_selected_ToDate.month.toString().padLeft(2, '0')}-${_selected_ToDate.day}';
        }
        _todateController.text =
            '${_selected_ToDate.year}-${_selected_ToDate.month.toString().padLeft(2, '0')}-${_selected_ToDate.day}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    //  throw UnimplementedError();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Payments ',
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
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(10),
            child: Card(
              color: Colors.white,
              elevation: 25,
              child: Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("From Date"),
                        InkWell(
                          onTap: () {
                            _selectFromDate(context);
                          },
                          child: Container(
                            height: 40,
                            width: MediaQuery.of(context).size.width * 0.35,
                            margin: EdgeInsets.only(
                                left: 0, top: 5, right: 0, bottom: 5),
                            // padding: EdgeInsets.symmetric(horizontal: 5.0),

                            decoration: BoxDecoration(
                              color: Colors.grey[200], // Gray background color
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: TextField(
                              controller: _FromdateController,
                              enabled: false,
                              decoration: InputDecoration(
                                //  hintText: 'Enter text',
                                border: InputBorder.none,
                                suffixIcon: Icon(
                                  Icons.calendar_month,
                                  size: 20,
                                ),
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("To Date"),
                        InkWell(
                          onTap: () {
                            _selectToDate(context);
                          },
                          child: Container(
                              height: 40,
                              width: MediaQuery.of(context).size.width * 0.35,
                              margin: EdgeInsets.only(
                                  left: 0, top: 5, right: 0, bottom: 5),
                              // padding: EdgeInsets.symmetric(horizontal: 3.0),

                              decoration: BoxDecoration(
                                color:
                                    Colors.grey[200], // Gray background color
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: Center(
                                child: TextField(
                                  controller: _todateController,
                                  enabled: false,
                                  decoration: InputDecoration(
                                    //  hintText: 'Enter text',
                                    border: InputBorder.none,
                                    suffixIcon: Icon(
                                      Icons.calendar_month,
                                      size: 20,
                                    ),
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                ),
                              )),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(""),
                        InkWell(
                            onTap: () {
                              if (_FromdateController.text.isEmpty) {
                                Fluttertoast.showToast(
                                    msg: "Please Select From Date",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.black,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              } else if (_todateController.text.isEmpty) {
                                Fluttertoast.showToast(
                                    msg: "Please Select To Date",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.black,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              } else {
                                payments_list_api_call();
                              }
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.15,
                              height: 40,
                              margin: EdgeInsets.only(
                                  left: 0, top: 5, right: 0, bottom: 5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                color: Pallete.buttonColor,
                              ),
                              alignment: Alignment.bottomCenter,
                              padding: EdgeInsets.all(5),
                              child: Icon(
                                Icons.search,
                                color: Colors.white,
                              ),
                            )),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child:
                // payments_list.isEmpty
                //  ? Center(
                //     child: Text(
                //     "No data found",
                //      style: TextStyle(fontSize: 25, color: Colors.grey,fontWeight: FontWeight.w700),
                //     ),
                //    ):
                _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: payments_list.length,
                        itemBuilder: (context, index) {
                          if (index == payments_list.length) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return Container(
                            margin: EdgeInsets.all(10),
                            child: Card(
                              elevation: 25,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              color: Colors.white,
                              child: Container(
                                //padding: EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.2,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.04,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10)),
                                            color: Pallete.buttonColor,
                                          ),
                                          child: Center(
                                            child: Column(
                                              children: [
                                                Text(
                                                  "Credit",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),

                                        //  Container(
                                        //   width: MediaQuery.of(context).size.width*0.3,
                                        //  height: MediaQuery.of(context).size.height*0.035,
                                        //  margin: EdgeInsets.only(right: 10),
                                        //   decoration: BoxDecoration(
                                        //     borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20)),
                                        //     color: Pallete.buttonColor,
                                        //   ),

                                        //   child:
                                        //   Center(
                                        //     child:
                                        //     Text("LMO2000825",
                                        //         style: TextStyle(
                                        //         color: Colors.black,
                                        //       ),),
                                        //   ),

                                        // ),
                                      ],
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                          top: 10,
                                          left: 20,
                                          right: 20,
                                          bottom: 10),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.3,
                                                child: Text(
                                                  "APSFL Share",
                                                  textAlign: TextAlign.start,
                                                ),
                                              ),
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.03,
                                                child: Text(":"),
                                              ),
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.3,
                                                child: Text(
                                                  "${payments_list[index].amount}",
                                                  textAlign: TextAlign.start,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.3,
                                                child: Text("Transaction Date"),
                                              ),
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.03,
                                                child: Text(":"),
                                              ),
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.3,
                                                child: Text(
                                                    "${payments_list[index].date_created}"),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                  "Description (${payments_list[index].mrcht_usr_nm})"),
                                            ],
                                          ),
                                          Container(
                                            height: 1,
                                            color: Colors.grey,
                                            margin: EdgeInsets.symmetric(
                                                vertical: 10),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Column(
                                                children: [
                                                  Text("Opening Balance"),
                                                  Text(
                                                      "${payments_list[index].open_bal}"),
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  Text("Close Balance"),
                                                  Text(
                                                      "${payments_list[index].close_bal}"),
                                                ],
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
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
