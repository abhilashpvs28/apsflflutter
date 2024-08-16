import 'package:apsfllmo/screens/homescreen/home_screen.dart';
import 'package:apsfllmo/utils/pallete.dart';
import 'package:flutter/material.dart';

class AccountLedger extends StatefulWidget{
  @override
  State<AccountLedger> createState() => _AccountLedgerState();
}

class _AccountLedgerState extends State<AccountLedger>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
   // throw UnimplementedError();
    return Scaffold(
        appBar: AppBar(
        title: const Text(
          'My Ledger',
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

    );
  }

}