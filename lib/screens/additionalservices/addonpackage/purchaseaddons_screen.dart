import 'package:apsfllmo/screens/additionalservices/addonpackage/his_purchaseaddons_screen.dart';
import 'package:apsfllmo/screens/additionalservices/addonpackage/local_purchaseaddons_screen.dart';
import 'package:apsfllmo/screens/additionalservices/addonpackage/standard_purchaseaddons_screen.dart';
import 'package:apsfllmo/utils/pallete.dart';
import 'package:flutter/material.dart';

class PurchaseaddonsScreen extends StatefulWidget {
  const PurchaseaddonsScreen({super.key});

  @override
  State<PurchaseaddonsScreen> createState() => _PurchaseaddonsScreenState();
}

class _PurchaseaddonsScreenState extends State<PurchaseaddonsScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of main tabs
      child: Scaffold(
        bottomNavigationBar: Container(
          height: 20,
          color: Pallete.backgroundColor,
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'LMO2000825',
                style: TextStyle(fontSize: 12, fontFamily: 'Cera-Bold'),
              ),
              Text(
                'V 5.9',
                style: TextStyle(fontSize: 12, fontFamily: 'Cera-Bold'),
              ),
              Text(
                'Powered by Greenlantern IT Solutions @ BBNL',
                style: TextStyle(fontSize: 12, fontFamily: 'Cera-Bold'),
              ),
            ],
          ),
        ),
        appBar: AppBar(
          title: const Text(
            'Purchase Add On Package',
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'Cera-Bold',
              fontSize: 20,
            ),
          ),
          backgroundColor: Pallete.backgroundColor,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            Column(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.replay,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    // Navigator.of(context).pushReplacement(MaterialPageRoute(
                    //     builder: (context) =>  null));
                  },
                ),
              ],
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'IPTV'),
              Tab(text: 'HSI'),
            ],
            indicatorColor: Colors.black,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
          ),
        ),
        body: const TabBarView(
          children: [
            DefaultTabController(
              length: 2, // Number of child tabs in the first main tab
              child: Column(
                children: [
                  TabBar(
                    tabs: [
                      Tab(text: 'STANDARD'),
                      Tab(text: 'LOCAL'),
                    ],
                    indicatorColor: Colors.black,
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.grey,
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        Center(child: StandardPurchaseaddonsScreen()),
                        Center(child: LocalPurchaseAddonsScreen()),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Center(child: HisPurchaseaddonsScreen()),
          ],
        ),
      ),
    );
  }
}
