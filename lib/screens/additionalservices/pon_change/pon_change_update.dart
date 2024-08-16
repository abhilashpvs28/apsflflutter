import 'dart:convert';
import 'dart:core';

import 'package:apsfllmo/model/box_exchange_model.dart';
import 'package:apsfllmo/model/district_list_model.dart';
import 'package:apsfllmo/model/olt_details_model.dart';
import 'package:apsfllmo/model/slot_details_model.dart';
import 'package:apsfllmo/model/slot_validation_model.dart';
import 'package:apsfllmo/screens/additionalservices/pon_change/pon_change.dart';
import 'package:apsfllmo/screens/homescreen/home_screen.dart';
import 'package:apsfllmo/utils/apiservice.dart';
import 'package:apsfllmo/utils/constants.dart';
import 'package:apsfllmo/utils/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class PonChangeUpdate extends StatefulWidget{
  final BoxExchangeModel boxExchangeModel;
    PonChangeUpdate({super.key, 
    required this.boxExchangeModel, 
    });
    @override
  State<PonChangeUpdate> createState() => _PonChangeUpdateState();

}

class _PonChangeUpdateState extends State<PonChangeUpdate>{

TextEditingController billing_addr1_controller = TextEditingController();
TextEditingController billing_addr2_controller = TextEditingController();
TextEditingController locality_controller = TextEditingController();
TextEditingController area_controller = TextEditingController();

TextEditingController installation_addr1_controller = TextEditingController();
TextEditingController installation_addr2_controller = TextEditingController();
TextEditingController locality_caf_controller = TextEditingController();
TextEditingController area_caf_controller = TextEditingController();


TextEditingController district_controller = TextEditingController();
TextEditingController mandal_controleer = TextEditingController();
TextEditingController village_controller = TextEditingController();

TextEditingController reason_for_chng_controller = TextEditingController();




 bool _isLoading =false;
List<dynamic> lineItemsJson =[];
 late Future<List<DistrictListModel>> futurePosts;
// late Future<List<OltDetailsModel>> olt_futurePosts;
List<OltDetailsModel> olt_futurePosts=[];
List<OltDetailsModel> olt_port_list=[];
List<OltDetailsModel> olt_slots_list=[];
List<SlotDetailsModel> olt_slots_two_list=[];
List<SlotDetailsModel> olt_slots_three_list=[];
List<DistrictListModel> district_list=[];
List<DistrictListModel> mndl_list=[];
List<DistrictListModel> village_list=[];
List<SlotValidationModel> slot_validation_list=[];
List<SlotValidationModel> splits_data_list=[];

  final List<String> reasons_list = ['PRODUCT CHANGE','DEFECTIVE DEVICE'];
  String? selectedreason;

  List<String> district_names=[];
  
 
 List<BoxExchangeModel> pon_chnage_refresh_list=[];

  List<dynamic> olt_details_list=[];
  List<String> olt_names=[];
  OltDetailsModel? Selected_olt;
  OltDetailsModel? selected_olt_port;
  String? selected_olt_id;
  String? selected_olt_port_id;

  DistrictListModel? selected_district_nm;
  String? selected_district_id='';

  DistrictListModel? selected_mndl_nm;
  String? selected_mndl_id='';
  String? selected_mndl_num='';

  DistrictListModel? selected_vlg_nm;
  String? selected_vlg_id=''; 
  String? selected_vlg_num='';

  OltDetailsModel? selected_slot1;
  String? selected_slot_id;
  String? selected_slt1_id='';
  String? selected_slt2_id='';
  String? selected_slt3_id='';
  


  SlotValidationModel? selected_slot2;
  String? selected_slot2_id;
  String? selected_slot2_nm;
 
 SlotValidationModel? selected_slot3;
  String? selected_slot3_id;
  String? selected_slot3_nm;

  String? ip_address;
  String? caf_typee;
  String? onu_id;
  int? aghara_cd_nw;
 
  bool _isButtonEnabled = false;
   bool _layout_visible=false;
  bool _text_visible=false;
   String? statusText='';

 
 
   @override
  void initState() {
    super.initState();
    selectedreason = reasons_list.first;
    billing_addr1_controller.text=widget.boxExchangeModel.loc_addr1_tx;
    billing_addr2_controller.text=widget.boxExchangeModel.loc_addr2_tx;
    locality_controller.text=widget.boxExchangeModel.loc_lcly_tx;
    area_controller.text=widget.boxExchangeModel.loc_ara_tx;
    installation_addr1_controller.text=widget.boxExchangeModel.instl_addr1_tx;
    installation_addr2_controller.text=widget.boxExchangeModel.instl_addr2_tx;
    locality_caf_controller.text=widget.boxExchangeModel.instl_lcly_tx;
    area_caf_controller.text=widget.boxExchangeModel.instl_ara_tx;
   
    district_controller.text!=widget.boxExchangeModel.dstrt_nm;
    mandal_controleer.text!=widget.boxExchangeModel.mndl_nm;
    village_controller.text!=widget.boxExchangeModel.vlge_nm;

    ip_address=getIpAddress(widget.boxExchangeModel.aghra_cd.toString());
   
  

    if(widget.boxExchangeModel.caf_type_id==1){
      caf_typee='Individual';
    }else{
      caf_typee="Enterprise";
    }

     if(widget.boxExchangeModel.enty_sts_id==10 || widget.boxExchangeModel.enty_sts_id==11){
      _layout_visible=false;
      _text_visible=true;
     }else{
      _layout_visible=true;
      _text_visible=false;
     }

     if (widget.boxExchangeModel.enty_sts_id == 10) {
      statusText = 'Box Change is already initiated, wait till it \n succeed.  Please click refresh to check the status';
;    } 
    if(widget.boxExchangeModel.enty_sts_id == 11) {
      statusText ="PON Change is already initiated, wait till it \n succeed.  Please click refresh to check the status";
      }
    

   
    setState(() {
      district_list_api();
      olt_details_api();
     // selected_district_nm=district_names.first;
    
    });
  }


