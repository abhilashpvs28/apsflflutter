import 'package:apsfllmo/utils/pallete.dart';
import 'package:flutter/material.dart';

class PersonalDetails extends StatelessWidget {
  final TextEditingController _adhrController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _panNoController = TextEditingController();
  final TextEditingController _bankAccountController = TextEditingController();
  final TextEditingController _reEnterBankAccountController =
      TextEditingController();
  final TextEditingController _ifscNameController = TextEditingController();
  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _gstNumberController = TextEditingController();
  final TextEditingController _gpayUpiController = TextEditingController();
  final TextEditingController _phonePeUpiController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Material(
        elevation: 10,
        child: Container(
          padding: EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Aadhaar No/Register No',
                style: TextStyle(fontSize: 14, fontFamily: 'Cera-Bold'),
              ),
              SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 1.7,
                    child: TextFormField(
                      controller: _adhrController,
                      decoration: InputDecoration(
                        labelText: 'Enter Aadhar Number',
                        labelStyle: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Cera-Bold'),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40)),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Aadhar Number';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  SizedBox(width: 4),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Pallete.buttonColor,
                      ),
                      onPressed: () {},
                      child: const Text(
                        'Retrive',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Cera-Bold',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              const Text(
                'First Name',
                style: TextStyle(fontSize: 14, fontFamily: 'Cera-Bold'),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _firstNameController,
                decoration: InputDecoration(
                  labelText: 'Enter First Name',
                  labelStyle: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cera-Bold'),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter First Name';
                  }
                  return null;
                },
                keyboardType: TextInputType.name,
              ),
              SizedBox(height: 10),
              const Text(
                'Last Name',
                style: TextStyle(fontSize: 14, fontFamily: 'Cera-Bold'),
              ),
              TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(
                  labelText: 'Enter Last Name',
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
              const Text(
                'Email',
                style: TextStyle(fontSize: 14, fontFamily: 'Cera-Bold'),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Enter Email',
                  labelStyle: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cera-Bold'),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40)),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 10),
              const Text(
                'Enter PAN No',
                style: TextStyle(fontSize: 14, fontFamily: 'Cera-Bold'),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _bankAccountController,
                decoration: InputDecoration(
                  labelText: 'Enter Bank Account No',
                  labelStyle: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cera-Bold',
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40)),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10),
              const Text(
                'Re-enter Bank Account No',
                style: TextStyle(fontSize: 14, fontFamily: 'Cera-Bold'),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _reEnterBankAccountController,
                decoration: InputDecoration(
                  labelText: 'Re-enter Bank Account No',
                  labelStyle: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cera-Bold',
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40)),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10),
              const Text(
                'IFSC Name',
                style: TextStyle(fontSize: 14, fontFamily: 'Cera-Bold'),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _ifscNameController,
                decoration: InputDecoration(
                  labelText: 'Enter IFSC Name',
                  labelStyle: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cera-Bold',
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40)),
                ),
                keyboardType: TextInputType.name,
              ),
              SizedBox(height: 10),
              const Text(
                'Bank Name',
                style: TextStyle(fontSize: 14, fontFamily: 'Cera-Bold'),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _bankNameController,
                decoration: InputDecoration(
                  labelText: 'Enter Bank Name',
                  labelStyle: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cera-Bold',
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40)),
                ),
                keyboardType: TextInputType.name,
              ),
              SizedBox(height: 10),
              const Text(
                'GST Number',
                style: TextStyle(fontSize: 14, fontFamily: 'Cera-Bold'),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _gstNumberController,
                decoration: InputDecoration(
                  labelText: 'Enter GST Number',
                  labelStyle: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cera-Bold',
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40)),
                ),
                keyboardType: TextInputType.name,
              ),
              SizedBox(height: 10),
              const Text(
                'Gpay UPI',
                style: TextStyle(fontSize: 14, fontFamily: 'Cera-Bold'),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _gpayUpiController,
                decoration: InputDecoration(
                  labelText: 'Enter Gpay UPI',
                  labelStyle: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cera-Bold',
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40)),
                ),
                keyboardType: TextInputType.name,
              ),
              SizedBox(height: 10),
              const Text(
                'PhonePe UPI',
                style: TextStyle(fontSize: 14, fontFamily: 'Cera-Bold'),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _phonePeUpiController,
                decoration: InputDecoration(
                  labelText: 'Enter PhonePe UPI',
                  labelStyle: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cera-Bold',
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40)),
                ),
                keyboardType: TextInputType.name,
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
