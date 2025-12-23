import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../widgets/app_drawer.dart';
import '../widgets/bwssb_logo.dart';
import 'water_quality_samples_screen.dart';
import 'login_screen.dart';
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
                            color: Color(0xFF2196F3),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'ಬೆಂಗಳೂರು ಜಲ ಮಂಡಳಿ ಮತ್ತು ಒಳಚರಂಡಿ ಮಂಡಳಿ',
                          style: TextStyle(
                            color: Colors.grey,
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
                      const SizedBox(height: 40),
                      
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
                                    builder: (context) => const LoginScreen(),
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
                      
                      const SizedBox(height: 80),
                      
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
                            SizedBox(height: 8),
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
    final paint = Paint();
    
    // Main blue background
    paint.color = const Color(0xFF2196F3);
    final path = Path();
    
    // Start from top
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height * 0.7);
    
    // Create curve at the bottom
    path.quadraticBezierTo(
      size.width * 0.5, 
      size.height * 0.9, 
      0, 
      size.height * 0.7
    );
    
    path.close();
    canvas.drawPath(path, paint);
    
    // Lighter blue curve overlay
    paint.color = const Color(0xFF42A5F5);
    final path2 = Path();
    
    path2.moveTo(0, size.height * 0.2);
    path2.quadraticBezierTo(
      size.width * 0.3,
      size.height * 0.1,
      size.width,
      size.height * 0.25,
    );
    path2.lineTo(size.width, size.height * 0.65);
    path2.quadraticBezierTo(
      size.width * 0.7,
      size.height * 0.8,
      0,
      size.height * 0.6,
    );
    path2.close();
    canvas.drawPath(path2, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}