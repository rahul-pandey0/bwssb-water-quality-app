// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import '../services/api_service.dart';
// import 'drawer_menu.dart';
// import '../widgets/wqms_app_bar.dart';
// import '../widgets/page_heading.dart';



// class AddWtpScreen extends StatefulWidget {
//   const AddWtpScreen({super.key});

//   @override
//   State<AddWtpScreen> createState() => _AddWtpScreenState();
// }

// class _AddWtpScreenState extends State<AddWtpScreen> {
//   bool loading = true;
//   bool showTable = false;
//   bool saving = false;

//   List<dynamic> wtpList = [];
//   List<dynamic> parameters = [];

//   int? selectedWtpId;
//   String? laboratory;
//   String? result;

//   DateTime? analysisStart;
//   DateTime? analysisEnd;
//   DateTime? sampleDate;

//   String sampleId = '';

//   final Map<String, String> values = {};
//   final Map<String, String> remarks = {};

//   @override
//   void initState() {
//     super.initState();
//     _loadWtp();
//   }

//   // ================= HELPERS =================

//   String _fmt(DateTime d) => DateFormat('yyyy-MM-dd').format(d);

//   void _msg(String msg) {
//     ScaffoldMessenger.of(context)
//         .showSnackBar(SnackBar(content: Text(msg)));
//   }

//   // ================= API =================

//   Future<void> _loadWtp() async {
//     final data = await ApiService.getWtpList();
//     setState(() {
//       wtpList = data;
//       loading = false;
//     });
//   }

//   Future<void> _addData() async {
//     if (selectedWtpId == null ||
//         laboratory == null ||
//         analysisStart == null ||
//         analysisEnd == null ||
//         sampleDate == null) {
//       _msg('Please fill all fields');
//       return;
//     }

//     setState(() => loading = true);

//     parameters = await ApiService.getWtpParameters();
//     sampleId = await ApiService.generateSampleIdWTP(
//       id: selectedWtpId!,
//       type: 1,
//     );

//     setState(() {
//       showTable = true;
//       loading = false;
//     });
//   }

//   Future<void> _save() async {
//     if (result == null) {
//       _msg('Please select result');
//       return;
//     }

//     setState(() => saving = true);

//     final payload = _buildParameterString();

//     await ApiService.saveWtpData(
//       data: {
//         "WTPId": selectedWtpId,
//         "SampleDate": _fmt(sampleDate!),
//         "AnalysisStartDate": _fmt(analysisStart!),
//         "AnalysisCompleteDate": _fmt(analysisEnd!),
//         "Latitude": "0",
//         "Longitude": "0",
//         "ParameterData": payload,
//         "Result": result,
//         "Laboratory": laboratory,
//         "DataLive": 0,
//         "SampleIdText": sampleId,
//         "ReferenceSampleId": 0,
//       },
//     );

//     setState(() {
//       saving = false;
//       showTable = false;
//       values.clear();
//       remarks.clear();
//     });

//     _msg('WTP Data saved successfully');
//   }

//   // ================= PARAM STRING =================

//   String _buildParameterString() {
//     final int stage = selectedWtpId!;
//     final buffer = <String>[];

//     for (final p in parameters) {
//       final key = "WTP${stage}_${p['i_ParameterId']}";
//       final v = values[key] ?? '';
//       final r = remarks[key] ?? '';
//       buffer.add("${key}_${v}_$r");
//     }

//     return buffer.join(',');
//   }

