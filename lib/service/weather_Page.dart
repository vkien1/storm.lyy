// // temp weather page

// import 'package:flutter/material.dart';
// import 'package:stormly/models/weather_model.dart';
// import 'package:stormly/service/weather_service.dart';

// class WeatherPage extends StatefulWidget {
//   const WeatherPage({super.key});

//   @override
//   State<WeatherPage> createState() => _WeatherPageState();
// }

// // class _WeatherPageState extends State<WeatherPage> {
//   //api key
//   final _weatherSevice = WeatherService('86c7a0641be5b0591c1c8f1bd926055d');
//   MyWeather? _weather;

//   // fetch weather
//   _fetchWeather() async {
//     //get the current city
//     String cityName = await _weatherSevice.getCurrentCity();

//     // get weather
//     try {
//       final weather = await _weatherSevice.getWeather(cityName);
//       setState(() {
//         _weather = weather;
//       });
//     }
//     // error catcher casue ill know ill mess up lol , like alawys
//     catch (e) {
//       print(e);
//     }
//   }
//   //weather animations

//   // inital sate of weather fetch
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();

//     _fetchWeather();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             //city name
//             Text(_weather?.cityName ?? "loading city.."),

//             //temperature
//             Text('${_weather?.temperature.round()}°C')
//           ],
//         ),
//       ),
//     );
//   }
// }
