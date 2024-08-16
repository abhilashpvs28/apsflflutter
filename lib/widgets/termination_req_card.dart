import 'dart:convert';

import 'package:apsfllmo/model/termination_req_model.dart';
import 'package:apsfllmo/utils/apiservice.dart';
import 'package:apsfllmo/utils/constants.dart';
import 'package:apsfllmo/utils/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class TerminationReqCard extends StatelessWidget{
   final TerminationReqModel terminationReqModel;
    TextEditingController cancel_reason_controller=TextEditingController();
    TerminationReqCard({
      required this.terminationReqModel,
      super.key,
      });
    



  @override
  Widget build(BuildContext context) {

     
      return  Container(
      margin:EdgeInsets.only(left: 10,top: 5,right: 10,bottom: 10) ,
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
                child:
                
                 Column(
                  children: [

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                         

                            Text(
                              "${terminationReqModel.cstmr_nm}"
                            ),

                             Text(
                
                              "${terminationReqModel.caf_id}"
                            ),
                          ],
                    ),
                     Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [

                             Row(
                              children: [
                                Icon(Icons.mobile_friendly,size: 15,color: Pallete.buttonColor,),
                                SizedBox(width: 5,),
                                 Text(
                              "${terminationReqModel.mbl_nu}",
                              style: TextStyle(
                                color: Pallete.buttonColor,
                              ),
                             
                            ),
                           
                              ],
                            ),
                           

                            //  Text(
                            //   "${boxExchangeModel.sts_nm}",
                            
                            // ),
                          ],
                    ),

                    //  Container(
                    //     height: 1,
                    //     color: Colors.grey,
                    //     margin: EdgeInsets.symmetric(vertical: 10),
                       
                    //   ),


                      Row(
                        children: [
                           Container(
                                height: 1.0,
                                width: 350.0, // Set the desired width for the line
                                color: Colors.grey, // Set the desired color for the line
                                ),
                               SizedBox(width: 10),

                              
                        ],
                      ),
                  
                     Column(
                        children: [
                           Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                             Container(
                              width: MediaQuery.of(context).size.width*0.3,
                              child:  Text("Aadhar",textAlign: TextAlign.start,),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width*0.03,
                              child: Text(":"),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width*0.3,
                              child: Text("${terminationReqModel.adhr_nu}",textAlign: TextAlign.start,),
                            ),

                        //  Text("Aadhar",textAlign: TextAlign.start,),
                        // Text(":"),
                        // Text("${terminationReqModel.adhr_nu}",textAlign: TextAlign.end,),
                        ],

                       ),

                           Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [

                          Container(
                              width: MediaQuery.of(context).size.width*0.3,
                              child:  Text("Requested Date"),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width*0.03,
                              child: Text(":"),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width*0.3,
                              child:  Text("${terminationReqModel.trmnd_req_dt}"),
                            ),

                        // Text("Requested Date"),
                        // Text(":"),
                        // Text("${terminationReqModel.trmnd_req_dt}"),

                         ],
                        ),
                      Visibility(
                        visible: (terminationReqModel.sts=="Approved")?true:false,
                        child:  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                          Container(
                              width: MediaQuery.of(context).size.width*0.3,
                              child:  Text("Approved Date"),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width*0.03,
                              child: Text(":"),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width*0.3,
                              child:  Text("${terminationReqModel.aprvd_ts}",),
                            ),

                        // Text("Approved Date"),
                        // Text(":"),
                        // Text("${terminationReqModel.aprvd_ts}",),
                      ],

                     ),
                        ),


                      Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                          Container(
                              width: MediaQuery.of(context).size.width*0.3,
                              child: Text("Additional Status"),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width*0.03,
                              child: Text(":"),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width*0.3,
                              child:  Text("${terminationReqModel.sts}",
                          style: TextStyle(
                            color: Colors.purple,
                          ),
                        ),
                            ),

                        // Text("Additional Status"),
                        // Text(":"),
                        // Text("${terminationReqModel.sts}",
                        //   style: TextStyle(
                        //     color: Colors.purple,
                        //   ),
                        // ),
                      ],

                     ),


                       Row(
                           mainAxisAlignment: MainAxisAlignment.end,
                           children: [
                           Visibility(
                            visible: (terminationReqModel.sts=="Approved")?false:true,
                            child:  
                            ElevatedButton(
                              onPressed: (){
                              showCustomDialog(context);

                              },
                              style: ElevatedButton.styleFrom(
                              backgroundColor:Pallete.lightorange,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                             child: const Text(
                              "Cancel Reuest",
                              style: TextStyle(
                                color: Pallete.buttonColor,
                              ),
                            ),
                            )
                       
                            ),
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
                  child:Text("Cancel Request",textAlign: TextAlign.start,
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
                  '${terminationReqModel.caf_id}',
                  textAlign: TextAlign.start,
                ),
                  Text(
                  terminationReqModel.cstmr_nm,
                  textAlign: TextAlign.start,
                ),
                const SizedBox(height: 16.0),
              

                   TextField(
                             controller: cancel_reason_controller,
                             decoration: const InputDecoration(
                             border: OutlineInputBorder(),
                             hintText: "Reason for Cancellation",
                             ),
                          
                            ),
                    
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('CANCEL'),
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
                               cancel_termination_req(context);

                             },
                            child: const Text(
                              "SUBMIT",
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






   Future<void> cancel_termination_req(BuildContext context) async {
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
            'caf_id': terminationReqModel.caf_id,
            'cncl_reason': cancel_reason_controller.text ,
            
            
            
          }

        });

        print("cancel_termination_payloads $body");

    final url = Uri.parse(Constants.baseUrl+Apiservice.cancel_termination_req);
    print("url $url");
    final response = await http.post(url,headers: headers,body: body);

print("response_code ${response.statusCode}");
    if (response.statusCode == 200) {
      // Handle successful response
      print('cancel_termination_data: ${response.body}');
      final res=json.decode(response.body);
      print("cancel_termination_res $res");
      if(res['status']==200){
         Fluttertoast.showToast(
            msg: "Termination request cancelled succesfully.",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 2,
                                  backgroundColor: Colors.red,
                                 textColor: Colors.white,
                                 fontSize: 18.0,
                                 );

       // showCustomSatusDialog(context,"Termination request cancelled succesfully.");
      }
      
      else{
         Fluttertoast.showToast(
            msg: res['message'],
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 2,
                                  backgroundColor: Colors.red,
                                 textColor: Colors.yellow,
                                 fontSize: 18.0,
                                 );

       // showCustomSatusDialog(context, res['message']);
      }

       
    }
    
    else {
      // Handle error response
      final res=json.decode(response.body);
    //  showCustomSatusDialog(context,res['message']);
    
       Fluttertoast.showToast(
            msg: res['message'],
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 2,
                                  backgroundColor: Colors.red,
                                 textColor: Colors.white,
                                 fontSize: 18.0,
                                 );

      print('Failed to load data');
    }
  }
 
 

 void showCustomSatusDialog(BuildContext context, String s) {
  final dialogContext=context;
     showDialog(
      context: dialogContext,
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