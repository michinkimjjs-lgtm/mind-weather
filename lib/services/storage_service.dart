import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/daily_mood.dart';

class StorageService {
  final _supabase = Supabase.instance.client;

  Future<void> saveMood(DailyMood mood) async {
    await _supabase.from('diaries').insert({
      'content': mood.moodText,
      'mood': mood.weatherType,
      'created_at': mood.date.toUtc().toIso8601String(),
    });
  }

  Future<List<DailyMood>> loadMoods() async {
    final response = await _supabase
        .from('diaries')
        .select()
        .order('created_at', ascending: false);

    return (response as List).map((e) => DailyMood(
          date: DateTime.parse(e['created_at']).toLocal(),
          moodText: e['content'],
          weatherType: e['mood'],
        )).toList();
  }

  Future<DailyMood?> getMoodForDate(DateTime date) async {
    // Search for entries that fall within the local day (00:00 to 24:00 Local)
    // Convert these boundaries to UTC for the detailed query
    final startOfDay = DateTime(date.year, date.month, date.day);
    final nextDay = DateTime(date.year, date.month, date.day + 1);

    final response = await _supabase
        .from('diaries')
        .select()
        .gte('created_at', startOfDay.toUtc().toIso8601String())
        .lt('created_at', nextDay.toUtc().toIso8601String())
        .limit(1)
        .maybeSingle();

    if (response == null) return null;

    return DailyMood(
      date: DateTime.parse(response['created_at']).toLocal(),
      moodText: response['content'],
      weatherType: response['mood'],
    );
  }
}
