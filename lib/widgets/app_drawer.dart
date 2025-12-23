import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'bwssb_logo.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    
    return Drawer(
      child: Column(
        children: [
          // Header
          Container(
            height: 200,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF2196F3),
                  Color(0xFF21CBF3),
                ],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const BWSSBLogo.menu(size: 60),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'BWSSB',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Water Quality Monitoring',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Text(
                      'Welcome, ${authService.userName ?? 'User'}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      authService.userRole ?? 'Field Officer',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Menu Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  icon: Icons.dashboard,
                  title: 'Dashboard',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/home');
                  },
                ),
                
                const Divider(height: 1),
                _buildDrawerHeader('Add Sample Data'),
                _buildDrawerItem(
                  icon: Icons.add_location,
                  title: 'Service Station',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/add-sample-service-station');
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.water_drop,
                  title: 'Water Treatment Plant',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/add-sample-wtp');
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.cleaning_services,
                  title: 'Sewage Treatment Plant',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/add-sample-stp');
                  },
                ),
                
                const Divider(height: 1),
                _buildDrawerHeader('Reports'),
                _buildDrawerItem(
                  icon: Icons.assessment,
                  title: 'Service Station Reports',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/reports-service-station');
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.bar_chart,
                  title: 'WTP Reports',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/reports-wtp');
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.show_chart,
                  title: 'STP Reports',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/reports-stp');
                  },
                ),
                
                const Divider(height: 1),
                _buildDrawerHeader('Dashboard Views'),
                _buildDrawerItem(
                  icon: Icons.map,
                  title: 'Map View',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/map-view');
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.location_on,
                  title: 'Service Stations',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/dashboard-service-stations');
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.business,
                  title: 'WTP Dashboard',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/dashboard-wtp');
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.factory,
                  title: 'STP Dashboard',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/dashboard-stp');
                  },
                ),
                
                const SizedBox(height: 20),
                const Divider(height: 1),
                
                // Logout
                _buildDrawerItem(
                  icon: Icons.logout,
                  title: 'Logout',
                  onTap: () async {
                    final authService = Provider.of<AuthService>(context, listen: false);
                    await authService.logout();
                    if (context.mounted) {
                      Navigator.pushReplacementNamed(context, '/login');
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader(String title) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.grey[600],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: textColor ?? Colors.grey[700],
        size: 20,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: textColor ?? Colors.grey[800],
          fontSize: 16,
        ),
      ),
      onTap: onTap,
      dense: true,
    );
  }
}