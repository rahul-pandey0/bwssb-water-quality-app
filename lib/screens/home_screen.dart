import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';
import '../widgets/loading_overlay.dart';
import 'drawer_menu.dart';
import '../widgets/wqms_app_bar.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool loading = true;

  DateTime? startDate;
  DateTime? endDate;

  List<dynamic> serviceStations = [];
  final Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
    final today = DateTime.now();
    startDate = today;
    endDate = today;
    fetchData();
  }

  String _fmt(DateTime d) =>
      DateFormat('yyyy-MM-dd').format(d);

  // ===================== FETCH DATA =====================
  Future<void> fetchData() async {
    setState(() => loading = true);

    try {
      final data = await ApiService.getGisView(
        startDate: _fmt(startDate!),
        endDate: _fmt(endDate!),
      );

      markers.clear();

      for (var item in data) {
        markers.add(
          Marker(
            markerId:
                MarkerId(item['s_ServiceStationName']),
            position: LatLng(
              double.parse(item['s_Latitude']),
              double.parse(item['s_Longitude']),
            ),
            infoWindow: InfoWindow(
              title: item['s_ServiceStationName'],
            ),
          ),
        );
      }

      setState(() {
        serviceStations = data;
      });
    } catch (_) {
      _showMsg('Failed to load GIS data');
    }

    setState(() => loading = false);
  }

  // ===================== DATE PICKER =====================
  Future<void> _pickDate(bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        isStart ? startDate = picked : endDate = picked;
      });
    }
  }

  bool _validate() {
    if (startDate == null) {
      _showMsg('Please select start date');
      return false;
    }
    if (endDate == null) {
      _showMsg('Please select end date');
      return false;
    }
    if (endDate!.isBefore(startDate!)) {
      _showMsg('End date must be after start date');
      return false;
    }
    return true;
  }

  void _showMsg(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  // ===================== UI =====================
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          drawer: const AppDrawer(),
          // appBar: AppBar(
          //   backgroundColor: Colors.white,
          //   elevation: 0,
          //   iconTheme:
          //       const IconThemeData(color: Colors.black),
          //   title: const Text(
          //     'WQMS – GIS View',
          //     style: TextStyle(
          //       color: Colors.blue,
          //       fontWeight: FontWeight.bold,
          //     ),
          //   ),
          // ),
            appBar: const WqmsAppBar(),
          body: Column(
            children: [
              // ===================== DATE FILTER =====================
              Padding(
                padding: const EdgeInsets.all(12),
                child: Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            _dateField(
                              label: 'START DATE',
                              date: startDate,
                              onTap: () => _pickDate(true),
                            ),
                            const SizedBox(width: 10),
                            _dateField(
                              label: 'END DATE',
                              date: endDate,
                              onTap: () => _pickDate(false),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () {
                              if (_validate()) {
                                fetchData();
                              }
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                  color: Colors.blue),
                            ),
                            child: const Text(
                              'REFRESH',
                              style:
                                  TextStyle(color: Colors.blue),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ===================== MAP =====================
              Expanded(
                child: GoogleMap(
                  initialCameraPosition:
                      const CameraPosition(
                    target:
                        LatLng(12.971599, 77.594566),
                    zoom: 10,
                  ),
                  markers: markers,
                ),
              ),
            ],
          ),
        ),

        // ===================== LOADER =====================
        LoadingOverlay(show: loading),
      ],
    );
  }

  // ===================== DATE FIELD =====================
Widget _dateField({
  required String label,
  required DateTime? date,
  required VoidCallback onTap,
}) {
  return Expanded(
    child: InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          suffixIcon: const Icon(Icons.calendar_today),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        ),
        child: Text(
          date == null ? 'Select date' : _fmt(date),
          style: const TextStyle(fontSize: 15),
        ),
      ),
    ),
  );
}

}
