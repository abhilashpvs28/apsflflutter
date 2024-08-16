import 'package:flutter/material.dart';

class NodatafoundScreen extends StatefulWidget {
  const NodatafoundScreen({super.key});

  @override
  State<NodatafoundScreen> createState() => _NodatafoundScreenState();
}

class _NodatafoundScreenState extends State<NodatafoundScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.2,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.width * 0.3,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        'assets/images/background/data_error_image.png',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'No Data Found!',
                  style: TextStyle(
                    color: Color.fromARGB(255, 22, 116, 239),
                    fontFamily: 'Cera-Bold',
                    fontSize: 22,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
