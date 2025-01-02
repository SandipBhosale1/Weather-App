import "package:flutter/material.dart";

class HourlyForecast extends StatelessWidget {
  // ignore: non_constant_identifier_names
  final String Time;
  // ignore: non_constant_identifier_names
  final String Temperature;
  final IconData icons;

  const HourlyForecast(
      {super.key,
      // ignore: non_constant_identifier_names
      required this.Time,
      // ignore: non_constant_identifier_names
      required this.Temperature,
      required this.icons});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Card(
        child: Container(
          width: 100,
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Text(
                Time,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ), //Time
              SizedBox(
                height: 8,
              ),
              Icon(
                icons,
                size: 32,
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                Temperature,
                // style: TextStyle(
                //   fontSize: 16,
                //   fontWeight: FontWeight.normal,
                // ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
