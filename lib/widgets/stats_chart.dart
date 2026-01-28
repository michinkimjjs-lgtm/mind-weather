import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:mind_weather/models/daily_mood.dart';
import 'package:mind_weather/utils/app_theme.dart';
import 'package:mind_weather/widgets/weather_icon.dart';

class StatsChart extends StatelessWidget {
  final List<DailyMood> events;

  const StatsChart({super.key, required this.events});

  @override
  Widget build(BuildContext context) {
    // Calculate stats
    Map<String, int> counts = {};
    for (var e in events) {
      counts[e.weatherType] = (counts[e.weatherType] ?? 0) + 1;
    }

    if (events.isEmpty) {
      return Container(
        height: 300,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: const Center(child: Text("아직 기록된 날씨가 없어요.")),
      );
    }

    return Container(
      height: 400,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Text("이번 달의 날씨 통계", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Expanded(
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 40,
                sections: counts.entries.map((e) {
                  final String type = e.key;
                  final int count = e.value;
                  Color color;
                  switch(type) {
                    case 'sunny': color: Colors.orangeAccent; break;
                    case 'cloudy': color: Colors.grey; break;
                    case 'rainy': color: Colors.blue; break;
                    case 'stormy': color: Colors.deepPurple; break;
                    case 'snowy': color: Colors.cyan; break;
                    default: color: Colors.green;
                  }
                  
                  // Use specific pastel colors from AppTheme if possible or map manually
                  if (type == 'sunny') color = const Color(0xFFFFD166);
                  if (type == 'cloudy') color = AppTheme.primaryBlue;
                  if (type == 'rainy') color = const Color(0xFF118AB2);
                  if (type == 'stormy') color = const Color(0xFF073B4C);
                  if (type == 'snowy') color = AppTheme.primaryMint;

                  return PieChartSectionData(
                    color: color,
                    value: count.toDouble(),
                    title: '$count',
                    radius: 60,
                    titleStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    badgeWidget: _Badge(weatherType: type),
                    badgePositionPercentageOffset: .98,
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String weatherType;
  const _Badge({required this.weatherType});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.2),
            blurRadius: 2,
          ),
        ],
      ),
      padding: const EdgeInsets.all(4),
      child: WeatherIcon(weatherType: weatherType, size: 20),
    );
  }
}
