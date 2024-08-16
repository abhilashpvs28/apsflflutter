import 'package:apsfllmo/model/box_exchange_model.dart';
import 'package:apsfllmo/model/submit_termination_model.dart';
import 'package:apsfllmo/screens/additionalservices/termination_request/selected_caf_terminations_list.dart';
import 'package:apsfllmo/utils/pallete.dart';
import 'package:flutter/material.dart';

class AddCafTerminationComment extends StatefulWidget{
  final List<BoxExchangeModel> selected_list;
   const AddCafTerminationComment(
    this.selected_list, 
    {super.key, });

  @override
  State<AddCafTerminationComment> createState() =>
      _AddCafTerminationCommentState();
}

class _AddCafTerminationCommentState extends State<AddCafTerminationComment>{

  TextEditingController cmt_controller=TextEditingController();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    //throw UnimplementedError();
    
     
     return Scaffold(
       appBar: AppBar(
        title: const Text(
          'Add CAF Termination',
          style: TextStyle(color: Colors.black, fontFamily: 'Cera-Bold'),
        ),
        backgroundColor: Pallete.backgroundColor,
        automaticallyImplyLeading: false,
        
      ),

      body:  Container(
        height: 130,
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        child:   Card(
              elevation: 25,
              color: Colors.white,
              child: Column(
                
               crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                
                    Container(
                       margin: EdgeInsets.only(left: 10,top: 5,right: 10,bottom: 5),
                      child:  Text("Enter Comment",
                    textAlign: TextAlign.start,
                    ),
                    ),
                        Container(
                              margin: EdgeInsets.all(10),
                             padding: EdgeInsets.symmetric(horizontal: 8.0),
                             decoration: BoxDecoration(
                            color: Pallete.lightgrey, // Gray background color
                          //  borderRadius: BorderRadius.circular(8.0),
                           ),
                           child: TextField(
                           controller: cmt_controller,
                          decoration: InputDecoration(
                          //  hintText: 'Enter text',
                          border: InputBorder.none,
                            ),
                            ),
                           ),
                ],

              ),
      ),

      ),
    
     

     bottomSheet: 
     Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
         TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('PREVIOUS'),
                    ),


           SizedBox(
                    height: 40,
                    width: 180,
                    child:  ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:Pallete.buttonColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(5),bottomRight: Radius.circular(5) )
                              ),
                            ),
                            onPressed: () { 
                             if(cmt_controller.text.isNotEmpty && widget.selected_list.isNotEmpty ){
                              SubmitTerminationModel? submitTerminationModel;
                              String cmt_texts=cmt_controller.text;
                              submitTerminationModel?.trmnd_desc_tx=cmt_controller.text;
                              Navigator.push(context, MaterialPageRoute(builder: (context) => SelectedCafTerminationsList(
                               widget.selected_list,
                               cmt_texts,
                              )));
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

     );

  }

}
