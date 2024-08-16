import 'dart:convert';
import 'package:apsfllmo/screens/additionalservices/bulkrenew_screen.dart';
import 'package:apsfllmo/screens/additionalservices/ponconnectionstatus/allocatedcaf_screen.dart';
import 'package:apsfllmo/utils/apiservice.dart';
import 'package:apsfllmo/utils/constants.dart';
import 'package:apsfllmo/utils/pallete.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class PonconnectionstatusScreen extends StatefulWidget {
  const PonconnectionstatusScreen({super.key});

  @override
  State<PonconnectionstatusScreen> createState() =>
      _PonconnectionstatusScreenState();
}

class _PonconnectionstatusScreenState extends State<PonconnectionstatusScreen> {
  final Map<int, List<Employee>> groupedEmployees = {};
  final Map<int, String> oltNames = {};
  final Map<int, String> dstrt_Names = {};
  final List<EmployeeDataSource> dataSources = [];
  bool _isLoading = false;
  List<dynamic> oltCafCounts = []; // Define it here

  @override
  void initState() {
    super.initState();
    _getAgntPonCounts();
  }

  Future<void> _getAgntPonCounts() async {
    final storage = FlutterSecureStorage();
    final String? token = await storage.read(key: 'token');

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

    try {
      var url = Uri.parse(Constants.baseUrl + Apiservice.pon_connection_status);
      print("url $url");
      final response = await http.get(url, headers: headers);

      print(' Response status: ${response.statusCode}');
      print(' Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> data = responseData['data'] ?? [];

        print('Data received from API: $data');

        if (data.isNotEmpty) {
          oltCafCounts = data[0][
              'oltCafCounts']; // Adjust as needed based on your response structure
          print('oltCafCounts: $oltCafCounts');
        }

        setState(() {
          groupedEmployees.clear();
          oltNames.clear();
          dstrt_Names.clear();
          dataSources.clear();

          for (var olt in data) {
            int sNo = olt['s_no'];
            String oltNm = olt['olt_nm'];
            String dstrt_Nm = olt['dstrt_nm'];
            oltNames[sNo] = oltNm;
            dstrt_Names[sNo] = dstrt_Nm;

            print('OLT Name: $oltNm, District Name: $dstrt_Nm');

            if (!groupedEmployees.containsKey(sNo)) {
              groupedEmployees[sNo] = [];
            }

            for (var oltCafCount in olt['oltCafCounts']) {
              groupedEmployees[sNo]!.add(Employee(
                oltCafCount['olt_id']
                    .toString(), // Convert to string and add this
                oltCafCount['olt_prt_nm'].toString(),
                oltCafCount['ttl'].toString(),
                oltCafCount['caf_cnt'].toString(),
                oltCafCount['caf_rmng'].toString(),
                oltCafCount['nw'].toString(),
              ));
              print('Employee added: ${oltCafCount['olt_prt_nm']}');
            }
          }

          for (var employees in groupedEmployees.values) {
            dataSources.add(EmployeeDataSource(employeeData: employees));
          }

          _isLoading = false;
        });
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  double _calculateHeight(int rowsCount) {
    return (rowsCount * 49.0) + 56.0;
  }

  void _navigateToAllocatedCaf(int oltId, int oltPartNm) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AllocatedcafScreen(
          oltId: oltId,
          oltPartNm: oltPartNm,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        height: 20,
        color: Pallete.backgroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'LMO2000825',
              style: TextStyle(fontSize: 12, fontFamily: 'Cera-Bold'),
            ),
            Text(
              'V 5.9',
              style: TextStyle(fontSize: 12, fontFamily: 'Cera-Bold'),
            ),
            Text(
              'Powered by Greenlantern IT Solutions @ BBNL',
              style: TextStyle(fontSize: 12, fontFamily: 'Cera-Bold'),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text(
          'PON Connection Status',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Cera-Bold',
            fontSize: 20,
          ),
        ),
        backgroundColor: Pallete.backgroundColor,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.replay,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const BulkrenewScreen()));
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: dataSources.length,
                itemBuilder: (context, index) {
                  int sNo = groupedEmployees.keys.elementAt(index);
                  int rowsCount = groupedEmployees[sNo]!.length;
                  String oltNm = oltNames[sNo] ?? 'Unknown';
                  String dstrt_Nm = dstrt_Names[sNo] ?? 'Unknown';

                  print(
                      'Building card for sNo: $sNo, oltNm: $oltNm, dstrt_Nm: $dstrt_Nm');

                  return Card(
                    elevation: 8,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.deepPurple[100]!,
                                width: 1.8,
                              ),
                            ),
                          ),
                          child: Column(
                            children: [
                              Container(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          '$oltNm',
                                          softWrap: true,
                                          style: const TextStyle(
                                            fontFamily: 'Cera-Bold',
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        '$dstrt_Nm',
                                        style: const TextStyle(
                                          fontFamily: 'Cera-Bold',
                                          color: Colors.black,
                                        ),
                                      )
                                    ],
                                  )),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: const Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '172.16.252.197',
                                        style: TextStyle(
                                          fontFamily: 'Cera-Bold',
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        'LMO2000825',
                                        style: TextStyle(
                                          fontFamily: 'Cera-Bold',
                                          color: Colors.black,
                                        ),
                                      )
                                    ]),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.zero,
                          padding: EdgeInsets.zero,
                          height: _calculateHeight(rowsCount),
                          child: SfDataGrid(
                            source: dataSources[index],
                            columnWidthMode: ColumnWidthMode.fill,
                            columns: <GridColumn>[
                              GridColumn(
                                columnName: 'Port',
                                label: Container(
                                  decoration: BoxDecoration(
                                    border: Border.symmetric(
                                      vertical: BorderSide(
                                        color: Colors.deepPurple[100]!,
                                        width: 1.5,
                                      ),
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(16.0),
                                  alignment: Alignment.center,
                                  child: const Text(
                                    'Port',
                                    style: TextStyle(
                                      fontFamily: 'Cera-Bold',
                                      color: Colors.blue,
                                      // fontSize: 10,
                                    ),
                                  ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'Total Count',
                                label: Container(
                                  decoration: BoxDecoration(
                                    border: Border.symmetric(
                                      vertical: BorderSide(
                                        color: Colors.deepPurple[100]!,
                                        width: 1.5,
                                      ),
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(16.0),
                                  alignment: Alignment.center,
                                  child: const Text(
                                    'Total',
                                    style: TextStyle(
                                      fontFamily: 'Cera-Bold',
                                      color: Colors.blue,
                                      // fontSize: 10,
                                    ),
                                  ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'Caf Count',
                                width:
                                    100, // Set a fixed width or adjust as necessary
                                label: Container(
                                  decoration: BoxDecoration(
                                    border: Border.symmetric(
                                      vertical: BorderSide(
                                        color: Colors.deepPurple[100]!,
                                        width: 1.5,
                                      ),
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(8.0),
                                  alignment: Alignment.center,
                                  child: const Text(
                                    'Allocated',
                                    style: TextStyle(
                                      fontFamily: 'Cera-Bold',
                                      color: Colors.blue,
                                      // fontSize: 12,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              GridColumn(
                                width:
                                    100, // Set a fixed width or adjust as necessary
                                columnName: 'Available',
                                label: Container(
                                  decoration: BoxDecoration(
                                    border: Border.symmetric(
                                      vertical: BorderSide(
                                        color: Colors.deepPurple[100]!,
                                        width: 1.5,
                                      ),
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(16.0),
                                  alignment: Alignment.center,
                                  child: const Text(
                                    'Available',
                                    style: TextStyle(
                                      fontFamily: 'Cera-Bold',
                                      color: Colors.blue,
                                      // fontSize: 11,
                                    ),
                                  ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'New',
                                label: Container(
                                  decoration: BoxDecoration(
                                    border: Border.symmetric(
                                      vertical: BorderSide(
                                        color: Colors.deepPurple[100]!,
                                        width: 1.5,
                                      ),
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(16.0),
                                  alignment: Alignment.center,
                                  child: const Text(
                                    'New',
                                    style: TextStyle(
                                      fontFamily: 'Cera-Bold',
                                      color: Colors.blue,
                                      // fontSize: 10,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                            onCellTap: (DataGridCellTapDetails details) {
                              if (details.rowColumnIndex.rowIndex > 0 &&
                                  details.rowColumnIndex.rowIndex <=
                                      groupedEmployees[sNo]!.length) {
                                final int dataIndex =
                                    details.rowColumnIndex.rowIndex - 1;
                                final Employee employee =
                                    groupedEmployees[sNo]![dataIndex];
                                final String cafCount = employee.cafCount;
                                final int oltId =
                                    int.tryParse(employee.oltId) ??
                                        0; // Correctly fetch oltId
                                final String oltPartNm = employee.oltPartNm;
                                print(
                                    'Cell tapped: olt_id=$oltId, olt_prt_nm=$oltPartNm, caf_cnt=$cafCount, Employee = $employee');

                                if (int.tryParse(cafCount) != null &&
                                    int.parse(cafCount) > 0) {
                                  _navigateToAllocatedCaf(
                                      oltId, int.tryParse(oltPartNm) ?? 0);
                                }
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
    );
  }
}

class Employee {
  final String oltId; // Added this line
  final String oltPartNm;
  final String totalCount;
  final String cafCount;
  final String remainingCount;
  final String nw;

  Employee(
    this.oltId, // Updated constructor
    this.oltPartNm,
    this.totalCount,
    this.cafCount,
    this.remainingCount,
    this.nw,
  );
}

class EmployeeDataSource extends DataGridSource {
  EmployeeDataSource({required List<Employee> employeeData}) {
    _employeeData = employeeData
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<String>(columnName: 'Port', value: e.oltPartNm),
              DataGridCell<String>(
                  columnName: 'Total Count', value: e.totalCount),
              DataGridCell<String>(columnName: 'Allocated', value: e.cafCount),
              DataGridCell<String>(
                  columnName: 'Available', value: e.remainingCount),
              DataGridCell<String>(columnName: 'New', value: e.nw),
            ]))
        .toList();
  }

  List<DataGridRow> _employeeData = [];

  @override
  List<DataGridRow> get rows => _employeeData;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(cells: [
      Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
            border: Border.symmetric(
                vertical: BorderSide(
          color: Colors.deepPurple[100]!,
          width: 1.5,
        ))),
        alignment: Alignment.center,
        child: Text(
          row.getCells()[0].value.toString(),
          style: const TextStyle(fontFamily: 'Cera-Bold'),
        ),
      ),
      Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
            border: Border.symmetric(
                vertical: BorderSide(
          color: Colors.deepPurple[100]!,
          width: 1.5,
        ))),
        alignment: Alignment.center,
        child: Text(
          row.getCells()[1].value.toString(),
          style: const TextStyle(fontFamily: 'Cera-Bold'),
        ),
      ),
      Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
            border: Border.symmetric(
                vertical: BorderSide(
          color: Colors.deepPurple[100]!,
          width: 1.5,
        ))),
        alignment: Alignment.center,
        child: Text(
          row.getCells()[2].value.toString(),
          style: const TextStyle(
            fontFamily: 'Cera-Bold',
            decoration: TextDecoration.underline,
          ),
        ),
      ),
      Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
            border: Border.symmetric(
                vertical: BorderSide(
          color: Colors.deepPurple[100]!,
          width: 1.5,
        ))),
        alignment: Alignment.center,
        child: Text(
          row.getCells()[3].value.toString(),
          style: const TextStyle(fontFamily: 'Cera-Bold'),
        ),
      ),
      Container(
        decoration: BoxDecoration(
            border: Border.symmetric(
                vertical: BorderSide(
          color: Colors.deepPurple[100]!,
          width: 1.5,
        ))),
        padding: const EdgeInsets.all(16.0),
        alignment: Alignment.center,
        child: Text(
          row.getCells()[4].value.toString(),
          style: const TextStyle(fontFamily: 'Cera-Bold'),
        ),
      ),
    ]);
  }
}
