import 'package:apsfllmo/screens/additionalservices/addonpackages_screen.dart';
import 'package:apsfllmo/screens/additionalservices/advancebulkrenew_screen.dart';
import 'package:apsfllmo/screens/additionalservices/box_exchange.dart';
import 'package:apsfllmo/screens/additionalservices/bulkrenew_screen.dart';
import 'package:apsfllmo/screens/additionalservices/packagechange_screen.dart';
import 'package:apsfllmo/screens/additionalservices/pon_change/pon_change.dart';
import 'package:apsfllmo/screens/additionalservices/ponconnectionstatus_screen.dart';
import 'package:apsfllmo/screens/additionalservices/renew2.dart';
import 'package:apsfllmo/screens/additionalservices/selfkycdocument_screen.dart';
import 'package:apsfllmo/screens/additionalservices/termination_request/terminated_cafs_list.dart';
import 'package:apsfllmo/screens/homescreen/home_screen.dart';
import 'package:apsfllmo/screens/subscriber_update_otp_verification/subscriber_update_otp_verification.dart';
import 'package:apsfllmo/utils/pallete.dart';
import 'package:apsfllmo/widgets/additional_services_widgets.dart';
import 'package:flutter/material.dart';

class AdditionalservicesScreen extends StatefulWidget {
  const AdditionalservicesScreen({super.key});

  @override
  State<AdditionalservicesScreen> createState() =>
      _AdditionalservicesScreenState();
}

class _AdditionalservicesScreenState extends State<AdditionalservicesScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final List<Map<String, dynamic>> _serviceItems = [
    {
      "text": "Renew",
      "color": const Color.fromARGB(255, 199, 237, 190),
      "short_text": "RS",
      "widget": const Renew2(),
    },
    {
      "text": "Box Exchange",
      "color": const Color.fromARGB(255, 189, 239, 238),
      "short_text": "BE",
      "widget": const BoxExchange(),
    },
    {
      "text": "PON Change",
      "color": const Color.fromARGB(255, 212, 209, 254),
      "short_text": "PC",
      "widget": const PonChange(),
    },
    {
      "text": "Termination Request",
      "color": const Color.fromARGB(255, 255, 174, 173),
      "short_text": "TR",
      "widget": const TerminatedCafsList(),
    },
    {
      "text": "Subscriber Update OTP Verification",
      "color": const Color.fromARGB(255, 199, 237, 190),
      "short_text": "OTP",
      "widget": const SubscriberUpdateOtpVerification(),
    },
    {
      "text": "Add On Packages",
      "color": const Color.fromARGB(255, 255, 211, 254),
      "short_text": "AO",
      "widget": const AddonpackagesScreen(),
    },
    {
      "text": "Available PON Info",
      "color": const Color.fromARGB(255, 212, 209, 254),
      "short_text": "AP",
      "widget": const PonconnectionstatusScreen(),
    },
    {
      "text": "Package Plan Change",
      "color": const Color.fromARGB(255, 199, 237, 190),
      "short_text": "PCK",
      "widget": const PackagechangeScreen(),
    },
    {
      "text": "Advance Bulk Renew(Active)",
      "color": const Color.fromARGB(255, 162, 111, 110),
      "short_text": "ABR",
      "widget": const AdvancebulkrenewScreen(),
    },
    {
      "text": "Bulk Renew(Suspended)",
      "color": const Color.fromARGB(255, 255, 174, 173),
      "short_text": "BR",
      "widget": const BulkrenewScreen(),
    },
    {
      "text": "Subscriber KYC Document Upload",
      "color": const Color.fromARGB(255, 157, 204, 248),
      "short_text": "KYC",
      "widget": null,
    },
    {
      "text": "Self KYC Document Upload",
      "color": const Color.fromARGB(255, 254, 212, 252),
      "short_text": "SKYC",
      "widget": const SelfkycdocumentScreen(),
    },
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _insertItems();
    });
  }

  void _insertItems() {
    Future.delayed(const Duration(milliseconds: 100), () {
      for (int i = 0; i < _serviceItems.length; i++) {
        Future.delayed(Duration(milliseconds: i * 100), () {
          _listKey.currentState?.insertItem(i);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'CPE Inventory',
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
                  builder: (BuildContext context) => const HomeScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: AnimatedList(
        key: _listKey,
        initialItemCount: 0,
        itemBuilder: (context, index, animation) {
          return _buildItem(context, _serviceItems[index], animation);
        },
      ),
    );
  }

  Widget _buildItem(BuildContext context, Map<String, dynamic> item,
      Animation<double> animation) {
    return SlideTransition(
      position: animation.drive(
        Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).chain(
          CurveTween(
            curve: Curves.easeInOut,
          ),
        ),
      ),
      child: AdditinalServicesWidgets(
        text: item['text'],
        color: item['color'],
        short_text: item['short_text'],
        onTap: () {
          if (item['widget'] != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => item['widget'],
              ),
            );
          }
        },
      ),
    );
  }
}
