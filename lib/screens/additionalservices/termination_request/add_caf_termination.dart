import 'dart:convert';

import 'package:apsfllmo/model/box_exchange_model.dart';
import 'package:apsfllmo/screens/additionalservices/termination_request/add_caf_termination_comment.dart';
import 'package:apsfllmo/utils/apiservice.dart';
import 'package:apsfllmo/utils/constants.dart';
import 'package:apsfllmo/utils/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AddCafTermination extends StatefulWidget{
  const AddCafTermination({super.key});

  @override
  State<AddCafTermination> createState() =>
      _AddCafTerminationState();
}

class _AddCafTerminationState extends State<AddCafTermination>{

  bool _isLoading =false;
  List<BoxExchangeModel> _add_terminationCafsList = [];
  final ScrollController _scrollController = ScrollController();
  TextEditingController _searchcontroller = TextEditingController();
  int _currentPage = 0;
  final int _itemsPerPage = 20;
  bool _hasMoreData = true;
  bool _isFetching = false;
  String? caf_type='';
 bool _isVisible=false;
  List<BoxExchangeModel> selected_list=[];
  List<BoxExchangeModel> fetchedData=[];
    String hint_text="CAF";
    bool _showIcons = false;
    int search_type=1;


  @override
  void initState() {
    super.initState();
     _fetchData("");
     _scrollController.addListener(_scrollListener);
      _searchcontroller.addListener(() {
      setState(() {
        _showIcons = _searchcontroller.text.isNotEmpty;
      });
    });
   
  }


 
    