  String getIpAddress(String aghraCd) {
  List<String> parts = aghraCd.split('-');
  return parts[0];
}



  void _checkButtonState() {
    setState(() {
      _isButtonEnabled =
         selected_olt_id.toString().isNotEmpty && selected_olt_port_id.toString().isNotEmpty && selected_slot_id.toString().isNotEmpty && selected_slt1_id.toString().isNotEmpty && selected_slt2_id.toString().isNotEmpty && selected_slt2_id.toString().isNotEmpty;
   
    });
  }

     Future<void> vlg_list_api_call() async {
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


               print('Request headers: $headers');

        
          var url = Uri.parse(Constants.baseUrl + Apiservice.agent_vlg_list+selected_mndl_num.toString()+"/"+selected_district_id.toString());
          print("url $url");
          final response = await http.get(url,headers: headers);

            if (response.statusCode == 200) {
              final data = json.decode(response.body);
              print('village_list_res $data');
              
              lineItemsJson = data['data'];
              List<dynamic> data_array=data['data'];  
              print('lineItemsJson $lineItemsJson');

          
              setState(() {
                for(int i=0;i<lineItemsJson.length;i++){
                village_list=data_array.map((json) => DistrictListModel.fromJson(json)).toList();
                print("village_list $village_list");

                selected_vlg_nm=village_list.first;

                 selected_vlg_num=village_list[0].vlge_nu.toString();
                selected_vlg_id=village_list[0].vlge_id.toString();
                
              }
              });

             

              // print(lineItemsJson.map((json) => DistrictListModel.fromJson(json)).toList());
              // return lineItemsJson.map((json) => DistrictListModel.fromJson(json)).toList();
          
    
           } else {
               print("faileddd");
              throw Exception('Failed to load posts');
           }
      } 
 
  
    Future<void> mndl_list_api_call() async {
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


               print('Request headers: $headers');

        
          var url = Uri.parse(Constants.baseUrl + Apiservice.agent_mndl_list+selected_district_id.toString());
          print("url $url");
          final response = await http.get(url,headers: headers);

            if (response.statusCode == 200) {
              final data = json.decode(response.body);
              print('mandal_list_res $data');
              
              lineItemsJson = data['data'];
              List<dynamic> data_array=data['data'];  
              print('lineItemsJson $lineItemsJson');

          
              setState(() {
                for(int i=0;i<lineItemsJson.length;i++){
                mndl_list=data_array.map((json) => DistrictListModel.fromJson(json)).toList();
                print("mndl_list $mndl_list");
                selected_mndl_nm=mndl_list.first;
                selected_mndl_num=mndl_list[0].mndl_nu.toString();
                selected_mndl_id=mndl_list[0].mndl_id.toString();
                
                vlg_list_api_call();
              }
              });

             

              // print(lineItemsJson.map((json) => DistrictListModel.fromJson(json)).toList());
              // return lineItemsJson.map((json) => DistrictListModel.fromJson(json)).toList();
          
    
           } else {
               print("faileddd");
              throw Exception('Failed to load posts');
           }
      } 
 
   Future<void> district_list_api() async {
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
        
          var url = Uri.parse(Constants.baseUrl + Apiservice.agent_district_list);
          print("url $url");
          final response = await http.get(url,headers: headers);

          if (response.statusCode == 200) {
              final data = json.decode(response.body);
              print('response_dataa_ponchange $data');
              
              lineItemsJson = data['data'];
              List<dynamic> data_array=data['data'];  
              print('lineItemsJson $lineItemsJson');
              print("data_array $data_array");

          

              setState(() {
                  district_list=data_array.map((json) => DistrictListModel.fromJson(json)).toList();
                print("district_list $district_list");
                selected_district_nm=district_list.first;

                selected_district_id=district_list[0].dstrt_id.toString();

                mndl_list_api_call();
              });

             // print('district names $district_names');

              // print(lineItemsJson.map((json) => DistrictListModel.fromJson(json)).toList());
              // return lineItemsJson.map((json) => DistrictListModel.fromJson(json)).toList();
          
    
           } else {
               print("faileddd");
              throw Exception('Failed to load posts');
           }
      } 
 
    
    Future<void> olt_details_api() async {
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
        
          var url = Uri.parse(Constants.baseUrl + Apiservice.oltdetails+agent_id.toString()!+"/"+widget.boxExchangeModel.caf_id.toString());
          print("olt_details_url $url");
          final response = await http.get(url,headers: headers);

             if (response.statusCode == 200) {
              final data = json.decode(response.body);
              print('olt_details_response $data');
              
              olt_details_list = data['data'];
              print('olt_details_list $olt_details_list');



              setState(() {
                 olt_futurePosts=olt_details_list.map((json) => OltDetailsModel.fromJson(json)).toList();
                 print("olt_futurePosts $olt_futurePosts");
                 selected_olt_id=olt_futurePosts[0].olt_id;
              
                //  for(int i=0;i<olt_details_list.length;i++){
                //     olt_names.add(olt_details_list[i]['olt_nm']);
                //  }
              });
            
              print('olt_names $olt_names');
              // print(olt_details_list.map((json) => OltDetailsModel.fromJson(json)).toList());
              // return olt_details_list.map((json) => OltDetailsModel.fromJson(json)).toList();
           }
           else {
               print("faileddd");
              throw Exception('Failed to load posts');
           }
      } 
 
    Future<void> slots_details_api_call() async {
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
        
          var url = Uri.parse(Constants.baseUrl + Apiservice.olt_slots_details+selected_olt_id.toString());
          print("olt_slots_url $url");
          final response = await http.get(url,headers: headers);

             if (response.statusCode == 200) {
              final data = json.decode(response.body); 
              List<dynamic> data_array=data['data'];    
              print("olt port data..$data");       

              setState(() {
                olt_slots_list=data_array.map((json) => OltDetailsModel.fromJson(json)).toList();
                print("olt_slots_list $olt_slots_list");            

              });
              
            
              // print(olt_details_list.map((json) => OltDetailsModel.fromJson(json)).toList());
              // return olt_details_list.map((json) => OltDetailsModel.fromJson(json)).toList();
           }
           else {
               print("faileddd");
              throw Exception('Failed to load posts');
           }
      } 
 
