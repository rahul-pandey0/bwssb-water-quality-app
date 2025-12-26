import 'package:bwssb_app/session/session_manager.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

import '../services/api_service.dart';
import '../models/service_station_model.dart';
import '../models/parameter_model.dart';
import '../validators/service_station_validator.dart';
import 'drawer_menu.dart';
import '../widgets/wqms_app_bar.dart';
import '../widgets/page_heading.dart';

class ServiceStationScreen extends StatefulWidget {
  const ServiceStationScreen({super.key});

  @override
  State<ServiceStationScreen> createState() => _ServiceStationScreenState();
}

class _ServiceStationScreenState extends State<ServiceStationScreen> {
  final _formKey = GlobalKey<FormState>();

  bool loading = true;
  bool saving = false;
  bool showTable = false;

  List<ServiceStation> stations = [];
  List<Parameter> parameters = [];

  String? division;
  String? subDivision;
  ServiceStation? station;
  String? laboratory;

  DateTime? sampleDate;
  DateTime? startDate;
  DateTime? endDate;

  double? lat;
  double? lng;

  final addressCtrl = TextEditingController();
  final rrCtrl = TextEditingController();

  String sampleId = '';

  @override
  void initState() {
    super.initState();
    loadStations();
  }

  Future<void> loadStations() async {
    stations = await ApiService.getServiceStations();
    setState(() => loading = false);
  }

