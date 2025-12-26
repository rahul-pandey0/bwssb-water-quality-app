import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/splash_screen.dart';
// import 'screens/login_screen1.dart';
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
import 'screens/landing_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/service_station_report_screen.dart';
import 'screens/wtp_report_screen.dart';
import 'screens/stp_report_screen.dart';
import 'screens/add_service_station_screen.dart';
import 'screens/add_wtp_screen.dart';
import 'screens/add_stp_screen.dart';
import 'screens/public_user_dash_board.dart';
import 'screens/view_map_public.dart';
import 'screens/service_station_report_screen_public.dart';
import 'screens/wtp_report_screen_public.dart';

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
        initialRoute: '/splash',
        routes: {
          '/splash': (context) => const SplashScreen(),
          '/': (context) => const LandingScreen(),
          '/home': (context) => const HomeScreen(),
          // '/home': (context) => const DashboardScreen(),
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

    '/maindashboard': (context) => const MainDashboardScreen(),


          
  // Water Quality
  '/serviceStations': (context) => const ServiceStationScreen(),
   '/wtp': (context) => const AddWtpScreen(),
   '/stp': (context) => const AddStpScreen(),



           // // Reports
   '/reportServiceStations': (context) => const ServiceStationReportScreen(),
   '/reportWtp': (context) => const WtpReportScreen(),
   '/reportStp': (context) => const StpReportScreen(),

   // Public User Dashboard
    '/map': (context) => const ViewMapPublic(),
    '/servicestationreportpublic': (context) => const ServiceStationReportScreenPublic(),
    '/wtpreportpublic': (context) => const WtpReportScreenPublic(),
        },
      ),
    );
  }
}