import 'dart:convert';

import 'package:apsfllmo/model/prepaid_dashboard_model.dart';
import 'package:apsfllmo/screens/homescreen/home_screen.dart';
import 'package:apsfllmo/utils/apiservice.dart';
import 'package:apsfllmo/utils/constants.dart';
import 'package:apsfllmo/utils/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class PrepaidDashboard extends StatefulWidget{
  @override
  State<PrepaidDashboard> createState() => _PrepaidDashboardState();
}

class _PrepaidDashboardState extends State<PrepaidDashboard>{

List<PrepaidDashboardModel> mtd_revenue_list=[];
List<PrepaidDashboardModel> cafcount_list=[];
List<PrepaidDashboardModel> mtd_online_clctn_list=[];
List<PrepaidDashboardModel> mtd_renewed_cafs_list=[];
List<PrepaidDashboardModel> expired_caf_list=[];
   @override
  void initState() {
    super.initState();
    setState(() {
      mtd_revenue_api_call();
      mtd_caf_count_api_call();
      mtd_caf_clctn_api_call();
      mtd_renewed_cafs_list_api_call();
      expired_cafs_api_call();
    });
  }


  Future<void> mtd_revenue_api_call() async{
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
          var url = Uri.parse(Constants.baseUrl + Apiservice.mtd_revenue);
          print("url $url");
          final response = await http.get(url,headers: headers);

          print("mtd_revenue_code ${response.statusCode}");
          if (response.statusCode == 200) {
              final data = json.decode(response.body);
              print('mtd_revenue_data$data');
             // return <List<RenewModel>>.fromJson(json.decode(response.body));
            
              List<dynamic> data_array=data['data'];  
              print("mtd_revenue_array $data_array");

              setState(() {
                mtd_revenue_list= data_array.map((json) => PrepaidDashboardModel.fromJson(json)).toList();
                print("mtd_revenue_list $mtd_revenue_list");            
              });

    
           } 
           else {
               print("faileddd");
              throw Exception('Failed to load posts');
           }
  }

 
  Future<void> mtd_caf_count_api_call() async{
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
          var url = Uri.parse(Constants.baseUrl + Apiservice.all_caf_cnt);
          print("url $url");
          final response = await http.get(url,headers: headers);

          print("cafcount_code ${response.statusCode}");
          if (response.statusCode == 200) {
              final data = json.decode(response.body);
              print('cafcount_data$data');
             // return <List<RenewModel>>.fromJson(json.decode(response.body));
            
              List<dynamic> data_array=data['data'];  
              print("cafcount_array $data_array");

              setState(() {
                cafcount_list= data_array.map((json) => PrepaidDashboardModel.fromJson(json)).toList();
                print("cafcount_list $cafcount_list");            
              });

    
           } 
           else {
               print("faileddd");
              throw Exception('Failed to load posts');
           }
  }

 Future<void> mtd_caf_clctn_api_call() async{
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
          var url = Uri.parse(Constants.baseUrl + Apiservice.mtd_online_clctn);
          print("url $url");
          final response = await http.get(url,headers: headers);

          print("cafcount_code ${response.statusCode}");
          if (response.statusCode == 200) {
              final data = json.decode(response.body);
              print('cafcount_data$data');
             // return <List<RenewModel>>.fromJson(json.decode(response.body));
            
              List<dynamic> data_array=data['data'];  
              print("cafcount_array $data_array");

              setState(() {
                mtd_online_clctn_list= data_array.map((json) => PrepaidDashboardModel.fromJson(json)).toList();
                print("mtd_online_clctn_list $mtd_online_clctn_list");            
              });

    
           } 
           else {
               print("faileddd");
              throw Exception('Failed to load posts');
           }
  }


Future<void> mtd_renewed_cafs_list_api_call() async{
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
          var url = Uri.parse(Constants.baseUrl + Apiservice.mtd_renewed_cafs);
          print("url $url");
          final response = await http.get(url,headers: headers);

          print("mtd_renewed_list ${response.statusCode}");
          if (response.statusCode == 200) {
              final data = json.decode(response.body);
              print('mtd_renewed_list$data');
             // return <List<RenewModel>>.fromJson(json.decode(response.body));
            
              List<dynamic> data_array=data['data'];  
              print("mtd_renewed_list_array $data_array");

              setState(() {
                mtd_renewed_cafs_list= data_array.map((json) => PrepaidDashboardModel.fromJson(json)).toList();
                print("mtd_renewed_cafs_list $mtd_renewed_cafs_list");            
              });

    
           } 
           else {
               print("faileddd");
              throw Exception('Failed to load posts');
           }
  }


Future<void> expired_cafs_api_call() async{
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
          var url = Uri.parse(Constants.baseUrl + Apiservice.expiry_cafs);
          print("url $url");
          final response = await http.get(url,headers: headers);

          print("expiry_cafs_st_code ${response.statusCode}");
          if (response.statusCode == 200) {
              final data = json.decode(response.body);
              print('expiry_cafs_list$data');
             // return <List<RenewModel>>.fromJson(json.decode(response.body));
            
              List<dynamic> data_array=data['data'];  
              print("expiry_cafs_list_array $data_array");

              setState(() {
                expired_caf_list= data_array.map((json) => PrepaidDashboardModel.fromJson(json)).toList();
                print("expiry_cafs_list $expired_caf_list");            
              });

    
           } 
           else {
               print("faileddd");
              throw Exception('Failed to load posts');
           }
  }



  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    //throw UnimplementedError();
    
