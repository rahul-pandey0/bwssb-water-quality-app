// import 'package:flutter/material.dart';
// import '../session/session_manager.dart';

// class WqmsAppBar extends StatefulWidget implements PreferredSizeWidget {
//   const WqmsAppBar({super.key});

//   @override
//   State<WqmsAppBar> createState() => _WqmsAppBarState();

//   @override
//   Size get preferredSize => const Size.fromHeight(60);
// }

// class _WqmsAppBarState extends State<WqmsAppBar> {
//   String username = '';

//   @override
//   void initState() {
//     super.initState();
//     _loadUser();
//   }

//   Future<void> _loadUser() async {
//     final name = await SessionManager.getUsername();
//     setState(() {
//       username = name ?? '';
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       backgroundColor: const Color(0xFF42B3FA),
//       elevation: 0,
//       iconTheme: const IconThemeData(color: Colors.white),
//       titleSpacing: 0,
//       title: Row(
//         children: [
//           Image.asset(
//             'assets/images/bwssblogodash.png',
//             height: 32,
//           ),
//           const SizedBox(width: 8),
//           // const Text(
//           //   'WQMS',
//           //   style: TextStyle(
//           //     color: Colors.white,
//           //     fontWeight: FontWeight.bold,
//           //   ),
//           // ),
//         ],
//       ),
//       actions: [
//         if (username.isNotEmpty)
//           Padding(
//             padding: const EdgeInsets.only(right: 12),
//             child: Center(
//               child: Text(
//                 username,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//           ),
//         TextButton.icon(
//           onPressed: () async {
//             await SessionManager.logout();
//             Navigator.pushNamedAndRemoveUntil(
//               context,
//               '/splash',
//               (route) => false,
//             );
//           },
//           icon: const Icon(Icons.logout, color: Colors.white),
//           label: const Text(
//             '',
//             style: TextStyle(color: Colors.white),
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import '../session/session_manager.dart';

class WqmsAppBar extends StatefulWidget implements PreferredSizeWidget {
  const WqmsAppBar({Key? key}) : super(key: key);

  @override
  State<WqmsAppBar> createState() => _WqmsAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(60);
}

class _WqmsAppBarState extends State<WqmsAppBar> {
  String username = '';

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  /// ✅ Web-safe async call
  Future<void> _loadUser() async {
    final name = await SessionManager.getUsername();

    if (!mounted) return; // 🔥 REQUIRED for Flutter Web

    setState(() {
      username = name ?? '';
    });
  }

  /// ✅ Logout handler
  Future<void> _logout(BuildContext context) async {
    await SessionManager.logout();

    if (!mounted) return;

    Navigator.pushNamedAndRemoveUntil(
      context,
      '/splash', // ⚠️ Make sure this route exists
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF42B3FA),
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.white),
      titleSpacing: 0,

      /// ---------- TITLE ----------
      title: Row(
        children: [
          Image.asset(
            'assets/images/bwssblogodash.png',
            height: 32,

            /// ✅ Prevents Web crash if asset missing
            errorBuilder: (context, error, stackTrace) {
              return const Icon(
                Icons.water_drop,
                color: Colors.white,
                size: 28,
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),

      /// ---------- ACTIONS ----------
      actions: [
        if (username.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Center(
              child: Text(
                username,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

        IconButton(
          tooltip: 'Logout',
          onPressed: () => _logout(context),
          icon: const Icon(Icons.logout, color: Colors.white),
        ),
      ],
    );
  }
}

