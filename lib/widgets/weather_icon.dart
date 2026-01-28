import 'package:flutter/material.dart';

class WeatherIcon extends StatelessWidget {
  final String weatherType;
  final double size;

  const WeatherIcon({
    super.key,
    required this.weatherType,
    this.size = 50,
  });

  @override
  Widget build(BuildContext context) {
    String assetName;
    switch (weatherType.toLowerCase()) {
      case 'sunny':
      case 'happy':
        assetName = 'sunny.png';
        break;
      case 'cloudy':
      case 'neutral':
        assetName = 'cloudy.png';
        break;
      case 'rainy':
      case 'sad':
        assetName = 'rainy.png';
        break;
      case 'stormy':
      case 'angry':
        assetName = 'stormy.png';
        break;
      case 'snowy':
      case 'calm':
        assetName = 'snowy.png';
        break;
      default:
        assetName = 'cloudy.png';
    }

    return Image.asset(
      'assets/images/$assetName',
      width: size,
      height: size,
      fit: BoxFit.contain,
    );
  }
}
