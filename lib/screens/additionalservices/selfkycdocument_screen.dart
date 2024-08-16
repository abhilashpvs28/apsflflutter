import 'package:apsfllmo/screens/additionalservices/selfkycdocument/addressinfo_screen.dart';
import 'package:apsfllmo/screens/homescreen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:apsfllmo/screens/additionalservices/additionalservices_screen.dart';
import 'package:apsfllmo/screens/additionalservices/selfkycdocument/kyc_doc_upload_screen.dart';
import 'package:apsfllmo/screens/additionalservices/selfkycdocument/personaldetails_screen.dart';
import 'package:apsfllmo/screens/additionalservices/selfkycdocument/termsandcondition_screen.dart';
// import 'package:apsfllmo/screens/homescreen/bbnlhome_screen.dart';

import 'package:apsfllmo/utils/pallete.dart';

class SelfkycdocumentScreen extends StatefulWidget {
  const SelfkycdocumentScreen({super.key});

  @override
  State<SelfkycdocumentScreen> createState() => _SelfkycdocumentScreenState();
}

class _SelfkycdocumentScreenState extends State<SelfkycdocumentScreen> {
  final TextEditingController _mobileNoController = TextEditingController();

  bool isChecked = true;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Pallete.backgroundColor,
        title: const Text(
          'Self KYC Document Upload',
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
              padding: EdgeInsets.all(8),
              height: MediaQuery.of(context).size.height * 1.25,
              child: PersonalDetails(),
            ),
            Container(
              padding: EdgeInsets.all(8),
              height: MediaQuery.of(context).size.height * 0.9,
              child: AddressInfo(),
            ),
            Container(
              padding: EdgeInsets.all(8),
              height: MediaQuery.of(context).size.height * 0.9,
              child: KYCDocUpload(),
            ),
            Container(
              padding: EdgeInsets.all(8),
              height: MediaQuery.of(context).size.height * 0.35,
              child: Material(
                elevation: 10,
                child: Container(
                  padding: EdgeInsets.all(10),
                  // color: const Color.fromARGB(255, 189, 207, 215),
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Confirm KYC Details',
                        style: TextStyle(fontSize: 18, fontFamily: 'Cera-Bold'),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: isChecked,
                            onChanged: (value) {
                              setState(() {
                                isChecked = value!;
                              });
                            },
                          ),
                          Flexible(
                            child: RichText(
                              text: TextSpan(
                                text:
                                    'I APSFL NOC (LMO2000825) have read, understood and accept the terms and conditions of APSFL.',
                                style: TextStyle(
                                  fontFamily: 'Cera-Bold',
                                  color: Colors.black,
                                ),
                                children: [
                                  TextSpan(
                                    text: ' View Details',
                                    style: TextStyle(
                                      fontFamily: 'Cera-Bold',
                                      color: Colors.blue, // Hyperlink color
                                      decoration: TextDecoration
                                          .underline, // Underline the hyperlink text
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = _navigateToTermsAndConditions,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Mobile Number',
                        style: TextStyle(fontSize: 14, fontFamily: 'Cera-Bold'),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _mobileNoController,
                        decoration: InputDecoration(
                          labelText: 'Enter Mobile Number',
                          labelStyle: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Cera-Bold'),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40)),
                        ),
                        keyboardType: TextInputType.name,
                      ),
                      SizedBox(height: 10),
                      Align(
                        alignment: Alignment.center,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Pallete.buttonColor),
                            onPressed: () {},
                            child: const Text(
                              'Submit KYC',
                              style: TextStyle(
                                fontFamily: 'Cera-Bold',
                                color: Colors.white,
                              ),
                            )),
                      )
                    ],
                  ),
                ),
              ),
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

  void _navigateToTermsAndConditions() {
    // Here you can navigate to the terms and conditions page
    // For example, you could use Navigator.push or any other navigation method
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const TermsandconditionScreen()),
    );
    print('Navigating to terms and conditions page');
  }
}
