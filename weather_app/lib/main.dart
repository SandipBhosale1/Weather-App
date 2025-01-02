import 'package:flutter/material.dart';
import 'package:weather_app/Pages/Weather_Screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WeatherScreen(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(
        useMaterial3: true,
      ),
      // ).copyWith(
      //     appBarTheme: AppBarTheme(
      //   backgroundColor: Colors.black87,
      // )),
    );
  }
}
