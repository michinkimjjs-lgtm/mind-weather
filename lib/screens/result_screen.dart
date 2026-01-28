import 'package:flutter/material.dart';
import 'package:mind_weather/models/daily_mood.dart';
import 'package:mind_weather/services/storage_service.dart';
import 'package:mind_weather/utils/app_theme.dart';
import 'package:mind_weather/widgets/weather_icon.dart';
import 'package:provider/provider.dart';

class ResultScreen extends StatelessWidget {
  final String moodText;
  final String weatherType;

  const ResultScreen({
    super.key,
    required this.moodText,
    required this.weatherType,
  });

  String _getWeatherDescription() {
    switch (weatherType) {
      case 'sunny': return '맑음 (행복)';
      case 'cloudy': return '흐림 (평범/걱정)';
      case 'rainy': return '비 (우울/슬픔)';
      case 'stormy': return '천둥번개 (화남)';
      case 'snowy': return '눈 (평온)';
      default: return weatherType;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '오늘의 마음 날씨는...',
                style: TextStyle(fontSize: 22, color: Colors.grey),
              ),
              const SizedBox(height: 40),
              // Animation or big icon
              TweenAnimationBuilder(
                tween: Tween<double>(begin: 0, end: 1),
                duration: const Duration(milliseconds: 1000),
                builder: (context, double value, child) {
                  return Transform.scale(
                    scale: value,
                    child: child,
                  );
                },
                child: WeatherIcon(weatherType: weatherType, size: 200),
              ),
              const SizedBox(height: 20),
              Text(
                _getWeatherDescription(),
                style: const TextStyle(
                  fontSize: 28, 
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textDark
                ),
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () async {
                  final storage = context.read<StorageService>();
                  await storage.saveMood(DailyMood(
                    date: DateTime.now(),
                    moodText: moodText,
                    weatherType: weatherType,
                  ));
                  if (context.mounted) {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                  backgroundColor: AppTheme.primaryMint,
                ),
                child: const Text('일기장에 기록하기', style: TextStyle(fontSize: 18)),
              ),
              TextButton(
                onPressed: () {
                   Navigator.pop(context); // Go back to edit
                },
                child: const Text('다시 쓰기', style: TextStyle(color: Colors.grey)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
