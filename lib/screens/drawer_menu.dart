import 'package:flutter/material.dart';
import '../session/session_manager.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: const Color(0xFF1E88E5),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // HEADER
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xFF1E88E5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/images/bwssblogodash.png',
                    height: 50,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'WQMS',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
//             DrawerHeader(
//   decoration: const BoxDecoration(color: Color(0xFF1E88E5)),
//   child: Center(
//     child: Text(
//       'Navigation',
//       style: TextStyle(
//         color: Colors.white,
//         fontSize: 18,
//         fontWeight: FontWeight.bold,
//       ),
//     ),
//   ),
// ),


            // HOME
            drawerItem(
              context,
              icon: Icons.home,
              title: 'Home',
              route: '/home',
            ),

            sectionTitle('Water Quality Data'),

            drawerItem(
              context,
              icon: Icons.factory,
              title: 'Service Stations',
              route: '/serviceStations',
            ),
            drawerItem(
              context,
              icon: Icons.water,
              title: 'WTP',
              route: '/wtp',
            ),
            drawerItem(
              context,
              icon: Icons.settings,
              title: 'STP',
              route: '/stp',
            ),

            const Divider(color: Colors.white70),

            sectionTitle('Reports'),

            drawerItem(
              context,
              icon: Icons.factory_outlined,
              title: 'Service Stations',
              route: '/reportServiceStations',
            ),
            drawerItem(
              context,
              icon: Icons.water_outlined,
              title: 'WTP',
              route: '/reportWtp',
            ),
            drawerItem(
              context,
              icon: Icons.settings_outlined,
              title: 'STP',
              route: '/reportStp',
            ),

            const Divider(color: Colors.white70),

            // LOGOUT
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.white),
              title: const Text(
                'Logout',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () async {
                await SessionManager.logout();
                Navigator.pushNamedAndRemoveUntil(
                    context, '/', (route) => false);
              },
            ),
          ],
        ),
      ),
    );
  }

  // Reusable drawer item
  Widget drawerItem(BuildContext context,
      {required IconData icon,
      required String title,
      required String route}) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      onTap: () {
        Navigator.pop(context); // close drawer
        Navigator.pushReplacementNamed(context, route);
      },
    );
  }

  // Section title widget
  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 0, 4),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import '../session/session_manager.dart';

// class AppDrawer extends StatelessWidget {
//   const AppDrawer({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: Container(
//         color: const Color(0xFF1E88E5),
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: [
//             // ================= HEADER =================
//             DrawerHeader(
//               decoration: const BoxDecoration(
//                 color: Color(0xFF1E88E5),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Image.asset(
//                     'assets/images/bwssblogodash.png',
//                     height: 50,
//                   ),
//                   const SizedBox(height: 10),
//                   const Text(
//                     'WQMS',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             // ================= HOME =================
//             drawerItem(
//               context,
//               icon: Icons.home,
//               title: 'Home',
//               route: '/home',
//             ),

//             // ================= WATER QUALITY (EXPANDABLE) =================
//             expandableSection(
//               title: 'Water Quality Data',
//               icon: Icons.water_drop,
//               children: [
//                 drawerItem(
//                   context,
//                   icon: Icons.factory,
//                   title: 'Service Stations',
//                   route: '/serviceStations',
//                 ),
//                 drawerItem(
//                   context,
//                   icon: Icons.water,
//                   title: 'WTP',
//                   route: '/wtp',
//                 ),
//                 drawerItem(
//                   context,
//                   icon: Icons.settings,
//                   title: 'STP',
//                   route: '/stp',
//                 ),
//               ],
//             ),

//             const Divider(color: Colors.white70),

//             // ================= REPORTS (EXPANDABLE) =================
//             expandableSection(
//               title: 'Reports',
//               icon: Icons.bar_chart,
//               children: [
//                 drawerItem(
//                   context,
//                   icon: Icons.factory_outlined,
//                   title: 'Service Stations',
//                   route: '/reportServiceStations',
//                 ),
//                 drawerItem(
//                   context,
//                   icon: Icons.water_outlined,
//                   title: 'WTP',
//                   route: '/reportWtp',
//                 ),
//                 drawerItem(
//                   context,
//                   icon: Icons.settings_outlined,
//                   title: 'STP',
//                   route: '/reportStp',
//                 ),
//               ],
//             ),

//             const Divider(color: Colors.white70),

//             // ================= LOGOUT =================
//             ListTile(
//               leading: const Icon(Icons.logout, color: Colors.white),
//               title: const Text(
//                 'Logout',
//                 style: TextStyle(color: Colors.white),
//               ),
//               onTap: () async {
//                 await SessionManager.logout();
//                 Navigator.pushNamedAndRemoveUntil(
//                   context,
//                   '/',
//                   (route) => false,
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // ================= REUSABLE DRAWER ITEM =================
//   Widget drawerItem(
//     BuildContext context, {
//     required IconData icon,
//     required String title,
//     required String route,
//   }) {
//     return ListTile(
//       dense: true,
//       leading: Icon(icon, color: Colors.white),
//       title: Text(
//         title,
//         style: const TextStyle(color: Colors.white),
//       ),
//       onTap: () {
//         Navigator.pop(context);
//         Navigator.pushReplacementNamed(context, route);
//       },
//     );
//   }

//   // ================= EXPANDABLE SECTION =================
//   Widget expandableSection({
//     required String title,
//     required IconData icon,
//     required List<Widget> children,
//   }) {
//     return Theme(
//       data: ThemeData().copyWith(
//         dividerColor: Colors.transparent,
//         splashColor: Colors.transparent,
//         highlightColor: Colors.transparent,
//       ),
//       child: ExpansionTile(
//         leading: Icon(icon, color: Colors.white),
//         title: Text(
//           title,
//           style: const TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         iconColor: Colors.white,
//         collapsedIconColor: Colors.white,
//         childrenPadding: const EdgeInsets.only(left: 16),
//         children: children,
//       ),
//     );
//   }
// }
