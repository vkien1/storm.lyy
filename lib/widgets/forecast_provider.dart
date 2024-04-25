import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// TileProvider implementation to fetch weather map tiles
class ForecastTileProvider implements TileProvider {
  final String mapType;
  final DateTime dateTime;
  int tileSize = 256;
  final double opacity;

// Constructor requiring map type, date-time, and opacity level
  ForecastTileProvider({
    required this.mapType,
    required this.dateTime,
    required this.opacity,
  });

// Method to get a tile at a given x, y coordinate and zoom level
  @override
  Future<Tile> getTile(int x, int y, int? zoom) async {
    Uint8List tileBytes = Uint8List(0);
    try {
      final date = dateTime.millisecondsSinceEpoch ~/ 1000; // Converts date to timestamp
      final url =
          "http://maps.openweathermap.org/maps/2.0/weather/$mapType/$zoom/$x/$y?date=$date&opacity=$opacity&fill_bound=true&appid=9de243494c0b295cca9337e1e96b00e2";
      if (TilesCache.tiles.containsKey(url)) {
        tileBytes = TilesCache.tiles[url]!; // Retrieves tile from cache if available
      } else {
        final uri = Uri.parse(url);

        final ByteData imageData = await NetworkAssetBundle(uri).load(""); // Loads tile image data from network
        tileBytes = imageData.buffer.asUint8List();
        TilesCache.tiles[url] = tileBytes;
      }
    } catch (e) {
      print(e.toString()); // Prints any errors encountered
    }
    return Tile(tileSize, tileSize, tileBytes);
  }
}

class TilesCache {
  static Map<String, Uint8List> tiles = {}; // Maps URLs to cached tiles
}