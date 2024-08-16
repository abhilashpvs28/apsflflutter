import 'package:apsfllmo/model/renew_model.dart';
import 'package:apsfllmo/utils/pallete.dart';
import 'package:flutter/material.dart';

class AddCafTerminationCard extends StatelessWidget{
  final RenewModel renewModel;
  AddCafTerminationCard({
    required this.renewModel,
    super.key
  });

  List<RenewModel> selected_list=[];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
   // throw UnimplementedError();
  
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
       margin:EdgeInsets.only(left: 10,top: 5,right: 10,bottom: 10) ,
      // height: 400,
      // width: 400,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [
           Card(
             elevation: 25,
             shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,

                children: [
                  

                   Container(
                    width: 40,
                    child: Checkbox(
                      value: selected_list.contains(renewModel),
                      onChanged: (value) {
                     // _onCheckboxChanged(value, renewModel);
                       
                        if(value==true){
                          selected_list.add(renewModel);
                        }else{
                          selected_list.remove(renewModel);
                        }
                        
                        print("selected_list $selected_list");

                    },
                       
                       ),

                   ),




                Container(
                  width: 330,
                padding: EdgeInsets.all(10),
                child:
                
                 Column(
                 

                  children: [

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     
                        children: [

                          
                            Text(
                              "${renewModel.cstmr_nm}",
                              textAlign: TextAlign.left,
                            ),

                             Column(
                              children: [
                                 Text(
                              "${renewModel.caf_id}",
                              textAlign: TextAlign.right,
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
                               ('${renewModel.sts_nm}'=="Active")?Pallete.green :('${renewModel.sts_nm}'=="Suspended")?Colors.deepOrange : ('${renewModel.sts_nm}'=="Terminated")?Colors.red:('${renewModel.sts_nm}'=="PON Change Initiated")? Colors.blue:('${renewModel.sts_nm}'=="BOX Change Initiated")?Colors.blue:Colors.black,
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
                                width: 280.0, // Set the desired width for the line
                                color: Colors.grey, // Set the desired color for the line
                                ),
                              
                        ],
                      ),
                  
                     Column(
                        children: [
                           Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                         Text("Aadhar",textAlign: TextAlign.start,),
                        Text(":"),
                        Text("${renewModel.adhr_nu}",textAlign: TextAlign.end,),
                        ],

                       ),

                           Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                        Text("ONU Serial No"),
                        Text(":"),
                        Text("${renewModel.onu_srl_nu}"),
                         ],
                        ),

                      Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("IPTV Serial No"),
                        Text(":"),
                        Text("${renewModel.iptv_srl_nu}"),
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
        ],
      ),
   
    );



  }
  
  void _onCheckboxChanged(bool? value, RenewModel renewModel) {
     if(value==true){

     }
  }




}