import 'package:flutter/material.dart';

class InitialCircle extends StatelessWidget {
  final String name;
  final double size;

  const InitialCircle({
    super.key,
    required this.name,
    this.size = 50.0, // Default size
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white, // White background
      ),
      alignment: Alignment.center,
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : "?",
        style: TextStyle(
          fontSize: size * 0.5, // Adjust font size based on circle size
          fontWeight: FontWeight.bold,
          color: Colors.black, // Bold black text
        ),
      ),
    );
  }
}
