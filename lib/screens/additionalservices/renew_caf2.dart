import 'dart:convert';

import 'package:apsfllmo/model/add_on_model.dart';
import 'package:apsfllmo/model/package_details_model.dart';
import 'package:apsfllmo/screens/additionalservices/renew2.dart';
import 'package:apsfllmo/screens/homescreen/home_screen.dart';
import 'package:apsfllmo/utils/apiservice.dart';
import 'package:apsfllmo/utils/constants.dart';
import 'package:apsfllmo/utils/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class RenewCaf2 extends StatefulWidget {
  final int caf_id;
  final String package_name;

  RenewCaf2({
    super.key,
    required this.caf_id,
    required this.package_name,
  });

  @override
  State<RenewCaf2> createState() => _RenewCafState();
}

class _RenewCafState extends State<RenewCaf2> {
  bool _isLoading = false;
  late Future<List<PackageDetailsModel>> futurePosts;
  late Map<String, dynamic>? basepack_details = {};
  late Map<String, dynamic>? updated_basepack_details = {};
  // List<PackageDetailsModel> updated_basepack_details=[];
  Map<String, dynamic> packageDetailsMap = {};

  final List<int> months_list = [1, 3, 6, 12, 20];
  int? selectedMonth = 1;
  List<PackageDetailsModel> package_list = [];
  List<AddOnModel> add_on_list = [];

  List<dynamic> channels_data_array = [];

  List<AddOnModel> selected_list = [];

  int add_on_cnt = 0;
  dynamic addon_price = 0.0;

  List<String> package_names = [];
  String? selectedPackage;
  int? selected_package_id = 79;
  PackageDetailsModel? selected_package_nm;

  dynamic old_pack_id;
  String? cpe_chrge;
  bool addon_selection = false;

  @override
  void initState() {
    super.initState();
    futurePosts = package_details();
    // district_list_api();
    package_wise_data_api_call();
    selectedMonth = months_list[0];

    setState(() {
      futurePosts;
      // district_list_api();
      basepack_details = {};
      updated_basepack_details = {};
      package_names = [];
      //  package_wise_data_api_call();
    });
  }

  bool isChecked = false;

  void _toggleCheckbox(bool? value) {
    setState(() {
      isChecked = value!;
    });
  }

  Future<void> renew_api() async {
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
        'caf_id': widget.caf_id,
        'mnthval': '$selectedMonth',
        'pckge_id': '$selected_package_id',
        'ttl_amt': ((updated_basepack_details != null)
            ? (calculateTotalCost(selectedMonth, updated_basepack_details,
                    '$cpe_chrge', addon_price)
                .toString())
            : ""),
        //'ttl_amt':("350.0"),
      }
    });

    print("renew_payloads $body");

    final url = Uri.parse(Constants.baseUrl + Apiservice.renew_api);
    print("url $url");
    final response = await http.post(url, headers: headers, body: body);

    print("response_code ${response.statusCode}");
    if (response.statusCode == 200) {
      // Handle successful response
      print('Renew Response data: ${response.body}');
      final res = json.decode(response.body);
      if (res['status'] == 200) {
        showCustomSatusDialog(context, "Successfully Done");
      } else {
        showCustomSatusDialog(context, res['message']);
      }
    } else {
      // Handle error response
      final res = json.decode(response.body);
      showCustomSatusDialog(context, res['message']);
      print('Failed to load data');
    }
  }

  Future<void> package_wise_data_api_call() async {
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

    print("selected_package_id $selected_package_id");

    final url = Uri.parse(Constants.baseUrl +
        Apiservice.package_wise_data +
        widget.caf_id.toString() +
        "/" +
        selected_package_id.toString());
    print("channels_url $url");

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      // Handle successful response
      final data = json.decode(response.body);
      print('response_dataa_ponchange $data');

      print('package wise Response data: ${response.body}');
      if (data['status'] == 200) {
        final List<dynamic> lineItemsJson = data['data'];
        print("lineitems ${lineItemsJson}");
        channels_data_array = data['data'];
        print("data_array $channels_data_array");

        if (channels_data_array.isNotEmpty) {
          setState(() {
            add_on_list = channels_data_array
                .map((json) => AddOnModel.fromJson(json))
                .toList();
            print("add_on_list $add_on_list");
          });
        } else {
          return;
        }
      }
    } else {
      // Handle error response
      print('Failed to load data');
    }
  }

  Future<List<PackageDetailsModel>> package_details() async {
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

    var url = Uri.parse(
        Constants.baseUrl + Apiservice.renewcafdata + widget.caf_id.toString());
    print("url $url");
    final response = await http.get(url, headers: headers);
    print('Response status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('response_dataa $data');

      old_pack_id = data['data']['old_pack_id'];
      cpe_chrge = data['data']['cpe_chrge'].toString();
      print("old_pack_id $old_pack_id");
      final List<dynamic> lineItemsJson = data['data']['bse_pck'];
      print("lineitems ${lineItemsJson}");

      setState(() {
        print(data['data'.length]);
        if (data['data'].length == 0) {
          Center(
            child: Text(
              "No Data Found",
              style: TextStyle(fontSize: 20),
            ),
          );
        }
      });

      for (int k = 0; k < lineItemsJson.length; k++) {
        if (lineItemsJson[k]['package_id'] == old_pack_id) {
          print("k $k");
          setState(() {
            basepack_details = data['data']['bse_pck'][k];
          });
          break;
        }
      }

      for (int k = 0; k < lineItemsJson.length; k++) {
        setState(() {
          selectedPackage = data['data']['bse_pck'][k]['package_name'];
          selected_package_id = data['data']['bse_pck'][k]['package_id'];
          package_names.add(data['data']['bse_pck'][k]['package_name']);
          packageDetailsMap[data['data']['bse_pck'][k]['package_name']] =
              data['data']['bse_pck'][k];
        });
      }

      print("package_names $package_names");

      if (package_names.isNotEmpty) {
        selectedPackage = package_names[0];
        setState(() {
          updatePackageDetails(selectedPackage);
        });
      }

      print("basepack_details $basepack_details");
      print("selectedPackage $selectedPackage");

      return lineItemsJson
          .map((json) => PackageDetailsModel.fromJson(json))
          .toList();
    } else {
      print("faileddd");
      throw Exception('Failed to load posts');
    }
  }

