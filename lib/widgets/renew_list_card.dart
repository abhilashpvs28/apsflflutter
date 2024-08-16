import 'dart:convert';

import 'package:apsfllmo/model/renew_model.dart';
import 'package:apsfllmo/screens/additionalservices/renew_caf2.dart';
import 'package:apsfllmo/utils/apiservice.dart';
import 'package:apsfllmo/utils/constants.dart';
import 'package:apsfllmo/utils/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class RenewListCard extends StatelessWidget{
 
   final RenewModel renewModel;

 const RenewListCard({required this.renewModel});




  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    //throw UnimplementedError();
     String? caf_type='';
     bool _isVisible=false;
     if(renewModel.caf_type_id==1){
       caf_type="(Individual)";
       _isVisible=false;
    }else{
      caf_type="(Enterprise)";
      _isVisible=true;
    }

    return 
    Container(
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
                              "${renewModel.cstmr_nm}"
                            ),

                            Column(
                              children: [
                                 Text(
                              "${renewModel.caf_id}"
                               ),

                                Visibility(
                            visible: _isVisible,
                            child: Text(
                            caf_type,
                            style: TextStyle(
                              color: Colors.blue
                            ),
                            ),
                           ),

                              ],
                            ),
                         
                          ],
                    ),
                     Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [

                            Row(
                              children: [
                                Icon(Icons.mobile_friendly,size: 15,),
                                 SizedBox(width: 5,),
                                Text(
                              "${renewModel.mbl_nu}"
                            ),
                              ],
                            ),

                             Text(
                              "${renewModel.sts_nm}",
                              style: TextStyle(
                               color: 
                               ('${renewModel.sts_nm}'=="Active")?Pallete.green:('${renewModel.sts_nm}'=="Suspended")?Colors.deepOrange : ('${renewModel.sts_nm}'=="Terminated")?Colors.red:('${renewModel.sts_nm}'=="PON Change Initiated")? Colors.blue:('${renewModel.sts_nm}'=="BOX Change Initiated")?Colors.blue:Colors.black,
                              ),
                             
                            
                            ),
                          ],
                    ),

                     Container(
                        height: 1,
                        color: Colors.grey,
                        margin: EdgeInsets.symmetric(vertical: 10),
                      ),
                  
                     Column(
                        children: [
                           Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            Container(
                              width: MediaQuery.of(context).size.width*0.3,
                              child: Text("Aadhar",textAlign: TextAlign.start,),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width*0.03,
                              child: Text(":"),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width*0.3,
                              child: Text("${renewModel.adhr_nu}",textAlign: TextAlign.start,),
                            ),

                        //  Text("Aadhar",textAlign: TextAlign.start,),
                        // Text(":"),
                        // Text("${renewModel.adhr_nu}",textAlign: TextAlign.end,),
                        ],

                       ),

                           Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [

                         Container(
                              width: MediaQuery.of(context).size.width*0.3,
                              child:  Text("ONU Serial No"),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width*0.03,
                              child: Text(":"),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width*0.3,
                              child: Text("${renewModel.onu_srl_nu}",textAlign: TextAlign.start,),
                            ),

                        // Text("ONU Serial No"),
                        // Text(":"),
                        // Text("${renewModel.onu_srl_nu}"),

                         ],
                        ),

                      Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                         Container(
                              width: MediaQuery.of(context).size.width*0.3,
                              child:  Text("IPTV Serial No"),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width*0.03,
                              child: Text(":"),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width*0.3,
                              child: Text("${renewModel.iptv_srl_nu}",textAlign: TextAlign.start,),
                            ),

                        // Text("IPTV Serial No"),
                        // Text(":"),
                        // Text("${renewModel.iptv_srl_nu}"),
                      ],

                     ),

                      Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                         Container(
                              width: MediaQuery.of(context).size.width*0.3,
                              child:   Text("CAF Activated On"),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width*0.03,
                              child: Text(":"),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width*0.3,
                              child: Text("${renewModel.actvnDt}",textAlign: TextAlign.start,),
                            ),

                        // Text("CAF Activated On"),
                        // Text(":"),
                        // Text("${renewModel.actvnDt}"),
                      ],
                     ),


                     Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                          Container(
                              width: MediaQuery.of(context).size.width*0.3,
                              child:  Text("Current Package"),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width*0.03,
                              child: Text(":"),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width*0.3,
                              child: Text("${renewModel.pckge_nm}",textAlign: TextAlign.start,),
                            ),

                        // Text("Current Package"),
                        // Text(":"),
                        // Text("${renewModel.pckge_nm}"),
                      ],

                     ),

                      Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                          Container(
                              width: MediaQuery.of(context).size.width*0.3,
                              child:  Text("Last Suspended On"),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width*0.03,
                              child: Text(":"),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width*0.3,
                              child: Text("${renewModel.spnd_dt}",textAlign: TextAlign.start,),
                            ),

                        // Text("Last Suspended On"),
                        // Text(":"),
                        // Text("${renewModel.spnd_dt}"),
                      ],

                     ),

                      Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                         Container(
                              width: MediaQuery.of(context).size.width*0.3,
                              child:  Text("Renewed On"),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width*0.03,
                              child: Text(":"),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width*0.3,
                              child: Text("${renewModel.Renewed_On}",textAlign: TextAlign.start,),
                            ),

                        // Text("Renewed On"),
                        // Text(":"),
                        // Text("${renewModel.Renewed_On}"),
                      ],

                     ),

                      Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                          Container(
                              width: MediaQuery.of(context).size.width*0.3,
                              child: Text("Valid Till"),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width*0.03,
                              child: Text(":"),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width*0.3,
                              child: Text("${renewModel.cycle_end_dt}",textAlign: TextAlign.start,),
                            ),


                        // Text("Valid Till"),
                        // Text(":"),
                        // Text("${renewModel.cycle_end_dt}",textAlign: TextAlign.start,),

                      ],

                     ),


                       const SizedBox(
                        height: 10,
                       ),

  
                         Row(
                           mainAxisAlignment: MainAxisAlignment.end,
                           children: [
                            ElevatedButton(
                              onPressed: (){
                               // Navigator.push(context, MaterialPageRoute(builder: (context) => RenewCaf()));
                              //  showDialog(
                              //      context: context,
                              //      builder: (BuildContext context) {
                              //      return AlertDialog(
                              //             title: Text("Alert"),
                              //             content: Text("Are you sure,you want to renew this connection(CAF)?"),
                              //             actions: <Widget>[
                              //             TextButton(
                              //             child: Text("OK"),
                              //             onPressed: () {
                              //              Navigator.push(context, MaterialPageRoute(builder: (context) => RenewCaf()));
                                           
                              //             },
                              //           ),
                              //         ],
                              //       );
                              //     },
                              //  );


                              showCustomDialog(context);

                              },
                              style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromRGBO(199, 237, 190, 1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                             child: const Text(
                              "Renew",
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
 
  }
  
  void showCustomDialog(BuildContext context) {
     showDialog(
      context: context,
      builder: (BuildContext context) {
        return 
        
        Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: 
          Container(
            width: 100,
            height: 220,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5),
                topRight: Radius.circular(5)
              )),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  height: 25,
                  color: Pallete.lightorange,
                  child:Text("Renew",textAlign: TextAlign.start,
                  style: TextStyle(color: Color.fromARGB(255, 1, 43, 116)),),
                ),
                SizedBox(height: 15,),
              
                SizedBox(
                  child: Container(
                    padding: EdgeInsets.only(left: 10,top: 5,right: 10,bottom: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                          Text(
                  '${renewModel.caf_id}',
                  textAlign: TextAlign.start,
                ),
                  Text(
                  renewModel.cstmr_nm,
                  textAlign: TextAlign.start,
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Are you sure you want to renew this connection(CAF)?',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24.0),
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
                    child:  ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromRGBO(244, 87, 37, 1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            onPressed: () { 
                              Navigator.of(context).pop();
                              if(renewModel.caf_type_id==1){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => RenewCaf2(
                                caf_id:renewModel.caf_id,
                                package_name: renewModel.pckge_nm,

                                ) ));
                              
                              }
                              else{
                                enterprise_caf_renew_api_call(context);
                              }

                             

                             //   Navigator.of(context).pop();
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

  

   Future<void> enterprise_caf_renew_api_call(BuildContext context) async {
     final storage = FlutterSecureStorage();
      final String? token = await storage.read(key: 'token');
      final String? agent_id = await storage.read(key: 'usr_ctgry_ky');

          print('Retrieved token: $token');
          print('usercategory_key $agent_id');

          if (token == null) {
              print('Token is null');
              //return ;
            }

    final Map<String, String> headers = {
      'x-access-token': '$token',
      'Content-Type': 'application/json'
    };

        final body = jsonEncode({
          'data':{
            'aaa_cd': renewModel.aaa_cd,
            'accessId': renewModel.aghra_cd ,
            'aghra_cd': renewModel.aghra_cd ,
            'caf_id': renewModel.caf_id ,
            'caf_type_id': renewModel.caf_type_id,
            'cstmr_id': renewModel.cstmr_id,
            'olt_crd_nu': renewModel.olt_crd_nu ,
            'olt_ip_addr_tx': renewModel.olt_ip_addr_tx,
            'olt_onu_id': renewModel.olt_onu_id,
            'olt_prt_nm': renewModel.olt_prt_nm,
            'pckge_id': renewModel.pckge_nm,
            'phne_nu': renewModel.mbl_nu,
            'subscr_code': renewModel.mdlwe_sbscr_id,
            
          }

        });

        print("renew_payloads $body");

    final url = Uri.parse(Constants.baseUrl+Apiservice.enterprise_cafrenew);
    print("url $url");
    final response = await http.post(url,headers: headers,body: body);

print("response_code ${response.statusCode}");
    if (response.statusCode == 200) {
      // Handle successful response
      print('Renew Response data: ${response.body}');
      final res=json.decode(response.body);
      print("enterprise_caf_res $res");
      if(res['status']==200){
        showCustomSatusDialog(context,"Successfully Done");
      }
      
      else{
        showCustomSatusDialog(context, res['message']);
      }

       
    }
    
    else {
      // Handle error response
      final res=json.decode(response.body);
     // showCustomSatusDialog(res['message']);
      print('Failed to load data');
    }
  }
 


  

 void showCustomSatusDialog(BuildContext context, String s) {
     showDialog(
      context: context,
      builder: (BuildContext context) {
        return 
        
        Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: 
          Container(
            width: 100,
            height: 130,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5),
                topRight: Radius.circular(5)
              )),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  height: 25,
                  color: Pallete.lightorange,
                  child:Text("Renew Status",textAlign: TextAlign.start,
                  style: TextStyle(color: Color.fromARGB(255, 1, 43, 116)),),
                ),
                SizedBox(height: 15,),
              
                SizedBox(
                  child: Container(
                    padding: EdgeInsets.only(left: 10,top: 5,right: 10,bottom: 5),
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

