import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../widgets/loading_overlay.dart';

class WTPReportDetailScreen extends StatefulWidget {
  final String wtpName;
  final String sampleDate;

  const WTPReportDetailScreen({
    super.key,
    required this.wtpName,
    required this.sampleDate,
  });

  @override
  State<WTPReportDetailScreen> createState() =>
      _WTPReportDetailScreenState();
}

class _WTPReportDetailScreenState extends State<WTPReportDetailScreen> {
  bool loading = true;
  List<dynamic> sample = [];
  List<dynamic> parameters = [];

  @override
  void initState() {
    super.initState();
    _loadDetail();
  }

  Future<void> _loadDetail() async {
    try {
      final data = await ApiService.getWTPReportDetail(
        wtpName: widget.wtpName,
        sampleDate: widget.sampleDate,
      );

      setState(() {
        sample = data['Sample'] ?? [];
        parameters = data['SampleData'] ?? [];
      });
    } catch (_) {}

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text('WTP Report Detail'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close',
                    style: TextStyle(color: Colors.white)),
              )
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'WTP Name : ${widget.wtpName}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 12),

                if (sample.isNotEmpty)
                  Card(
                    child: ListTile(
                      title: Text(
                          sample.first['dt_SampleDate']
                              .replaceAll('T', ' ')),
                      subtitle:
                          Text('Result : ${sample.first['s_Result']}'),
                    ),
                  ),

                const SizedBox(height: 12),

                _tableHeader(),

                ...parameters.map(_parameterRow).toList(),
              ],
            ),
          ),
        ),

        LoadingOverlay(show: loading),
      ],
    );
  }

  Widget _tableHeader() {
    return Container(
      padding: const EdgeInsets.all(8),
      color: Colors.lightBlue.shade200,
      child: const Row(
        children: [
          Expanded(child: Text('Parameter Name')),
          Expanded(child: Text('Value')),
          Expanded(child: Text('Remarks')),
        ],
      ),
    );
  }

  Widget _parameterRow(dynamic p) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          Expanded(child: Text(p['s_ParameterName'] ?? '')),
          Expanded(
            child: Text(
              p['f_ParameterValue'].toString(),
              style: TextStyle(
                color: double.tryParse(
                            p['f_ParameterValue'].toString()) !=
                        null &&
                    double.parse(p['f_ParameterValue'].toString()) > 7
                    ? Colors.red
                    : Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(child: Text(p['s_Remarks'] ?? '')),
        ],
      ),
    );
  }
}
