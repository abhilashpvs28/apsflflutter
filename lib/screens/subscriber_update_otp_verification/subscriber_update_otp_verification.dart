import 'dart:convert';

import 'package:apsfllmo/model/subscriber_otp_verification_model.dart';
import 'package:apsfllmo/utils/apiservice.dart';
import 'package:apsfllmo/utils/constants.dart';
import 'package:apsfllmo/utils/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class SubscriberUpdateOtpVerification extends StatefulWidget{
  const SubscriberUpdateOtpVerification({super.key});

  @override
  State<SubscriberUpdateOtpVerification> createState() => _SubscriberUpdateOtpVerificationState();
}

class _SubscriberUpdateOtpVerificationState extends State<SubscriberUpdateOtpVerification>{

   List<SubscriberOtpVerificationModel> _subscriber_otp_vList = [];
    

   
 @override
  void initState() {
    super.initState();
   
      subscriber_otp_verification_list();
      
  }

    
    Future<void> subscriber_otp_verification_list() async {
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
  
          var url = Uri.parse(Constants.baseUrl + Apiservice.subscriber_otp_verification+agent_id!);
          print("url $url");
          final response = await http.get(url,headers: headers);

          print("subscriber_status_code ${response.statusCode}");
          if (response.statusCode == 200) {
              final data = json.decode(response.body);
              print('response_subscriber_otp $data');
             // return <List<RenewModel>>.fromJson(json.decode(response.body));
            
              List<dynamic> data_array=data['data'];  
              print("data_array $data_array");

    
              setState(() {
                
                  _subscriber_otp_vList= data_array.map((json) => SubscriberOtpVerificationModel.fromJson(json)).toList();
                print("_subscriber_otp_vList $_subscriber_otp_vList");
              
              
              });

    
           } else {
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
          'Pon Change',
          style: TextStyle(color: Colors.black, fontFamily: 'Cera-Bold'),
        ),
        backgroundColor: Pallete.backgroundColor,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.refresh,
              color: Colors.black,
            ),
            onPressed: () {
              subscriber_otp_verification_list();
            },
          ),
        ],
      ),

    body: Column(
      children: [

         Container(
         
        margin: EdgeInsets.only(left: 10,top: 0,right: 10,bottom: 5),
        child:Card(
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
                 
                   SizedBox(
                    height: 35,
                    child:   Center(
                      child: TextField(
                     decoration: InputDecoration(
                     prefixIcon: Icon(Icons.search,color: Colors.grey,),
                     hintText: "Search Here",
              
                     border: OutlineInputBorder(
                     borderRadius: BorderRadius.all(Radius.circular(20)),
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
      ),

      
         Expanded(
            child: 
            ListView.builder(
              itemCount: _subscriber_otp_vList.length,
              itemBuilder: (context, index) {
                if (index == _subscriber_otp_vList.length) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
               return   Container(
      margin:EdgeInsets.only(left: 10,top: 5,right: 10,bottom: 5) ,
      // height: 400,
      // width: 400,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
           Card(
             elevation: 25,
             shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
              color: Colors.white,
              child: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                            Text(
                              "APSFL NOC"
                            ),

                           Spacer(),

                            Column(
                              children: [
                                 Text(
                              "${_subscriber_otp_vList[index].caf_id}"
                               ),

                              ],
                            ),
                         
                          ],
                    ),
                   
                
                     Column(
                        children: [
                         // Text("Old Details",style: TextStyle(color: Pallete.buttonColor,decoration: TextDecoration.underline,decorationColor: Pallete.buttonColor),),
                        
                         Row(
                           mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                           Text("Old Details",style: TextStyle(color: Pallete.buttonColor,decoration: TextDecoration.underline,decorationColor: Pallete.buttonColor),),
                        
                        ],

                       ),

                          SizedBox(height: 5,),
                           Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                         Text("Aadhar",textAlign: TextAlign.start,),
                         Spacer(),
                        Text(":"),
                        Spacer(),
                        Text("${_subscriber_otp_vList[index].adhr_nu}",textAlign: TextAlign.end,),
                        ],

                       ),

                           Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                        Text("Mobile No"),
                        Spacer(),
                        Text(":"),
                        Spacer(),
                        Text("${_subscriber_otp_vList[index].mbl_nu}"),
                         ],
                        ),

                      Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Email"),
                        Spacer(),
                        Text(":"),
                        Spacer(),
                        Text("${_subscriber_otp_vList[index].loc_eml1_tx}"),
                      ],

                     ),

                      Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Building/House/Flat"),
                        Spacer(),
                        Text(":"),

                        Spacer(),

                        Flexible(
                          child:  Text("${_subscriber_otp_vList[index].instl_addr1_tx}",
                        maxLines: null,
                        overflow: TextOverflow.visible,
                        
                        ),
                          )
                        // Text("${_subscriber_otp_vList[index].instl_addr1_tx}",
                        // maxLines: null,
                        // overflow: TextOverflow.visible,
                        // ),
                      ],
                     ),


                     Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Street Name"),
                        Spacer(),
                        Text(":"),
                        Spacer(),
                        Text("${_subscriber_otp_vList[index].instl_ara_tx}"),
                      ],

                     ),

                      Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Locality/Area"),
                        Spacer(),
                        Text(":"),
                        Spacer(),
                        Text("${_subscriber_otp_vList[index].instl_lcly_tx}"),
                      ],

                     ),


                        Row(
                           mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                           Text("New Details",style: TextStyle(color: Pallete.buttonColor,decoration: TextDecoration.underline,decorationColor: Pallete.buttonColor),),
                        
                        ],

                       ),
                      Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Mobile No"),
                        Spacer(),
                        Text(":"),
                        Spacer(),
                        Text("${_subscriber_otp_vList[index].mbl_nu_updtd}"),
                      ],

                     ),

                       Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Email"),
                        Spacer(),
                        Text(":"),
                        Spacer(),
                        Text("${_subscriber_otp_vList[index].loc_eml1_tx_updtd}"),
                      ],

                     ),


                      Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Building/House/Flat"),
                        Spacer(),
                        Text(":"),
                        Spacer(),
                        Flexible(
                          child:  Text("${_subscriber_otp_vList[index].instl_addr1_tx_updtd}",
                        maxLines: null,
                        overflow: TextOverflow.visible,
                        
                        ),
                          )
                       
                      ],

                     ),

                       Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Street Name"),
                        Spacer(),
                        Text(":"),
                        Spacer(),
                        Text("${_subscriber_otp_vList[index].instl_ara_tx_updtd}"),
                      ],

                     ),
                     

                        Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Locality/Area"),
                        Spacer(),
                        Text(":"),
                        Spacer(),
                        Text("${_subscriber_otp_vList[index].instl_lcly_tx_updtd}"),
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

                            Text("Date:${_subscriber_otp_vList[index].updt_ts}"),

                            ElevatedButton(
                              onPressed: (){
                              

                              },
                              style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromRGBO(199, 237, 190, 1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                             child: const Text(
                              "Verify",
                              style: TextStyle(
                                color: Color.fromARGB(255, 2, 95, 38),
                              ),
                            ),
                            )
                       
                      ],

                     ),



                        ],
                      ),
                  ],
                 ),
              ),

          ),
       
        ],
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