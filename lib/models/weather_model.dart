class MyWeather {
  final String cityName;
  final double temperature;
  final String mainCondition;
  final String time; // Change the type to String

  MyWeather({
    required this.cityName,
    required this.temperature,
    required this.mainCondition,
    required this.time,
  });

  factory MyWeather.fromJson(Map<String, dynamic> json) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000);

    // Extract hourly time (format: HH:00)
    String hourlyTime = '${dateTime.hour.toString().padLeft(2, '0')}:00';

    // Extract current date and month (format: DD/MM)
    String dateMonth =
        '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}';

    // Combine hourly time and date/month into a single string
    String formattedTime = '$hourlyTime, $dateMonth';

    return MyWeather(
      cityName: json['name'],
      temperature: json['main']['temp'].toDouble(),
      mainCondition: json['weather'][0]['main'],
      time: formattedTime, // Assign the formatted time string
    );
  }
}