//  Future<void> district_list_api() async {
//           final storage = FlutterSecureStorage();
//           final String? token = await storage.read(key: 'token');
//           final String? agent_id = await storage.read(key: 'usr_ctgry_ky');

//           print('Retrieved token: $token');
//           print('usercategory_key $agent_id');

//           if (token == null) {
//               setState(() {
//               //_isLoading = false;
//               });
//               print('Token is null');
//               //return ;
//             }

//     final Map<String, String> headers = {
//       'x-access-token': '$token',
//       'Content-Type': 'application/json'
//     };

//          print('Request headers: $headers');

//         print("selected_package_id $selected_package_id");
//        final url = Uri.parse(Constants.baseUrl + Apiservice.renewcafdata+widget.caf_id.toString());
//        print("package_url $url");

//         final response = await http.get(url,headers: headers);

//           if (response.statusCode == 200) {
//               final data = json.decode(response.body);

//               print('response_dataa_ponchange $data');

//                old_pack_id=data['data']['old_pack_id'];
//                cpe_chrge=data['data']['cpe_chrge'].toString();
//                print("old_pack_id $old_pack_id");

//                if(data['status']==200){
//                  final List<dynamic> lineItemsJson = data['data']['bse_pck'];
//                  print("lineitems ${lineItemsJson}");
//                  List<dynamic> data_array=data['data']['bse_pck'];
//                  print("data_array $data_array");

//                   setState(() {
//                     package_list=data_array.map((json) => PackageDetailsModel.fromJson(json)).toList();
//                     print("package_list $package_list");
//                   selected_package_nm=package_list.first;
//                   print("selected_pk_nm ${package_list[0].package_name}");

//                     selected_package_id=package_list[0].package_id;

//                     for (int k = 0; k < package_list.length; k++){
//                       print("loop");
//                    if(package_list[k].package_id==old_pack_id){
//                         print("k $k");
//                          setState(() {
//                         basepack_details=data['data']['bse_pck'][k];

//                         packageDetailsMap[data['data']['bse_pck'][k]['package_name']] = data['data']['bse_pck'][k];

//                         updatePackageDetails(package_list[0].package_name);
//                     });
//                     break;
//                   }

//                 }

//                   });

//                }

