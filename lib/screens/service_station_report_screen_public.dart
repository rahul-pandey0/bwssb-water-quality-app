import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../widgets/loading_overlay.dart';
// import 'drawer_menu.dart';
import 'service_station_report_detail_screen_public.dart';
import '../widgets/wqms_app_bar.dart';
import '../widgets/page_heading.dart';

class ServiceStationReportScreenPublic extends StatefulWidget {
  const ServiceStationReportScreenPublic({super.key});

  @override
  State<ServiceStationReportScreenPublic> createState() =>
      _ServiceStationReportScreenPublicState();
}

class _ServiceStationReportScreenPublicState
    extends State<ServiceStationReportScreenPublic> {
  DateTime? startDate;
  DateTime? endDate;

  bool loading = false;
  bool showEmpty = false;
  bool isClicked = false;

  List<dynamic> reports = [];

  // ===================== INIT =====================
  @override
  void initState() {
    super.initState();
    final today = DateTime.now();
    startDate = today;
    endDate = today;
  }

  // ===================== DATE PICKER =====================
  Future<void> _pickDate(bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDate: isStart ? startDate! : endDate!,
    );

    if (picked != null) {
      setState(() {
        isStart ? startDate = picked : endDate = picked;
      });
    }
  }

  // ===================== VALIDATION =====================
  bool _validate() {
    if (endDate!.isBefore(startDate!)) {
      _showMsg('End date must be after start date');
      return false;
    }
    return true;
  }

  // ===================== GET REPORT =====================
  Future<void> _getReport() async {
    if (!_validate()) return;

    setState(() {
      loading = true;
      showEmpty = false;
      isClicked = true;
      reports.clear();
    });

    try {
      final data = await ApiService.getServiceStationReports(
        startDate: _fmt(startDate!),
        endDate: _fmt(endDate!),
      );

      setState(() {
        reports = data;
        showEmpty = data.isEmpty;
      });
    } catch (_) {
      _showMsg('Failed to load report');
    }

    setState(() => loading = false);
  }

  void _showMsg(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  String _fmt(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  // ===================== UI =====================
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
        //  drawer: const AppDrawer(),
          // appBar: AppBar(
          //   backgroundColor: Colors.white,
          //   elevation: 0,
          //   iconTheme: const IconThemeData(color: Colors.black),
          //   title: const Text(
          //     'Water Quality Report for Service Stations',
          //     style: TextStyle(
          //       color: Colors.blue,
          //       fontWeight: FontWeight.bold,
          //     ),
          //   ),
          // ),
          appBar: const WqmsAppBar(),

          body: SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
    // ✅ REUSABLE PAGE HEADING
    const PageHeading(
      title: 'Water Quality Report for Service Stations',
    ),
               
                // ===================== DATE CARD =====================
                Card(
                  elevation: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            _dateField(
                              label: 'START DATE',
                              date: startDate!,
                              onTap: () => _pickDate(true),
                            ),
                            const SizedBox(width: 10),
                            _dateField(
                              label: 'END DATE',
                              date: endDate!,
                              onTap: () => _pickDate(false),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: _getReport,
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.blue),
                            ),
                            child: const Text(
                              'SUBMIT',
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // ===================== REPORT RANGE =====================
                if (isClicked && !showEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 4,
                    ),
                    child: Text(
                      'Report For : ${_fmt(startDate!)} To ${_fmt(endDate!)}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                // ===================== EMPTY =====================
                if (showEmpty)
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'There is no data reported',
                      style: TextStyle(color: Colors.red, fontSize: 16),
                    ),
                  ),

                // ===================== LIST =====================
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: reports.length,
                  itemBuilder: (_, i) {
                    final r = reports[i];
                    return Card(
                      child: ListTile(
                        title: Text(
                          r['s_ServiceStationName'] ?? '',
                          style: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(
                              r['s_Address'] ?? '',
                              style: const TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              r['dt_SampleDate'] ?? '',
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => ServiceStationReportDetailScreenPublic(
                                    sampleId: r['i_SampleId'].toString(),
                                  ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),

        // ===================== LOADER =====================
        LoadingOverlay(show: loading),
      ],
    );
  }

  // ===================== FLOATING DATE FIELD =====================
  Widget _dateField({
    required String label,
    required DateTime date,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            prefixIcon: const Icon(Icons.calendar_today),
          ),
          child: Text(_fmt(date), style: const TextStyle(fontSize: 15)),
        ),
      ),
    );
  }
}
