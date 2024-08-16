import 'package:apsfllmo/common/global_screen.dart';
import 'package:apsfllmo/screens/homescreen/home_screen.dart';
import 'package:apsfllmo/screens/navigation/Account_ledger.dart';
import 'package:apsfllmo/screens/navigation/prepaid_dashboard.dart';
import 'package:apsfllmo/screens/notificationscreen/bbnlnotifications_screen.dart';
import 'package:apsfllmo/utils/constants.dart';
import 'package:apsfllmo/utils/saveappdata.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../utils/pallete.dart';

class BbnlDrawerNavigationScreen extends StatefulWidget {
  const BbnlDrawerNavigationScreen({super.key});

  @override
  State<BbnlDrawerNavigationScreen> createState() =>
      _BbnlDrawerNavigationScreenState();
}

class _BbnlDrawerNavigationScreenState
    extends State<BbnlDrawerNavigationScreen> {
      final SaveAppData saveAppData = SaveAppData();
  Future<void> _showLogoutConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Row(
            children: [
              Icon(
                Icons.warning_rounded,
                size: 30,
                color: Color.fromARGB(136, 168, 168, 168),
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                'Logout',
                style: TextStyle(
                  fontFamily: 'Cera-Bold',
                ),
              ),
            ],
          ),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to logout ?',
                    style: TextStyle(
                      fontFamily: 'Cera-Bold',
                    )),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel',
                  style:
                      TextStyle(fontFamily: 'Cera-Bold', color: Colors.black)),
              onPressed: () {
                Navigator.of(context).pop(); // dismiss the dialog
              },
            ),
            TextButton(
              child: const Text('OK',
                  style:
                      TextStyle(fontFamily: 'Cera-Bold', color: Colors.black)),
              onPressed: () async {
                Navigator.of(context).pop(); // dismiss the dialog
                Constants.baseUrl="";
                Constants.splash_token="";
                saveAppData.save_flag_type("");


                final _storage = FlutterSecureStorage();
                await _storage.delete(
                    key: 'token'); // Remove token from storage
                await _storage.delete(
                    key: 'caf_id'); // Remove caf_id from storage
                await _storage.delete(
                    key: 'cstmr_nm'); // Remove cstmr_nm from storage
                await _storage.delete(
                    key: 'mbl_nu'); // Remove mbl_nu from storage
                await _storage.delete(
                    key:
                        'current_plan_id'); // Remove current_plan_id from storage
                await _storage.delete(
                    key: 'lmo_cd'); // Remove lmo_cd from storage
                await _storage.delete(
                    key: 'cstmr_id'); // Remove cstmr_id from storage
                await _storage.delete(
                    key:
                        'mdlwe_sbscr_id'); // Remove mdlwe_sbscr_id from storage
                await _storage.delete(
                    key: 'cartItems'); // Remove cartItems from storage
                await _storage.delete(
                    key: 'totalPrice'); // Remove totalPrice from storage
                Navigator.of(context)
                    .pushReplacement(MaterialPageRoute(builder: (context) {
                  return const GlobalScreen();
                }));
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const UserAccountsDrawerHeader(
            accountName: null,
            accountEmail: null,
            decoration: BoxDecoration(
              color: Pallete.backgroundColor,
              image: DecorationImage(
                image: AssetImage(
                    'assets/images/background/logo_bbnl_updated.png'),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.home,
              size: 30,
              color: Color.fromARGB(255, 78, 10, 141),
            ),
            title: const Text(
              'Home',
              style: TextStyle(fontFamily: 'Cera-Bold', fontSize: 15),
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return const HomeScreen();
              }));
            },
          ),
          Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.grey, // Adjust the color as needed
                  width: 0.5, // Adjust the width as needed
                ),
              ),
            ),
            child: ListTile(
              leading: const Icon(
                Icons.dashboard,
                size: 30,
                color: Color.fromARGB(255, 78, 10, 141),
              ),
              title: const Text(
                'Prepaid Dashboard',
                style: TextStyle(fontFamily: 'Cera-Bold', fontSize: 15),
              ),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return PrepaidDashboard();
                }));
              },
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.grey, // Adjust the color as needed
                  width: 0.5, // Adjust the width as needed
                ),
              ),
            ),
            child: ListTile(
              leading: const Icon(
                Icons.account_balance,
                size: 30,
                color: Color.fromARGB(255, 78, 10, 141),
              ),
              title: const Text(
                'Account Ledger',
                style: TextStyle(fontFamily: 'Cera-Bold', fontSize: 15),
              ),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return  AccountLedger();
                }));
              },
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.grey, // Adjust the color as needed
                  width: 0.5, // Adjust the width as needed
                ),
              ),
            ),
            child: ListTile(
              leading: const Icon(
                Icons.help_center,
                size: 30,
                color: Color.fromARGB(255, 78, 10, 141),
              ),
              title: const Text(
                'Complaints',
                style: TextStyle(fontFamily: 'Cera-Bold', fontSize: 15),
              ),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return const BbnlNotificationsScreen();
                }));
              },
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.grey, // Adjust the color as needed
                  width: 0.5, // Adjust the width as needed
                ),
              ),
            ),
            child: Container(
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.grey, // Adjust the color as needed
                    width: 0.05, // Adjust the width as needed
                  ),
                ),
              ),
              child: ListTile(
                leading: const Icon(
                  Icons.people,
                  size: 30,
                  color: Color.fromARGB(255, 78, 10, 141),
                ),
                title: const Text(
                  'Contacts',
                  style: TextStyle(fontFamily: 'Cera-Bold', fontSize: 15),
                ),
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return const BbnlNotificationsScreen();
                  }));
                },
              ),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.grey, // Adjust the color as needed
                  width: 0.5, // Adjust the width as needed
                ),
              ),
            ),
            child: ListTile(
              leading: const Icon(
                Icons.notifications,
                size: 30,
                color: Color.fromARGB(255, 78, 10, 141),
              ),
              title: const Text(
                'Notifications',
                style: TextStyle(fontFamily: 'Cera-Bold', fontSize: 15),
              ),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return const BbnlNotificationsScreen();
                }));
              },
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.grey, // Adjust the color as needed
                  width: 0.5, // Adjust the width as needed
                ),
              ),
            ),
            child: ListTile(
              leading: const Icon(
                Icons.phone_android,
                size: 30,
                color: Color.fromARGB(255, 78, 10, 141),
              ),
              title: const Text(
                'Change Phone Number',
                style: TextStyle(fontFamily: 'Cera-Bold', fontSize: 15),
              ),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return const BbnlNotificationsScreen();
                }));
              },
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.grey, // Adjust the color as needed
                  width: 0.5, // Adjust the width as needed
                ),
              ),
            ),
            child: ListTile(
              leading: const Icon(
                Icons.key,
                size: 30,
                color: Color.fromARGB(255, 78, 10, 141),
              ),
              title: const Text(
                'Password reset',
                style: TextStyle(fontFamily: 'Cera-Bold', fontSize: 15),
              ),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return const BbnlNotificationsScreen();
                }));
              },
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.grey, // Adjust the color as needed
                  width: 0.5, // Adjust the width as needed
                ),
              ),
            ),
            child: ListTile(
              leading: const Icon(
                Icons.logout,
                size: 30,
                color: Color.fromARGB(255, 78, 10, 141),
              ),
              title: const Text(
                'Logout',
                style: TextStyle(fontFamily: 'Cera-Bold', fontSize: 15),
              ),
              onTap: () async {
                await _showLogoutConfirmationDialog();
              },
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(width: 1),
              ),
            ),
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              children: [
                Container(
                  width: 240,
                  // alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(left: 18),
                  child: const Text(
                    'Version',
                    style: TextStyle(
                      fontFamily: 'Cera-Bold',
                      fontWeight: FontWeight.w900,
                      fontSize: 15,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: const Text(
                    '3.7',
                    style: TextStyle(
                      fontFamily: 'Cera-Bold',
                      fontWeight: FontWeight.w900,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
