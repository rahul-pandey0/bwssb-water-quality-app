import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapPickerScreen extends StatefulWidget {
  const MapPickerScreen({super.key});

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  GoogleMapController? _mapController;
  LatLng? _selectedLatLng;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadCurrentLocation();
  }

  Future<void> _loadCurrentLocation() async {
    final pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _selectedLatLng = LatLng(pos.latitude, pos.longitude);
      loading = false;
    });
  }

  void _onMapTap(LatLng position) {
    setState(() => _selectedLatLng = position);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Location'),
        actions: [
          TextButton(
            onPressed: _selectedLatLng == null
                ? null
                : () => Navigator.pop(context, _selectedLatLng),
            child: const Text(
              'CONFIRM',
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _selectedLatLng!,
                zoom: 12,
              ),
              onMapCreated: (c) => _mapController = c,
              onTap: _onMapTap,
              markers: {
                if (_selectedLatLng != null)
                  Marker(
                    markerId: const MarkerId('selected'),
                    position: _selectedLatLng!,
                  ),
              },
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
            ),
    );
  }
}
