import 'package:flutter/material.dart';

class CpeInventoryCard extends StatelessWidget{
  String? count;
  String? name;

  CpeInventoryCard(this.count,this.name,{super.key});
  
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
   // throw UnimplementedError();

    return Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                  

                     child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                      height: 3.0,
                    ),
                           Text(
                      "$count",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                      ),
                      textAlign: TextAlign.center,
                    ),

                     SizedBox(
                      height: 3.0,
                    ),

                    Text(
                      "$name",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 3.0,
                    ),
                    
                        ],
                      ),
                      );

  }

}