//            } else {
//                print("faileddd");
//               throw Exception('Failed to load posts');
//            }
//       }

  void updatePackageDetails(String? packageName) {
    setState(() {
      if (packageName != null && packageDetailsMap.containsKey(packageName)) {
        updated_basepack_details = packageDetailsMap[packageName];
        selectedPackage = packageName[0];
        print("updated_basepack_details $updated_basepack_details");
        selected_package_id = updated_basepack_details?['package_id'];
        selectedPackage = updated_basepack_details?['package_name'];
        print("selectd_package_id $selected_package_id");
        package_wise_data_api_call();
      } else {
        updated_basepack_details = {};
      }
    });
  }

  // void updatePackageDetails(PackageDetailsModel? packageName) {
  //   setState(() {
  //     if (packageName != null && package_list.contains(packageName)) {
  //       updated_basepack_details =packageName ;
  //       selected_package_nm=packageName.package_name;
  //       print("updated_basepack_details33 $updated_basepack_details");
  //       selected_package_id=updated_basepack_details.package_id;
  //       selectedPackage=updated_basepack_details.package_name;
  //       print("selectedPackage$selectedPackage");
  //       print("selectd_package_id33 $selected_package_id");
  //     } else {
  //       updated_basepack_details = [];
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    //throw UnimplementedError();

    Size size = MediaQuery.of(context).size;

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
      body: Column(
        children: [
          Center(
            child: selectedPackage == null
                ? CircularProgressIndicator()
                : Text(""),
          ),
          Container(
            padding: EdgeInsets.all(5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Current Package Details (${widget.caf_id})",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),

                const SizedBox(
                  height: 5,
                ),
                // if(old_pack_details.)
                Card(
                  elevation: 25,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  color: Colors.white,
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(
                            left: 5, top: 5, right: 5, bottom: 10),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("${basepack_details?['package_name']}"),
                                Text("${basepack_details?['created_at']}")
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    Text("Rs ${basepack_details?['ttl_cst']}"),
                                    const Text("Total")
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(
                                        "RS ${basepack_details?['tot_chrge9']}"),
                                    Text("Charge")
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(
                                        "RS ${basepack_details?['tot_gst_at9']}"),
                                    Text("Others")
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: 5,
                ),
                Text(
                  "*Select Package",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),

                const SizedBox(
                  height: 5,
                ),

                Container(
                  //  height: 30,

                  child: Column(
                    children: <Widget>[
                      CustomDropdown<String>(
                        items: package_names,
                        selectedValue: selectedPackage,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedPackage = newValue;
                            updatePackageDetails(newValue);
                          });
                        },
                      ),
                    ],
                  ),
                ),

                //     Container(
                //     // height: 30,
                //    margin: EdgeInsets.only(left: 0,top: 5,right: 0,bottom: 5),
                //    padding: EdgeInsets.symmetric(horizontal: 8.0),
                //    decoration: BoxDecoration(
                //    color: Pallete.lightgrey, // Gray background color
                //     //  borderRadius: BorderRadius.circular(8.0),
                //    ),

                //   child: DropdownButtonHideUnderline(
                //     child:  DropdownButton<PackageDetailsModel>(
                //     value: selected_package_nm,
                //     icon: const Icon(Icons.arrow_drop_down), // Right facing icon
                //     // iconSize: 16,
                //     // elevation: 16,
                //     isExpanded: true,
                //     onChanged: (PackageDetailsModel? newValue) {
                //       setState(() {
                //         selected_package_nm = newValue!;
                //          if (newValue != null) {
                //          print('Selected PACKAGE ID: ${newValue.package_id}');
                //          selected_package_id=newValue.package_id;
                //          updatePackageDetails(newValue.package_name);
                //          package_wise_data_api_call();

                //        }

                //       });
                //     },
                //     items: package_list.map((PackageDetailsModel value) {
                //       return DropdownMenuItem<PackageDetailsModel>(
                //         value: value,
                //         child: Text(value.package_name),
                //       );
                //     }).toList(),
                //   ),

                //     ),

                // ),

                Text(
                  "Update Package Details",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),

                //if(selectedPackage!=null)

                Card(
                  elevation: 25,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  color: Colors.white,
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(
                            left: 5, top: 5, right: 5, bottom: 10),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    "${updated_basepack_details?['package_name']}"),
                                Text(
                                    "${updated_basepack_details?['created_at']}")
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                        "Rs ${updated_basepack_details?['ttl_cst']}"),
                                    Text("Total")
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(
                                        "RS ${updated_basepack_details?['tot_chrge9']}"),
                                    Text("Charge")
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(
                                        "RS ${updated_basepack_details?['tot_gst_at9']}"),
                                    Text("Others")
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "No of Months",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                    //Text("1"),
                    SizedBox(
                      height: 10,
                    ),

                    Expanded(
                      child: Container(
                        height: 35,
                        margin: EdgeInsets.all(5),
                        color: Pallete.lightgrey,
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<int>(
                            value: selectedMonth,
                            //  isExpanded: true,
                            icon: Icon(Icons.arrow_drop_down),
                            items: months_list.map((int value) {
                              return DropdownMenuItem<int>(
                                value: value,
                                child: Text(value.toString()),
                              );
                            }).toList(),
                            onChanged: (int? newValue) {
                              setState(() {
                                selectedMonth = newValue!;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                Card(
                  elevation: 25,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  color: Colors.white,
                  child: Column(
                    children: [
                      Container(
                        // height: 100,
                        padding: EdgeInsets.only(
                            left: 5, top: 5, right: 5, bottom: 10),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: Column(
                                        children: [
                                          Text("${add_on_cnt}"),
                                          Text("Addons")
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text("${addon_price}"),
                                          Text("Price")
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text("$cpe_chrge"),
                                          Text("CPE Rental")
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text("$selectedMonth"),
                                          Text("No of Months")
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text((updated_basepack_details?[
                                                      'ttl_cst9'] !=
                                                  null)
                                              ? calculateTotalCost(
                                                      selectedMonth,
                                                      updated_basepack_details,
                                                      '$cpe_chrge',
                                                      addon_price)
                                                  .toString()
                                              : ""),
                                          Text("Total")
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 30,
                                  child: Center(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        showCustomDialog(context);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Pallete.lightorange,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                        ),
                                      ),
                                      child: const Text(
                                        "Purchase",
                                        style: TextStyle(
                                          color: Pallete.buttonColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Text(
                  "Channels List",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
              ],
            ),
          ),
          Visibility(
              visible: (add_on_list.isNotEmpty) ? true : false,
              child: Expanded(
                child: ListView.builder(
                  // controller: _scrollController,
                  itemCount: add_on_list.length,
                  itemBuilder: (context, index) {
                    if (index == add_on_list.length) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return Container(
                      margin: EdgeInsets.only(
                          left: 15, top: 0, right: 15, bottom: 0),
                      child: Card(
                        elevation: 25,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        color: Colors.white,
                        child: Row(
                          children: [
                            Container(
                              width: 320,
                              padding: EdgeInsets.all(8),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("${add_on_list[index].pckge_nm}"),
                                      Text(formatDate(
                                          "${add_on_list[index].expry_dt}"))
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Total Channels"),
                                      Text("${add_on_list[index].crnt_sts_in}")
                                    ],
                                  ),
                                  Container(
                                    height: 1,
                                    color: Colors.grey,
                                    margin: EdgeInsets.symmetric(vertical: 10),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                              "Rs ${add_on_list[index].chrge_at}"),
                                          const Text("Total")
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                              "RS ${add_on_list[index].gst_at}"),
                                          Text("Charge")
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 40,
                              child: Checkbox(
                                value:
                                    selected_list.contains(add_on_list[index]),
                                // value: true,
                                onChanged: (value) {
                                  setState(() {
                                    // calculateTotalCost(selectedMonth, updated_basepack_details, '$cpe_chrge',addon_price).toString()

                                    if (value == true) {
                                      add_on_cnt++;
                                      addon_price = addon_price +
                                          add_on_list[index].chrge_at +
                                          add_on_list[index].gst_at;
                                      selected_list.add(add_on_list[index]);
                                    } else {
                                      add_on_cnt--;
                                      if (addon_price > 0) {
                                        addon_price = addon_price -
                                            (add_on_list[index].chrge_at +
                                                add_on_list[index].gst_at);
                                      } else {
                                        addon_price = addon_price;
                                      }

                                      selected_list.remove(add_on_list[index]);
                                    }

                                    print("selected_list $selected_list");
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )),
        ],
      ),
    );
  }

  void showCustomDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Container(
            width: 100,
            height: 220,
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
                    "Payment Details",
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text("Addons"),
                                Text(":"),
                                Text("$add_on_cnt"),
                              ],
                            ),
                            Row(
                              children: [
                                Text("Addons Price"),
                                Text("$addon_price"),
                                Text((double.parse(selectedMonth.toString()) *
                                        addon_price)
                                    .toString()),
                              ],
                            ),
                            Row(
                              children: [
                                Text("Cpe Rental"),
                                Text(":"),
                                Text('$cpe_chrge'),
                              ],
                            ),
                            Row(
                              children: [
                                Text("Package Amount"),
                                Text(":"),
                                Text((selectedMonth! *
                                        double.parse(
                                            '${updated_basepack_details?['ttl_cst']}'))
                                    .toString()),
                                //  Text(calculateTotalCost(selectedMonth, updated_basepack_details, '$cpe_chrge',(selectedMonth!*0.0)).toString())
                              ],
                            ),
                            Column(
                              children: [
                                Container(
                                  height: 1,
                                  color: Colors.grey,
                                  margin: EdgeInsets.symmetric(vertical: 10),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text("Total Amount"),
                                Text(":"),
                                Text((updated_basepack_details != null)
                                    ? calculateTotalCost(
                                            selectedMonth,
                                            updated_basepack_details,
                                            '$cpe_chrge',
                                            addon_price)
                                        .toString()
                                    : ''),
                                // Text(((selectedMonth!*0.0)+(double.parse('$cpe_chrge'))+(selectedMonth!*double.parse('${updated_basepack_details?['ttl_cst']}'))).toString()),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('NO'),
                            ),
                            SizedBox(
                              height: 30,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Color.fromRGBO(244, 87, 37, 1),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  if (selected_package_id.toString() == '') {
                                    showCustomSatusDialog(
                                        context, "Please Select the Package");
                                    return;
                                  } else {
                                    renew_api();
                                  }
                                },
                                child: const Text(
                                  "YES",
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
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String formatDate(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    DateFormat dateFormat = DateFormat('MMMM d, yyyy');
    return dateFormat.format(dateTime);
  }

  double calculateTotalCost(
      int? selectedMonth,
      Map<String, dynamic>? updatedBasepackDetails,
      String cpeCharge,
      double addon_price) {
    if (selectedMonth == null) {
      throw ArgumentError(
          'selectedMonth or updatedBasepackDetails cannot be null');
      // print("selectedMonth or updatedBasepackDetails cannot be null");
    }
//|| updatedBasepackDetails == null || updatedBasepackDetails['ttl_cst9']==null
    double ttlCst = double.parse((updatedBasepackDetails?['ttl_cst9'] != null)
        ? ('${updatedBasepackDetails?['ttl_cst9']}')
        : '');
    double totalCost =
        double.parse(cpeCharge) + (selectedMonth * (ttlCst + addon_price));

    return totalCost;
  }

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
                                        builder: (BuildContext context) =>
                                            Renew2()));
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

class CustomDropdown<T> extends StatefulWidget {
  final List<T> items;
  final T? selectedValue;
  final void Function(T?) onChanged;

  CustomDropdown({
    required this.items,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  _CustomDropdownState<T> createState() => _CustomDropdownState<T>();
}

class _CustomDropdownState<T> extends State<CustomDropdown<T>> {
  T? dropdownValue;

  @override
  void initState() {
    super.initState();
    //  dropdownValue = widget.selectedValue;
    //dropdownValue = widget.selectedValue?? widget.items.first;
    dropdownValue = widget.selectedValue ??
        (widget.items.isNotEmpty ? widget.items.first : null);
  }

  // @override
  // void initState() {
  //   super.initState();
  //   dropdownValue =( widget.selectedValue=='')?widget.items[0]:(widget.selectedValue==null)?widget.items[0]:widget.selectedValue;
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          height: 35,
          width: 400,
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(color: Color.fromARGB(255, 240, 239, 239)),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: dropdownValue,
              focusColor: Colors.grey,
              elevation: 8,
              onChanged: (T? newValue) {
                setState(() {
                  dropdownValue = newValue;
                  widget.onChanged(newValue);
                });
              },
              items: widget.items.map<DropdownMenuItem<T>>((T value) {
                return DropdownMenuItem<T>(
                  value: value,
                  child: Text(value.toString()),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
