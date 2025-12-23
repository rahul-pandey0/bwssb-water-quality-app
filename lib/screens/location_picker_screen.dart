import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationPickerScreen extends StatefulWidget {
  const LocationPickerScreen({Key? key}) : super(key: key);

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  GoogleMapController? _mapController;
  LatLng? _currentPosition;
  LatLng? _selectedPosition;
  bool _isLoading = true;
  String _locationText = '';

  // Default location (Bangalore)
  static const LatLng _defaultLocation = LatLng(12.9716, 77.5946);

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      // Check and request location permission
      final permission = await Permission.location.status;
      if (permission != PermissionStatus.granted) {
        final result = await Permission.location.request();
        if (result != PermissionStatus.granted) {
          setState(() {
            _currentPosition = _defaultLocation;
            _selectedPosition = _defaultLocation;
            _isLoading = false;
            _locationText = 'Bangalore, Karnataka';
          });
          return;
        }
      }

      // Check if location services are enabled
      final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _currentPosition = _defaultLocation;
          _selectedPosition = _defaultLocation;
          _isLoading = false;
          _locationText = 'Bangalore, Karnataka';
        });
        return;
      }

      // Get current position
      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _selectedPosition = LatLng(position.latitude, position.longitude);
        _isLoading = false;
        _locationText = '${position.latitude.toStringAsFixed(6)}, ${position.longitude.toStringAsFixed(6)}';
      });
    } catch (e) {
      setState(() {
        _currentPosition = _defaultLocation;
        _selectedPosition = _defaultLocation;
        _isLoading = false;
        _locationText = 'Bangalore, Karnataka';
      });
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _onMapTap(LatLng position) {
    setState(() {
      _selectedPosition = position;
      _locationText = '${position.latitude.toStringAsFixed(6)}, ${position.longitude.toStringAsFixed(6)}';
    });
  }

  void _confirmLocation() {
    if (_selectedPosition != null) {
      final locationData = {
        'address': _locationText,
        'latitude': _selectedPosition!.latitude,
        'longitude': _selectedPosition!.longitude,
      };
      Navigator.pop(context, locationData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Location'),
        actions: [
          TextButton(
            onPressed: _confirmLocation,
            child: const Text(
              'Confirm',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                // Location Info
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  color: Colors.blue[50],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Selected Location:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2196F3),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(_locationText),
                    ],
                  ),
                ),
                // Map
                Expanded(
                  child: GoogleMap(
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: _currentPosition ?? _defaultLocation,
                      zoom: 15.0,
                    ),
                    onTap: _onMapTap,
                    markers: {
                      if (_selectedPosition != null)
                        Marker(
                          markerId: const MarkerId('selected_location'),
                          position: _selectedPosition!,
                          infoWindow: const InfoWindow(
                            title: 'Selected Location',
                          ),
                        ),
                      if (_currentPosition != null && _currentPosition != _selectedPosition)
                        Marker(
                          markerId: const MarkerId('current_location'),
                          position: _currentPosition!,
                          icon: BitmapDescriptor.defaultMarkerWithHue(
                            BitmapDescriptor.hueBlue,
                          ),
                          infoWindow: const InfoWindow(
                            title: 'Current Location',
                          ),
                        ),
                    },
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                  ),
                ),
                // Action Buttons
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            if (_currentPosition != null && _mapController != null) {
                              _mapController!.animateCamera(
                                CameraUpdate.newLatLng(_currentPosition!),
                              );
                              setState(() {
                                _selectedPosition = _currentPosition;
                                _locationText = '${_currentPosition!.latitude.toStringAsFixed(6)}, ${_currentPosition!.longitude.toStringAsFixed(6)}';
                              });
                            }
                          },
                          icon: const Icon(Icons.my_location),
                          label: const Text('Use Current'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _confirmLocation,
                          icon: const Icon(Icons.check),
                          label: const Text('Confirm'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2196F3),
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}