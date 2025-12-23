import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/add_sample_service_station_screen.dart';
import 'screens/add_sample_wtp_screen.dart';
import 'screens/add_sample_stp_screen.dart';
import 'screens/map_view_screen.dart';
import 'screens/sample_collection_screen.dart';
import 'screens/water_quality_samples_screen.dart';
import 'screens/reports_screen.dart';
import 'screens/dashboard_screens.dart';
import 'services/auth_service.dart';

void main() {
  runApp(const BWSSBApp());
}

class BWSSBApp extends StatelessWidget {
  const BWSSBApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
      ],
      child: MaterialApp(
        title: 'BWSSB Water Quality Monitoring',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: const Color(0xFF2196F3),
          scaffoldBackgroundColor: Colors.grey[50],
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF2196F3),
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2196F3),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF2196F3)),
            ),
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/home': (context) => const DashboardScreen(),
          '/dashboard': (context) => const DashboardScreen(),
          '/login': (context) => const LoginScreen(),
          '/add-sample-service-station': (context) => const AddSampleServiceStationScreen(),
          '/add-sample-wtp': (context) => const AddSampleWTPScreen(),
          '/add-sample-stp': (context) => const AddSampleSTPScreen(),
          '/map-view': (context) => const MapViewScreen(),
          '/sample-collection': (context) => const SampleCollectionScreen(),
          '/water-quality-samples': (context) => const WaterQualitySamplesScreen(),
          '/reports-service-station': (context) => const ReportsScreen(type: 'Service Station'),
          '/reports-wtp': (context) => const ReportsScreen(type: 'WTP'),
          '/reports-stp': (context) => const ReportsScreen(type: 'STP'),
          '/dashboard-service-stations': (context) => const DashboardServiceStationsScreen(),
          '/dashboard-wtp': (context) => const DashboardWTPScreen(),
          '/dashboard-stp': (context) => const DashboardSTPScreen(),
        },
      ),
    );
  }
}