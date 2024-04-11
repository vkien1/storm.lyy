import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(33.7490, -84.3877),
    zoom: 7,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
            mapType: MapType.hybrid,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
          Positioned(
  top: 40, 
  left: 10, 
  child: SafeArea(
    child: FloatingActionButton(
      backgroundColor: Colors.white.withOpacity(0.9),
      foregroundColor: Colors.black, 
     
      child: const Text('Done', style: TextStyle(fontSize: 16)),
      onPressed: () {
        Navigator.of(context).pop(); 
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8), 
      ),
    ),
  ),
),

        ],
      ),
    );
  }
}
