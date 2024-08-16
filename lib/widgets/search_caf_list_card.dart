import 'dart:convert';
import 'package:apsfllmo/model/renew_model.dart';
import 'package:apsfllmo/screens/additionalservices/renew_caf2.dart';
import 'package:apsfllmo/screens/searchcafs/customerdetails/personaldetails_screen.dart';
import 'package:apsfllmo/screens/searchcafs/customerdetails_screen.dart';
import 'package:apsfllmo/utils/apiservice.dart';
import 'package:apsfllmo/utils/constants.dart';
import 'package:apsfllmo/utils/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class SearchCafListCard extends StatelessWidget {
  final RenewModel renewModel;

  const SearchCafListCard({required this.renewModel});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    //throw UnimplementedError();
    int? caf_id = renewModel.caf_id;
    print('this is caf id :- $caf_id'); // Access caf_id through widget.caf_id
    String? caf_type = '';
    bool _isVisible = false;
    if (renewModel.caf_type_id == 1) {
      caf_type = "(Individual)";
      _isVisible = false;
    } else {
      caf_type = "(Enterprise)";
      _isVisible = true;
    }

    return InkWell(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => CustomerdetailsScreen(caf_id: caf_id),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(left: 10, top: 5, right: 10, bottom: 5),
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
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${renewModel.cstmr_nm}",
                          style: TextStyle(fontFamily: 'Cera-Bold'),
                        ),
                        Column(
                          children: [
                            Text(
                              "${renewModel.caf_id}",
                              style: TextStyle(fontFamily: 'Cera-Bold'),
                            ),
                            Visibility(
                              visible: _isVisible,
                              child: Text(
                                caf_type,
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontFamily: 'Cera-Bold'),
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
                            Icon(
                              Icons.mobile_friendly,
                              size: 15,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "${renewModel.mbl_nu}",
                              style: TextStyle(fontFamily: 'Cera-Bold'),
                            ),
                          ],
                        ),
                        Text(
                          "${renewModel.sts_nm}",
                          style: TextStyle(
                            fontFamily: 'Cera-Bold',
                            color: ('${renewModel.sts_nm}' == "Active")
                                ? Pallete.green
                                : ('${renewModel.sts_nm}' == "Suspended")
                                    ? Colors.deepOrange
                                    : ('${renewModel.sts_nm}' == "Terminated")
                                        ? Colors.red
                                        : ('${renewModel.sts_nm}' ==
                                                "PON Change Initiated")
                                            ? Colors.blue
                                            : ('${renewModel.sts_nm}' ==
                                                    "BOX Change Initiated")
                                                ? Colors.blue
                                                : Colors.black,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 1,
                      color: Colors.grey,
                      margin: EdgeInsets.symmetric(vertical: 10),
                    ),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              // color: Colors.blue,
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: Text(
                                "Aadhar",
                                textAlign: TextAlign.start,
                                style: TextStyle(fontFamily: 'Cera-Bold'),
                              ),
                            ),
                            Container(
                              // color: Colors.green,
                              width: MediaQuery.of(context).size.width * 0.1,
                              child: Text(
                                ":",
                                style: TextStyle(fontFamily: 'Cera-Bold'),
                              ),
                            ),
                            Container(
                              // color: Colors.amber,
                              width: MediaQuery.of(context).size.width * 0.35,
                              child: Text(
                                "${renewModel.adhr_nu}",
                                textAlign: TextAlign.start,
                                style: TextStyle(fontFamily: 'Cera-Bold'),
                              ),
                            ),

                            //  Text("Aadhar",textAlign: TextAlign.start,),
                            // Text(":"),
                            // Text("${renewModel.adhr_nu}",textAlign: TextAlign.end,),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: Text(
                                "Billing Frequency",
                                style: TextStyle(fontFamily: 'Cera-Bold'),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.1,
                              child: Text(
                                ":",
                                style: TextStyle(fontFamily: 'Cera-Bold'),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.35,
                              child: Text(
                                "${renewModel.frqncy_nm}",
                                textAlign: TextAlign.start,
                                style: TextStyle(fontFamily: 'Cera-Bold'),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: Text(
                                "ONU Serial No",
                                style: TextStyle(fontFamily: 'Cera-Bold'),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.1,
                              child: Text(
                                ":",
                                style: TextStyle(fontFamily: 'Cera-Bold'),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.35,
                              child: Text(
                                "${renewModel.onu_srl_nu}",
                                textAlign: TextAlign.start,
                                style: TextStyle(fontFamily: 'Cera-Bold'),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: Text(
                                "IPTV Serial No",
                                style: TextStyle(fontFamily: 'Cera-Bold'),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.1,
                              child: Text(
                                ":",
                                style: TextStyle(fontFamily: 'Cera-Bold'),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.35,
                              child: Text(
                                "${renewModel.iptv_srl_nu}",
                                textAlign: TextAlign.start,
                                style: TextStyle(fontFamily: 'Cera-Bold'),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: Text(
                                "Subscriber Code",
                                style: TextStyle(fontFamily: 'Cera-Bold'),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.1,
                              child: Text(
                                ":",
                                style: TextStyle(fontFamily: 'Cera-Bold'),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.35,
                              child: Text(
                                "${renewModel.mdlwe_sbscr_id}",
                                textAlign: TextAlign.start,
                                style: TextStyle(fontFamily: 'Cera-Bold'),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: Text(
                                "Telephone Allocated",
                                style: TextStyle(fontFamily: 'Cera-Bold'),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.1,
                              child: Text(
                                ":",
                                style: TextStyle(fontFamily: 'Cera-Bold'),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.35,
                              child: Text(
                                "Yes",
                                textAlign: TextAlign.start,
                                style: TextStyle(fontFamily: 'Cera-Bold'),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: Text(
                                "CAF Activated On",
                                style: TextStyle(fontFamily: 'Cera-Bold'),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.1,
                              child: Text(
                                ":",
                                style: TextStyle(fontFamily: 'Cera-Bold'),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.35,
                              child: Text(
                                "${renewModel.actvnDt}",
                                textAlign: TextAlign.start,
                                style: TextStyle(fontFamily: 'Cera-Bold'),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: Text(
                                "Suspended On",
                                style: TextStyle(fontFamily: 'Cera-Bold'),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.1,
                              child: Text(
                                ":",
                                style: TextStyle(fontFamily: 'Cera-Bold'),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.35,
                              child: Text(
                                "${renewModel.spnd_dt}",
                                textAlign: TextAlign.start,
                                style: TextStyle(fontFamily: 'Cera-Bold'),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: Text(
                                "Suspeneded Days",
                                style: TextStyle(fontFamily: 'Cera-Bold'),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.1,
                              child: Text(
                                ":",
                                style: TextStyle(fontFamily: 'Cera-Bold'),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.35,
                              child: Text(
                                "${renewModel.spnd_count}",
                                textAlign: TextAlign.start,
                                style: TextStyle(fontFamily: 'Cera-Bold'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
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
  }
}
