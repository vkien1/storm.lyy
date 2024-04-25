// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:weather/weather.dart';
import 'package:stormly/widgets/forecast_provider.dart'; 

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>(); 
  final WeatherFactory _weatherFactory = WeatherFactory("86c7a0641be5b0591c1c8f1bd926055d"); // Factory to fetch weather data
  Set<Marker> _markers = {};
  Set<TileOverlay> _tileOverlays = {};
  MapType _currentMapType = MapType.normal;  // Current type of map displayed
  String? _currentWeatherOverlay; // Current weather overlay (none)

  static const CameraPosition _kGooglePlex = CameraPosition( 
    target: LatLng(33.7490, -84.3877), // Default camera position (centered around GA.)
    zoom: 6, // Adjust default zoom of map.
  );

  @override
  void initState() {
    super.initState();
    _addTemperatureMarkers();  // Call method for the markers you see
  }

  Future<void> _addTemperatureMarker(double lat, double lon) async {  // Method for markers
    Weather weather = await _weatherFactory.currentWeatherByLocation(lat, lon);
    final marker = Marker(
      markerId: MarkerId('${lat}_${lon}'),
      position: LatLng(lat, lon),
      infoWindow: InfoWindow(
        title: '${weather.areaName}',
        snippet: 'Temp: ${weather.temperature?.fahrenheit?.toStringAsFixed(1)}°F',
      ),
    );

    setState(() {
      _markers.add(marker); // Adds the new marker to the set
    });
  }
  // Adds multiple markers for different locations
  void _addTemperatureMarkers() {
    _addTemperatureMarker(33.7490, -84.3877); // Atlanta, GA
    _addTemperatureMarker(27.6648, -81.5158); // Florida
    _addTemperatureMarker(32.3182, -86.9023); // Alabama
    _addTemperatureMarker(33.8361, -81.1637); // South Carolina
    _addTemperatureMarker(35.5175, -86.5804); // Tennessee
  }

  void _updateWeatherOverlay(String? overlayType) {
    setState(() { 
      _tileOverlays.clear(); // Clears existing overlays
      if (overlayType != null) {
        final tileOverlay = TileOverlay(
          tileOverlayId: TileOverlayId('weather_overlay_$overlayType'),
          tileProvider: ForecastTileProvider( // Provides tile overlays based on weather type
            mapType: overlayType,
            dateTime: DateTime.now(),
            opacity: 0.8,
          ),
        );
        _tileOverlays.add(tileOverlay);
      }
    });
  }

// Widget to select different weather overlays 
  Widget _buildWeatherOverlaySelector() {
    return Positioned(
      top: 110.0,
      right: 10.0,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.7),
          borderRadius: BorderRadius.circular(4.0),
          border: Border.all(color: Colors.grey, width: 0.8),
        ),
        padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String?>(
            value: _currentWeatherOverlay,
            hint: Text("Weather Overlay"),
            // Options for some weather overlays
            items: [
              DropdownMenuItem(value: "PR0", child: Text("Rain")),
              DropdownMenuItem(value: "CL", child: Text("Clouds")),
              DropdownMenuItem(value: "WND", child: Text("Wind")),
              DropdownMenuItem(value: null, child: Text("None")),
            ],
            onChanged: (value) {
              setState(() {
                _currentWeatherOverlay = value; 
                _updateWeatherOverlay(value); // Updates the map overlay based on selection
              });
            },
          ),
        ),
      ),
    );
  }

  // Cylce from normal, satellitle and hybrid map layout
  Widget _buildMapTypeSelector() {
    return Positioned(
      top: 50.0,
      right: 10.0,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.7),
          borderRadius: BorderRadius.circular(4.0),
          border: Border.all(color: Colors.grey, width: 0.8),
        ),
        padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<MapType>(
            value: _currentMapType,
            icon: Icon(Icons.arrow_drop_down),
            // Options for MapTypes.
            items: [
              DropdownMenuItem(value: MapType.normal, child: Text("Normal")),
              DropdownMenuItem(value: MapType.satellite, child: Text("Satellite")),
              DropdownMenuItem(value: MapType.hybrid, child: Text("Hybrid")),
            ],
            onChanged: (MapType? type) {
              if (type != null) {
                setState(() {
                  _currentMapType = type; // Sets new map type
                });
              }
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
            mapType: _currentMapType,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller); // Completes the controller with GoogleMap controller
            },
            markers: _markers,
            tileOverlays: _tileOverlays,
          ),
          _buildMapTypeSelector(), // Adds selector for map types
          _buildWeatherOverlaySelector(), // Adds selector for weather overlays
          Positioned(
            top: 60,
            left: 10,
            child: SafeArea(
              child: FloatingActionButton.small(
                backgroundColor: Colors.white.withOpacity(0.7),
                foregroundColor: Colors.black,
                child: Icon(Icons.arrow_back_ios, size: 15),
                onPressed: () => Navigator.of(context). pop(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
