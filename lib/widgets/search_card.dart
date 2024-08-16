import 'package:flutter/material.dart';

class SearchCard extends StatelessWidget{
  final String? serch_flag;
  SearchCard({
    required this.serch_flag
});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    //throw UnimplementedError();
    return  
    
    Column(
    // mainAxisAlignment: MainAxisAlignment.start,
    // crossAxisAlignment: CrossAxisAlignment.start,
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
                      child: TextField(
                     decoration: InputDecoration(
                     prefixIcon: Icon(Icons.search,color: Colors.grey,),
                     hintText: "CAF",
              
                     border: OutlineInputBorder(
                     borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
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
                  
                },
                child: Column(
                  children: [
                     Icon(Icons.list_alt_outlined,color: Colors.grey,size: 20,),
            Text(
              "CAF",
              style: TextStyle(
                fontSize: 12,
              ),
              ),
                  ],
                ),

              ),
           
           ],
          ),
         
         Column(
           children: [
            Icon(Icons.mobile_friendly,color: Colors.grey,size: 20,),
            Text(
              "Mobile",
              style: TextStyle(
                fontSize: 12,
              ),
              ),
           ],
          ),

          Column(
           children: [
            Icon(Icons.file_copy,color: Colors.grey,size: 20,),
            Text(
              "Aadhar",
              style: TextStyle(
                fontSize: 12,
              ),
              ),
           ],
          ),

          Column(
           children: [
            Icon(Icons.person,color: Colors.grey,size: 20,),
            Text(
              "Name",
              style: TextStyle(
                fontSize: 12,
              ),
              ),
           ],
          ),

          Column(
           children: [
            Icon(Icons.file_copy_outlined,color: Colors.grey,size: 20,),
            Text(
              "Serial No",
              style: TextStyle(
                fontSize: 12,
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

    );

  }

}