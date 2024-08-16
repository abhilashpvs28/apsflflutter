import 'dart:convert';

import 'package:apsfllmo/model/inventorycount_model.dart';
import 'package:apsfllmo/screens/homescreen/home_screen.dart';
import 'package:apsfllmo/utils/apiservice.dart';
import 'package:apsfllmo/utils/constants.dart';
import 'package:apsfllmo/widgets/cpe_inventory_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../../utils/pallete.dart';


class CpeInventoryScreen extends StatefulWidget {
  const CpeInventoryScreen({super.key});
  @override
  State<CpeInventoryScreen> createState() => _CpeInventoryScreenState();
}

class _CpeInventoryScreenState extends State<CpeInventoryScreen> {

  bool _isLoading = false;
  late Future<List<InventoryCountModel>> futurePosts22;
  List<InventoryCountModel> cpe_invetory_data=[];
 // List<dynamic> inventoryList = [];
  List<InventoryCountModel> inventoryList = [];
  List<dynamic> inv_cnt=[];
  Map? mapResponse;
  Map? dataResponse;
  Map? listResponse;
  int selectedIndex=0;
  int? status;
  int? totall;
  int? allocatedd;
  int? availablee;

  List<dynamic> cpe_total_list=[];
  List<dynamic> cpe_installed_list=[];
  List<dynamic> cpe_available_list=[];
   List<dynamic> jsonData=[];


  @override
  void initState() {
    super.initState();
    fetchinvCounts();
  //  cpeData();
    
  }


