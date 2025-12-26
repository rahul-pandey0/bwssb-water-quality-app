import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';
import 'drawer_menu.dart';
import '../widgets/wqms_app_bar.dart';
import '../widgets/page_heading.dart';

class AddStpScreen extends StatefulWidget {
  const AddStpScreen({super.key});

  @override
  State<AddStpScreen> createState() => _AddStpScreenState();
}

class _AddStpScreenState extends State<AddStpScreen> {
  bool loading = true;
  bool showTable = false;
  bool saving = false;

  List<dynamic> stpList = [];
  List<dynamic> parameters = [];

  int? selectedStpId;
  String? result;

  DateTime? analysisStart;
  DateTime? analysisEnd;
  DateTime? sampleDate;

  String sampleId = '';

  final Map<String, String> values = {};
  final Map<String, String> remarks = {};

  @override
  void initState() {
    super.initState();
    _loadStp();
  }

  // ================= HELPERS =================

  String _fmt(DateTime d) => DateFormat('yyyy-MM-dd').format(d);

  void _msg(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  // ================= API =================

  Future<void> _loadStp() async {
    final data = await ApiService.getStpList();
    setState(() {
      stpList = data;
      loading = false;
    });
  }

  Future<void> _addData() async {
    if (selectedStpId == null ||
        analysisStart == null ||
        analysisEnd == null ||
        sampleDate == null) {
      _msg('Please fill all fields');
      return;
    }

    setState(() => loading = true);

    parameters = await ApiService.getStpParameters();
    sampleId = await ApiService.generateSampleId(selectedStpId!);

    setState(() {
      showTable = true;
      loading = false;
    });
  }

  Future<void> _save() async {
    if (result == null) {
      _msg('Please select result');
      return;
    }

    setState(() => saving = true);

    final payload = _buildParameterString();

    await ApiService.saveStpData(
      data: {
        "STPId": selectedStpId,
        "SampleDate": _fmt(sampleDate!),
        "AnalysisStartDate": _fmt(analysisStart!),
        "AnalysisCompleteDate": _fmt(analysisEnd!),
        "Latitude": "0",
        "Longitude": "0",
        "ParameterData": payload,
        "Result": result,
        "Laboratory": "0",
        "DataLive": 0,
        "SampleIdText": sampleId,
        "ReferenceSampleId": 0,
      },
    );

    setState(() {
      saving = false;
      showTable = false;
      values.clear();
      remarks.clear();
    });

    _msg('STP Data saved successfully');
  }

  // ================= PARAM STRING =================

  String _buildParameterString() {
    final buffer = <String>[];

    for (final p in parameters) {
      final key = "STP${selectedStpId}_${p['i_ParameterId']}";
      final v = values[key] ?? '';
      final r = remarks[key] ?? '';
      buffer.add("${key}_${v}_$r");
    }

    return buffer.join(',');
  }

  // ================= UI =================

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          drawer: const AppDrawer(),
          appBar: const WqmsAppBar(),
          body: loading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      const PageHeading(
                        title: 'Add STP Water Quality Data',
                      ),
                      _headerCard(),
                      _dateCard(),
                      if (showTable) _sampleIdCard(),
                      if (showTable) _parameterTable(),
                      if (showTable) _resultCard(),
                      if (showTable)
                        ElevatedButton(
                          onPressed: saving ? null : _save,
                          child: const Text('SAVE'),
                        ),
                    ],
                  ),
                ),
        ),
        if (saving)
          Container(
            color: Colors.black26,
            child: const Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }

  // ================= WIDGETS =================

  Widget _headerCard() => Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: DropdownButtonFormField<int>(
            decoration: const InputDecoration(labelText: 'STP NAME'),
            value: selectedStpId,
            items: stpList
                .map((e) => DropdownMenuItem<int>(
                      value: e['i_STPId'],
                      child: Text(e['s_STPName']),
                    ))
                .toList(),
            onChanged: (v) => setState(() => selectedStpId = v),
          ),
        ),
      );

  Widget _dateCard() => Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              _dateField(
                  'A.N START DATE', analysisStart, (d) => analysisStart = d),
              _dateField(
                  'A.N COMPLETE DATE', analysisEnd, (d) => analysisEnd = d),
              _dateField('SAMPLE DATE', sampleDate, (d) => sampleDate = d),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _addData,
                child: const Text('ADD DATA'),
              ),
            ],
          ),
        ),
      );

  Widget _sampleIdCard() => Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Sample Id : $sampleId',
              style: const TextStyle(fontSize: 15),
            ),
          ),
        ),
      );

  Widget _resultCard() => Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: DropdownButtonFormField<String>(
            decoration: const InputDecoration(labelText: 'RESULT'),
            value: result,
            items: const [
              DropdownMenuItem(value: 'SPP', child: Text('SPP')),
              DropdownMenuItem(value: 'NSPP', child: Text('NSPP')),
            ],
            onChanged: (v) => setState(() => result = v),
          ),
        ),
      );

  // Widget _parameterTable() => Card(
  //       child: SingleChildScrollView(
  //         scrollDirection: Axis.horizontal,
  //         child: DataTable(
  //           columns: const [
  //             DataColumn(label: Text('ID')),
  //             DataColumn(label: Text('Parameter')),
  //             DataColumn(label: Text('Value')),
  //             DataColumn(label: Text('Remarks')),
  //             DataColumn(label: Text('Desired')),
  //             DataColumn(label: Text('Permissible')),
  //           ],
  //           rows: parameters.map((p) {
  //             final key = "STP${selectedStpId}_${p['i_ParameterId']}";

  //             return DataRow(cells: [
  //               DataCell(Text(p['i_ParameterId'].toString())),
  //               DataCell(Text(p['s_ParameterName'])),
  //               DataCell(TextField(
  //                 onChanged: (v) => values[key] = v,
  //               )),
  //               DataCell(TextField(
  //                 onChanged: (v) => remarks[key] = v,
  //               )),
  //               DataCell(Text(p['f_DesiredLimit'].toString())),
  //               DataCell(Text(p['f_PermissibleLimit'].toString())),
  //             ]);
  //           }).toList(),
  //         ),
  //       ),
  //     );


