import 'package:apsfllmo/model/box_exchange_model.dart';
import 'package:apsfllmo/utils/pallete.dart';
import 'package:flutter/material.dart';

class BoxExchangeCard extends StatelessWidget{
   final BoxExchangeModel boxExchangeModel;
   const BoxExchangeCard({required this.boxExchangeModel});




  @override
  Widget build(BuildContext context) {
   
    String? caf_type='';
     bool _isVisible=false;
     if(boxExchangeModel.caf_type_id==1){
       caf_type="(Individual)";
       _isVisible=false;
    }else{
      caf_type="(Enterprise)";
      _isVisible=true;
    }

      return
        Container(
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
                              "${boxExchangeModel.cstmr_nm}"
                            ),

                             Column(
                              children: [
                                 Text(
                              "${boxExchangeModel.caf_id}"
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
                              "${boxExchangeModel.mbl_nu}"
                            ),
                              ],
                            ),


                             Text(
                              "${boxExchangeModel.sts_nm}",
                              style: TextStyle(
                               color: 
                               ('${boxExchangeModel.sts_nm}'=="Active")?Pallete.green :('${boxExchangeModel.sts_nm}'=="Suspended")?Colors.deepOrange : ('${boxExchangeModel.sts_nm}'=="Terminated")?Colors.red:('${boxExchangeModel.sts_nm}'=="PON Change Initiated")? Colors.blue:('${boxExchangeModel.sts_nm}'=="BOX Change Initiated")?Colors.blue:Colors.black,
                              ),
                            
                            ),
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
                                width: 320.0, // Set the desired width for the line
                                color: Colors.grey, // Set the desired color for the line
                                ),
                               SizedBox(width: 10),

                               Icon(Icons.arrow_drop_down,color: Colors.grey,),
                        ],
                      ),
                  
                     Column(
                        children: [
                           Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            Container(
                              width: MediaQuery.of(context).size.width*0.3,
                              child:Text("Aadhar",textAlign: TextAlign.start,),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width*0.01,
                              child: Text(":"),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width*0.35,
                              child:  Text("${boxExchangeModel.adhr_nu}",textAlign: TextAlign.start,),
                            ),
                         
                        
                       
                        ],

                       ),

                           Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [

                          Container(
                              width: MediaQuery.of(context).size.width*0.3,
                              child:Text("ONU Serial No"),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width*0.01,
                              child: Text(":"),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width*0.35,
                              child:  Text("${boxExchangeModel.onu_srl_nu}"),
                            ),
                        // Text("ONU Serial No"),
                        // Text(":"),
                        // Text("${boxExchangeModel.onu_srl_nu}"),
                        
                         ],
                        ),

                      Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        Container(
                              width: MediaQuery.of(context).size.width*0.3,
                              child:Text("IPTV Serial No"),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width*0.01,
                              child: Text(":"),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width*0.35,
                              child: Text("${boxExchangeModel.iptv_srl_nu}"),
                            ),

                        // Text("IPTV Serial No"),
                        // Text(":"),
                        // Text("${boxExchangeModel.iptv_srl_nu}"),

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

 
}