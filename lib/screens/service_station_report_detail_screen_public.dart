import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../widgets/loading_overlay.dart';

class ServiceStationReportDetailScreenPublic extends StatefulWidget {
  final String sampleId;

  const ServiceStationReportDetailScreenPublic({
    super.key,
    required this.sampleId,
  });

  @override
  State<ServiceStationReportDetailScreenPublic> createState() =>
      _ServiceStationReportDetailScreenState();
}

class _ServiceStationReportDetailScreenState
    extends State<ServiceStationReportDetailScreenPublic> {
  bool loading = true;

  List<dynamic> sampleInfo = [];
  List<dynamic> parameters = [];

  @override
  void initState() {
    super.initState();
    _loadDetail();
  }

  // ===================== API =====================
  Future<void> _loadDetail() async {
    try {
      final data =
          await ApiService.getServiceStationReportDetail(widget.sampleId);

      setState(() {
        sampleInfo = data['Sample'] ?? [];
        parameters = data['SampleData'] ?? [];
      });
    } catch (_) {
      _showMsg('Failed to load report detail');
    }

    setState(() => loading = false);
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
          appBar: AppBar(
            title: const Text('Service Station Report Detail'),
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
                // ===================== SAMPLE INFO =====================
                if (sampleInfo.isNotEmpty) _buildSampleInfo(),

                const SizedBox(height: 12),

                // ===================== PARAMETER HEADER =====================
                _tableHeader(),

                // ===================== PARAMETER LIST =====================
                ...parameters.map((p) => _parameterRow(p)).toList(),
              ],
            ),
          ),
        ),

        // ===================== LOADER =====================
        LoadingOverlay(show: loading),
      ],
    );
  }

  // ===================== SAMPLE INFO =====================
  Widget _buildSampleInfo() {
    final s = sampleInfo.first;
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            _infoRow('Address', s['s_Address']),
            _infoRow('Result', s['s_Result']),
            _infoRow('Latitude', s['s_Latitude']),
            _infoRow('Longitude', s['s_Longitude']),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(value?.toString() ?? ''),
          ),
        ],
      ),
    );
  }

  // ===================== TABLE HEADER =====================
  Widget _tableHeader() {
    return Container(
      padding: const EdgeInsets.all(8),
      color: Colors.lightBlue.shade200,
      child: Row(
        children: const [
          Expanded(
            flex: 4,
            child: Text(
              'Parameter Name',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              'Value',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              'Remarks',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // ===================== PARAMETER ROW =====================
  Widget _parameterRow(dynamic p) {
    final value = p['f_ParameterValue'];
    final isHigh =
        value != null && double.tryParse(value.toString()) != null
            ? double.parse(value.toString()) > 7
            : false;

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(p['s_ParameterName'] ?? ''),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value?.toString() ?? '',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isHigh ? Colors.red : Colors.green,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(p['s_Remarks'] ?? ''),
          ),
        ],
      ),
    );
  }
}
