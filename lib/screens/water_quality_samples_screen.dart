import 'package:flutter/material.dart';
import 'add_sample_screen.dart';

class WaterQualitySamplesScreen extends StatelessWidget {
  const WaterQualitySamplesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WQMS'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF2196F3),
              Color(0xFF21CBF3),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              const Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Water Quality Monitoring System',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // Map View Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Navigate to map view
                    },
                    icon: const Icon(Icons.map, color: Colors.white),
                    label: const Text(
                      'MAP VIEW',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1976D2),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Sample Categories
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Today's Samples
                        _buildSampleSection(
                          context,
                          title: "TODAY'S SAMPLES",
                          backgroundColor: Colors.blue[50]!,
                        ),
                        const SizedBox(height: 24),
                        // Monthly Samples
                        _buildSampleSection(
                          context,
                          title: "MONTHLY SAMPLES",
                          backgroundColor: Colors.green[50]!,
                        ),
                        const SizedBox(height: 24),
                        // Yearly Samples
                        _buildSampleSection(
                          context,
                          title: "YEARLY SAMPLES",
                          backgroundColor: Colors.orange[50]!,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSampleSection(
    BuildContext context, {
    required String title,
    required Color backgroundColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2196F3),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              _buildSampleTypeCard(
                context,
                icon: Icons.location_city,
                title: 'Service Station',
                sampleType: 'service_station',
              ),
              _buildSampleTypeCard(
                context,
                icon: Icons.water,
                title: 'WTP',
                sampleType: 'wtp',
              ),
              _buildSampleTypeCard(
                context,
                icon: Icons.cleaning_services,
                title: 'STP',
                sampleType: 'stp',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSampleTypeCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String sampleType,
  }) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              if (sampleType == 'service_station') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddSampleScreen(),
                  ),
                );
              } else {
                // Handle other sample types
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('$title samples coming soon!'),
                  ),
                );
              }
            },
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              child: Column(
                children: [
                  Icon(
                    icon,
                    size: 32,
                    color: const Color(0xFF2196F3),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}