import 'dart:convert';

import 'package:apsfllmo/model/revenue_sharing_model.dart';
import 'package:apsfllmo/screens/homescreen/home_screen.dart';
import 'package:apsfllmo/utils/apiservice.dart';
import 'package:apsfllmo/utils/constants.dart';
import 'package:apsfllmo/utils/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class RevenueSharing extends StatefulWidget{
  @override
  State<RevenueSharing> createState() => _RevenueSharingState();
}

class _RevenueSharingState extends State<RevenueSharing>{

  // List<int> yrs_list=[2024,2023,2022,2021,2020,1999];
   List<int> yrs_list=[];
   late int selected_yr_nm;
   int selected_mnth=0;

   List<RevenueSharingModel> revenue_sharing_list=[];


 
 @override
  void initState() {
    super.initState();
   yrs_list=getYearsList(6);
   selected_yr_nm=yrs_list[0];
   print("selected_yr_nm $selected_yr_nm");
   revenue_sharing_api_call();
 
  }

  List<int> getYearsList(int backYears) {
  int currentYear = DateTime.now().year;
  List<int> years = [];
  for (int i = 0; i <= backYears; i++) {
    years.add(currentYear - i);
  }
  return years;
}

  Future<void> revenue_sharing_api_call() async{
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

             var url = Uri.parse(Constants.baseUrl + Apiservice.revenue_sharing+selected_yr_nm.toString()+"/"+agent_id!+"/"+selected_mnth.toString());
          print("url $url");
          final response = await http.get(url,headers: headers);

          print("revenue_sharing ${response.statusCode}");
          if (response.statusCode == 200) {
              final data = json.decode(response.body);
              print('revenue_sharing_data$data');
             // return <List<RenewModel>>.fromJson(json.decode(response.body));
            
              List<dynamic> data_array=data['data'];  
              print("data_array $data_array");

          

              setState(() {
                
                  revenue_sharing_list= data_array.map((json) => RevenueSharingModel.fromJson(json)).toList();
                print("revenue_sharing_list $revenue_sharing_list");
              
              
              });

    
           } else {
               print("faileddd");
              throw Exception('Failed to load posts');
           }


  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
  //  throw UnimplementedError();

     return Scaffold(
        appBar: AppBar(
        title: const Text(
          'Revenue Sharing',
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
        children: [
            Container(
              margin: EdgeInsets.all(10),
             
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Select Year",
                  textAlign: TextAlign.start,),
                   Container(
                  // height: 30,
                 margin: EdgeInsets.only(left: 0,top: 5,right: 0,bottom: 5),
                 padding: EdgeInsets.symmetric(horizontal: 8.0),
                  decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.grey,
                  width: 1,
                  
                )
              ),
               
                child: DropdownButtonHideUnderline(
                  child:  DropdownButton<int>(
                  value: selected_yr_nm,
                  icon: const Icon(Icons.arrow_drop_down), // Right facing icon
                  // iconSize: 16,
                  // elevation: 16,
                  isExpanded: true,
                  onChanged: (int? newValue) {
                    setState(() {
                      selected_yr_nm = newValue!;
                        revenue_sharing_api_call();
                      
                    });
                  },
                  items: yrs_list.map((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text(value.toString()),
                    );
                  }).toList(),
                ),
             
                  ),
              
              ),

                ],
              ),
            ),
          
          SizedBox(height: 10,),
         
         Expanded(
          child: 
          revenue_sharing_list.isEmpty
           ? Center(
              child: Text(
              "No data found",
               style: TextStyle(fontSize: 25, color: Colors.grey,fontWeight: FontWeight.w700),
              ),
             ): 
           ListView.builder(
              itemCount: revenue_sharing_list.length,
              itemBuilder: (context, index) {
                if (index == revenue_sharing_list.length) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
               return 
               
               Container(
            margin: EdgeInsets.all(10),
            child:  
           Card(
             elevation: 25,
             shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
              color: Colors.white,
              child: Container(
                //padding: EdgeInsets.all(10),
                child:
                
                 Column(
                  children: [

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      Container(
                        width: MediaQuery.of(context).size.width*0.2,
                        height: MediaQuery.of(context).size.height*0.05,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(bottomRight: Radius.circular(20)),
                          color: Pallete.buttonColor,
                        ),

                        child:
                        Center(
                          child:  Column(
                          children: [
                            Text("JUL",
                              style: TextStyle(
                              color: Colors.white,
                            ),),
                            Text("2024",
                              style: TextStyle(
                              color: Colors.white,
                              )
                            )
                          ],
                        ),
                        ),

                      ),

                       Container(
                        width: MediaQuery.of(context).size.width*0.3,
                       height: MediaQuery.of(context).size.height*0.035,
                       margin: EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20)),
                          color: Pallete.buttonColor,
                        ),

                        child:
                        Center(
                          child: 
                          Text("LMO2000825",
                              style: TextStyle(
                              color: Colors.black,
                            ),),
                        ),

                      ),



                      ],
                    ),


                    Container(
                      margin: EdgeInsets.only(top: 10,left: 20,right: 20,bottom: 10),
                      child: Column(
                        children: [
                          
                       Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                         Text("APSFL Share",textAlign: TextAlign.start,),
                        
                        Text("${revenue_sharing_list[index].apsflshare}",textAlign: TextAlign.end,),
                        ],

                       ),

                           Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                        Text("MSO Share"),
                        Text("${revenue_sharing_list[index].msoshare}"),
                         ],
                        ),

                      Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("LMO Share"),
                        Text("${revenue_sharing_list[index].lmoshare}"),
                      ],
                     ),

                      Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Total"),
                        Text("${revenue_sharing_list[index].total}"),
                      ],
                     ),

                        Container(
                        height: 1,
                        color: Colors.grey,
                        margin: EdgeInsets.symmetric(vertical: 10),
                      ),

                      Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                         children: [
                            Text("CAF Count"),
                         Text("${revenue_sharing_list[index].cafcount}"),
                         ],
                        ),

                        Column(
                         children: [
                            Text("Paid"),
                         Text("${revenue_sharing_list[index].paid}"),
                         ],
                        ),

                        Column(
                         children: [
                            Text("Not Paid"),
                         Text("${revenue_sharing_list[index].NotPaid}"),
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