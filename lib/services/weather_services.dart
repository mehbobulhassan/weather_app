import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weather_app/models/weather_model.dart';

class WeatherServices {
  
  static const baseUrl = "https://api.openweathermap.org/data/2.5/weather";
  static const apiKey = "c7bb671c2cc22bff519658d3ec31f903";

  Future<WeatherModel> fetchWeather(String city) async {
    final url = "$baseUrl?q=$city&appid=$apiKey";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return WeatherModel.fromJson(data);
    } else {
      throw Exception('not load the data');
    }
  }
}
