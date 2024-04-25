// fetches weather data from an API using the latitude and longitude

class MyWeather {
  final String cityName;
  final double temperature;
  final String mainCondition;
  final DateTime time;

  MyWeather({
    required this.cityName,
    required this.temperature,
    required this.mainCondition,
    required this.time,
  });

  factory MyWeather.fromJson(Map<String, dynamic> json) {
    return MyWeather(
      cityName: json['name'],
      temperature: json['main']['temp'].toDouble(),
      mainCondition: json['weather'][0]['main'],
      time: DateTime.fromMicrosecondsSinceEpoch(
          json['dt'] * 1000), // pare time from weather api json
    );
  }
}
