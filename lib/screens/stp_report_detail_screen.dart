import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../widgets/loading_overlay.dart';

class StpReportDetailScreen extends StatefulWidget {
  final String sampleId;
  const StpReportDetailScreen({super.key, required this.sampleId});

  @override
  State<StpReportDetailScreen> createState() =>
      _StpReportDetailScreenState();
}

class _StpReportDetailScreenState extends State<StpReportDetailScreen> {
  bool loading = true;
  Map<String, dynamic>? data;

  @override
  void initState() {
    super.initState();
    loadDetail();
  }

  Future<void> loadDetail() async {
    final res =
        await ApiService.getStpReportDetail(widget.sampleId);
    setState(() {
      data = res;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(title: const Text('STP Report Detail')),
          body: data == null
              ? const SizedBox()
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      /// SAMPLE INFO
                      Card(
                        child: ListTile(
                          title: Text(
                              data!['Sample'][0]['s_LaboratoryName']),
                          subtitle:
                              Text(data!['Sample'][0]['s_Result']),
                        ),
                      ),

                      const SizedBox(height: 10),

                      /// PARAMETERS
                      ...data!['SampleData'].map<Widget>((p) => Card(
                            child: ListTile(
                              title: Text(p['s_ParameterName']),
                              subtitle: Text(p['s_Remarks']),
                              trailing: Text(
                                p['f_ParameterValue'].toString(),
                                style: TextStyle(
                                    color: (p['f_ParameterValue'] ?? 0) > 7
                                        ? Colors.red
                                        : Colors.green,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ))
                    ],
                  ),
                ),
        ),
        LoadingOverlay(show: loading),
      ],
    );
  }
}