//   // ================= UI =================

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Scaffold(
//            drawer: const AppDrawer(),
//               appBar: const WqmsAppBar(),
//           //appBar: AppBar(title: const Text('Add WTP Water Quality Data')),
//           body: loading
//               ? const Center(child: CircularProgressIndicator())
//               : SingleChildScrollView(
//                   padding: const EdgeInsets.all(12),
//                   child: Column(
//                     children: [
//                        const PageHeading(
//       title: 'Add WTP Water Quality Data',
//     ),
               
//                       _headerCard(),
//                       _dateCard(),
//                       if (showTable) _sampleIdCard(),
//                       if (showTable) _parameterTable(),
//                       if (showTable) _resultCard(),
//                       if (showTable)
//                         ElevatedButton(
//                           onPressed: saving ? null : _save,
//                           child: const Text('SAVE'),
//                         ),
//                     ],
//                   ),
//                 ),
//         ),
//         if (saving)
//           Container(
//             color: Colors.black26,
//             child: const Center(child: CircularProgressIndicator()),
//           ),
//       ],
//     );
//   }

//   // ================= CARDS =================

//   Widget _headerCard() => Card(
//         child: Padding(
//           padding: const EdgeInsets.all(12),
//           child: Column(
//             children: [
//               DropdownButtonFormField<int>(
//                 decoration: const InputDecoration(
//                   labelText: 'WTP NAME',
//                   border: OutlineInputBorder(),
//                   isDense: true,
//                 ),
//                 value: selectedWtpId,
//                 items: wtpList
//                     .map((e) => DropdownMenuItem<int>(
//                           value: e['i_WTPId'],
//                           child: Text(e['s_WTPName']),
//                         ))
//                     .toList(),
//                 onChanged: (v) => setState(() => selectedWtpId = v),
//               ),
//               const SizedBox(height: 12),
//               DropdownButtonFormField<String>(
//                 decoration: const InputDecoration(
//                   labelText: 'LABORATORY',
//                   border: OutlineInputBorder(),
//                   isDense: true,
//                 ),
//                 value: laboratory,
//                 items: const [
//                   DropdownMenuItem(value: '0', child: Text('TK Halli')),
//                   DropdownMenuItem(value: '1', child: Text('Harohalli')),
//                   DropdownMenuItem(value: '2', child: Text('Tataguni')),
//                 ],
//                 onChanged: (v) => setState(() => laboratory = v),
//               ),
//             ],
//           ),
//         ),
//       );

//   Widget _dateCard() => Card(
//         child: Padding(
//           padding: const EdgeInsets.all(12),
//           child: Column(
//             children: [
//               _dateRow('A.N START DATE', analysisStart,
//                   (d) => analysisStart = d),
//               _dateRow('A.N COMPLETE DATE', analysisEnd,
//                   (d) => analysisEnd = d),
//               _dateRow('SAMPLE DATE', sampleDate,
//                   (d) => sampleDate = d),
//               const SizedBox(height: 16),
//               Center(
//                 child: ElevatedButton(
//                   onPressed: _addData,
//                   child: const Text('ADD DATA'),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );

//   Widget _sampleIdCard() => Card(
//         child: Padding(
//           padding: const EdgeInsets.all(12),
//           child: Align(
//             alignment: Alignment.centerLeft,
//             child: Text(
//               'Sample Id : $sampleId',
//               style: const TextStyle(fontSize: 15),
//             ),
//           ),
//         ),
//       );

//   Widget _resultCard() => Card(
//         child: Padding(
//           padding: const EdgeInsets.all(12),
//           child: DropdownButtonFormField<String>(
//             decoration: const InputDecoration(
//               labelText: 'RESULT',
//               border: OutlineInputBorder(),
//               isDense: true,
//             ),
//             value: result,
//             items: const [
//               DropdownMenuItem(value: 'SPP', child: Text('SPP')),
//               DropdownMenuItem(value: 'NSPP', child: Text('NSPP')),
//             ],
//             onChanged: (v) => setState(() => result = v),
//           ),
//         ),
//       );

//   Widget _parameterTable() => Card(
//         child: SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//           child: DataTable(
//             columns: const [
//               DataColumn(label: Text('ID')),
//               DataColumn(label: Text('Parameter')),
//               DataColumn(label: Text('Value')),
//               DataColumn(label: Text('Remarks')),
//               DataColumn(label: Text('Unit')),
//               DataColumn(label: Text('Limit')),
//             ],
//             rows: parameters.map((p) {
//               final key = "WTP${selectedWtpId}_${p['i_ParameterId']}";
//               return DataRow(cells: [
//                 DataCell(Text(p['i_ParameterId'].toString())),
//                 DataCell(Text(p['s_ParameterName'])),
//                 DataCell(TextField(
//                   onChanged: (v) => values[key] = v,
//                 )),
//                 DataCell(TextField(
//                   onChanged: (v) => remarks[key] = v,
//                 )),
//                 DataCell(Text(p['s_Unit'].toString())),
//                 DataCell(Text(p['f_DesiredLimit'].toString())),
//               ]);
//             }).toList(),
//           ),
//         ),
//       );

//   // ================= DATE FIELD =================

//   Widget _dateRow(
//     String label,
//     DateTime? date,
//     Function(DateTime) onPicked,
//   ) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6),
//       child: InkWell(
//         onTap: () => _pickDate(onPicked),
//         child: IgnorePointer(
//           child: TextFormField(
//             controller: TextEditingController(
//               text: date == null ? '' : _fmt(date),
//             ),
//             decoration: InputDecoration(
//               labelText: label,
//               border: const OutlineInputBorder(),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> _pickDate(Function(DateTime) cb) async {
//     final d = await showDatePicker(
//       context: context,
//       firstDate: DateTime(2020),
//       lastDate: DateTime.now(),
//       initialDate: DateTime.now(),
//     );
//     if (d != null) setState(() => cb(d));
//   }
// }

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';
import 'drawer_menu.dart';
import '../widgets/wqms_app_bar.dart';
import '../widgets/page_heading.dart';

class AddWtpScreen extends StatefulWidget {
  const AddWtpScreen({super.key});

  @override
  State<AddWtpScreen> createState() => _AddWtpScreenState();
}

class _AddWtpScreenState extends State<AddWtpScreen> {
  bool loading = true;
  bool showTable = false;
  bool saving = false;

  List<dynamic> wtpList = [];
  List<dynamic> parameters = [];

  int? selectedWtpId;
  int? selectedStage; // ✅ IMPORTANT
  String? laboratory;
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
    _loadWtp();
  }

  // ================= HELPERS =================

  String _fmt(DateTime d) => DateFormat('yyyy-MM-dd').format(d);

  void _msg(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  // ================= API =================

  Future<void> _loadWtp() async {
    final data = await ApiService.getWtpList();
    setState(() {
      wtpList = data;
      loading = false;
    });
  }

  Future<void> _addData() async {
    if (selectedWtpId == null ||
        selectedStage == null ||
        laboratory == null ||
        analysisStart == null ||
        analysisEnd == null ||
        sampleDate == null) {
      _msg('Please fill all fields');
      return;
    }

    setState(() => loading = true);

    parameters = await ApiService.getWtpParameters();

    sampleId = await ApiService.generateSampleIdWTP(
      id: selectedWtpId!,
      type: 1,
    );

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

    await ApiService.saveWtpData(
      data: {
        "WTPId": selectedWtpId,
        "SampleDate": _fmt(sampleDate!),
        "AnalysisStartDate": _fmt(analysisStart!),
        "AnalysisCompleteDate": _fmt(analysisEnd!),
        "Latitude": "0",
        "Longitude": "0",
        "ParameterData": _buildParameterString(),
        "Result": result,
        "Laboratory": laboratory,
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

    _msg('WTP Data saved successfully');
  }

  // ================= PARAM STRING (RN EXACT) =================

  String _buildParameterString() {
    final List<String> buffer = [];

    for (final p in parameters) {
      final key = "WTP${selectedStage}_${p['i_ParameterId']}";
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
                        title: 'Add WTP Water Quality Data',
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

  // ================= CARDS =================

  Widget _headerCard() => Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(
                  labelText: 'WTP NAME',
                  border: OutlineInputBorder(),
                ),
                value: selectedWtpId,
                items: wtpList
                    .map((e) => DropdownMenuItem<int>(
                          value: e['i_WTPId'],
                          child: Text(e['s_WTPName']),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => selectedWtpId = v),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(
                  labelText: 'WTP STAGE',
                  border: OutlineInputBorder(),
                ),
                value: selectedStage,
                items: const [
                  DropdownMenuItem(value: 1, child: Text('Stage 1')),
                  DropdownMenuItem(value: 2, child: Text('Stage 2')),
                  DropdownMenuItem(value: 3, child: Text('Stage 3')),
                  DropdownMenuItem(value: 4, child: Text('Stage 4 - Phase 1')),
                  DropdownMenuItem(value: 5, child: Text('Stage 4 - Phase 2')),
                ],
                onChanged: (v) => setState(() => selectedStage = v),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'LABORATORY',
                  border: OutlineInputBorder(),
                ),
                value: laboratory,
                items: const [
                  DropdownMenuItem(value: '0', child: Text('TK Halli')),
                  DropdownMenuItem(value: '1', child: Text('Harohalli')),
                  DropdownMenuItem(value: '2', child: Text('Tataguni')),
                ],
                onChanged: (v) => setState(() => laboratory = v),
              ),
            ],
          ),
        ),
      );

  Widget _dateCard() => Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              _dateRow('A.N START DATE', analysisStart,
                  (d) => analysisStart = d),
              _dateRow('A.N COMPLETE DATE', analysisEnd,
                  (d) => analysisEnd = d),
              _dateRow('SAMPLE DATE', sampleDate,
                  (d) => sampleDate = d),
              const SizedBox(height: 16),
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
            child: Text('Sample Id : $sampleId'),
          ),
        ),
      );

  Widget _resultCard() => Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'RESULT',
              border: OutlineInputBorder(),
            ),
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
  //             DataColumn(label: Text('Unit')),
  //             DataColumn(label: Text('Limit')),
  //           ],
  //           rows: parameters.map((p) {
  //             final key = "WTP${selectedStage}_${p['i_ParameterId']}";
  //             return DataRow(cells: [
  //               DataCell(Text(p['i_ParameterId'].toString())),
  //               DataCell(Text(p['s_ParameterName'])),
  //               DataCell(TextField(
  //                 onChanged: (v) => values[key] = v,
  //               )),
  //               DataCell(TextField(
  //                 onChanged: (v) => remarks[key] = v,
  //               )),
  //               DataCell(Text(p['s_Unit'].toString())),
  //               DataCell(Text(p['f_DesiredLimit'].toString())),
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
          dataRowHeight: 44, // ✅ compact row height
          headingRowHeight: 42,
          columns: const [
            DataColumn(label: Text('ID')),
            DataColumn(label: Text('Parameter')),
            DataColumn(label: Text('Value')),
            DataColumn(label: Text('Remarks')),
            DataColumn(label: Text('Unit')),
            DataColumn(label: Text('Limit')),
          ],
          rows: List.generate(parameters.length, (index) {
            final p = parameters[index];
            final key = "WTP${selectedStage}_${p['i_ParameterId']}";

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
                    width: 160,
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

                // Unit
                DataCell(
                  Text(
                    p['s_Unit']?.toString() ?? '-',
                    style: const TextStyle(fontSize: 12),
                  ),
                ),

                // Desired Limit
                DataCell(
                  Text(
                    p['f_DesiredLimit']?.toString() ?? '-',
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );

  Widget _dateRow(
    String label,
    DateTime? date,
    Function(DateTime) onPicked,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: InkWell(
        onTap: () => _pickDate(onPicked),
        child: IgnorePointer(
          child: TextFormField(
            controller: TextEditingController(
              text: date == null ? '' : _fmt(date),
            ),
            decoration: InputDecoration(
              labelText: label,
              border: const OutlineInputBorder(),
            ),
          ),
        ),
      ),
    );
  }

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