    return Scaffold(
        appBar: AppBar(
        title: const Text(
          'Prepaid ',
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


      body: Center(
        child:Container(
          margin: EdgeInsets.all(10),
          child:
           Column(
            children: [
                Card(
             elevation: 25,
             shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
              color: Colors.white,
              child: Container(
                //padding: EdgeInsets.all(10),
               
          child: 
          cafcount_list.isEmpty
           ? Center(
              child: 
              // Text(
              // "No data found",
              //  style: TextStyle(fontSize: 25, color: Colors.grey,fontWeight: FontWeight.w700),
              // ),
              CircularProgressIndicator(),
             ):
             Container(
              height: MediaQuery.of(context).size.height*0.2,
             padding: EdgeInsets.all(5),
              child:
              //  Expanded(
              // child:
               ListView.builder(
              itemCount: cafcount_list.length,
              itemBuilder: (context, index) {
                if (index == cafcount_list.length) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
               return

                        Container(
                      margin: EdgeInsets.only(top: 0,left: 20,right: 20,bottom: 0),
                      child: Column(
                        children: [  


                      Column(
                        children: [
                           Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            Text(cafcount_list[index].Status_name.toString(),),
                            Text(cafcount_list[index].CAF_COUNT.toString(),style: TextStyle(color: Pallete.buttonColor),),
                           
                        ],

                       ),
                                Container(
                        height: 1,
                        color: Colors.grey,
                        margin: EdgeInsets.symmetric(vertical: 10),
                      ),

                        ],
                      ),
                        ]));
              }
                     ),
                
          //   ), 

             ),
         
                     
              

           
              ),

          ),
      
               Card(
             elevation: 25,
             shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
              color: Colors.white,
              child: Container(
                //padding: EdgeInsets.all(10),
               
          child: 
          mtd_revenue_list.isEmpty
           ? Center(
              child: 
              // Text(
              // "No data found",
              //  style: TextStyle(fontSize: 25, color: Colors.grey,fontWeight: FontWeight.w700),
              // ),
              CircularProgressIndicator(),
             ):
             Container(
              height: MediaQuery.of(context).size.height*0.1,
              margin: EdgeInsets.only(top: 0,left: 20,right: 20,bottom: 0),
             padding: EdgeInsets.all(5),
              child:ListView.builder(
              itemCount: mtd_revenue_list.length,
              itemBuilder: (context, index) {
               return
                // Container(
                //       margin: EdgeInsets.only(top: 0,left: 20,right: 20,bottom: 0),
                //       child:
                       Column(
                        children: [  


                      Column(
                        children: [
                           Row(
                           mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                           
                                 Text(mtd_revenue_list[index].month.toString()),
                                Text(mtd_revenue_list[index].ttl_apsfl_mnth_rvnue.toString(),style: TextStyle(color: Pallete.buttonColor),),                         
                              ],
                            ),


                             Column(
                              children: [
                                 Text(mtd_revenue_list[index].mnth.toString()),
                                 Text(mtd_revenue_list[index].ttl_apsfl_mnth_clctn.toString(),style: TextStyle(color: Pallete.buttonColor),),
                           
                              ],
                            ),

                           
                        ],

                       ),

                        ],
                      ),
                       
                        ]);
                       // );
              }
                     ),
                
          //   ), 

             ),
           
              ),

          ),
      
                 Card(
             elevation: 25,
             shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
              color: Colors.white,
              child: Container(
                //padding: EdgeInsets.all(10),
               
          child: 
          mtd_online_clctn_list.isEmpty
           ? Center(
              child: 
            
              CircularProgressIndicator(),
             ):
             Container(
             // height: MediaQuery.of(context).size.height*0.1,
              margin: EdgeInsets.only(top: 0,left: 20,right: 20,bottom: 0),
             padding: EdgeInsets.all(5),
              child:
              // ListView.builder(
              // itemCount: mtd_online_clctn_list.length,
              // itemBuilder: (context, index) {
              //  return
                // Container(
                //       margin: EdgeInsets.only(top: 0,left: 20,right: 20,bottom: 0),
                //       child:
                       Column(
                        children: [  


                      Column(
                        children: [
                           Row(
                           mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                           
                                 Text(mtd_online_clctn_list[0].tdy.toString()),
                                Text(mtd_online_clctn_list[0].tdyamt.toString(),style: TextStyle(color: Pallete.buttonColor),),                         
                              ],
                            ),


                             Column(
                              children: [
                                 Text(mtd_online_clctn_list[1].tdy.toString()),
                                 Text(mtd_online_clctn_list[1].tdyamt.toString(),style: TextStyle(color: Pallete.buttonColor),),
                           
                              ],
                            ),

                           
                        ],

                       ),

                        ],
                      ),
                       
                        ]),
                       // );
             // }
                    // ),
                
          //   ), 

             ),
           
              ),

          ),
      
               
                 Card(
             elevation: 25,
             shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
              color: Colors.white,
              child: Container(
                //padding: EdgeInsets.all(10),
               
          child: 
          mtd_renewed_cafs_list.isEmpty
           ? Center(
              child: 
            
              CircularProgressIndicator(),
             ):
             Container(
             // height: MediaQuery.of(context).size.height*0.1,
              margin: EdgeInsets.only(top: 0,left: 20,right: 20,bottom: 0),
             padding: EdgeInsets.all(5),
              child:   Column(
                        children: [  


                      Column(
                        children: [
                           Row(
                           mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                           
                                 Text(mtd_renewed_cafs_list[0].tdy.toString()),
                                Text(mtd_renewed_cafs_list[0].tdy_renwd_caf.toString(),style: TextStyle(color: Pallete.buttonColor),),                         
                              ],
                            ),


                             Column(
                              children: [
                                 Text(mtd_renewed_cafs_list[1].tdy.toString()),
                                 Text(mtd_renewed_cafs_list[1].tdy_renwd_caf.toString(),style: TextStyle(color: Pallete.buttonColor),),
                           
                              ],
                            ),

                           
                        ],

                       ),

                        ],
                      ),
                       
                        ]),
                       // );
             // }
                    // ),
                
          //   ), 

             ),
           
              ),

          ),
      
                
                 Card(
             elevation: 25,
             shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
              color: Colors.white,
              child: Container(
                //padding: EdgeInsets.all(10),
               
          child: 
          expired_caf_list.isEmpty
           ? Center(
              child: 
            
              CircularProgressIndicator(),
             ):
             Container(
             // height: MediaQuery.of(context).size.height*0.1,
              margin: EdgeInsets.only(top: 0,left: 20,right: 20,bottom: 0),
             padding: EdgeInsets.all(5),
              child:   Column(
                        children: [  


                      Column(
                        children: [
                           Row(
                           mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                           
                                 Text(expired_caf_list[0].sum.toString()),
                                Text(expired_caf_list[0].expired_caf.toString(),style: TextStyle(color: Pallete.buttonColor),),                         
                              ],
                            ),


                             Column(
                              children: [
                                 Text(expired_caf_list[1].sum.toString()),
                                 Text(expired_caf_list[1].expired_caf.toString(),style: TextStyle(color: Pallete.buttonColor),),
                           
                              ],
                            ),

                           
                        ],

                       ),

                        ],
                      ),
                       
                        ]),
                       // );
             // }
                    // ),
                
          //   ), 

             ),
           
              ),

          ),
      




            ],
          ),
        )
      ),


    );

  }

}