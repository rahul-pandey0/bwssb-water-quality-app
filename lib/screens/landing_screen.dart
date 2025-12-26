
import 'package:flutter/material.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // ================= LOGO =================
          Padding(
            padding: const EdgeInsets.only(top: 60),
            child: Image.asset(
              'assets/images/bwssblogodash.png',
              height: 60,
              width: double.infinity,
              fit: BoxFit.contain,
            ),
          ),

          // ================= IMAGE + LOGIN BUTTON =================
          Stack(
            children: [
              Image.asset(
                'assets/images/dash3.png',
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
              ),

              Positioned(
                top: 45,
                left: 2,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: 45,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.login, color: Colors.white, size: 18),
                    label: const Text(
                      'BWSSB Login',
                      style: TextStyle(fontSize: 14),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF42B3FA),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                  ),
                ),
              ),
            ],
          ),

          // ================= VIEW WATER QUALITY BUTTON =================
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.science, color: Colors.white),
              label: const Text(
                'View Water Quality Data',
                style: TextStyle(fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFA8072),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/maindashboard');
              },
            ),
          ),

          // ================= BLUE BACKGROUND BELOW =================
          Expanded(
            child: Container(
              width: double.infinity,
              color: const Color(0xFF42B3FA),
            ),
          ),
        ],
      ),
    );
  }
}
