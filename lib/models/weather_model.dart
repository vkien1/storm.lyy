// fetches weather data from an API using the latitude and longitude

class MyWeather {
  final String cityName;
  final double temperature;
  final String mainCondition;

  MyWeather({
    required this.cityName,
    required this.temperature,
    required this.mainCondition,
  });

  factory MyWeather.fromJson(Map<String, dynamic> json) {
    return MyWeather(
      cityName: json['name'],
      temperature: json['main']['temp'].toDouble(),
      mainCondition: json['weather'][0]['main'],
    );
  }
}
