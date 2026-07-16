import 'package:flutter/material.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/services/weather_services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _cityController = TextEditingController();

  WeatherModel? weather;
  bool isLoading = false;
  final WeatherServices _weatherServices = WeatherServices();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  Future<void> searchWeather() async {
    FocusScope.of(context).unfocus();
    final city = _cityController.text.trim();

    if (city.isEmpty) return;

    setState(() {
      isLoading = true;
    });

    try {
      final WeatherModel result = await _weatherServices.fetchWeather(city);

      setState(() {
        weather = result;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Weather App"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: _cityController,
                decoration: const InputDecoration(
                  hintText: "Enter the City",
                  prefixIcon: Icon(Icons.location_city),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: searchWeather,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: const Text("Search"),
              ),
              const SizedBox(height: 100),
              isLoading
                  ? Center(child: CircularProgressIndicator())
                  : weather == null
                  ? Center(
                      child: Text(
                        "Search for a city",
                        style: TextStyle(fontSize: 20),
                      ),
                    )
                  : Center(
                      child: SizedBox(
                        width: 320,
                        child: Card(
                          elevation: 8,
                          color: Colors.grey.shade300,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.network(
                                  "https://openweathermap.org/img/wn/${weather!.icon}@2x.png",
                                ),
                                SizedBox(height: 10),
                                Text(
                                  weather!.city,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "${(weather!.temperature - 273.15).toStringAsFixed(2)}°C",
                                  style: TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Description: ${(weather!.description).toUpperCase()}',
                                ),
                                SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Humidity: ${weather!.humidity}%'),
                                    Text(
                                      'Wind Speed: ${weather!.windSpeed} m/s',
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
