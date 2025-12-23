import 'package:flutter/material.dart';
import '../widgets/bwssb_logo.dart';

class MapViewScreen extends StatefulWidget {
  const MapViewScreen({Key? key}) : super(key: key);

  @override
  State<MapViewScreen> createState() => _MapViewScreenState();
}

class _MapViewScreenState extends State<MapViewScreen> {
  String _selectedLayer = 'Service Stations';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BWSSB Map View'),
        backgroundColor: const Color(0xFF2196F3),
        foregroundColor: Colors.white,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                _selectedLayer = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'Service Stations', child: Text('Service Stations')),
              const PopupMenuItem(value: 'WTP', child: Text('Water Treatment Plants')),
              const PopupMenuItem(value: 'STP', child: Text('Sewage Treatment Plants')),
              const PopupMenuItem(value: 'All', child: Text('Show All')),
            ],
            icon: const Icon(Icons.layers),
          ),
        ],
      ),
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF2196F3).withOpacity(0.1),
            ),
            child: Row(
              children: [
                const BWSSBLogo.dashboard(size: 40),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Bangalore Water Infrastructure Map',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2196F3),
                        ),
                      ),
                      Text(
                        'Current Layer: $_selectedLayer',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Image.asset(
                  'assets/images/supply.png',
                  width: 30,
                  height: 30,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.map,
                      color: Color(0xFF2196F3),
                      size: 30,
                    );
                  },
                ),
              ],
            ),
          ),
          
          // Map placeholder
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                image: const DecorationImage(
                  image: NetworkImage('https://maps.googleapis.com/maps/api/staticmap?center=12.9716,77.5946&zoom=10&size=800x600&maptype=roadmap&key=YOUR_API_KEY'),
                  fit: BoxFit.cover,
                  onError: _mapErrorWidget,
                ),
              ),
              child: Stack(
                children: [
                  // Map placeholder content
                  const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.map,
                          size: 80,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Bangalore Water Infrastructure Map',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Interactive map showing water treatment facilities,\nservice stations, and distribution network',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Legend
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Legend',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _buildLegendItem(Icons.location_on, 'Service Stations', Colors.red),
                          _buildLegendItem(Icons.business, 'Water Treatment Plants', Colors.blue),
                          _buildLegendItem(Icons.cleaning_services, 'Sewage Treatment Plants', Colors.purple),
                          _buildLegendItem(Icons.water, 'Water Distribution', Colors.cyan),
                        ],
                      ),
                    ),
                  ),
                  
                  // Sample location markers
                  if (_selectedLayer == 'Service Stations' || _selectedLayer == 'All') ...[
                    _buildMapMarker(100, 150, 'HSR Layout', Colors.red),
                    _buildMapMarker(200, 200, 'Koramangala', Colors.red),
                    _buildMapMarker(150, 300, 'Indiranagar', Colors.red),
                  ],
                  
                  if (_selectedLayer == 'WTP' || _selectedLayer == 'All') ...[
                    _buildMapMarker(250, 100, 'TK Halli WTP', Colors.blue),
                    _buildMapMarker(300, 250, 'Harohalli WTP', Colors.blue),
                  ],
                  
                  if (_selectedLayer == 'STP' || _selectedLayer == 'All') ...[
                    _buildMapMarker(180, 350, 'Bellandur STP', Colors.purple),
                    _buildMapMarker(120, 250, 'Vrishabhavathi STP', Colors.purple),
                  ],
                ],
              ),
            ),
          ),
          
          // Info panel
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildInfoCard('Service Stations', '150+', Colors.red),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildInfoCard('WTPs', '5', Colors.blue),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildInfoCard('STPs', '7', Colors.purple),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add location functionality
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Location tracking enabled'),
              backgroundColor: Colors.blue,
            ),
          );
        },
        backgroundColor: const Color(0xFF2196F3),
        child: const Icon(Icons.my_location, color: Colors.white),
      ),
    );
  }

  static void _mapErrorWidget(Object exception, StackTrace? stackTrace) {
    // Handle map loading error
  }

  Widget _buildLegendItem(IconData icon, String label, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildMapMarker(double left, double top, String label, Color color) {
    return Positioned(
      left: left,
      top: top,
      child: GestureDetector(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Selected: $label'),
              duration: const Duration(seconds: 1),
            ),
          );
        },
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: color),
              ),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
            Icon(
              Icons.location_on,
              color: color,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String count, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            count,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}