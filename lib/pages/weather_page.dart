import 'package:flutter/material.dart';
import 'package:flutter_minimalist_weatherapp/models/weather_model.dart';
import 'package:flutter_minimalist_weatherapp/services/weather_service.dart';
import 'package:lottie/lottie.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {

  //api key
  final _weatherService = WeatherService('4e455e106f9c64970e020812f7197084');
  Weather? _weather;

  //fetch weather
  _fetchWeather() async{
    //get cityname 
    String cityName = await _weatherService.getCurrentCity();

    //get weather for that city
    try{
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch(e){
        print(e);
    }
  }

  //weather animations
  String getWeatherAnimation(String? mainCondition){
    if(mainCondition == null) {
      return 'assets/sunny.json';
    }

    switch(mainCondition.toLowerCase()){
      case 'clouds': 
        return 'assets/cloudy.json';

      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/misty.json';  
      
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rainy.json';

      case 'thunderstorm':
        return 'assets/thunderstorm.json';

      case 'clear':
        return 'assets/sunny.json';

      default : return 'assets/sunny.json';
    }
  }


  @override
  void initState() {
    // init state to fetch the weather at the very start
    super.initState();

    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text("Weather Today", style: TextStyle(  fontSize: 50, color: Colors.black),),

          //city name
          Text(_weather?.cityName ?? "loading city ...", style: TextStyle(  fontSize: 30, color: Colors.black),),

          //animation
          Lottie.asset(getWeatherAnimation(_weather?.mainCondition ?? "")),

          //weather 
          Text("${_weather?.temperature.round()??"loading..."}° C", style: TextStyle(  fontSize: 25, color: Colors.black),),
        ],
      ),
      )
    );
  }
}