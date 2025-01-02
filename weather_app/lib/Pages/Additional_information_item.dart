// ignore: file_names
import 'package:flutter/material.dart';

class AdditionalInformationItem extends StatelessWidget {
  final IconData icons;
  final String label;
  final double value;

  const AdditionalInformationItem(
      {super.key,
      required this.icons,
      required this.label,
      required this.value});

  @override
  // Widget build(BuildContext context) {
  //   return const Column(
  //     children: [
  //       Icon(icons, size: 50), //Icons.water_drop
  //       SizedBox(
  //         height: 8,
  //       ),
  //       Text(
  //         label,
  //         style: TextStyle(
  //           fontSize: 12,
  //         ),
  //       ),
  //       SizedBox(
  //         height: 8,
  //       ),
  //       Text(
  //         value,
  //         style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  //       ),
  //     ],
  //   );
  // }

  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icons, // Replace 'icons' with an actual IconData or pass it dynamically
          size: 50,
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          label, // Replace 'label' with a string or pass it dynamically
          style: const TextStyle(
            fontSize: 12,
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          value
              .toString(), // Replace 'value' with a string or pass it dynamically
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