   Future<void> _fetchData(String search_text) async {
    if (_isFetching) return;
    _isFetching = true;

    setState(() {
      _isLoading = true;
    });

    fetchedData = await termination_cafs(_currentPage,search_text);

    setState(() {
      _isLoading = false;
      _isFetching = false;
      if (fetchedData.length < _itemsPerPage) {
        _hasMoreData = false;
      }else{
         _currentPage++;
      }

      if(_currentPage==0){
        _add_terminationCafsList=fetchedData;
      }
      else{
        _add_terminationCafsList.addAll(fetchedData);
      }
     
    });
  }

 
   Future<List<BoxExchangeModel>> termination_cafs(int limit_position, String search_text) async {
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
            'agntId': "$agent_id" ,
            "sts": 0,
            "frm_dt": '',
            'lmt_pstn':limit_position,
            'srch_txt':search_text,
            'srch_type':search_type,
            'to_dt':'',
            'trmnd_in':'0'
          }


        });

        print("add_termination_payloads $body");

        
          var url = Uri.parse(Constants.baseUrl + Apiservice.add_termination_cafs_list);
          print("url $url");
          final response = await http.post(url,headers: headers,body: body);

          if (response.statusCode == 200) {
              final data = json.decode(response.body);
              print('response_dataa_add_termination $data');
             // return <List<RenewModel>>.fromJson(json.decode(response.body));
             final List<dynamic> lineItemsJson = data['data'];
             print(lineItemsJson.map((json) => BoxExchangeModel.fromJson(json)).toList());
             return lineItemsJson.map((json) => BoxExchangeModel.fromJson(json)).toList();

    
           } else {
               print("faileddd");
              throw Exception('Failed to load posts');
           }
      } 

     
    void _scrollListener() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !_isLoading &&
        _hasMoreData) {
      _fetchData("");
    }
  }


 


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
   // throw UnimplementedError();
  
   return Scaffold(
       appBar: AppBar(
        title: const Text(
          'TerminatedCAFs',
          style: TextStyle(color: Colors.black, fontFamily: 'Cera-Bold'),
        ),
        backgroundColor: Pallete.backgroundColor,
        automaticallyImplyLeading: false,
        actions: [         

          IconButton(
            icon: const Icon(
              Icons.refresh,
              color: Color.fromARGB(255, 2, 24, 63),
            ),
            onPressed: () {
              // Navigator.pushReplacement(
              //     context,
              //     MaterialPageRoute(
              //         builder: (BuildContext context) =>
              //             const BbnlHomeScreen()));
            },
          ),
        ],
      ),

     
    
      body: Column(

        children: [
          Container(
          //  child: SearchCard(serch_flag: "terminated_cafs"),
            
              
            child:   Column(
    
      children: [
       Container(
       
        //  color: Pallete.backgroundColor,
        child:  Stack(
          alignment: Alignment.topLeft,
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
                   Text(
                    "Choose Search Type Before Enter",
                    textAlign: TextAlign.left,
                    textDirection: TextDirection.rtl,
                    ),
                   SizedBox(height: 10,),

                   SizedBox(
                    height: 35,
                    child:   Center(
                      child:

                    Container(
                      height: 40,
         decoration: BoxDecoration(
       
          borderRadius: BorderRadius.circular(12.0),
         ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: _searchcontroller,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                   
                    hintText: hint_text
                  ),
                 
                ),
              ),
           
              Visibility(
                visible: _showIcons,
              
               child: 
                        IconButton(
                        icon: Icon(Icons.done),
                        onPressed: () {
                           _currentPage = 0;
                           _add_terminationCafsList.clear();
                          _fetchData(_searchcontroller.text);
                         
                        },
                      ),
              ),
          
              Visibility(
                visible: _showIcons,
              child:  IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          _searchcontroller.clear();
                         // _fetchData("");
                        },
                      ),
              ),
            ],
          ),
        ),



                   
                    ),
                   ),
       
     SizedBox(height: 10,),

     

      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
           children: [
              InkWell(
                onTap: () {
                  setState(() {
                    hint_text="CAF";
                    search_type=1;
                  });
                },
                child: Column(
                  children: [

                     Icon(Icons.list_alt_outlined,color: Colors.grey,size: 20,),
            Text(
              "CAF",
              style: TextStyle(
                fontSize: 12,
                decoration: hint_text == "CAF"? TextDecoration.underline: TextDecoration.none,
                                                    
              ),
              ),
                  ],
                ),

              ),
           
           ],
          ),
         
         Column(
           children: [
              InkWell(
                onTap: () {
                  setState(() {
                    hint_text="Mobile";
                    search_type=3;
                  });
                },
                child: Column(
                  children: [

                     Icon(Icons.mobile_friendly,color: Colors.grey,size: 20,),
            Text(
              "Mobile",
              style: TextStyle(
                fontSize: 12,
                decoration: hint_text == "Mobile"? TextDecoration.underline: TextDecoration.none,
              ),
              ),
                  ],
                ),

              ),
           

           
           ],
          ),

          Column(
           children: [
            
            InkWell(
                onTap: () {
                  setState(() {
                    hint_text="Aadhar";
                    search_type=2;
                  });
                },
                child: Column(
                  children: [

                     Icon(Icons.file_copy,color: Colors.grey,size: 20,),
            Text(
              "Aadhar",
              style: TextStyle(
                fontSize: 12,
                decoration: hint_text == "Aadhar"? TextDecoration.underline: TextDecoration.none,
              ),
              ),
                  ],
                ),

              ),
           

           ],
          ),

          Column(
           children: [
             InkWell(
                onTap: () {
                  setState(() {
                    hint_text="Name";
                    search_type=4;
                  });
                },
                child: Column(
                  children: [

                     Icon(Icons.person,color: Colors.grey,size: 20,),
            Text(
              "Name",
              style: TextStyle(
                fontSize: 12,
                decoration: hint_text == "Name"? TextDecoration.underline: TextDecoration.none,
              ),
              ),
                  ],
                ),

              ),
           
           ],
          ),

          Column(
           children: [
             InkWell(
                onTap: () {
                  setState(() {
                    hint_text="Serial No";
                    search_type=5;
                  });
                },
                child: Column(
                  children: [

                     Icon(Icons.file_copy,color: Colors.grey,size: 20,),
            Text(
              "Serial No",
              style: TextStyle(
                fontSize: 12,
                decoration: hint_text == "Serial No"? TextDecoration.underline: TextDecoration.none,
              ),
              ),
                  ],
                ),

              ),
           
           ],
          ),



        ],

      ),




          ],
        ),
                ],
              ),
            ),
        ),
      ),

          ],
        )
       
       ),
      
      ],

    ),
          
            
            ),

            Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _add_terminationCafsList.length + (_hasMoreData ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _add_terminationCafsList.length) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              
              //  return AddCafTerminationCard(renewModel: _add_terminationCafsList[index]);

                return    Container(
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
                      value: selected_list.contains(_add_terminationCafsList[index]),
                      onChanged: (value) {
                     // _onCheckboxChanged(value, renewModel);
                       
                     setState(() {
                          if(value==true){
                          selected_list.add(_add_terminationCafsList[index]);
                        }else{
                          selected_list.remove(_add_terminationCafsList[index]);
                        }
                        
                        print("selected_list $selected_list");
                     });

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
                              "${_add_terminationCafsList[index].cstmr_nm}",
                              textAlign: TextAlign.left,
                            ),

                             Column(
                              children: [
                                 Text(
                              "${_add_terminationCafsList[index].caf_id}",
                              textAlign: TextAlign.right,
                               ),

                                Visibility(
                            visible: (_add_terminationCafsList[index].caf_type_id==1)?false : true,
                            child: Text(
                            (_add_terminationCafsList[index].caf_type_id==1)?"(Individual)" : "(Enterprise)",
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
                              "${_add_terminationCafsList[index].mbl_nu}"
                            ),
                              ],
                            ),

                             Text(
                              "${_add_terminationCafsList[index].sts_nm}",
                              style: TextStyle(
                               color: 
                               ('${_add_terminationCafsList[index].sts_nm}'=="Active")?Pallete.green :('${_add_terminationCafsList[index].sts_nm}'=="Suspended")?Colors.deepOrange : ('${_add_terminationCafsList[index].sts_nm}'=="Terminated")?Colors.red:('${_add_terminationCafsList[index].sts_nm}'=="PON Change Initiated")? Colors.blue:('${_add_terminationCafsList[index].sts_nm}'=="BOX Change Initiated")?Colors.blue:Colors.black,
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
                        Text("${_add_terminationCafsList[index].adhr_nu}",textAlign: TextAlign.end,),
                        ],

                       ),

                           Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                        Text("ONU Serial No"),
                        Text(":"),
                        Text("${_add_terminationCafsList[index].onu_srl_nu}"),
                         ],
                        ),

                      Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("IPTV Serial No"),
                        Text(":"),
                        Text("${_add_terminationCafsList[index].iptv_srl_nu}"),
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



              },
            ),
          ),

       
        ],

      ),



   

     bottomSheet:
      
      Container(
      margin: EdgeInsets.only(left: 0,top: 0,right: 0,bottom: 5),
      height: 40,
      color: Pallete.buttonColor,
      child:
       Center(    
        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:Pallete.buttonColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5),bottomRight: Radius.circular(5) )
                              ),
                            ),
                            onPressed: () { 
                              print("listtt $selected_list");
                              if(selected_list.isNotEmpty){
                                   Navigator.push(context, MaterialPageRoute(builder: (context) => AddCafTerminationComment(
                              selected_list,
                             )));
                              }
                            
                          
                             },
                            child: const Text(
                              "NEXT",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),



       )
     ),


   );


  }

}
