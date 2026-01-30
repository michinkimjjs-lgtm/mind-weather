import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mind_weather/screens/home_screen.dart';
import 'package:mind_weather/utils/app_theme.dart';
import 'package:mind_weather/services/gemini_service.dart';
import 'package:mind_weather/services/storage_service.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://ofhliqfzdbiwmwsfkrpk.supabase.co',
    anonKey: 'sb_publishable_x-l-Q-jwO6xtHxt9C2ErsA_mzO7q2X7',
  );
  await initializeDateFormatting();
  runApp(const MindWeatherApp());
}

class MindWeatherApp extends StatelessWidget {
  const MindWeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => StorageService()),
        Provider(create: (_) => GeminiService()),
      ],
      child: MaterialApp(
        title: 'Mind Weather',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const HomeScreen(),
      ),
    );
  }
}
