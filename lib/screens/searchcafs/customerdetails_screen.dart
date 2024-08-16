import 'package:apsfllmo/screens/homescreen/home_screen.dart';
import 'package:apsfllmo/screens/searchcafs/customerdetails/personaldetails_screen.dart';
import 'package:apsfllmo/screens/searchcafs/customerdetails/personaldetailstab_screen.dart';
import 'package:apsfllmo/utils/pallete.dart';
import 'package:flutter/material.dart';

class CustomerdetailsScreen extends StatefulWidget {
  final int? caf_id; // Add a field to store caf_id
  const CustomerdetailsScreen(
      {super.key, this.caf_id}); // Make sure to use 'this.caf_id'

  @override
  State<CustomerdetailsScreen> createState() => _CustomerdetailsScreenState();
}

class _CustomerdetailsScreenState extends State<CustomerdetailsScreen> {
  @override
  Widget build(BuildContext context) {
    print(
        'this is caf id :- ${widget.caf_id}'); // Access caf_id through widget.caf_id
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Pallete.backgroundColor,
        title: const Text(
          'Customer Details',
          style: TextStyle(
            fontFamily: 'Cera-Bold',
            fontSize: 18,
            color: Colors.black,
          ),
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              child:
                  PersonaldetailsScreen(caf_id: widget.caf_id), // Pass caf_id
            ),
            Container(
              height: 600,
              padding: const EdgeInsets.all(8),
              child: PersonaldetailstabScreen(caf_id: widget.caf_id),
            ),
          ],
        ),
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
