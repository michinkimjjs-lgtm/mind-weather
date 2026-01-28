import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/daily_mood.dart';

class StorageService {
  static const String key = 'daily_moods';

  Future<void> saveMood(DailyMood mood) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> moodList = prefs.getStringList(key) ?? [];
    
    // Check if entry for today exists and update it, or add new
    // Simple logic: Load all, filter out same day, add new, save
    List<DailyMood> currentMoods = moodList.map((e) => DailyMood.fromJson(jsonDecode(e))).toList();
    
    // Remove any existing entry for the same date (year-month-day)
    currentMoods.removeWhere((item) => 
      item.date.year == mood.date.year && 
      item.date.month == mood.date.month && 
      item.date.day == mood.date.day
    );
    
    currentMoods.add(mood);
    
    // convert back to string list
    List<String> newMoodList = currentMoods.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList(key, newMoodList);
  }

  Future<List<DailyMood>> loadMoods() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> moodList = prefs.getStringList(key) ?? [];
    return moodList.map((e) => DailyMood.fromJson(jsonDecode(e))).toList();
  }
  
  Future<DailyMood?> getMoodForDate(DateTime date) async {
    final moods = await loadMoods();
    try {
      return moods.firstWhere((item) => 
        item.date.year == date.year && 
        item.date.month == date.month && 
        item.date.day == date.day
      );
    } catch (e) {
      return null;
    }
  }
}
