// ignore_for_file: file_names
import 'dart:convert';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/Pages/Additional_information_item.dart';
import 'package:weather_app/Pages/hourly_forecast_item.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late Future<Map<String, dynamic>> currentWeatherFuture;
  late Future<List<dynamic>> hourlyForecastFuture;
  String cityName = "Pune,India";

  @override
  void initState() {
    super.initState();
    loadEnvironmentAndFetchWeather();
  }

  void loadEnvironmentAndFetchWeather() async {
    await dotenv.load(fileName: ".env");
    setState(() {
      currentWeatherFuture = getCurrentWeather();
      hourlyForecastFuture = getHourlyForecast();
    });
  }

  Future<Map<String, dynamic>> getCurrentWeather() async {
    final apiKey = dotenv.env['OpenWeatherApiKey'];

    if (apiKey == null) {
      throw Exception("API key not found in .env file");
    }

    final url =
        "https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey&units=metric";

    final res = await http.get(Uri.parse(url));
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return {
        'temperature': data['main']['temp'],
        'weatherCondition': data['weather'][0]['description'],
        'humidity': data['main']['humidity'],
        'windSpeed': data['wind']['speed'],
        'pressure': data['main']['pressure'],
      };
    } else {
      throw Exception("Error fetching current weather: ${res.body}");
    }
  }

  Future<List<dynamic>> getHourlyForecast() async {
    final apiKey = dotenv.env['OpenWeatherApiKey'];

    if (apiKey == null) {
      throw Exception("API key not found in .env file");
    }

    final url =
        "https://api.openweathermap.org/data/2.5/forecast?q=$cityName&appid=$apiKey&units=metric";

    final res = await http.get(Uri.parse(url));
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return data['list'];
    } else {
      throw Exception("Error fetching hourly forecast: ${res.body}");
    }
  }

  void showCityInputDialog() {
    final TextEditingController cityController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Enter City Name"),
          content: TextField(
            controller: cityController,
            decoration: const InputDecoration(
              hintText: "City Name",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  cityName = cityController.text.trim();
                  loadEnvironmentAndFetchWeather();
                });
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Weather App",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: loadEnvironmentAndFetchWeather,
            icon: const Icon(Icons.refresh),
            tooltip: "Refresh",
          ),
          IconButton(
            onPressed: showCityInputDialog,
            icon: const Icon(Icons.location_city),
            tooltip: "Change City",
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: currentWeatherFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          }

          final weatherData = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Main Weather Card
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Text(
                                "${weatherData['temperature']} °C",
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Icon(
                                Icons.cloud,
                                size: 64,
                              ),
                              Text(
                                weatherData['weatherCondition'],
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Hourly Forecast Section
                FutureBuilder<List<dynamic>>(
                  future: hourlyForecastFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Text("Error: ${snapshot.error}"),
                      );
                    }

                    final hourlyData = snapshot.data!;
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(hourlyData.length, (index) {
                          final hourData = hourlyData[index];
                          final time = DateTime.fromMillisecondsSinceEpoch(
                              hourData['dt'] * 1000);
                          final temperature = hourData['main']['temp'];
                          final weatherIcon = hourData['weather'][0]['icon'];

                          return HourlyForecast(
                            Time: "${time.hour}:00",
                            icons: getWeatherIcon(weatherIcon),
                            Temperature: "$temperature°C",
                          );
                        }),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),

                // Additional Information Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AdditionalInformationItem(
                      icons: Icons.water_drop,
                      label: "Humidity",
                      value: weatherData['humidity'],
                    ),
                    AdditionalInformationItem(
                      icons: Icons.air,
                      label: "Wind Speed",
                      value: weatherData['windSpeed'],
                    ),
                    AdditionalInformationItem(
                      icons: Icons.beach_access,
                      label: "Pressure",
                      value: weatherData['pressure'],
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  IconData getWeatherIcon(String iconCode) {
    switch (iconCode) {
      case '01d':
        return Icons.wb_sunny;
      case '01n':
        return Icons.nights_stay;
      case '02d':
      case '02n':
        return Icons.cloud;
      case '03d':
      case '03n':
      case '04d':
      case '04n':
        return Icons.cloud_queue;
      case '09d':
      case '09n':
        return Icons.grain;
      case '10d':
      case '10n':
        return Icons.grain;
      case '11d':
      case '11n':
        return Icons.flash_on;
      case '13d':
      case '13n':
        return Icons.ac_unit;
      case '50d':
      case '50n':
        return Icons.blur_on;
      default:
        return Icons.help;
    }
  }
}
