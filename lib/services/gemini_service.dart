import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  // TODO: Replace with your actual Gemini API Key
  // You can get one at https://aistudio.google.com/
  static const String _apiKey = 'AIzaSyDEeHRj5MFU6SKX6p5zxozIa8EnwpFBCxU';
  
  late final GenerativeModel _model;

  GeminiService() {
    _model = GenerativeModel(
      model: 'gemini-pro',
      apiKey: _apiKey,
    );
  }

  Future<String> analyzeMood(String text) async {
    if (_apiKey == 'YOUR_API_KEY_HERE') {
      // Simulate for demo if key is missing
      await Future.delayed(const Duration(seconds: 1));
      return 'sunny'; 
    }

    final prompt = '''
      Analyze the sentiment of the following diary entry and classify it into exactly one of these weather categories:
      - sunny (for happy, joy, positive, excited)
      - cloudy (for neutral, bored, anxious, confused)
      - rainy (for sad, depressed, melancholic, crying)
      - stormy (for angry, frustrated, stressed, mad)
      - snowy (for calm, peaceful, cool, relaxed)

      Diary entry: "$text"

      Return ONLY the category name in lowercase (e.g., "sunny"). Do not add any explanation or extra text.
    ''';

    try {
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      String result = response.text?.trim().toLowerCase() ?? 'sunny';
      
      // Safety check to ensure valid category
      final validCategories = ['sunny', 'cloudy', 'rainy', 'stormy', 'snowy'];
      if (!validCategories.contains(result)) {
        // Fallback or attempt to parse if it contains the word
        for (var cat in validCategories) {
          if (result.contains(cat)) return cat;
        }
        return 'cloudy'; // Default fallback
      }
      return result;
    } catch (e) {
      print('Gemini API Error: $e');
      return 'cloudy'; // Fallback on error
    }
  }
}
