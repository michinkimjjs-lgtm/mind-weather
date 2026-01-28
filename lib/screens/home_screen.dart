import 'package:flutter/material.dart';
import 'package:mind_weather/models/daily_mood.dart';
import 'package:mind_weather/screens/input_screen.dart';
import 'package:mind_weather/services/storage_service.dart';
import 'package:mind_weather/utils/app_theme.dart';
import 'package:mind_weather/widgets/weather_icon.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../widgets/stats_chart.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, DailyMood> _events = {};

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    final storage = context.read<StorageService>();
    final moods = await storage.loadMoods();
    if (mounted) {
      setState(() {
        _events = {
          for (var m in moods)
            DateTime(m.date.year, m.date.month, m.date.day): m
        };
      });
    }
  }

  List<DailyMood> _getEventsForDay(DateTime day) {
    final normalizedDay = DateTime(day.year, day.month, day.day);
    if (_events.containsKey(normalizedDay)) {
      return [_events[normalizedDay]!];
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mind Weather'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => StatsChart(events: _events.values.toList()),
                backgroundColor: Colors.transparent,
              );
            },
          )
        ],
      ),
      body: Column(
        children: [
          TableCalendar<DailyMood>(
            firstDay: DateTime.utc(2023, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            eventLoader: _getEventsForDay,
            calendarFormat: CalendarFormat.month,
            startingDayOfWeek: StartingDayOfWeek.sunday,
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
            calendarStyle: const CalendarStyle(
              outsideDaysVisible: false,
              todayDecoration: BoxDecoration(
                color: AppTheme.primaryMint,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: AppTheme.primaryBlue,
                shape: BoxShape.circle,
              ),
            ),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
              
              // Check if entry exists, show details?
              // For now, simple selection.
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                if (events.isNotEmpty) {
                  return Positioned(
                    bottom: 1,
                    child: WeatherIcon(
                      weatherType: events.first.weatherType,
                      size: 20,
                    ),
                  );
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 20),
          if (_selectedDay != null && _getEventsForDay(_selectedDay!).isNotEmpty)
             Expanded(
               child: Container(
                 margin: const EdgeInsets.all(20),
                 padding: const EdgeInsets.all(20),
                 decoration: BoxDecoration(
                   color: Colors.white,
                   borderRadius: BorderRadius.circular(20),
                   boxShadow: [
                     BoxShadow(
                       color: Colors.black.withOpacity(0.05),
                       blurRadius: 10,
                       offset: const Offset(0, 5),
                     )
                   ]
                 ),
                 child: Column(
                   children: [
                     // Show big icon and text
                     WeatherIcon(
                       weatherType: _getEventsForDay(_selectedDay!).first.weatherType,
                       size: 80,
                     ),
                     const SizedBox(height: 10),
                     Text(
                       _getEventsForDay(_selectedDay!).first.moodText,
                       style: const TextStyle(fontSize: 16),
                       textAlign: TextAlign.center,
                     ),
                   ],
                 ),
               ),
             ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.primaryPink,
        child: const Icon(Icons.edit, color: Colors.white),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const InputScreen()),
          );
          _loadEvents(); // Refresh after return
        },
      ),
    );
  }
}
