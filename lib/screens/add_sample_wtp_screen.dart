import 'package:flutter/material.dart';
import '../widgets/bwssb_logo.dart';

class AddSampleWTPScreen extends StatefulWidget {
  const AddSampleWTPScreen({Key? key}) : super(key: key);

  @override
  State<AddSampleWTPScreen> createState() => _AddSampleWTPScreenState();
}

class _AddSampleWTPScreenState extends State<AddSampleWTPScreen> {
  final _formKey = GlobalKey<FormState>();
  final _sampleIdController = TextEditingController();
  final _locationController = TextEditingController();
  final _notesController = TextEditingController();
  
  String? _selectedWTP;
  String? _selectedParameter;
  String? _selectedStage;
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Sample Data - Water Treatment Plant'),
        backgroundColor: const Color(0xFF4CAF50),
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
                color: const Color(0xFF4CAF50).withOpacity(0.1),
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
                          'WTP Sample Data',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4CAF50),
                          ),
                        ),
                        Text(
                          'Add water quality sample data for treatment plants',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Image.asset(
                    'assets/images/wtp.png',
                    width: 40,
                    height: 40,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.business,
                        size: 40,
                        color: Color(0xFF4CAF50),
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
                  
                  // WTP Dropdown
                  DropdownButtonFormField<String>(
                    value: _selectedWTP,
                    decoration: const InputDecoration(
                      labelText: 'Water Treatment Plant',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.business),
                    ),
                    items: [
                      'Cauvery Water Treatment Plant - TK Halli',
                      'Cauvery Water Treatment Plant - Harohalli',
                      'Cauvery Water Treatment Plant - Tataguni',
                      'Arkavathi Water Treatment Plant',
                      'Hesaraghatta Water Treatment Plant',
                    ].map((wtp) {
                      return DropdownMenuItem(
                        value: wtp,
                        child: Text(wtp),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedWTP = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a WTP';
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
                      'Raw Water',
                      'Coagulation',
                      'Sedimentation',
                      'Filtration',
                      'Disinfection',
                      'Treated Water',
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
                      'pH',
                      'Turbidity',
                      'Total Dissolved Solids',
                      'Chlorine',
                      'Residual Chlorine',
                      'Fluoride',
                      'Iron',
                      'Hardness',
                      'Alkalinity',
                      'Coliforms',
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
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('WTP sample data submitted successfully!'),
        backgroundColor: Colors.green,
      ),
    );
    
    _formKey.currentState!.reset();
    _sampleIdController.clear();
    _locationController.clear();
    _notesController.clear();
    setState(() {
      _selectedWTP = null;
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