     Future<void> slots_details_for_port_api_call() async {
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
        
          var url = Uri.parse(Constants.baseUrl + Apiservice.olt_slot_details_for_port+"/"+selected_olt_port_id.toString());
          print("olt_slots_url $url");
          final response = await http.get(url,headers: headers);

             if (response.statusCode == 200) {
              final data = json.decode(response.body); 
              List<dynamic> data_array=data['data'];    
              print("olt slots data..$data");       

              setState(() {
                olt_port_list=data_array.map((json) => OltDetailsModel.fromJson(json)).toList();
                print("olt_port_list $olt_port_list");


              });
              
            
              // print(olt_details_list.map((json) => OltDetailsModel.fromJson(json)).toList());
              // return olt_details_list.map((json) => OltDetailsModel.fromJson(json)).toList();
           }
           else {
               print("faileddd");
              throw Exception('Failed to load posts');
           }
      } 
 

    
     Future<void> validation_slots_data_api_call() async {
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

         final body = jsonEncode({
          'data':{           
            //'olt_prt_id': selected_olt_port_id,
            'spltsData':[
              {
                'olt_prt_id': int.parse(selected_olt_port_id!),
                'olt_slt_id': int.parse(selected_slot_id!),
                'slt1_id': int.parse(selected_slt1_id!),
                'slt2_id': int.parse(selected_slt2_id!),
                'slt3_id': int.parse(selected_slt3_id!),
              }
            ]
          }

         });

         print('body $body');
        
          var url = Uri.parse(Constants.baseUrl + Apiservice.validation_split_data);
          print("validation_split_url $url");
          final response = await http.post(url,headers: headers,body: body);
           // print("split_validation_res11 ${json.decode(response.body)}");
           print("response_statuscode ${response.statusCode}");
             if (response.statusCode == 200) {
              final data = json.decode(response.body); 
              print("split_validation_res $data");
              List<dynamic> data_array=data['data'];    
              print("slot_validation_data..$data_array");       

              setState(() {
                 slot_validation_list=data_array.map((json) => SlotValidationModel.fromJson(json)).toSet().toList();
                 print("slot_validation_list $slot_validation_list");
              });
              
            
              // print(olt_details_list.map((json) => OltDetailsModel.fromJson(json)).toList());
              // return olt_details_list.map((json) => OltDetailsModel.fromJson(json)).toList();
           }
           else {
               print("faileddd");
              throw Exception('Failed to load posts');
           }
      } 
 
     
     Future<void> splits_data_api_call() async {
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

         final body = jsonEncode({
          'data':{           
           
                'olt_slt_id': int.parse(selected_slot_id!),
                'splt1_nu': int.parse(selected_slt1_id!),
                'splt2_nu': int.parse(selected_slot2_nm!),
                'splt3_nu': int.parse(selected_slot3_nm!),
              }
         });

         print('body $body');
        
          var url = Uri.parse(Constants.baseUrl + Apiservice.split_data);
          print("split_url $url");
          final response = await http.post(url,headers: headers,body: body);
           // print("split_validation_res11 ${json.decode(response.body)}");
           print("response_statuscode ${response.statusCode}");
             if (response.statusCode == 200) {
              final data = json.decode(response.body); 
              print("split_res $data");
              List<dynamic> data_array=data['data'];    
              print("slot_data..$data_array");       

              setState(() {
                 splits_data_list=data_array.map((json) => SlotValidationModel.fromJson(json)).toSet().toList();
                 print("splits_data_list $splits_data_list");
                 onu_id=splits_data_list[0].onu_id.toString();
                 print("onu_id $onu_id");
              });
              
            
              // print(olt_details_list.map((json) => OltDetailsModel.fromJson(json)).toList());
              // return olt_details_list.map((json) => OltDetailsModel.fromJson(json)).toList();
           }
           else {
               print("faileddd");
              throw Exception('Failed to load posts');
           }
      } 
 




      Future<void> slots_two_details_for_port_api_call(String selected_slot) async {
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

          final body = jsonEncode({
          'data':[{
            'level1': selected_slot,
            'olt_prt_id': selected_olt_port_id,
          }]

        });

        print("body...$body");
        
          var url = Uri.parse(Constants.baseUrl + Apiservice.olt_slot_two_details_for_port);
          print("olt_slots_two_url $url");
          final response = await http.post(url,headers: headers,body: body);

            
             if (response.statusCode == 200) {
              final data = json.decode(response.body); 
              List<dynamic> data_array=data['data'];    
              print("olt slots data..$data");       

              setState(() {
                olt_slots_two_list=data_array.map((json) => SlotDetailsModel.fromJson(json)).toList();
                print("olt_slots_two_list $olt_slots_two_list");
              });
              
            
              // print(olt_details_list.map((json) => OltDetailsModel.fromJson(json)).toList());
              // return olt_details_list.map((json) => OltDetailsModel.fromJson(json)).toList();
           }
           else {
               print("faileddd");
              throw Exception('Failed to load posts');
           }
      } 
 
      Future<void> slots_three_details_for_port_api_call( String olt_port_id) async {
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

            final body = jsonEncode({
          'data':[{
            'level1': selected_slot1,
            'level2':selected_slot2,
            'olt_prt_id': olt_port_id,
          }
          ]

        });

        print("body...$body");
        
          var url = Uri.parse(Constants.baseUrl + Apiservice.olt_slot_three_details_for_port);
          print("olt_slots_two_url $url");
          final response = await http.post(url,headers: headers,body: body);

             if (response.statusCode == 200) {
              final data = json.decode(response.body); 
              List<dynamic> data_array=data['data'];    
             
              print("olt slots data..$data");       

              setState(() {
                olt_slots_three_list=data_array.map((json) => SlotDetailsModel.fromJson(json)).toList();
                print("olt_slots_three_list $olt_slots_three_list");
              });
              
            
              // print(olt_details_list.map((json) => OltDetailsModel.fromJson(json)).toList());
              // return olt_details_list.map((json) => OltDetailsModel.fromJson(json)).toList();
           }
           else {
               print("faileddd");
              throw Exception('Failed to load posts');
           }
      } 
 
 