Widget _parameterTable() => Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: MaterialStateProperty.all(
            Colors.blue.shade50,
          ),
          headingTextStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
          dataRowHeight: 44, // ✅ compact height
          headingRowHeight: 42,
          columns: const [
            DataColumn(label: Text('ID')),
            DataColumn(label: Text('Parameter')),
            DataColumn(label: Text('Value')),
            DataColumn(label: Text('Remarks')),
            DataColumn(label: Text('Desired')),
            DataColumn(label: Text('Permissible')),
          ],
          rows: List.generate(parameters.length, (index) {
            final p = parameters[index];
            final key = "STP${selectedStpId}_${p['i_ParameterId']}";

            return DataRow(
              color: MaterialStateProperty.resolveWith<Color?>(
                (states) =>
                    index.isEven ? Colors.white : Colors.grey.shade100,
              ),
              cells: [
                // ID
                DataCell(
                  Text(
                    p['i_ParameterId'].toString(),
                    style: const TextStyle(fontSize: 12),
                  ),
                ),

                // Parameter Name
                DataCell(
                  SizedBox(
                    width: 170,
                    child: Text(
                      p['s_ParameterName'],
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ),

                // Value (compact input)
                DataCell(
                  SizedBox(
                    width: 90,
                    height: 36,
                    child: TextField(
                      onChanged: (v) => values[key] = v,
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                        border: OutlineInputBorder(),
                      ),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ),

                // Remarks (compact input)
                DataCell(
                  SizedBox(
                    width: 120,
                    height: 36,
                    child: TextField(
                      onChanged: (v) => remarks[key] = v,
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                        border: OutlineInputBorder(),
                      ),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ),

                // Desired Limit
                DataCell(
                  Text(
                    p['f_DesiredLimit']?.toString() ?? '-',
                    style: const TextStyle(fontSize: 12),
                  ),
                ),

                // Permissible Limit
                DataCell(
                  Text(
                    p['f_PermissibleLimit']?.toString() ?? '-',
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );

  // ================= DATE FIELD (FIXED FLOATING LABEL) =================

  Widget _dateField(
    String label,
    DateTime? d,
    Function(DateTime) cb,
  ) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: TextFormField(
          readOnly: true,
          decoration: InputDecoration(
            labelText: label,
            suffixIcon: const Icon(Icons.calendar_today),
          ),
          controller: TextEditingController(
            text: d == null ? '' : _fmt(d),
          ),
          onTap: () => _pickDate(cb),
        ),
      );

  Future<void> _pickDate(Function(DateTime) cb) async {
    final d = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDate: DateTime.now(),
    );
    if (d != null) setState(() => cb(d));
  }
}
