import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/bwssb_api_service.dart';
import '../widgets/bwssb_logo.dart';

class SampleCollectionScreen extends StatefulWidget {
  const SampleCollectionScreen({Key? key}) : super(key: key);

  @override
  State<SampleCollectionScreen> createState() => _SampleCollectionScreenState();
}

class _SampleCollectionScreenState extends State<SampleCollectionScreen> {
  final BWSSBApiService _apiService = BWSSBApiService();
  
  // Dropdown data
  List<Map<String, dynamic>> _divisions = [];
  List<Map<String, dynamic>> _subDivisions = [];
  List<Map<String, dynamic>> _serviceStations = [];
  List<Map<String, dynamic>> _laboratories = [];
  List<Map<String, dynamic>> _parameters = [];
  List<dynamic> _rawServiceStationData = [];
  
  // Selected values
  String? _selectedDivision;
  String? _selectedSubDivision;
  String? _selectedServiceStation;
  String? _selectedServiceStationId;
  String? _selectedLaboratory;
  String? _generatedSampleId;
  
  // Loading states
  bool _isLoadingServiceStations = false;
  bool _isLoadingSubDivisions = false;
  bool _isLoadingParameters = false;
  bool _isGeneratingSampleId = false;
  
  // Form visibility
  bool _showParameterForm = false;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final token = authService.token;
    
    if (token == null) return;

    setState(() {
      _isLoadingServiceStations = true;
    });

