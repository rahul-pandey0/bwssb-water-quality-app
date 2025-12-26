import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../widgets/app_drawer.dart';
import '../widgets/bwssb_logo.dart';
import 'water_quality_samples_screen.dart';
import 'login_screen1.dart';
import 'sample_collection_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            onPressed: () => Scaffold.of(context).openDrawer(),
            icon: Image.asset(
              'assets/images/menu.png',
              width: 24,
              height: 24,
              color: const Color(0xFF2196F3),
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.menu,
                  color: Color(0xFF2196F3),
                );
              },
            ),
          ),
        ),
        actions: [
          Consumer<AuthService>(
            builder: (context, authService, child) {
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Center(
                  child: Text(
                    'Welcome, ${authService.userName ?? 'User'}',
                    style: const TextStyle(
                      color: Color(0xFF2196F3),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Column(
          children: [
            // Top Section with BWSSB Logo and Title
            Container(
              padding: const EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 20),
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Row(
                children: [
                  // BWSSB Logo
                  const BWSSBLogo.dashboard(),
                  const SizedBox(width: 16),
                  // Title Text
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bangalore Water Supply and Sewerage Board',
                          style: TextStyle(
                            color: Color.fromRGBO(21, 10, 9, 1),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'ಬೆಂಗಳೂರು ಜಲ ಮಂಡಳಿ ಮತ್ತು ಒಳಚರಂಡಿ ಮಂಡಳಿ',
                          style: TextStyle(
                            // color: Colors.grey,
                            color: Color.fromRGBO(33, 150, 243, 1),
                            fontSize: 12,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Main Content with Curved Design
            Expanded(
              child: Stack(
                children: [
                  // Background with curves
                  CustomPaint(
                    painter: CurvedBackgroundPainter(),
                    size: Size.infinite,
                  ),
                  
                  // Content
                  Column(
                    children: [
                      const SizedBox(height: 100),
                      
                      // BWSSB Login Button
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Container(
                          width: double.infinity,
                          height: 45,
                          decoration: BoxDecoration(
                            color: const Color(0xFF4FC3F7),
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginScreen1(),
                                  ),
                                );
                              },
                              borderRadius: BorderRadius.circular(8),
                              child: const Center(
                                child: Text(
                                  'BWSSB Login',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 180),
                      
                      // Title and Subtitle
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: Column(
                          children: [
                            Text(
                              'Water Quality Monitoring System',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                height: 1.3,
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              'Delivering Hygienic and Safe Water for the city of Bengaluru',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const Spacer(),
                      
                      // Sample Collection Button
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: BWSSBIconButton.serviceStation(
                          label: 'Sample Collection',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SampleCollectionScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // View Water Quality Data Button
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: BWSSBIconButton.waterQuality(
                          label: 'View Water Quality Data',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const WaterQualitySamplesScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                      
                      const Spacer(),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CurvedBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF2196F3)
      ..style = PaintingStyle.fill;

    final path = Path();

    // Move start point higher (smaller value = higher on screen)
    path.moveTo(0, size.height * 0.25); // previously 0.45

    // Control point for the curve (y-value controls height)
    path.quadraticBezierTo(
      size.width * 0.15,
      size.height * 0.45, // previously 0.5
      size.width,
      size.height * 0.20, // adjust end of curve
    );

    // Fill bottom
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}