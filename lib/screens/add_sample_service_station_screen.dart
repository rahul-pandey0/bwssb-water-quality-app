import 'package:flutter/material.dart';
import '../widgets/bwssb_logo.dart';

class AddSampleServiceStationScreen extends StatefulWidget {
  const AddSampleServiceStationScreen({Key? key}) : super(key: key);

  @override
  State<AddSampleServiceStationScreen> createState() => _AddSampleServiceStationScreenState();
}

class _AddSampleServiceStationScreenState extends State<AddSampleServiceStationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _sampleIdController = TextEditingController();
  final _locationController = TextEditingController();
  final _notesController = TextEditingController();
  
  String? _selectedServiceStation;
  String? _selectedParameter;
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Sample Data - Service Station'),
        backgroundColor: const Color(0xFF2196F3),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with logo
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF2196F3).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const BWSSBLogo.dashboard(size: 50),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Service Station Sample Data',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2196F3),
                          ),
                        ),
                        Text(
                          'Add water quality sample data for service stations',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Image.asset(
                    'assets/images/servicestation.png',
                    width: 40,
                    height: 40,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.location_on,
                        size: 40,
                        color: Color(0xFF2196F3),
                      );
                    },
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sample ID
                  TextFormField(
                    controller: _sampleIdController,
                    decoration: const InputDecoration(
                      labelText: 'Sample ID',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.confirmation_num),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Sample ID';
                      }
                      return null;
                    },
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Service Station Dropdown
                  DropdownButtonFormField<String>(
                    value: _selectedServiceStation,
                    decoration: const InputDecoration(
                      labelText: 'Service Station',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.location_city),
                    ),
                    items: [
                      'HSR Layout Service Station',
                      'Koramangala Service Station',
                      'Indiranagar Service Station',
                      'Whitefield Service Station',
                      'Electronic City Service Station',
                    ].map((station) {
                      return DropdownMenuItem(
                        value: station,
                        child: Text(station),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedServiceStation = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a service station';
                      }
                      return null;
                    },
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Parameter Dropdown
                  DropdownButtonFormField<String>(
                    value: _selectedParameter,
                    decoration: const InputDecoration(
                      labelText: 'Parameter',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.science),
                    ),
                    items: [
                      'pH',
                      'Turbidity',
                      'Total Dissolved Solids',
                      'Chlorine',
                      'Residual Chlorine',
                      'Fluoride',
                      'Iron',
                      'Hardness',
                    ].map((parameter) {
                      return DropdownMenuItem(
                        value: parameter,
                        child: Text(parameter),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedParameter = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a parameter';
                      }
                      return null;
                    },
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Location
                  TextFormField(
                    controller: _locationController,
                    decoration: const InputDecoration(
                      labelText: 'Location/Address',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.place),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter location';
                      }
                      return null;
                    },
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Date Picker
                  InkWell(
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                      );
                      if (date != null) {
                        setState(() {
                          _selectedDate = date;
                        });
                      }
                    },
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Sample Date',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.calendar_today),
                      ),
                      child: Text(
                        '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Notes
                  TextFormField(
                    controller: _notesController,
                    decoration: const InputDecoration(
                      labelText: 'Notes (Optional)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.note),
                    ),
                    maxLines: 3,
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _submitSampleData();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4CAF50),
                        foregroundColor: Colors.white,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.save),
                          SizedBox(width: 8),
                          Text(
                            'Submit Sample Data',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitSampleData() {
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sample data submitted successfully!'),
        backgroundColor: Colors.green,
      ),
    );
    
    // Clear form
    _formKey.currentState!.reset();
    _sampleIdController.clear();
    _locationController.clear();
    _notesController.clear();
    setState(() {
      _selectedServiceStation = null;
      _selectedParameter = null;
      _selectedDate = DateTime.now();
    });
  }

  @override
  void dispose() {
    _sampleIdController.dispose();
    _locationController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}