import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../widgets/loading_overlay.dart';
import 'drawer_menu.dart';
import 'wtp_report_detail_screen.dart';

class WtpReportScreen extends StatefulWidget {
  const WtpReportScreen({super.key});

  @override
  State<WtpReportScreen> createState() => _WtpReportScreenState();
}

class _WtpReportScreenState extends State<WtpReportScreen> {
  DateTime? startDate;
  DateTime? endDate;

  bool loading = false;
  bool showEmpty = false;
  bool isClicked = false;

  List<dynamic> reports = [];

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

  // ===================== VALIDATION =====================
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
      final data = await ApiService.getWTPReports(
        startDate: _fmt(startDate!),
        endDate: _fmt(endDate!),
      );

      setState(() {
        reports = data;
        showEmpty = data.isEmpty;
      });
    } catch (_) {
      _showMsg('Failed to load WTP report');
    }

    setState(() => loading = false);
  }

  void _showMsg(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  String _fmt(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  // ===================== UI =====================
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          drawer: const AppDrawer(),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.black),
            title: const Text(
              'Water Quality Report for WTP',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ===================== DATE CARD =====================
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            _dateField(
                              label: 'REPORT START DATE',
                              date: startDate,
                              onTap: () => _pickDate(true),
                            ),
                            const SizedBox(width: 10),
                            _dateField(
                              label: 'REPORT END DATE',
                              date: endDate,
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
                              side:
                                  const BorderSide(color: Colors.blue),
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
                        vertical: 8, horizontal: 4),
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
                      style:
                          TextStyle(color: Colors.red, fontSize: 16),
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
                          r['s_WTPName'] ?? '',
                          style: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            r['dt_SampleDate']
                                .toString()
                                .replaceAll('T', ' '),
                            style:
                                const TextStyle(color: Colors.grey),
                          ),
                        ),
                        trailing:
                            const Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  WTPReportDetailScreen(
                                sampleDate:
                                    r['dt_SampleDate'],
                                wtpName:
                                    r['s_WTPName'],
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

  // ===================== DATE FIELD =====================
  Widget _dateField({
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 6),
          InkWell(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(
                  vertical: 12, horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    date == null
                        ? 'SELECT DATE'
                        : _fmt(date),
                  ),
                  const Icon(Icons.calendar_today, size: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
