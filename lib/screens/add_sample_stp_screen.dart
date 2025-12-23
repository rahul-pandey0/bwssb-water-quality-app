import 'package:flutter/material.dart';
import '../widgets/bwssb_logo.dart';

class AddSampleSTPScreen extends StatefulWidget {
  const AddSampleSTPScreen({Key? key}) : super(key: key);

  @override
  State<AddSampleSTPScreen> createState() => _AddSampleSTPScreenState();
}

class _AddSampleSTPScreenState extends State<AddSampleSTPScreen> {
  final _formKey = GlobalKey<FormState>();
  final _sampleIdController = TextEditingController();
  final _locationController = TextEditingController();
  final _notesController = TextEditingController();
  
  String? _selectedSTP;
  String? _selectedParameter;
  String? _selectedStage;
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Sample Data - Sewage Treatment Plant'),
        backgroundColor: const Color(0xFF9C27B0),
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
                color: const Color(0xFF9C27B0).withOpacity(0.1),
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
                          'STP Sample Data',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF9C27B0),
                          ),
                        ),
                        Text(
                          'Add wastewater quality sample data for treatment plants',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Image.asset(
                    'assets/images/stp.png',
                    width: 40,
                    height: 40,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.cleaning_services,
                        size: 40,
                        color: Color(0xFF9C27B0),
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
                  
                  // STP Dropdown
                  DropdownButtonFormField<String>(
                    value: _selectedSTP,
                    decoration: const InputDecoration(
                      labelText: 'Sewage Treatment Plant',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.factory),
                    ),
                    items: [
                      'Vrishabhavathi Valley STP',
                      'Bellandur STP',
                      'Kengeri STP',
                      'Yelahanka STP',
                      'Whitefield STP',
                      'Koramangala STP',
                      'Cubbon Park STP',
                    ].map((stp) {
                      return DropdownMenuItem(
                        value: stp,
                        child: Text(stp),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedSTP = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select an STP';
                      }
                      return null;
                    },
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Treatment Stage
                  DropdownButtonFormField<String>(
                    value: _selectedStage,
                    decoration: const InputDecoration(
                      labelText: 'Treatment Stage',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.layers),
                    ),
                    items: [
                      'Raw Sewage',
                      'Primary Treatment',
                      'Secondary Treatment',
                      'Tertiary Treatment',
                      'Treated Effluent',
                      'Sludge Treatment',
                    ].map((stage) {
                      return DropdownMenuItem(
                        value: stage,
                        child: Text(stage),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedStage = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select treatment stage';
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
                      'BOD',
                      'COD',
                      'TSS',
                      'pH',
                      'Dissolved Oxygen',
                      'Ammonia',
                      'Nitrates',
                      'Phosphates',
                      'Oil & Grease',
                      'Faecal Coliforms',
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
                      labelText: 'Sampling Point',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.place),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter sampling point';
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
                        backgroundColor: const Color(0xFF9C27B0),
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
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('STP sample data submitted successfully!'),
        backgroundColor: Colors.green,
      ),
    );
    
    _formKey.currentState!.reset();
    _sampleIdController.clear();
    _locationController.clear();
    _notesController.clear();
    setState(() {
      _selectedSTP = null;
      _selectedParameter = null;
      _selectedStage = null;
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