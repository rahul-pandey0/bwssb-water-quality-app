import 'package:flutter/material.dart';
import '../widgets/bwssb_logo.dart';

class ReportsScreen extends StatefulWidget {
  final String type; // 'Service Station', 'WTP', or 'STP'
  
  const ReportsScreen({Key? key, required this.type}) : super(key: key);

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  DateTime _fromDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _toDate = DateTime.now();
  String? _selectedLocation;
  String? _selectedParameter;

  @override
  Widget build(BuildContext context) {
    Color themeColor = _getThemeColor();
    
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.type} Reports'),
        backgroundColor: themeColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: themeColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const BWSSBLogo.dashboard(size: 50),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${widget.type} Reports',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: themeColor,
                          ),
                        ),
                        Text(
                          'Generate and view water quality reports',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    _getIcon(),
                    size: 40,
                    color: themeColor,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Filter Options
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Report Filters',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Date Range
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => _selectDate(context, true),
                            child: InputDecorator(
                              decoration: const InputDecoration(
                                labelText: 'From Date',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.calendar_today),
                              ),
                              child: Text(
                                '${_fromDate.day}/${_fromDate.month}/${_fromDate.year}',
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: InkWell(
                            onTap: () => _selectDate(context, false),
                            child: InputDecorator(
                              decoration: const InputDecoration(
                                labelText: 'To Date',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.calendar_today),
                              ),
                              child: Text(
                                '${_toDate.day}/${_toDate.month}/${_toDate.year}',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Location Dropdown
                    DropdownButtonFormField<String>(
                      value: _selectedLocation,
                      decoration: InputDecoration(
                        labelText: '${widget.type}',
                        border: const OutlineInputBorder(),
                        prefixIcon: Icon(_getIcon()),
                      ),
                      items: _getLocations().map((location) {
                        return DropdownMenuItem(
                          value: location,
                          child: Text(location),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedLocation = value;
                        });
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
                      items: _getParameters().map((parameter) {
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
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Generate Report Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _generateReport,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: themeColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.assessment),
                            SizedBox(width: 8),
                            Text('Generate Report'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Recent Reports
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Recent Reports',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: themeColor,
                            child: const Icon(Icons.description, color: Colors.white),
                          ),
                          title: Text('${widget.type} Report ${index + 1}'),
                          subtitle: Text('Generated on ${DateTime.now().subtract(Duration(days: index)).day}/${DateTime.now().month}/${DateTime.now().year}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.download),
                                onPressed: () => _downloadReport(index),
                              ),
                              IconButton(
                                icon: const Icon(Icons.share),
                                onPressed: () => _shareReport(index),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getThemeColor() {
    switch (widget.type) {
      case 'WTP':
        return const Color(0xFF4CAF50);
      case 'STP':
        return const Color(0xFF9C27B0);
      default:
        return const Color(0xFF2196F3);
    }
  }

  IconData _getIcon() {
    switch (widget.type) {
      case 'WTP':
        return Icons.business;
      case 'STP':
        return Icons.cleaning_services;
      default:
        return Icons.location_on;
    }
  }

  List<String> _getLocations() {
    switch (widget.type) {
      case 'WTP':
        return [
          'TK Halli WTP',
          'Harohalli WTP',
          'Tataguni WTP',
          'Arkavathi WTP',
          'Hesaraghatta WTP',
        ];
      case 'STP':
        return [
          'Vrishabhavathi Valley STP',
          'Bellandur STP',
          'Kengeri STP',
          'Yelahanka STP',
          'Whitefield STP',
        ];
      default:
        return [
          'HSR Layout Service Station',
          'Koramangala Service Station',
          'Indiranagar Service Station',
          'Whitefield Service Station',
        ];
    }
  }

  List<String> _getParameters() {
    switch (widget.type) {
      case 'STP':
        return ['BOD', 'COD', 'TSS', 'pH', 'Dissolved Oxygen'];
      default:
        return ['pH', 'Turbidity', 'Chlorine', 'TDS', 'Hardness'];
    }
  }

  void _selectDate(BuildContext context, bool isFromDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isFromDate ? _fromDate : _toDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        if (isFromDate) {
          _fromDate = picked;
        } else {
          _toDate = picked;
        }
      });
    }
  }

  void _generateReport() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.type} report generated successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _downloadReport(int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Downloading ${widget.type} Report ${index + 1}...'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _shareReport(int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing ${widget.type} Report ${index + 1}...'),
        backgroundColor: Colors.orange,
      ),
    );
  }
}