    void updateSelectedIndex(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

    Future<void> fetchinvCounts() async {

         

        final storage = FlutterSecureStorage();
        final token = await storage.read(key: 'token');
        print("token $token");

        // Headers
        final header_token = {
            'Content-Type': 'application/json',
            'x-access-token': token,
        };
         if (token == null) {
          setState(() {
            _isLoading = false;
          });
          print('Token is null');
          return;
        }

          // Remove any null values from headers
          final cleanedHeaders = header_token.map((key, value) {
            if (value != null) {
                  return MapEntry(key, value);
            } else {
              // Handle the case where the value is null if necessary
              return MapEntry(key, ''); // Or remove the key entirely, or some other logic
            }
          });

    
          var url = Uri.parse(Constants.baseUrl + Apiservice.inventorycnt);
          print("url $url");
          final response = await http.get(url,headers: cleanedHeaders);

          if (response.statusCode == 200) {
              final data = json.decode(response.body);
     
                setState(() {
                  inv_cnt=data['data'];
                  status=data['status'];
                  totall=data['data'][0]['Total'];
                  allocatedd=data['data'][0]['Allocated'];
                  availablee=data['data'][0]['Available'];
                  print("total $totall");
                  print("allocated $allocatedd");
                  print("available $availablee");
                  print("inv_list $inv_cnt");

                  cpeData();
   

        }); 
   
    } else {
      print("faileddd");
      throw Exception('Failed to load posts');
    }
  }


    Future<void> cpeData() async {


        final storage = FlutterSecureStorage();
        final token = await storage.read(key: 'token');
        print("token $token");

        // Headers
        final header_token = {
            'Content-Type': 'application/json',
            'x-access-token': token,
        };

          // Remove any null values from headers
          final cleanedHeaders = header_token.map((key, value) {
            if (value != null) {
                  return MapEntry(key, value);
            } else {
              // Handle the case where the value is null if necessary
              return MapEntry(key, ''); // Or remove the key entirely, or some other logic
            }
          });

          print("cleanedHeaders $cleanedHeaders");
     
        //    if (token == null) {
        //   setState(() {
        //     _isLoading = false;
        //   });
        //   print('Token is null');
        //   return;
        // }
    
          var url = Uri.parse(Constants.baseUrl + Apiservice.cpedata);
          print("url $url");
          final response = await http.get(url,headers: cleanedHeaders);

          if (response.statusCode == 200) {
           // _isLoading = false;
              final response_data = json.decode(response.body);
              
                setState(() {
                  jsonData = json.decode(response.body)['data'];
                  print("object $jsonData");

               //   inventoryList=jsonData;
                 
                  inventoryList=jsonData.map((json) => InventoryCountModel.fromJson(json)).toList();

                 
                   print("listresponse $cpe_invetory_data");
                    //print("mapresponse $mapResponse");
                     print("inventory_list $inventoryList");
                  
                });

                
   
          }
           else {
           // _isLoading = false;
              print("Cpe data faileddd");
              throw Exception('Failed to load Cpedata');
            }
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'CPE Inventory',
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
                      builder: (BuildContext context) =>
                          const HomeScreen()));
            },
          ),
        ],
      ),

    

        body: Column(
         // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            Center(
              child: totall==null? CircularProgressIndicator(): Text(""),
            ),
            
           Container(
            margin: EdgeInsets.only(left: 25.0,top: 30.0,right: 25.0,bottom: 5.0),
            padding: EdgeInsets.only(left: 0,top: 15,right: 10,bottom: 15),
            //color: Color.fromARGB(255, 235, 89, 4),
          //  height: 100,
            alignment: Alignment.topCenter,
            decoration: BoxDecoration(
              color:Color.fromARGB(255, 224, 97, 23),
              borderRadius: BorderRadius.circular(5)
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
    
                       Text(
                      "$totall",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                      
                   
                    const SizedBox(
                      height: 5.0,
                    ),
                   
                   InkWell(
                      onTap: () {
                       setState(() {
                          updateSelectedIndex(0);
                          print("selectedIndex0 $selectedIndex");
                       });
 
                      },

                      child:  Text(
                      "Total",
                      style: TextStyle(
                        color: (selectedIndex==0)?Colors.black:Colors.white,
                        fontSize: 15.0,
                        decoration: (selectedIndex==0)?TextDecoration.underline:TextDecoration.none,
                        decorationColor: (selectedIndex==0)?Colors.black:Colors.white,
                        
                      ),
                      textAlign: TextAlign.center,
                    ),
                   ),
                      
                  ],
                
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${allocatedd}",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                     
                     SizedBox(
                      height: 5.0,
                    ),

                      InkWell(
                      onTap: () {
                        print("installed_click");
                       setState(() {
                          updateSelectedIndex(1);
                          print("selectedIndex1 $selectedIndex");
                          print("selected_item $inventoryList[selectedIndex].DSNCOMBO ");
                       }); 
                      },
                      child:Text(
                      "CAF Installed",
                       style: TextStyle(
                        color: (selectedIndex==1)?Colors.black:Colors.white,
                        fontSize: 15.0,
                        decoration: (selectedIndex==1)?TextDecoration.underline:TextDecoration.none,
                        decorationColor: (selectedIndex==1)?Colors.black:Colors.white,
                        
                      ),
                      textAlign: TextAlign.center,
                    ),

                      ),
                    

                 
                  ],
                
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                     "${availablee}",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                      ),
                      textAlign: TextAlign.center,
                    ),

                     SizedBox(
                      height: 5.0,
                    ),


                     InkWell(
                      onTap: () {
                       setState(() {
                          updateSelectedIndex(2);
                          print("selectedIndex2 $selectedIndex");
                       });
                      },

                      child: Text(
                      "Available",
                       style: TextStyle(
                        color: (selectedIndex==2)?Colors.black:Colors.white,
                        fontSize: 15.0,
                        decoration: (selectedIndex==2)?TextDecoration.underline:TextDecoration.none,
                        decorationColor: (selectedIndex==2)?Colors.black:Colors.white,
                        
                      ),
                      textAlign: TextAlign.center,
                    ),
                     ),
                   
                  ],
                
                )
              ],

            ),
           
          ),

          Container(
            margin:const EdgeInsets.only(left: 25.0,top: 5.0,right: 25.0,bottom: 0.0),
            padding:const EdgeInsets.only(left: 20,top: 15,right: 20,bottom: 15),
            decoration:const BoxDecoration(
              color:  Color.fromARGB(255, 246, 202, 177),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5),
                topRight: Radius.circular(5),
              
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              
              children: [
                 Text(
                      "${inventoryList[selectedIndex].label}",
                    //  "Total",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.0,
                      ),
                      textAlign: TextAlign.center,
                    ),

                     Text(
                     // "129",
                     // $inventoryList.map((item) => item.total).toList()
                     "${inventoryList[selectedIndex].total}",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.0,
                      ),
                      textAlign: TextAlign.center,
                    ),

              ],
            ),

          ),

          Container(
            margin:const EdgeInsets.only(left: 25.0,top: 5.0,right: 25.0,bottom: 10.0),
            padding:const EdgeInsets.only(left: 20,top: 10,right: 20,bottom: 10),
             decoration:const BoxDecoration(
              color:  Color.fromARGB(255, 246, 202, 177),
              borderRadius: BorderRadius.only(
            
                bottomLeft: Radius.circular(5),
                bottomRight: Radius.circular(5)
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
               const SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                   children: [
                   
                    const SizedBox(height: 20,),
                    CpeInventoryCard("${inventoryList[selectedIndex].DASAN} ", "DASAN"),
              

                    const SizedBox(width: 10,),               
                    CpeInventoryCard("${inventoryList[selectedIndex].ZTE}", "ZTE"),
                    const SizedBox(width: 10,),

                    CpeInventoryCard("${inventoryList[selectedIndex].PT}", "PT"),               

                   ],
                ),


                 const SizedBox(
                    height: 20,
                  ),

                  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                   children: [
                   
                    const SizedBox(height: 20,),                    
                    CpeInventoryCard("${inventoryList[selectedIndex].RGW}", "RGW"),
             
                    const SizedBox(width: 10,),                
                     CpeInventoryCard("${inventoryList[selectedIndex].YAGA}", "YAGA"),
                 
                    const SizedBox(width: 10,),
                     CpeInventoryCard("${inventoryList[selectedIndex].IPTV}", "IPTV"),
              


                   ],
                ),

               const SizedBox(height: 20,),

                 Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                   
                    const SizedBox(height: 20,),
                    const SizedBox(width: 20,),
                  
                     CpeInventoryCard("${inventoryList[selectedIndex].DSNCOMBO}", "DSNCOMBO"),
                
                    
                   ],
                ),
              ],
              
            ),

          )
          ],
        )

    );
  }
}
