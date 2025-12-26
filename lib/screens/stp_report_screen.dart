import 'package:bwssb_app/screens/stp_report_detail_screen.dart';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../widgets/loading_overlay.dart';

class StpReportScreen extends StatefulWidget {
  const StpReportScreen({super.key});

  @override
  State<StpReportScreen> createState() => _StpReportScreenState();
}

class _StpReportScreenState extends State<StpReportScreen> {
  DateTime? startDate;
  DateTime? endDate;

  bool loading = false;
  bool showEmpty = false;

  List<dynamic> stpList = [];
  List<dynamic> reports = [];
  int? selectedStpId;

  @override
  void initState() {
    super.initState();
    loadStp();
  }

  // ===================== LOAD STP =====================
  Future<void> loadStp() async {
    final data = await ApiService.getStpList();
    setState(() => stpList = data);
  }

  // ===================== DATE PICKER =====================
  Future<void> pickDate(bool isStart) async {
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

  // ===================== FETCH REPORT =====================
  Future<void> getReport() async {
    if (selectedStpId == null) {
      showMsg('Please select STP');
      return;
    }
    if (startDate == null || endDate == null) {
      showMsg('Please select start & end date');
      return;
    }

    setState(() {
      loading = true;
      showEmpty = false;
    });

    try {
      final data = await ApiService.getStpReports(
        stpId: selectedStpId!,
        startDate: startDate!.toIso8601String().split('T')[0],
        endDate: endDate!.toIso8601String().split('T')[0],
      );

      setState(() {
        reports = data;
        showEmpty = data.isEmpty;
      });
    } catch (_) {
      showMsg('Failed to load STP reports');
    }

    setState(() => loading = false);
  }

  void showMsg(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  // ===================== UI =====================
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text('Water Quality Report for STP'),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                // ===================== FILTER CARD =====================
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      children: [
                        // ===================== STP DROPDOWN =====================
                        DropdownButtonFormField<int>(
                          value: selectedStpId,
                          decoration: const InputDecoration(
                            labelText: 'STP NAME',
                            border: OutlineInputBorder(),
                          ),
                          items: stpList
                              .map(
                                (e) => DropdownMenuItem<int>(
                                  value: e['i_STPId'],
                                  child: Text(e['s_STPName']),
                                ),
                              )
                              .toList(),
                          onChanged: (v) =>
                              setState(() => selectedStpId = v),
                        ),

                        const SizedBox(height: 12),

                        // ===================== FLOATING DATE FIELDS =====================
                        Row(
                          children: [
                            _floatingDateField(
                              label: 'REPORT START DATE',
                              date: startDate,
                              onTap: () => pickDate(true),
                            ),
                            const SizedBox(width: 10),
                            _floatingDateField(
                              label: 'REPORT END DATE',
                              date: endDate,
                              onTap: () => pickDate(false),
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),

                        // ===================== SUBMIT BUTTON =====================
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: getReport,
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            child: const Text(
                              'SUBMIT',
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                if (showEmpty)
                  const Text(
                    'No data reported',
                    style: TextStyle(color: Colors.red),
                  ),

                // ===================== RESULT LIST =====================
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: reports.length,
                  itemBuilder: (_, i) {
                    final r = reports[i];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        title: Text(
                          r['s_STPName'],
                          style: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          r['dt_SampleDate'].replaceAll('T', ' '),
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => StpReportDetailScreen(
                                sampleId:
                                    r['i_SampleId'].toString(),
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

  // ===================== FLOATING DATE FIELD WIDGET =====================
  Widget _floatingDateField({
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
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
          ),
          child: Text(
            date == null
                ? 'Select date'
                : date.toIso8601String().split('T')[0],
            style: const TextStyle(fontSize: 15),
          ),
        ),
      ),
    );
  }
}