      Future<void> pon_chng_sbmt_api_call() async {
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


         print("new_lag ${ "lag:${olt_slots_list[0].olt_acs_nde_id}:${Selected_olt?.crd_id.toString()}:${selected_olt_port?.olt_prt_nm}:${splits_data_list[0].onu_id!.toString()}"}");
         print("aghra_cd_nw ${"${Selected_olt?.olt_ip_addr_tx}-${Selected_olt?.crd_id.toString()}-${aghara_cd_nw}-${splits_data_list[0].onu_id!} "}");
         print("stpbx_id ${widget.boxExchangeModel.stpbx_id}");
         if(widget.boxExchangeModel.stpbx_id==null){
          showCustomSatusDialog(context,"Setup box is empty");
         }

         print(" tps ${ widget.boxExchangeModel?.mdl_dtls_tx}");

            final body = jsonEncode({
          'data':{
            'acId':widget.boxExchangeModel.onu_mac_addr_tx.toString(),
            'acessid':widget.boxExchangeModel.onu_mac_addr_tx.toString(),
            'address_one': billing_addr1_controller.text,
            'address_two': billing_addr2_controller.text,
            'aghra_cd': widget.boxExchangeModel.aghra_cd.toString(),
            'aghra_cd_hsi':widget.boxExchangeModel.aghra_cd.toString() ,
            'aghra_cd_iptv' : widget.boxExchangeModel.aghra_cd.toString().replaceRange(21, null, "-IPTV"),

          
            'aghra_cd_nw' : "${Selected_olt?.olt_ip_addr_tx}-${Selected_olt?.crd_id.toString()}-${aghara_cd_nw}-${splits_data_list[0].onu_id!}",
            'ara' : area_controller.text,
            'caf_address_one': installation_addr1_controller.text,
            'caf_address_two': installation_addr2_controller.text,
            'caf_area': area_caf_controller.text,
            'caf_id': widget.boxExchangeModel.caf_id,
            'caf_locality': area_caf_controller.text,
            'chng_rsn_txt': reason_for_chng_controller.text ,
            'customer_id': widget.boxExchangeModel.cstmr_id,
            'district_id': selected_district_id,
            'localty':locality_controller.text ,
            'mandal_id': selected_mndl_id,
            'mdle_cd': widget.boxExchangeModel.mdlwe_sbscr_id,
            'new_lag_id': "lag:${olt_slots_list[0].olt_acs_nde_id}:${Selected_olt?.crd_id.toString()}:${selected_olt_port?.olt_prt_nm}:$onu_id",//wrong
            'old_lag_id': widget.boxExchangeModel.aaa_cd,
            'old_split_id': widget.boxExchangeModel.olt_prt_splt_tx,
            'olt_crd_nu': '${Selected_olt?.crd_id.toString()}',
            'olt_id': Selected_olt?.olt_id,
            'olt_ip_addr_tx': Selected_olt?.olt_ip_addr_tx ,
            'olt_onu_id': onu_id,//wrong
            'olt_prt_id': '${olt_slots_list[0].olt_prt_id}',
            'olt_prt_nm': '${olt_slots_list[0].olt_prt_nm}',
            'olt_prt_splt_tx': Selected_olt?.olt_ip_addr_tx,
            'olt_srl_nu': Selected_olt?.olt_srl_nu,
            'pckge_id':widget.boxExchangeModel?.crnt_pln_id ,
            'replacename': widget.boxExchangeModel.cstmr_nm.toString().replaceAll(" ", "") ,
            'serialNumber': widget.boxExchangeModel.onu_srl_nu,
            'splt_id': widget.boxExchangeModel.splt_id ,
            'stpbx_id': widget.boxExchangeModel.stpbx_id,
            'subscr_code': widget.boxExchangeModel.mdlwe_sbscr_id ,
            'tps':[
              widget.boxExchangeModel?.mdl_dtls_tx,
            ],
            'village_id': selected_vlg_id,
          }
          

        });

        print("body...$body");
        
          var url = Uri.parse(Constants.baseUrl + Apiservice.pon_chng_submit);
          print("olt_slots_two_url $url");
          final response = await http.post(url,headers: headers,body: body);
            print("pon_submit_res $response");
             print("pon_chng_status_cd ${response.statusCode}");
             if (response.statusCode == 200) {


              final data = json.decode(response.body); 
              print("pon_submit_res $data");
              if(data['status']==200){
                showCustomSatusDialog(context,'PON Changed Successfully....');
            

              }
              else if(data['status']==700){
                print("${data['message']}");
                showCustomSatusDialog(context,'${data['message']}');
              }

           }
           else {
               print("faileddd");
              throw Exception('Failed to load posts');
           }
      } 
 

     
  Future<void> olt_pon_refresh_api() async {
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

    print('pon_refresh_api_headers $headers');
   
  
    final url = Uri.parse(Constants.baseUrl+Apiservice.pon_chng_refresh+widget.boxExchangeModel.caf_id.toString());
    print("url $url");
    final response = await http.get(url,headers: headers);
     _isLoading=true;
    print("response_code ${response.statusCode}");
    if (response.statusCode == 200) {
      // Handle successful response
      _isLoading=false;
      print('box_chng_refresh data: ${response.body}');
      final res=json.decode(response.body);

      List<dynamic> data_array=res['data'];
      
      if(res['status']==200){
         pon_chnage_refresh_list=data_array.map((json) => BoxExchangeModel.fromJson(json)).toList();
           
      }
      else{
         print("failedd..");
         showCustomSatusDialog(context, res['message']);
      }
       
    }
    
    else {
      // Handle error response
      _isLoading=false;
      final res=json.decode(response.body);
        print("faileddd");
         showCustomSatusDialog(context, res['message']);
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
          'Pon Change ',
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

        body:    SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(10),
          
          child: Column(
            children: [
             Card(
              elevation: 25,
              color: Colors.white,
              child: Column(
                children: [
                   Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [

                         _buildInfoRow("Name", widget.boxExchangeModel.frst_nm+widget.boxExchangeModel.lst_nm,Pallete.lightgrey),
                          _buildInfoRow("CAF No", widget.boxExchangeModel.caf_nu.toString(),Colors.white),
                          _buildInfoRow("Connection Type", caf_typee!,Pallete.lightgrey),
                          _buildInfoRow("Mobile No", widget.boxExchangeModel.mbl_nu.toString(),Colors.white),
                          _buildInfoRow("Aadhaar No", widget.boxExchangeModel.adhr_nu.toString(),Pallete.lightgrey),
                          _buildInfoRow("Locality", widget.boxExchangeModel.instl_lcly_tx.toString(),Colors.white),
                          _buildInfoRow("OLT Name", widget.boxExchangeModel.onu_srl_nu.toString(),Pallete.lightgrey),
                          _buildInfoRow("OLT Serial No", widget.boxExchangeModel.onu_srl_nu.toString(),Colors.white),
                          _buildInfoRow("OLT IP Address", widget.boxExchangeModel.olt_ip_addr_tx!,Pallete.lightgrey),
                          _buildInfoRow("OLT Port Splits", ""+widget.boxExchangeModel.olt_prt_splt_tx,Colors.white),
                          _buildInfoRow("Device", widget.boxExchangeModel.aghra_cd.toString()!,Pallete.lightgrey),


                  ],
                
                ),


              ),
            
                ],
              )
             
             ),
             
               const SizedBox(
                height: 10,),

             Column(
              children: [
                Visibility(
                  visible: _layout_visible,
                  child: 
                Card(
                  elevation: 25,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Column(
                  children: [
                     Container(
                     padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Customer Details",style: TextStyle(color: Colors.blueAccent),),
                        Text("Select District",), 

                        Container(
                  // height: 30,
                 margin: EdgeInsets.only(left: 0,top: 5,right: 0,bottom: 5),
                 padding: EdgeInsets.symmetric(horizontal: 8.0),
                 decoration: BoxDecoration(
                 color: Pallete.lightgrey, // Gray background color
                  //  borderRadius: BorderRadius.circular(8.0),
                 ),
               
                child: DropdownButtonHideUnderline(
                  child:  DropdownButton<DistrictListModel>(
                  value: selected_district_nm,
                  icon: const Icon(Icons.arrow_drop_down), // Right facing icon
                  // iconSize: 16,
                  // elevation: 16,
                  isExpanded: true,
                  onChanged: (DistrictListModel? newValue) {
                    setState(() {
                      selected_district_nm = newValue!;
                       if (newValue != null) {
                       print('Selected DISTRICT ID: ${newValue.dstrt_id}');
                       selected_district_id=newValue.dstrt_id.toString();
                       mndl_list_api_call();
                     }

                    });
                  },
                  items: district_list.map((DistrictListModel value) {
                    return DropdownMenuItem<DistrictListModel>(
                      value: value,
                      child: Text(value.dstrt_nm),
                    );
                  }).toList(),
                ),
             
                  ),
              
              ),

                          //   Container(
                          // // height: 30,
                          //     margin: EdgeInsets.only(left: 0,top: 5,right: 0,bottom: 5),
                          //    padding: EdgeInsets.symmetric(horizontal: 8.0),
                          //    decoration: BoxDecoration(
                          //   color: Colors.grey[200], // Gray background color
                          // //  borderRadius: BorderRadius.circular(8.0),
                          //  ),
                          //  child: TextField(
                          //   controller: district_controller,
                          // decoration: InputDecoration(
                          // //  hintText: 'Enter text',
                          // border: InputBorder.none,
                          //   ),
                          //   ),
                          //  ),
                    

                           Text("Select Mandal",),
                          //     Container(
                          // // height: 30,
                          //     margin: EdgeInsets.only(left: 0,top: 5,right: 0,bottom: 5),
                          //    padding: EdgeInsets.symmetric(horizontal: 8.0),
                          //    decoration: BoxDecoration(
                          //   color: Colors.grey[200], // Gray background color
                          // //  borderRadius: BorderRadius.circular(8.0),
                          //  ),
                          //  child: TextField(
                          // controller: mandal_controleer,
                          // decoration: InputDecoration(
                          // //  hintText: 'Enter text',
                          // border: InputBorder.none,
                          //   ),
                          //   ),
                          //  ),
                    
                          
                       Container(
                  // height: 30,
                 margin: EdgeInsets.only(left: 0,top: 5,right: 0,bottom: 5),
                 padding: EdgeInsets.symmetric(horizontal: 8.0),
                 decoration: BoxDecoration(
                 color: Pallete.lightgrey, // Gray background color
                  //  borderRadius: BorderRadius.circular(8.0),
                 ),
               
                child: DropdownButtonHideUnderline(
                  child:  DropdownButton<DistrictListModel>(
                  value: selected_mndl_nm,
                  icon: const Icon(Icons.arrow_drop_down), // Right facing icon
                  // iconSize: 16,
                  // elevation: 16,
                  isExpanded: true,
                  onChanged: (DistrictListModel? newValue) {
                    setState(() {
                      selected_mndl_nm = newValue!;
                       if (newValue != null) {
                       print('Selected Mandal NUM: ${newValue.mndl_nu.toString()}');
                       selected_mndl_num=newValue.mndl_nu.toString(); 
                       vlg_list_api_call();                     
                     }
                    });
                  },
                  items: mndl_list.map((DistrictListModel value) {
                    return DropdownMenuItem<DistrictListModel>(
                      value: value,
                      child: Text(value.mndl_nm.toString()),
                    );
                  }).toList(),
                ),
             
                  ),
              
              ),


                            Text("Select Village",),
                          // Container(
                          // // height: 30,
                          //     margin: EdgeInsets.only(left: 0,top: 5,right: 0,bottom: 5),
                          //    padding: EdgeInsets.symmetric(horizontal: 8.0),
                          //    decoration: BoxDecoration(
                          //   color: Colors.grey[200], // Gray background color
                          // //  borderRadius: BorderRadius.circular(8.0),
                          //  ),
                          //  child: TextField(
                          //    controller: village_controller,
                          // decoration: InputDecoration(
                          // //  hintText: 'Enter text',
                          // border: InputBorder.none,
                          //   ),
                          //   ),
                          //  ),
                          
                         Container(
                  // height: 30,
                 margin: EdgeInsets.only(left: 0,top: 5,right: 0,bottom: 5),
                 padding: EdgeInsets.symmetric(horizontal: 8.0),
                 decoration: BoxDecoration(
                 color: Pallete.lightgrey, // Gray background color
                  //  borderRadius: BorderRadius.circular(8.0),
                 ),
               
                child: DropdownButtonHideUnderline(
                  child:  DropdownButton<DistrictListModel>(
                  value: selected_vlg_nm,
                  icon: const Icon(Icons.arrow_drop_down), // Right facing icon
                  // iconSize: 16,
                  // elevation: 16,
                  isExpanded: true,
                  onChanged: (DistrictListModel? newValue) {
                    setState(() {
                      selected_vlg_nm = newValue!;
                       if (newValue != null) {
                       print('Selected VILLAGE ID: ${newValue.vlge_id}');
                       selected_vlg_id=newValue.vlge_id.toString();
                       selected_vlg_num=newValue.vlge_nu.toString();
                        
                     }
                    });
                  },
                  items: village_list.map((DistrictListModel value) {
                    return DropdownMenuItem<DistrictListModel>(
                      value: value,
                      child: Text(value.vlge_nm.toString()),
                    );
                  }).toList(),
                ),
             
                  ),
              
              ),


                                 Text("Billing Address 1",),
                        Container(
                          // height: 30,
                              margin: EdgeInsets.only(left: 0,top: 5,right: 0,bottom: 5),
                             padding: EdgeInsets.symmetric(horizontal: 8.0),
                             decoration: BoxDecoration(
                            color: Colors.grey[200], // Gray background color
                          //  borderRadius: BorderRadius.circular(8.0),
                           ),
                           child: TextField(
                             controller: billing_addr1_controller,
                          decoration: InputDecoration(
                          //  hintText: 'Enter text',
                          border: InputBorder.none,
                            ),
                            ),
                           ),
                    
                                Text("Billing Address 2",),
                        Container(
                          // height: 30,
                              margin: EdgeInsets.only(left: 0,top: 5,right: 0,bottom: 5),
                             padding: EdgeInsets.symmetric(horizontal: 8.0),
                             decoration: BoxDecoration(
                            color: Colors.grey[200], // Gray background color
                          //  borderRadius: BorderRadius.circular(8.0),
                           ),
                           child: TextField(
                            controller: billing_addr2_controller,
                          decoration: InputDecoration(
                          //  hintText: 'Enter text',
                          border: InputBorder.none,
                            ),
                            ),
                           ),
                    
                              Text("Locality",),
                        Container(
                          // height: 30,
                              margin: EdgeInsets.only(left: 0,top: 5,right: 0,bottom: 5),
                             padding: EdgeInsets.symmetric(horizontal: 8.0),
                             decoration: BoxDecoration(
                            color: Colors.grey[200], // Gray background color
                          //  borderRadius: BorderRadius.circular(8.0),
                           ),
                           child: TextField(
                             controller: locality_controller,
                          decoration: InputDecoration(
                          //  hintText: 'Enter text',
                          border: InputBorder.none,
                            ),
                            ),
                           ),
                    
                               Text("Area",),
                        Container(
                          // height: 30,
                              margin: EdgeInsets.only(left: 0,top: 5,right: 0,bottom: 5),
                             padding: EdgeInsets.symmetric(horizontal: 8.0),
                             decoration: BoxDecoration(
                            color: Colors.grey[200], // Gray background color
                          //  borderRadius: BorderRadius.circular(8.0),
                           ),
                           child: TextField(
                             controller: area_controller,
                          decoration: InputDecoration(
                          //  hintText: 'Enter text',
                          border: InputBorder.none,
                            ),
                            ),
                           ),
                    

                         const SizedBox(
                          height: 5,
                         ),
                        
                        Text("CAF Details",style: TextStyle(color: Colors.blueAccent),),

                        
                              Text("Installation Address 1",),
                        Container(
                          // height: 30,
                              margin: EdgeInsets.only(left: 0,top: 5,right: 0,bottom: 5),
                             padding: EdgeInsets.symmetric(horizontal: 8.0),
                             decoration: BoxDecoration(
                            color: Colors.grey[200], // Gray background color
                          //  borderRadius: BorderRadius.circular(8.0),
                           ),
                           child: TextField(
                             controller: installation_addr1_controller,
                          decoration: InputDecoration(
                          //  hintText: 'Enter text',
                          border: InputBorder.none,
                            ),
                            ),
                           ),
                    
                               Text("Installation Address 2",),
                        Container(
                          // height: 30,
                              margin: EdgeInsets.only(left: 0,top: 5,right: 0,bottom: 5),
                             padding: EdgeInsets.symmetric(horizontal: 8.0),
                             decoration: BoxDecoration(
                            color: Colors.grey[200], // Gray background color
                          //  borderRadius: BorderRadius.circular(8.0),
                           ),
                           child: TextField(
                             controller: installation_addr2_controller,
                          decoration: InputDecoration(
                          //  hintText: 'Enter text',
                          border: InputBorder.none,
                            ),
                            ),
                           ),

                              Text("Locality",),
                        Container(
                          // height: 30,
                              margin: EdgeInsets.only(left: 0,top: 5,right: 0,bottom: 5),
                             padding: EdgeInsets.symmetric(horizontal: 8.0),
                             decoration: BoxDecoration(
                            color: Colors.grey[200], // Gray background color
                          //  borderRadius: BorderRadius.circular(8.0),
                           ),
                           child: TextField(
                             controller: locality_caf_controller,
                          decoration: InputDecoration(
                          //  hintText: 'Enter text',
                          border: InputBorder.none,
                            ),
                            ),
                           ),
                      
                              Text("Area",),
                        Container(
                          // height: 30,
                              margin: EdgeInsets.only(left: 0,top: 5,right: 0,bottom: 5),
                             padding: EdgeInsets.symmetric(horizontal: 8.0),
                             decoration: BoxDecoration(
                            color: Colors.grey[200], // Gray background color
                          //  borderRadius: BorderRadius.circular(8.0),
                           ),
                           child: TextField(
                             controller: area_caf_controller,
                          decoration: InputDecoration(
                          //  hintText: 'Enter text',
                          border: InputBorder.none,
                            ),
                            ),
                           ),
                    
                  
                     
                         Text("OLT Details",style: TextStyle(color: Colors.blueAccent),),

                         Text("*OLT ID",), 
                        Container(
                  // height: 30,
                 margin: EdgeInsets.only(left: 0,top: 5,right: 0,bottom: 5),
                 padding: EdgeInsets.symmetric(horizontal: 8.0),
                 decoration: BoxDecoration(
                 color: Pallete.lightgrey, // Gray background color
                  //  borderRadius: BorderRadius.circular(8.0),
                 ),
               
                 child: DropdownButtonHideUnderline(
                  child:  DropdownButton<OltDetailsModel>(
                  value: Selected_olt,
                  icon: const Icon(Icons.arrow_drop_down), // Right facing icon
                  // iconSize: 16,
                  // elevation: 16,
                  isExpanded: true,
                  onChanged: (OltDetailsModel? newValue) {
                    setState(() {
                      Selected_olt = newValue!;
                      if (newValue != null) {
                       print('Selected OLT ID: ${newValue.olt_id}');
                       selected_olt_id=newValue.olt_id.toString();
                        slots_details_api_call();
                        _checkButtonState();
                     }
                    });
                     
                  },
                  items: olt_futurePosts.map((OltDetailsModel olt) {
                    return DropdownMenuItem<OltDetailsModel>(
                      value: olt,
                      child: Text(olt.olt_nm),
                    );
                  }).toList(),
                ),
             
                  ),
              
              ),

                         Text("*OLT Port-ID",), 
                        Container(
                  // height: 30,
                 margin: EdgeInsets.only(left: 0,top: 5,right: 0,bottom: 5),
                 padding: EdgeInsets.symmetric(horizontal: 8.0),
                 decoration: BoxDecoration(
                 color: Pallete.lightgrey, // Gray background color
                  //  borderRadius: BorderRadius.circular(8.0),
                 ),
               
                child: DropdownButtonHideUnderline(
                  child:  DropdownButton<OltDetailsModel>(
                  value: selected_olt_port,
                  icon: const Icon(Icons.arrow_drop_down), // Right facing icon
                  // iconSize: 16,
                  // elevation: 16,
                  isExpanded: true,
                 
                  onChanged: (OltDetailsModel? newValue) {
                   setState(() {
                      selected_olt_port = newValue!;
                      if (newValue != null) {
                       print('Selected OLT PORT ID: ${newValue.olt_prt_id}');
                       selected_olt_port_id='${newValue.olt_prt_id}';  
                      

                        if(widget.boxExchangeModel.mdlwe_sbscr_id!=null){
                          print("iffff mdlwe_sbscr_id not null");
                          print("olt_slots_list[0].crd_id ${olt_slots_list[0].crd_id}");
                        if(olt_slots_list[0].crd_id==1 && widget.boxExchangeModel.mdlwe_sbscr_id.contains("D") ){
                            aghara_cd_nw=newValue.olt_prt_nm!+8;  
                            print("aghara_cd_nw1 $aghara_cd_nw");
                        }else{
                            aghara_cd_nw=newValue.olt_prt_nm!;
                             print("aghara_cd_nw2 $aghara_cd_nw");
                        }

                      }
                      else{
                        if(olt_slots_list[0].crd_id==1){
                           print("iffff mdlwe_sbscr_id not null");
                          aghara_cd_nw=newValue.olt_prt_nm!+8;
                        }else{
                          aghara_cd_nw=newValue.olt_prt_nm!;
                        }
                      }



                         slots_details_for_port_api_call();   
                          _checkButtonState();              
                     }
                    });
                  },
                  items: olt_slots_list.map((OltDetailsModel olt) {
                    return DropdownMenuItem<OltDetailsModel>(
                      value: olt,
                      child: Text(olt.olt_prt_nm.toString()),
                    );
                  }).toList(),
                ),
             
                  ),
              
              ),

                         Text("*Level-1 Slot",), 
                        Container(
                  // height: 30,
                 margin: EdgeInsets.only(left: 0,top: 5,right: 0,bottom: 5),
                 padding: EdgeInsets.symmetric(horizontal: 8.0),
                 decoration: BoxDecoration(
                 color: Pallete.lightgrey, // Gray background color
                  //  borderRadius: BorderRadius.circular(8.0),
                 ),
               
                child: DropdownButtonHideUnderline(
                  child:  DropdownButton<OltDetailsModel>(
                  value: selected_slot1,
                  icon: const Icon(Icons.arrow_drop_down), // Right facing icon
                  // iconSize: 16,
                  // elevation: 16,
                  isExpanded: true,
                  onChanged: (OltDetailsModel? newValue) {
                    setState(() {
                      selected_slot1 = newValue!;
                      print('selected_slot1 $selected_slot1');
                      if (newValue != null) {
                       print('Selected OLT SLOT1 ID: ${newValue.olt_slt_id.toString()}');
                       selected_slot_id=newValue.olt_slt_id.toString(); 
                       selected_slt1_id=newValue.slt1_id.toString();
                       selected_slt2_id=newValue.slt2_id.toString();
                       selected_slt3_id=newValue.slt3_id.toString();
                       print("selected_slot_id $selected_slot_id");
                      // slots_two_details_for_port_api_call(newValue.olt_prt_id.toString());  


                      validation_slots_data_api_call();
                       _checkButtonState();
             
                     }
                    });
                  },
                  items: olt_port_list.map((OltDetailsModel value) {
                    return DropdownMenuItem<OltDetailsModel>(
                      value: value,
                      child: Text(value.slt1_id.toString()),
                    );
                  }).toList(),
                ),
             
                  ),
              
              ),

                         Text("*Level-2 Slot",), 
                        Container(
                  // height: 30,
                 margin: EdgeInsets.only(left: 0,top: 5,right: 0,bottom: 5),
                 padding: EdgeInsets.symmetric(horizontal: 8.0),
                 decoration: BoxDecoration(
                 color: Pallete.lightgrey, // Gray background color
                  //  borderRadius: BorderRadius.circular(8.0),
                 ),
               
                child: DropdownButtonHideUnderline(
                  child:  DropdownButton<SlotValidationModel>(
                  value: selected_slot2,
                  icon: const Icon(Icons.arrow_drop_down), // Right facing icon
                  // iconSize: 16,
                  // elevation: 16,
                  isExpanded: true,
                  onChanged: (SlotValidationModel? newValue) {
                   setState(() {
                      selected_slot2 = newValue!;
                      if (newValue != null) {
                       print('Selected OLT SLOT2 ID: ${newValue.slidoriginal.toString()}');
                       selected_slot2_id=newValue.slidoriginal.toString();
                       selected_slot2_nm=newValue.sptwo.toString();   
                      // slots_three_details_for_port_api_call(newValue.olt_slt_id.toString());
                       _checkButtonState();
             
                     }
                    });
                  },
                  items: slot_validation_list.map((SlotValidationModel value) {
                    return DropdownMenuItem<SlotValidationModel>(
                      value: value,
                      child: Text(value.sptwo.toString()),
                    );
                  }).toSet().toList(),
                ),
             
                  ),
              
              ),
                        
                           Text("*Level-3 Slot",), 
                        Container(
                  // height: 30,
                 margin: EdgeInsets.only(left: 0,top: 5,right: 0,bottom: 5),
                 padding: EdgeInsets.symmetric(horizontal: 8.0),
                 decoration: BoxDecoration(
                 color: Pallete.lightgrey, // Gray background color
                  //  borderRadius: BorderRadius.circular(8.0),
                 ),
               
                child: DropdownButtonHideUnderline(
                  child:  DropdownButton<SlotValidationModel>(
                  value: selected_slot3,
                  icon: const Icon(Icons.arrow_drop_down), // Right facing icon
                  // iconSize: 16,
                  // elevation: 16,
                  isExpanded: true,
                  // underline: Container(
                  //   height: 2,
                  //   color: Colors.deepPurpleAccent,
                  // ),
                  onChanged: (SlotValidationModel? newValue) {
                     setState(() {
                      selected_slot3 = newValue!;
                      if (newValue != null) {
                       print('Selected OLT SLOT1 ID: ${newValue.spthree.toString()}');
                       selected_slot3_id=newValue.spthree.toString();   
                       selected_slot3_nm=newValue.spthree.toString();

                       splits_data_api_call();
                        _checkButtonState();
                     }
                    });
                  },
                  items: slot_validation_list.map((SlotValidationModel value) {
                    return DropdownMenuItem<SlotValidationModel>(
                      value: value,
                      child: Text(value.spthree.toString()),
                    );
                  }).toSet().toList(),
                ),
             
                  ),
              
              ),

                       
                      
                         Text("Reason for Change",),
                         
                            Container(
                          // height: 30,
                              margin: EdgeInsets.only(left: 0,top: 5,right: 0,bottom: 5),
                             padding: EdgeInsets.symmetric(horizontal: 8.0),
                             decoration: BoxDecoration(
                            color: Colors.grey[200], // Gray background color
                          //  borderRadius: BorderRadius.circular(8.0),
                           ),
                           child: TextField(
                             controller: reason_for_chng_controller,
                          decoration: InputDecoration(
                          //  hintText: 'Enter text',
                          border: InputBorder.none,
                            ),
                            ),
                           ),
                    
                        const SizedBox(
                          height: 10,
                        ),
                         Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                              backgroundColor: _isButtonEnabled?Pallete.buttonColor:Pallete.lightorange,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5),bottomRight: Radius.circular(5) )
                              ),
                            ),
                            onPressed: () { 
                              if(_isButtonEnabled){
                                  pon_chng_sbmt_api_call();
                              }
                            
                          
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
                  ],
                  ),
                ),


                ),
               
                  
                Visibility(
                  visible: _text_visible,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Note: $statusText",
                      textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10,),
                      ElevatedButton(
                         style: ElevatedButton.styleFrom(
                              backgroundColor: Pallete.buttonColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5),bottomRight: Radius.circular(5) )
                              ),
                            ),
                        onPressed: (){
                        olt_pon_refresh_api();
                        }, 
                         child: const Text(
                              "REFRESH",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                        )
                    ],
                  )
                  ),
                
              
              ],

             ),
              

            ],

          ),
        ),
      ),


    );

  }


   Widget _buildInfoRow(String label, String value,Color color) {
    return Container(
      color: color,
      padding: EdgeInsets.all(5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(":"),
          Text(value),
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
                         Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                           PonChange()));

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