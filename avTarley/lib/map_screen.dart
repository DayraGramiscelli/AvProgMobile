import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'vaga_repository.dart';

class MapScreen extends StatefulWidget {
  final Vaga vaga;
  const MapScreen({super.key, required this.vaga});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Position? _currentPosition;
  GoogleMapController? _mapController;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position pos = await Geolocator.getCurrentPosition();
      setState(() {
        _currentPosition = pos;
        _loading = false;
      });
      _moveCamera();
    } catch (e) {
      setState(() {
        _loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao obter localização atual: $e')),
      );
    }
  }

  void _moveCamera() {
    if (_mapController == null || _currentPosition == null) return;
    final vagaLatLng = LatLng(widget.vaga.latitude, widget.vaga.longitude);
    final userLatLng =
        LatLng(_currentPosition!.latitude, _currentPosition!.longitude);
    final bounds = LatLngBounds(
      southwest: LatLng(
        (vagaLatLng.latitude < userLatLng.latitude)
            ? vagaLatLng.latitude
            : userLatLng.latitude,
        (vagaLatLng.longitude < userLatLng.longitude)
            ? vagaLatLng.longitude
            : userLatLng.longitude,
      ),
      northeast: LatLng(
        (vagaLatLng.latitude > userLatLng.latitude)
            ? vagaLatLng.latitude
            : userLatLng.latitude,
        (vagaLatLng.longitude > userLatLng.longitude)
            ? vagaLatLng.longitude
            : userLatLng.longitude,
      ),
    );
    _mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 80));
  }

  @override
  Widget build(BuildContext context) {
    final vagaLatLng = LatLng(widget.vaga.latitude, widget.vaga.longitude);
    final userLatLng = _currentPosition != null
        ? LatLng(_currentPosition!.latitude, _currentPosition!.longitude)
        : null;
    Set<Marker> markers = {
      Marker(
        markerId: const MarkerId('vaga'),
        position: vagaLatLng,
        infoWindow: const InfoWindow(title: 'Sua vaga'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    };
    if (userLatLng != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('usuario'),
          position: userLatLng,
          infoWindow: const InfoWindow(title: 'Você está aqui'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Mapa da Vaga')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: vagaLatLng,
                zoom: 17,
              ),
              markers: markers,
              myLocationEnabled: true,
              onMapCreated: (controller) {
                _mapController = controller;
                if (_currentPosition != null) {
                  _moveCamera();
                }
              },
            ),
    );
  }
}
