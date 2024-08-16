import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AdditinalServicesWidgets extends StatelessWidget {
  final String? text;
  Color color;
  String? short_text;
  VoidCallback onTap;

  //  AdditinalServicesWidgets( this.text,
  //  this.color,
  //  this.short_text,
  //  this.onTap, {Key? key, required Null Function() onTap,}):super(key: key);

  AdditinalServicesWidgets({
    required this.text,
    required this.color,
    required this.short_text,
    required this.onTap,
  });

  //AdditinalServicesWidgets()

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    // throw UnimplementedError();

    return InkWell(

        //print("Renewwwww111");
        onTap: onTap,
        child: Center(
          child: Container(
              margin: EdgeInsets.only(left: 15, top: 10, right: 15),
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  //color: Color.fromARGB(255, 199, 237, 190),
                  color: color,
                  style: BorderStyle.solid,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          alignment: Alignment.topCenter,
                          width: 60,
                          height: 40,
                          //  color: Color.fromARGB(255, 199, 237, 190),
                          color: color,
                          child: Center(
                            child: Text(
                              "$short_text",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Cera-Bold',
                              ),
                            ),
                          )),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "$text",
                        style: TextStyle(
                          fontFamily: 'Cera-Bold',
                        ),
                      ),
                    ],
                  ),
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
  }
}
