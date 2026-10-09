import 'package:shared_preferences/shared_preferences.dart';

class SettingsPersistence {
  Future<void> saveBackgroundColor(int color) async {
    await SharedPreferencesAsync().setInt('backgroundColor', color);
  }

  Future<int> loadBackgroundColor() async {
    return await SharedPreferencesAsync().getInt('backgroundColor') ??
        0xff000000;
  }

  Future<void> saveSettings(String username, String image) async {
    final prefs = SharedPreferencesAsync();
    await prefs.setString('username', username);
    await prefs.setString('backgroundImage', image);
  }

  Future<Map<String, String>> loadSettings() async {
    final prefs = SharedPreferencesAsync();
    return {
      'username': await prefs.getString('username') ?? '',
      'backgroundImage': await prefs.getString('backgroundImage') ?? '',
    };
  }
}