    try {
      // Load service station data
      final result = await _apiService.getServiceStation(token: token);
      if (result['success'] == true && result['data'] != null) {
        _rawServiceStationData = result['data'];
        _divisions = _apiService.filterDivisions(_rawServiceStationData);
      }
      
      // Load laboratory data
      _laboratories = _apiService.getLaboratoryOptions();
      
    } catch (e) {
      _showErrorSnackBar('Failed to load initial data: $e');
    } finally {
      setState(() {
        _isLoadingServiceStations = false;
      });
    }
  }

  Future<void> _onDivisionChanged(String? division) async {
    setState(() {
      _selectedDivision = division;
      _selectedSubDivision = null;
      _selectedServiceStation = null;
      _selectedServiceStationId = null;
      _isLoadingSubDivisions = true;
      _subDivisions = [];
      _serviceStations = [];
    });

    if (division != null) {
      _subDivisions = _apiService.filterSubDivisions(_rawServiceStationData, division);
    }

    setState(() {
      _isLoadingSubDivisions = false;
    });
  }

  void _onSubDivisionChanged(String? subDivision) {
    setState(() {
      _selectedSubDivision = subDivision;
      _selectedServiceStation = null;
      _selectedServiceStationId = null;
      _serviceStations = [];
    });

    if (subDivision != null && _selectedDivision != null) {
      _serviceStations = _apiService.filterServiceStations(
        _rawServiceStationData,
        _selectedDivision!,
        subDivision,
      );
    }
  }

  void _onServiceStationChanged(String? serviceStation) {
    setState(() {
      _selectedServiceStation = serviceStation;
      _generatedSampleId = null;
    });

    if (serviceStation != null) {
      // Find the service station ID
      final station = _serviceStations.firstWhere(
        (s) => s['name'] == serviceStation,
        orElse: () => {},
      );
      _selectedServiceStationId = station['id']?.toString();
    }
  }

  Future<void> _generateSampleId() async {
    if (_selectedServiceStationId == null) return;

    final authService = Provider.of<AuthService>(context, listen: false);
    final token = authService.token;
    
    if (token == null) return;

    setState(() {
      _isGeneratingSampleId = true;
    });

    try {
      final result = await _apiService.generateSampleId(
        token: token,
        serviceStationId: _selectedServiceStationId!,
      );
      
      if (result['success'] == true) {
        setState(() {
          _generatedSampleId = result['sampleId'] ?? result['data'] ?? 'Generated';
        });
        _showSuccessSnackBar('Sample ID generated successfully!');
      }
    } catch (e) {
      _showErrorSnackBar('Failed to generate Sample ID: $e');
    } finally {
      setState(() {
        _isGeneratingSampleId = false;
      });
    }
  }

  Future<void> _loadParameters() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final token = authService.token;
    
    if (token == null) return;

    setState(() {
      _isLoadingParameters = true;
    });

    try {
      final result = await _apiService.getParametersForServiceStation(token: token);
      if (result['success'] == true && result['data'] != null) {
        _parameters = List<Map<String, dynamic>>.from(result['data']);
        
        // Check if any parameter is "Residual Chlorine"
        final hasResidualChlorine = _parameters.any(
          (param) => param['s_ParameterName'] == 'Residual Chlorine',
        );
        
        setState(() {
          _showParameterForm = hasResidualChlorine;
        });
      }
    } catch (e) {
      _showErrorSnackBar('Failed to load parameters: $e');
    } finally {
      setState(() {
        _isLoadingParameters = false;
      });
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sample Collection'),
        backgroundColor: const Color(0xFF2196F3),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Division Dropdown
            _buildDropdownField(
              label: 'Division',
              value: _selectedDivision,
              items: _divisions,
              onChanged: _onDivisionChanged,
              isLoading: _isLoadingServiceStations,
            ),
            
            const SizedBox(height: 16),
            
            // Sub-Division Dropdown
            _buildDropdownField(
              label: 'Sub-Division',
              value: _selectedSubDivision,
              items: _subDivisions,
              onChanged: _onSubDivisionChanged,
              isLoading: _isLoadingSubDivisions,
              enabled: _selectedDivision != null,
            ),
            
            const SizedBox(height: 16),
            
            // Service Station Dropdown
            _buildDropdownField(
              label: 'Service Station',
              value: _selectedServiceStation,
              items: _serviceStations,
              onChanged: _onServiceStationChanged,
              enabled: _selectedSubDivision != null,
            ),
            
            const SizedBox(height: 16),
            
            // Laboratory Dropdown
            _buildDropdownField(
              label: 'Laboratory',
              value: _selectedLaboratory,
              items: _laboratories,
              onChanged: (value) => setState(() => _selectedLaboratory = value),
              valueField: 'value',
              displayField: 'label',
            ),
            
            const SizedBox(height: 24),
            
            // Generate Sample ID Section
            if (_selectedServiceStation != null) ...[
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Sample ID Generation',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2196F3),
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      if (_generatedSampleId != null)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            border: Border.all(color: Colors.green),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Generated Sample ID:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _generatedSampleId!,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'monospace',
                                ),
                              ),
                            ],
                          ),
                        ),
                      
                      const SizedBox(height: 16),
                      
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isGeneratingSampleId ? null : _generateSampleId,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2196F3),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: _isGeneratingSampleId
                              ? const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Text('Generating...'),
                                  ],
                                )
                              : const Text('Generate Sample ID'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
            ],
            
            // Load Parameters Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoadingParameters ? null : _loadParameters,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF5722),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: _isLoadingParameters
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                          SizedBox(width: 12),
                          Text('Loading Parameters...'),
                        ],
                      )
                    : const Text('Load Parameters'),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Dynamic Parameter Form
            if (_showParameterForm) ...[
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Residual Chlorine Form',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF5722),
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Residual Chlorine Value',
                          border: OutlineInputBorder(),
                          suffixText: 'mg/L',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      
                      const SizedBox(height: 16),
                      
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Notes',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                      ),
                      
                      const SizedBox(height: 16),
                      
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            _showSuccessSnackBar('Residual Chlorine data saved!');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Save Data'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            
            // Parameters List
            if (_parameters.isNotEmpty) ...[
              const SizedBox(height: 24),
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Available Parameters',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2196F3),
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      ..._parameters.map((param) => ListTile(
                        leading: Icon(
                          param['s_ParameterName'] == 'Residual Chlorine'
                              ? Icons.science
                              : Icons.analytics,
                          color: const Color(0xFF2196F3),
                        ),
                        title: Text(param['s_ParameterName'] ?? 'Unknown Parameter'),
                        subtitle: param['Description'] != null
                            ? Text(param['Description'])
                            : null,
                        trailing: param['s_ParameterName'] == 'Residual Chlorine'
                            ? const Icon(Icons.check_circle, color: Colors.green)
                            : null,
                      )),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<Map<String, dynamic>> items,
    required void Function(String?) onChanged,
    bool isLoading = false,
    bool enabled = true,
    String valueField = 'value',
    String displayField = 'name',
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2196F3),
          ),
        ),
        const SizedBox(height: 8),
        
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: isLoading
              ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      SizedBox(width: 12),
                      Text('Loading...'),
                    ],
                  ),
                )
              : DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: value,
                    hint: Text('Select $label'),
                    isExpanded: true,
                    onChanged: enabled ? onChanged : null,
                    items: items.map((item) {
                      return DropdownMenuItem<String>(
                        value: item[valueField],
                        child: Text(item[displayField] ?? ''),
                      );
                    }).toList(),
                  ),
                ),
        ),
      ],
    );
  }
}