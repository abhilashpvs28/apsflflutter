import 'dart:convert';

import 'package:apsfllmo/model/box_exchange_model.dart';
import 'package:apsfllmo/screens/additionalservices/box_change_details.dart';
import 'package:apsfllmo/screens/homescreen/home_screen.dart';
import 'package:apsfllmo/utils/apiservice.dart';
import 'package:apsfllmo/utils/constants.dart';
import 'package:apsfllmo/utils/pallete.dart';
import 'package:apsfllmo/widgets/box_exchange_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class BoxExchange extends StatefulWidget{
  const BoxExchange({super.key});

  @override
  State<BoxExchange> createState() => _BoxExchangeState();
  
}

class _BoxExchangeState extends State<BoxExchange>{

  bool _isLoading =false;
  //late Future<List<BoxExchangeModel>> futurePosts;

 List<BoxExchangeModel> _boxExchangList = [];
  final ScrollController _scrollController = ScrollController();
  TextEditingController _searchcontroller = TextEditingController();
  int _currentPage = 0;
  final int _itemsPerPage = 20;
  bool _hasMoreData = true;
  bool _isFetching = false;
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

    fetchedData = await boxexchange_data(_currentPage,search_text);

    setState(() {
      _isLoading = false;
      _isFetching = false;
    
      if (fetchedData.length < _itemsPerPage) {
        _hasMoreData = false;
      } else {
        _currentPage++;
      }
      if (_currentPage == 0) {
        _boxExchangList = fetchedData; // Reset list for new search
      } else {
        _boxExchangList.addAll(fetchedData); // Append to existing list
      }
    });
  }

    Future<List<BoxExchangeModel>> boxexchange_data(int limit_position, String search_text) async {
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
            'adhar_nu': '0',
            'agntID': "$agent_id" ,
            'caf_nu':'0',
            'frmdate':'',
            'lmt_pstn':limit_position,
            'mbl_nu':'0',
            'srch_txt':search_text,
            'srch_type':search_type,
            'sts':'0',
            'todate':''
          }

        });

        print("renew_payloads $body");

        
          var url = Uri.parse(Constants.baseUrl + Apiservice.BoxExchange);
          print("url $url");
          final response = await http.post(url,headers: headers,body: body);

          if (response.statusCode == 200) {
              final data = json.decode(response.body);
              print('response_dataa_boxchange $data');
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
    //throw UnimplementedError();

    return Scaffold(
       appBar: AppBar(
        title: const Text(
          'Box Exchange',
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

      body: 
       Column(

        children: [
          Container(
           // child: SearchCard(serch_flag: "BoxExchange"),
            
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
                           _boxExchangList.clear();
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
              itemCount: _boxExchangList.length + (_hasMoreData ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _boxExchangList.length) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
           
                return InkWell(
                    onTap: () {
                       Navigator.push(context, MaterialPageRoute(builder: (context) => BoxChangeDetails(
                         boxExchangeModel: _boxExchangList[index]
                       )));
                    },
                    child: BoxExchangeCard(boxExchangeModel: _boxExchangList[index]),

                  );
              },
            ),
          ),

        ],

      ),

    );
  }

}
