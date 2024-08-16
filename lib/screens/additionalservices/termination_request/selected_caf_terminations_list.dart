import 'dart:convert';

import 'package:apsfllmo/model/box_exchange_model.dart';
import 'package:apsfllmo/model/submit_termination_model.dart';
import 'package:apsfllmo/screens/homescreen/home_screen.dart';
import 'package:apsfllmo/utils/apiservice.dart';
import 'package:apsfllmo/utils/constants.dart';
import 'package:apsfllmo/utils/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class SelectedCafTerminationsList extends StatefulWidget{
  final List<BoxExchangeModel> selected_list;
  final String cmt_text;
  const SelectedCafTerminationsList(
    this.selected_list,
    this.cmt_text, 
    {super.key});

  @override
  State<SelectedCafTerminationsList> createState() =>
      _SelectedCafTerminationsListState();
}

class _SelectedCafTerminationsListState extends State<SelectedCafTerminationsList>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
   // throw UnimplementedError();

List<SubmitTerminationModel> submit_payloadss=[];
SubmitTerminationModel? submitTerminationModel;

   Future<void> termination_submit_api() async {
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
         print(" selected_list ${widget.selected_list.toString()}");
         print("selected_list ${widget.selected_list}");

         print("length.......${widget.selected_list.length}");
         Map<String, dynamic> jsonObject = {};
         List<Map<String, dynamic>> jsonList = [];

         for(int i=0;i<widget.selected_list.length;i++){
          print("length..${widget.selected_list.length}");
          print("act_dt${widget.selected_list[i].actvnDt}");

  

             jsonObject['actvnDt']=widget.selected_list[i].actvnDt;
             jsonObject['adhr_nu']=widget.selected_list[i].adhr_nu;
             jsonObject['caf_id']=widget.selected_list[i].caf_id;
             jsonObject['caf_nu']=widget.selected_list[i].caf_nu;
             jsonObject['frqncy_id']=widget.selected_list[i].frqncy_id;
             jsonObject['frqncy_nm']=widget.selected_list[i].frqncy_nm;
             jsonObject['frst_nm']=widget.selected_list[i].frst_nm;
             jsonObject['iptv_srl_nu']=widget.selected_list[i].iptv_srl_nu;
             jsonObject['isChecked']=true;
             jsonObject['loc_std_cd']=widget.selected_list[i].loc_std_cd;
             jsonObject['lst_nm']=widget.selected_list[i].lst_nm;
             jsonObject['mbl_nu']=widget.selected_list[i].mbl_nu;
             jsonObject['mdlwe_sbscr_id']=widget.selected_list[i].mdlwe_sbscr_id;
             jsonObject['onu_srl_nu']=widget.selected_list[i].onu_srl_nu;
             jsonObject['phne_nu']=widget.selected_list[i].phne_nu;
             jsonObject['sno']=widget.selected_list[i].sno;
             jsonObject['srno']=1;
             jsonObject['sts_clr_cd_tx']=widget.selected_list[i].sts_clr_cd_tx;
             jsonObject['sts_nm']=widget.selected_list[i].sts_nm;
             jsonObject['termn_req_sts']=null;
             jsonObject['trmnd']="trmnd_rqst_in";
             jsonObject['trmnd_desc_tx']=widget.cmt_text;

            

             jsonList.add(jsonObject);

         }

          print("jsonList $jsonList");
    
         final body = jsonEncode({
          'data':jsonList,
         });

         print('body $body');
        
          var url = Uri.parse(Constants.baseUrl + Apiservice.termination_submit_api);
          print("termination_submit_url $url");
          final response = await http.post(url,headers: headers,body: body);
           print("response_statuscode ${response.statusCode}");
             if (response.statusCode == 200) {
              final data = json.decode(response.body); 
              print("termination_submit_res_res $data");

              if(data['status']==200){
                 showCustomSatusDialog(context, "Successfully Done");
                List<dynamic> data_array=data['data'];    
                 print("slot_validation_data..$data_array"); 
               
              }
              else{
                showCustomSatusDialog(context, data['message']);
              }
                 

             
           }
           else {
               print("faileddd");
               final data=json.decode(response.body);
               showCustomSatusDialog(context, data['message']);
              throw Exception('Failed to load posts');
           }
      } 
 

   return Scaffold(
        appBar: AppBar(
        title: const Text(
          'Add CAF Termination',
          style: TextStyle(color: Colors.black, fontFamily: 'Cera-Bold'),
        ),
        backgroundColor: Pallete.backgroundColor,
        automaticallyImplyLeading: false,
        
      ),

   
       body: ListView.builder(
        itemCount: widget.selected_list.length,
        itemBuilder: (context, index) {
          final renewModel = widget.selected_list[index];
         // return BoxExchangeCard(boxExchangeModel: widget.selected_list[index]);
          return   Container(
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
                              "${widget.selected_list[index].cstmr_nm}"
                            ),

                             Column(
                              children: [
                                 Text(
                              "${widget.selected_list[index].caf_id}"
                               ),

                                Visibility(
                            visible: (widget.selected_list[index].caf_type_id==1)?false:true,
                            child: Text(
                            (widget.selected_list[index].caf_type_id==1)?"(Individual)":"(Enterprise)",
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
                            Text(
                              "${widget.selected_list[index].mbl_nu}",
                             
                            ),

                             Text(
                              "${widget.selected_list[index].sts_nm}",
                              style: TextStyle(
                               color: 
                               ('${widget.selected_list[index].sts_nm}'=="Active")?Pallete.green :('${widget.selected_list[index].sts_nm}'=="Suspended")?Colors.deepOrange : ('${widget.selected_list[index].sts_nm}'=="Terminated")?Colors.red:('${widget.selected_list[index].sts_nm}'=="PON Change Initiated")? Colors.blue:('${widget.selected_list[index].sts_nm}'=="BOX Change Initiated")?Colors.blue:Colors.black,
                              ),
                            
                            ),
                          ],
                    ),

                     Container(
                        height: 1,
                        color: Colors.grey,
                        margin: EdgeInsets.symmetric(vertical: 10),
                       
                      ),


                      // Row(
                      //   children: [
                      //      Container(
                      //           height: 1.0,
                      //           width: 350.0, // Set the desired width for the line
                      //           color: Colors.grey, // Set the desired color for the line
                      //           ),
                      //          SizedBox(width: 10),
                      //   ],
                      // ),
                  
                     Column(
                        children: [
                           Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                         Text("Aadhar",textAlign: TextAlign.start,),
                        Text(":"),
                        Text("${widget.selected_list[index].adhr_nu}",textAlign: TextAlign.end,),
                        ],

                       ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                        Text("CAF Activated On"),
                        Text(":"),
                        Text("${widget.selected_list[index].actvnDt}"),
                         ],
                        ),


                           Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                        Text("ONU Serial No"),
                        Text(":"),
                        Text("${widget.selected_list[index].onu_srl_nu}"),
                         ],
                        ),

                      Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("IPTV Serial No"),
                        Text(":"),
                        Text("${widget.selected_list[index].iptv_srl_nu}"),
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
    

        bottomSheet: 
     Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
         TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('PREVIOUS'),
                    ),


           SizedBox(
                    height: 40,
                    width: 180,
                    child:  ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:Pallete.buttonColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5),bottomRight: Radius.circular(5) )
                              ),
                            ),
                            onPressed: () { 
                             termination_submit_api();

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




   );

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
                  child:Text("Termination Status",textAlign: TextAlign.start,
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

                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> HomeScreen()));
                         
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