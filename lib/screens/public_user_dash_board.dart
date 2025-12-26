import 'package:bwssb_app/session/session_manager.dart';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../widgets/loading_overlay.dart';

class MainDashboardScreen extends StatefulWidget {
  const MainDashboardScreen({super.key});

  @override
  State<MainDashboardScreen> createState() =>
      _MainDashboardScreenState();
}

class _MainDashboardScreenState
    extends State<MainDashboardScreen> {
  bool loading = true;
  Map<String, dynamic>? summary;
  String username = 'Guest';

  @override
  void initState() {
    super.initState();
    _loadDashboard();
  }

  // ================= LOAD DASHBOARD =================
  Future<void> _loadDashboard() async {
    try {
      setState(() => loading = true);

      await ApiService.login(
        username: 'public',
        password: 'dw\$83v\$!D*z2WvAC',
      );

      final user = await SessionManager.getUsername();
      final data = await ApiService.getSampleSummary();

      setState(() {
        username = user ?? 'Guest';
        summary = data;
        loading = false;
      });
    } catch (_) {
      loading = false;
      _msg('Failed to load dashboard');
    }
  }

  void _msg(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.black),
            title: const Text(
              'Water Quality Monitoring System',
              style: TextStyle(color: Colors.blue),
            ),
            actions: [
              Row(
                children: [
                  Text(username,
                      style: const TextStyle(color: Colors.black)),
                  IconButton(
                    icon: const Icon(Icons.logout),
                    onPressed: _logout,
                  ),
                ],
              )
            ],
          ),
          body: loading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      _banner(),
                      const SizedBox(height: 8),
                      _mapButton(),
                      const SizedBox(height: 8),

                      _section(
                        title: 'TODAYS SAMPLES',
                        data: summary!['Daily'][0],
                        enableTap: true,
                      ),
                      _section(
                        title: 'MONTHLY SAMPLES',
                        data: summary!['Monthly'][0],
                        enableTap: false,
                      ),
                      _section(
                        title: 'YEARLY SAMPLES',
                        data: summary!['Yearly'][0],
                        enableTap: false,
                      ),
                    ],
                  ),
                ),
        ),
        LoadingOverlay(show: loading),
      ],
    );
  }

  // ================= BANNER =================
  Widget _banner() => Column(
        children: [
          Image.asset('assets/images/dash.png'),
          Image.asset(
            'assets/images/water2.png',
            height: 80,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ],
      );

  // ================= MAP BUTTON (CLICKABLE) =================
  Widget _mapButton() => SizedBox(
        width: double.infinity,
        height: 42,
        child: ElevatedButton.icon(
          onPressed: () => Navigator.pushNamed(context, '/map'),
          icon: const Icon(Icons.map, size: 18),
          label: const Text('VIEW MAPVIEW'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
          ),
        ),
      );

  // ================= SECTION =================
  Widget _section({
    required String title,
    required Map<String, dynamic> data,
    required bool enableTap,
  }) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    fontSize: 15, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),

            Row(
              children: [
                _miniCard(
                  icon: 'assets/images/servicestation.png',
                  count:
                      data['i_ServiceStation_${_suffix(title)}'],
                  label: 'Service Station',
                  onTap: enableTap
                      ? () => Navigator.pushNamed(
                          context, '/servicestationreportpublic')
                      : null,
                ),
                _miniCard(
                  icon: 'assets/images/wtp.png',
                  count: data['i_WTP_${_suffix(title)}'],
                  label: 'WTP',
                  onTap: enableTap
                      ? () => Navigator.pushNamed(
                          context, '/wtpreportpublic')
                      : null,
                ),
                _miniCard(
                  icon: 'assets/images/stp.png',
                  count: data['i_STP_${_suffix(title)}'],
                  label: 'STP',
                  onTap: enableTap
                      ? () => Navigator.pushNamed(
                          context, '/stpreportpublic')
                      : null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ================= MINI CARD =================
  Widget _miniCard({
    required String icon,
    required dynamic count,
    required String label,
    VoidCallback? onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: Colors.black12),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(icon, height: 36),
                const SizedBox(height: 4),
                Text(
                  count.toString(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 11),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _suffix(String title) {
    if (title.contains('TODAY')) return 'Daily';
    if (title.contains('MONTH')) return 'Monthly';
    return 'Yearly';
  }

  // ================= LOGOUT =================
  Future<void> _logout() async {
    await SessionManager.logout();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/login');
  }
}
