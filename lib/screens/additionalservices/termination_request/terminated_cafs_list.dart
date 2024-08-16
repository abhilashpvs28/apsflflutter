import 'dart:convert';

import 'package:apsfllmo/model/termination_req_model.dart';
import 'package:apsfllmo/screens/additionalservices/termination_request/add_caf_termination.dart';
import 'package:apsfllmo/utils/apiservice.dart';
import 'package:apsfllmo/utils/constants.dart';
import 'package:apsfllmo/utils/pallete.dart';
import 'package:apsfllmo/widgets/termination_req_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class TerminatedCafsList extends StatefulWidget{
  const TerminatedCafsList({super.key});

  @override
  State<TerminatedCafsList> createState() =>
      _TerminatedCafsListState();
}

class _TerminatedCafsListState extends State<TerminatedCafsList>{

  bool _isLoading =false;
  List<TerminationReqModel> _terminationCafsList = [];
  final ScrollController _scrollController = ScrollController();
  TextEditingController _searchcontroller = TextEditingController();
  int _currentPage = 0;
  final int _itemsPerPage = 20;
  bool _hasMoreData = true;
  bool _isFetching = false;
  List<TerminationReqModel> fetchedData=[];
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
      }
      else{
      _currentPage++;

      }

      if(_currentPage==0){
        _terminationCafsList=fetchedData;
      }else{
        _terminationCafsList.addAll(fetchedData);
      }
      
    });
  }

   Future<List<TerminationReqModel>> termination_cafs(int limit_position, String search_text) async {
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
            'lmt_pstn': limit_position,
            'srch_txt': search_text ,
            'srch_type':search_type,           
          }

        });

        print("renew_payloads $body");

        
          var url = Uri.parse(Constants.baseUrl + Apiservice.termination_data);
          print("url $url");
          final response = await http.post(url,headers: headers,body: body);

          if (response.statusCode == 200) {
              final data = json.decode(response.body);
              print('response_dataa_boxchange $data');
             // return <List<RenewModel>>.fromJson(json.decode(response.body));
             final List<dynamic> lineItemsJson = data['data'];
             print(lineItemsJson.map((json) => TerminationReqModel.fromJson(json)).toList());
             return lineItemsJson.map((json) => TerminationReqModel.fromJson(json)).toList();

    
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
    //throw UnimplementedError();

    
    return Scaffold(
       appBar: AppBar(
        title: const Text(
          'TerminatedCAFs',
          style: TextStyle(color: Colors.black, fontFamily: 'Cera-Bold'),
        ),
        backgroundColor: Pallete.backgroundColor,
        automaticallyImplyLeading: false,
        actions: [

                          ElevatedButton(
                              onPressed: (){
                                Navigator.pushReplacement(
                                              context,
                                               MaterialPageRoute(
                                               builder: (BuildContext context) =>
                                              const AddCafTermination()));

                              },
                              style: ElevatedButton.styleFrom(
                              backgroundColor:Pallete.buttonColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                             child: const Text(
                              "+Termination",
                              style: TextStyle(
                                color:Colors.white,
                              ),
                            ),
                            ),             
                       

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

              _fetchData("");
            },
          ),
        ],
      ),

     
      body: Column(

        children: [
          Container(
           // child: SearchCard(serch_flag: "TerminatedCafs"),
            
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
                           _terminationCafsList.clear();
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
            child: _terminationCafsList.isEmpty
           ? Center(
              child: Text(
              "No data found",
               style: TextStyle(fontSize: 25, color: Colors.grey),
              ),
             ):
              ListView.builder(
              controller: _scrollController,
              itemCount: _terminationCafsList.length + (_hasMoreData ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _terminationCafsList.length) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              
                return TerminationReqCard(terminationReqModel: _terminationCafsList[index]);
              },
            ),
          ),



        ],

      ),




    );
    
  }

}
