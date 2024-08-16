import 'dart:convert';
import 'package:apsfllmo/screens/enterprisecaf/customerinformation_screen.dart';
import 'package:apsfllmo/screens/homescreen/home_screen.dart';
import 'package:apsfllmo/utils/apiservice.dart';
import 'package:apsfllmo/utils/constants.dart';
import 'package:apsfllmo/utils/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

class SelectenterpriseScreen extends StatefulWidget {
  const SelectenterpriseScreen({super.key});

  @override
  State<SelectenterpriseScreen> createState() => _SelectenterpriseScreenState();
}

class _SelectenterpriseScreenState extends State<SelectenterpriseScreen> {
  late Future<List<dynamic>> _futureData;
  List<dynamic> _allData = [];
  List<dynamic> _filteredData = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _futureData = _total_search_caf();
    _searchController.addListener(_filterData);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterData);
    _searchController.dispose();
    super.dispose();
  }

  Future<List<dynamic>> _total_search_caf() async {
    final storage = FlutterSecureStorage();
    final String? token = await storage.read(key: 'token');
    final String? agent_id = await storage.read(key: 'usr_ctgry_ky');

    print('Retrieved token: $token');
    print('usercategory_key: $agent_id');

    if (token == null) {
      print('Token is null');
      throw Exception('Token is null');
    }

    if (agent_id == null) {
      print('agent_id is null');
      throw Exception('agent_id is null');
    }

    final Map<String, String> headers = {
      'x-access-token': token,
      'Content-Type': 'application/json'
    };

    print('Request headers: $headers');

    var endpoint = '${Apiservice.list_enterprise_caf}?agent_id=$agent_id';
    var url = Uri.parse('${Constants.baseUrl}$endpoint');
    print('URL: $url');

    final response = await http.get(url, headers: headers);

    print('Response status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<dynamic> data = responseData['data'] ?? [];
      print('API data: $data');
      setState(() {
        _allData = data;
        _filteredData = data;
      });
      return data;
    } else {
      print('Failed to fetch data. Status code: ${response.statusCode}');
      throw Exception('Failed to fetch data');
    }
  }

  void _filterData() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredData = _allData.where((item) {
        final cstmrNm = item['cstmr_nm']?.toLowerCase() ?? '';
        return cstmrNm.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Pallete.backgroundColor,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'EnterPrise CAF',
              style: TextStyle(
                fontFamily: 'Cera-Bold',
                fontSize: 18,
                color: Colors.black,
              ),
            ),
          ],
        ),
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
                  builder: (BuildContext context) => const HomeScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colors.blue,
                    width: 2.0,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colors.blue,
                    width: 2.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colors.blue,
                    width: 2.0,
                  ),
                ),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: _futureData,
              builder: (BuildContext context,
                  AsyncSnapshot<List<dynamic>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No data available'));
                } else {
                  return ListView.builder(
                    itemCount: _filteredData.length,
                    itemBuilder: (context, index) {
                      final item = _filteredData[index];
                      return InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  EpCafCustomerinformationScreen(
                                      customerData: item),
                            ));
                          },
                          child: Center(
                            child: Container(
                                margin: EdgeInsets.only(
                                    left: 15, top: 10, right: 15),
                                height: 50,
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255),
                                  border: Border.all(
                                    color: Color.fromARGB(255, 5, 191, 237),
                                    style: BorderStyle.solid,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                        padding: EdgeInsets.only(left: 10),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.75,
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.add_chart_rounded,
                                              color: Pallete.buttonColor,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Flexible(
                                                child: Text(
                                              item['cstmr_nm'] ?? 'N/A',
                                              style: TextStyle(
                                                fontFamily: 'Cera-Bold',
                                                fontSize: 13,
                                              ),
                                            )),
                                          ],
                                        )),
                                    Container(
                                      alignment: Alignment.topCenter,
                                      width: 60,
                                      height: 40,
                                      child: Lottie.asset(
                                        height: 120,
                                        width: 120,
                                        'assets/images/logos/rightarrow.json',
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ],
                                )),
                          ));
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: MediaQuery.of(context).size.height * 0.03,
        color: Pallete.backgroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'LMO2000825',
              style: TextStyle(fontSize: 10, fontFamily: 'Cera-Bold'),
            ),
            Text(
              'V 5.9',
              style: TextStyle(fontSize: 10, fontFamily: 'Cera-Bold'),
            ),
            Text(
              'Powered by Greenlantern IT Solutions @ BBNL',
              style: TextStyle(fontSize: 10, fontFamily: 'Cera-Bold'),
            ),
          ],
        ),
      ),
    );
  }
}
