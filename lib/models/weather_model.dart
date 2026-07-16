class WeatherModel {
  final String city;
  final double temperature;
  final int humidity;
  final String description;
  final String icon;
  final double windSpeed;

  WeatherModel({
    required this.city,
    required this.temperature,
    required this.humidity,
    required this.description,
    required this.icon,
    required this.windSpeed,
  });



factory WeatherModel.fromJson(Map<String, dynamic> json){

  return WeatherModel(
    city: json['name'], 
    temperature: (json['main']['temp'] as num).toDouble() , 
    humidity: json['main']['humidity'], 
    description: json['weather'][0]['description'], 
    icon: json['weather'][0]['icon'], 
    windSpeed: (json["wind"]['speed'] as num).toDouble());

}







}



