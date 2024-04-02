import 'dart:convert';

import 'package:flutter_minimalist_weatherapp/models/weather_model.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class WeatherService{
  static const BASE_URL = "https://api.openweathermap.org/data/2.5/weather";
  final String apiKey;

  WeatherService(this.apiKey);

  Future<Weather> getWeather(String cityName) async{  //method for getting the weather through the city
    final response = await http.get(Uri.parse('$BASE_URL?q=$cityName&appid=$apiKey&units=metric'));

    if(response.statusCode == 200){
      return Weather.fromJson(jsonDecode(response.body));
    }else{
      throw Exception("Failed to fetch the API" + response.body.toString());
    }
  }

  Future<String> getCurrentCity() async{ //handling the location of the user & getting the user's cityname to pass it on to get the weather

    //get the location permission from user
    LocationPermission permission = await Geolocator.checkPermission();

    if(permission==LocationPermission.denied){
      permission = await Geolocator.requestPermission();
    }


    //fetch the user location 
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    //convert the location into coordinates 
    List<Placemark> placemark = await placemarkFromCoordinates(position.latitude, position.longitude);

    //get the cityname from the coordinates
    String? cityName = placemark[0].locality;

    return cityName??"";
  }
}