  // ================= LOCATION =================
  Future<void> getLocation() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      showMsg('Location services are disabled');
      return;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      showMsg('Location permission denied');
      return;
    }

    final pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      lat = pos.latitude;
      lng = pos.longitude;
    });
  }

  // ================= ADD DATA =================
  Future<void> addData() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);

    parameters = await ApiService.getParameters();
    sampleId = await ApiService.generateSampleId(station!.id);

    setState(() {
      loading = false;
      showTable = true;
    });
  }

  // ================= SAVE =================
  Future<void> save() async {
    if (lat == null || lng == null) {
      showMsg('Failed to get location, try again');
      return;
    }

    final err = ServiceStationValidator.validateDates(startDate, endDate);
    if (err != null) {
      showMsg(err);
      return;
    }

    setState(() => saving = true);

    try {
      final now = DateTime.now();
      final time =
          '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

      final body = {
        "SampleIdText": sampleId,
        "SampleId": 0,
        "SampleDate": '${_fmt(sampleDate!)} $time',
        "AnalysisStartDate": '${_fmt(startDate!)} $time',
        "AnalysisCompleteDate": '${_fmt(endDate!)} $time',
        "Address": addressCtrl.text,
        "ServiceStationId": station!.id,
        "UserId": await SessionManager.getUsername(),
        "Latitude": lat.toString(),
        "Longitude": lng.toString(),
        "ParameterData": buildParameterData(),
        "Laboratory": laboratory,
        "Result": "",
        "DataLive": 0,
        "ReferenceSampleId": 0,
        "RRNumber": rrCtrl.text,
      };

      final success =
          await ApiService.saveServiceStationData(body);

      setState(() => saving = false);

      if (success) {
        showMsg('Service Station Data saved successfully');
        resetForm();
      } else {
        showMsg('Failed to save data');
      }
    } catch (e) {
      setState(() => saving = false);
      showMsg('Something went wrong');
    }
  }

  String buildParameterData() {
    return parameters.map((p) {
      final result = p.result ?? '';
      final remark = p.remark ?? '';
      return '${p.id}_${result}_$remark';
    }).join(',');
  }

  void resetForm() {
    setState(() {
      division = null;
      subDivision = null;
      station = null;
      laboratory = null;
      sampleDate = null;
      startDate = null;
      endDate = null;
      lat = null;
      lng = null;
      showTable = false;
      parameters.clear();
      addressCtrl.clear();
      rrCtrl.clear();
      sampleId = '';
    });
  }

  void showMsg(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          drawer: const AppDrawer(),
          // appBar: AppBar(
          //   title: const Text('Add Service Station Water Quality Data'),
          // ),
          appBar: const WqmsAppBar(),

          body: loading
              ? const Center(child: CircularProgressIndicator())
              : Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(12),
                    child: Center(
                      child: SizedBox(
                        width: 900,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                              // ✅ REUSABLE PAGE HEADING
    const PageHeading(
      title: 'Add Service Station Water Quality Data',
    ),
               
                            Center(
                              child: ElevatedButton(
                                onPressed: getLocation,
                                child:
                                    const Text('Get The Current Location'),
                              ),
                            ),
                            const SizedBox(height: 12),
                            buildDropdownCard(),
                            buildDateCard(),
                            if (showTable) buildLocationCard(),
                            if (showTable) buildParameterTable(),
                            if (showTable)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20),
                                child: SizedBox(
                                  height: 45,
                                  child: ElevatedButton(
                                    onPressed: saving ? null : save,
                                    child: const Text('SAVE'),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
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

  Widget buildDropdownCard() => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              dropdown(
                'DIVISION',
                division,
                stations.map((e) => e.division).toSet().toList(),
                (v) => setState(() => division = v),
              ),
              const SizedBox(height: 12),
              dropdown(
                'SUB DIVISION',
                subDivision,
                stations
                    .where((e) => e.division == division)
                    .map((e) => e.subDivision)
                    .toSet()
                    .toList(),
                (v) => setState(() => subDivision = v),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<ServiceStation>(
                decoration: const InputDecoration(
                  labelText: 'SERVICE STATION',
                  border: OutlineInputBorder(),
                ),
                value: station,
                items: stations
                    .where((e) =>
                        e.division == division &&
                        e.subDivision == subDivision)
                    .map((e) =>
                        DropdownMenuItem(value: e, child: Text(e.name)))
                    .toList(),
                onChanged: (v) => setState(() => station = v),
                validator: (v) =>
                    ServiceStationValidator.requiredDropdown(
                        v, 'Service Station'),
              ),
              const SizedBox(height: 12),
              dropdown(
                'LABORATORY',
                laboratory,
                const ['WTL High Grounds', 'WTL Jayanagar'],
                (v) => setState(() => laboratory = v),
              ),
            ],
          ),
        ),
      );

  Widget buildDateCard() => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              dateField(
                label: 'SAMPLE DATE',
                date: sampleDate,
                onTap: () =>
                    pick((d) => setState(() => sampleDate = d)),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: dateField(
                      label: 'START DATE',
                      date: startDate,
                      onTap: () =>
                          pick((d) => setState(() => startDate = d)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: dateField(
                      label: 'END DATE',
                      date: endDate,
                      onTap: () =>
                          pick((d) => setState(() => endDate = d)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 45,
                child: ElevatedButton(
                  onPressed: station == null ? null : addData,
                  child: const Text('ADD DATA'),
                ),
              ),
            ],
          ),
        ),
      );

  Widget buildLocationCard() => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Longitude: ${lng ?? 'null'}    Latitude: ${lat ?? 'null'}',
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: addressCtrl,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    ServiceStationValidator.requiredField(v, 'Address'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: rrCtrl,
                decoration: const InputDecoration(
                  labelText: 'RR Number',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    ServiceStationValidator.requiredField(v, 'RR Number'),
              ),
              const SizedBox(height: 8),
              Text(
                'Sample Id : $sampleId',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      );

Widget buildParameterTable() => Card(
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowHeight: 42,
          dataRowHeight: 48,
          columnSpacing: 18,
          headingRowColor: MaterialStateProperty.all(
            Colors.blue.shade50,
          ),
          columns: const [
            DataColumn(label: Text('ID')),
            DataColumn(label: Text('Parameter')),
          
            DataColumn(label: Text('Result')),
            DataColumn(label: Text('Remark')),
              DataColumn(label: Text('Unit')),
            DataColumn(label: Text('Desired Limit')),
            DataColumn(label: Text('Permissible Limit')),
          ],
          rows: List.generate(parameters.length, (index) {
            final p = parameters[index];

            return DataRow(
              color: MaterialStateProperty.resolveWith<Color?>(
                (states) =>
                    index.isEven ? Colors.grey.shade50 : Colors.white,
              ),
              cells: [
                DataCell(Text(p.id.toString())),
                DataCell(Text(p.name)),
              

                // ✅ Compact Result field
                DataCell(
                  SizedBox(
                    width: 80,
                    height: 36,
                    child: TextField(
                      onChanged: (v) => p.result = v,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),

                // ✅ Compact Remark field
                DataCell(
                  SizedBox(
                    width: 120,
                    height: 36,
                    child: TextField(
                      onChanged: (v) => p.remark = v,
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
                  DataCell(Text(p.unit)),
                DataCell(Text(p.desiredLimit)),
                DataCell(Text(p.permissibleLimit)),
              ],
            );
          }),
        ),
      ),
    );

  // Widget buildParameterTable() => Card(
  //       child: SingleChildScrollView(
  //         scrollDirection: Axis.horizontal,
  //         child: DataTable(
  //           columns: const [
  //             DataColumn(label: Text('ID')),
  //             DataColumn(label: Text('Parameter')),
  //             DataColumn(label: Text('Result')),
  //             DataColumn(label: Text('Remark')),
  //           ],
  //           rows: parameters.map((p) {
  //             return DataRow(cells: [
  //               DataCell(Text(p.id.toString())),
  //               DataCell(Text(p.name)),
  //               DataCell(
  //                 SizedBox(
  //                   width: 80,
  //                   child:
  //                       TextField(onChanged: (v) => p.result = v),
  //                 ),
  //               ),
  //               DataCell(
  //                 SizedBox(
  //                   width: 120,
  //                   child:
  //                       TextField(onChanged: (v) => p.remark = v),
  //                 ),
  //               ),
  //             ]);
  //           }).toList(),
  //         ),
  //       ),
  //     );

  Widget dropdown(
    String label,
    String? value,
    List<String> items,
    Function(String?) onChanged,
  ) =>
      DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        value: items.contains(value) ? value : null,
        items: items
            .map((e) =>
                DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: onChanged,
        validator: (v) =>
            ServiceStationValidator.requiredDropdown(v, label),
      );

  Widget dateField({
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
  }) {
    return TextFormField(
      readOnly: true,
      onTap: onTap,
      controller:
          TextEditingController(text: date == null ? '' : _fmt(date)),
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        suffixIcon: const Icon(Icons.calendar_today),
      ),
    );
  }

  Future<void> pick(Function(DateTime) cb) async {
    final d = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDate: DateTime.now(),
    );
    if (d != null) cb(d);
  }

  String _fmt(DateTime d) =>
      DateFormat('yyyy-MM-dd').format(d);
}
