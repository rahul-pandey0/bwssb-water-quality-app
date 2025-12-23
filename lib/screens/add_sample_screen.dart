import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/water_quality_service.dart';
import 'location_picker_screen.dart';

class AddSampleScreen extends StatefulWidget {
  const AddSampleScreen({Key? key}) : super(key: key);

  @override
  State<AddSampleScreen> createState() => _AddSampleScreenState();
}

class _AddSampleScreenState extends State<AddSampleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _sampleDateController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  
  Map<String, dynamic>? _selectedDivision;
  Map<String, dynamic>? _selectedSubDivision;
  Map<String, dynamic>? _selectedServiceStation;
  String? _selectedLaboratory;
  String? _currentLocation;
  double? _latitude;
  double? _longitude;
  
  List<Map<String, dynamic>> _serviceStations = [];
  List<Map<String, dynamic>> _divisions = [];
  List<Map<String, dynamic>> _subDivisions = [];
  List<Map<String, dynamic>> _stations = [];
  bool _isLoading = false;
  
  final WaterQualityService _waterQualityService = WaterQualityService();

  final List<String> _laboratories = [
    'Central Lab',
    'Regional Lab 1', 
    'Regional Lab 2',
    'Mobile Lab Unit 1',
    'Mobile Lab Unit 2'
  ];

  @override
  void initState() {
    super.initState();
    _sampleDateController.text = DateFormat('dd-MMM-yyyy').format(DateTime.now());
    _loadServiceStations();
  }

  @override
  void dispose() {
    _sampleDateController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  Future<void> _loadServiceStations() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final token = authService.accessToken;
      
      if (token != null) {
        final stations = await _waterQualityService.getServiceStations(token);
        setState(() {
          _serviceStations = stations;
          _processDivisionData(stations);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading service stations: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _processDivisionData(List<Map<String, dynamic>> stations) {
    _divisions.clear();
    for (var division in stations) {
      _divisions.add({
        'DivisionId': division['DivisionId'],
        'DivisionName': division['DivisionName'],
        'SubDivisions': division['SubDivisions'] ?? [],
      });
    }
  }

  void _onDivisionChanged(Map<String, dynamic>? division) {
    setState(() {
      _selectedDivision = division;
      _selectedSubDivision = null;
      _selectedServiceStation = null;
      _subDivisions.clear();
      _stations.clear();
      
      if (division != null && division['SubDivisions'] != null) {
        _subDivisions = List<Map<String, dynamic>>.from(division['SubDivisions']);
      }
    });
  }

  void _onSubDivisionChanged(Map<String, dynamic>? subDivision) {
    setState(() {
      _selectedSubDivision = subDivision;
      _selectedServiceStation = null;
      _stations.clear();
      
      if (subDivision != null && subDivision['ServiceStations'] != null) {
        _stations = List<Map<String, dynamic>>.from(subDivision['ServiceStations']);
      }
    });
  }

  Future<void> _selectDate(TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      controller.text = DateFormat('dd-MMM-yyyy').format(picked);
    }
  }

  Future<void> _getCurrentLocation() async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => const LocationPickerScreen(),
      ),
    );
    
    if (result != null) {
      setState(() {
        _currentLocation = result['address'];
        _latitude = result['latitude'];
        _longitude = result['longitude'];
      });
    }
  }

  Future<void> _submitSample() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (_currentLocation == null || _latitude == null || _longitude == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please get current location first'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final token = authService.accessToken;
      
      if (token != null) {
        final success = await _waterQualityService.submitServiceStationSample(
          token: token,
          sampleId: DateTime.now().millisecondsSinceEpoch.toString(),
          sampleDate: DateFormat('yyyy-MM-dd HH:mm:ss').format(
            DateFormat('dd-MMM-yyyy').parse(_sampleDateController.text)
          ),
          analysisStartDate: _startDateController.text.isNotEmpty 
              ? DateFormat('yyyy-MM-dd HH:mm:ss').format(
                  DateFormat('dd-MMM-yyyy').parse(_startDateController.text)
                )
              : '',
          analysisCompleteDate: _endDateController.text.isNotEmpty 
              ? DateFormat('yyyy-MM-dd HH:mm:ss').format(
                  DateFormat('dd-MMM-yyyy').parse(_endDateController.text)
                )
              : '',
          address: _currentLocation!,
          serviceStationId: _selectedServiceStation?['ServiceStationId'] ?? 0,
          userId: 1, // You might want to get this from auth service
          latitude: _latitude!,
          longitude: _longitude!,
          parameterData: [], // Add parameter data as needed
        );

        if (success && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Sample data submitted successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        } else {
          throw Exception('Failed to submit sample data');
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error submitting sample: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WQMS'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            color: const Color(0xFF2196F3),
            padding: const EdgeInsets.all(16),
            child: const Text(
              'Add Service Station Water Quality Data',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Form
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Get Current Location Button
                    ElevatedButton.icon(
                      onPressed: _getCurrentLocation,
                      icon: const Icon(Icons.location_on, color: Colors.white),
                      label: const Text(
                        'Get The Current Location',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4CAF50),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    if (_currentLocation != null) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.green),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.check_circle, color: Colors.green),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Location: $_currentLocation',
                                style: const TextStyle(color: Colors.green),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),
                    
                    // Division Dropdown
                    DropdownButtonFormField<Map<String, dynamic>>(
                      value: _selectedDivision,
                      decoration: const InputDecoration(
                        labelText: 'DIVISION',
                        border: OutlineInputBorder(),
                      ),
                      items: _divisions.map((division) {
                        return DropdownMenuItem(
                          value: division,
                          child: Text(division['DivisionName'] ?? ''),
                        );
                      }).toList(),
                      onChanged: _isLoading ? null : _onDivisionChanged,
                      validator: (value) => value == null ? 'Please select division' : null,
                    ),
                    const SizedBox(height: 16),
                    
                    // Sub Division Dropdown
                    DropdownButtonFormField<Map<String, dynamic>>(
                      value: _selectedSubDivision,
                      decoration: const InputDecoration(
                        labelText: 'SUB DIVISION',
                        border: OutlineInputBorder(),
                      ),
                      items: _subDivisions.map((subDiv) {
                        return DropdownMenuItem(
                          value: subDiv,
                          child: Text(subDiv['SubDivisionName'] ?? ''),
                        );
                      }).toList(),
                      onChanged: _isLoading ? null : _onSubDivisionChanged,
                      validator: (value) => value == null ? 'Please select sub division' : null,
                    ),
                    const SizedBox(height: 16),
                    
                    // Service Station Dropdown
                    DropdownButtonFormField<Map<String, dynamic>>(
                      value: _selectedServiceStation,
                      decoration: const InputDecoration(
                        labelText: 'SERVICE STATION',
                        border: OutlineInputBorder(),
                      ),
                      items: _stations.map((station) {
                        return DropdownMenuItem(
                          value: station,
                          child: Text(station['ServiceStationName'] ?? ''),
                        );
                      }).toList(),
                      onChanged: _isLoading ? null : (value) {
                        setState(() {
                          _selectedServiceStation = value;
                        });
                      },
                      validator: (value) => value == null ? 'Please select service station' : null,
                    ),
                    const SizedBox(height: 16),
                    
                    // Laboratory Dropdown
                    DropdownButtonFormField<String>(
                      value: _selectedLaboratory,
                      decoration: const InputDecoration(
                        labelText: 'LABORATORY',
                        border: OutlineInputBorder(),
                      ),
                      items: _laboratories.map((lab) {
                        return DropdownMenuItem(
                          value: lab,
                          child: Text(lab),
                        );
                      }).toList(),
                      onChanged: _isLoading ? null : (value) {
                        setState(() {
                          _selectedLaboratory = value;
                        });
                      },
                      validator: (value) => value == null ? 'Please select laboratory' : null,
                    ),
                    const SizedBox(height: 16),
                    
                    // Sample Date
                    TextFormField(
                      controller: _sampleDateController,
                      decoration: InputDecoration(
                        labelText: 'SAMPLE DATE',
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () => _selectDate(_sampleDateController),
                        ),
                      ),
                      readOnly: true,
                      validator: (value) => value!.isEmpty ? 'Please select sample date' : null,
                    ),
                    const SizedBox(height: 20),
                    
                    // Add Data Button
                    ElevatedButton(
                      onPressed: _isLoading ? null : _submitSample,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2196F3),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            )
                          : const Text(
                              'ADD DATA',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Date Range Section
                    const Text(
                      'Date Range',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2196F3),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'A.N START DATE',
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(height: 4),
                              TextFormField(
                                controller: _startDateController,
                                decoration: InputDecoration(
                                  hintText: 'SELECT DATE',
                                  border: const OutlineInputBorder(),
                                  suffixIcon: IconButton(
                                    icon: const Icon(Icons.calendar_today),
                                    onPressed: () => _selectDate(_startDateController),
                                  ),
                                ),
                                readOnly: true,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'A.N COMPLETE DATE',
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(height: 4),
                              TextFormField(
                                controller: _endDateController,
                                decoration: InputDecoration(
                                  hintText: 'SELECT DATE',
                                  border: const OutlineInputBorder(),
                                  suffixIcon: IconButton(
                                    icon: const Icon(Icons.calendar_today),
                                    onPressed: () => _selectDate(_endDateController),
                                  ),
                                ),
                                readOnly: true,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}