class DailyMood {
  final DateTime date;
  final String moodText;
  final String weatherType; // 'sunny', 'cloudy', 'rainy', 'stormy', 'snowy'

  DailyMood({
    required this.date,
    required this.moodText,
    required this.weatherType,
  });

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'moodText': moodText,
      'weatherType': weatherType,
    };
  }

  factory DailyMood.fromJson(Map<String, dynamic> json) {
    return DailyMood(
      date: DateTime.parse(json['date']),
      moodText: json['moodText'],
      weatherType: json['weatherType'],
    );
  }
}
