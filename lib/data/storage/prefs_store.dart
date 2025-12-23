import 'package:shared_preferences/shared_preferences.dart';

class PrefKeys {
  static const isChallengeActive = 'isChallengeActive';
  static const currentGoal = 'currentGoal';
  static const goalDuration = 'goalDuration';
  static const startDate = 'startDate';
  static const successCount = 'successCount';
  static const lastCheckDate = 'lastCheckDate';
}

class PrefsStore {
  Future<SharedPreferences> get _prefs async => SharedPreferences.getInstance();

  Future<bool> getBool(String key, {bool fallback = false}) async {
    final p = await _prefs;
    return p.getBool(key) ?? fallback;
  }

  Future<int> getInt(String key, {int fallback = 0}) async {
    final p = await _prefs;
    return p.getInt(key) ?? fallback;
  }

  Future<String> getString(String key, {String fallback = ''}) async {
    final p = await _prefs;
    return p.getString(key) ?? fallback;
  }

  Future<void> setBool(String key, bool value) async {
    final p = await _prefs;
    await p.setBool(key, value);
  }

  Future<void> setInt(String key, int value) async {
    final p = await _prefs;
    await p.setInt(key, value);
  }

  Future<void> setString(String key, String value) async {
    final p = await _prefs;
    await p.setString(key, value);
  }

  Future<void> clearChallenge() async {
    final p = await _prefs;
    await p.remove(PrefKeys.isChallengeActive);
    await p.remove(PrefKeys.currentGoal);
    await p.remove(PrefKeys.goalDuration);
    await p.remove(PrefKeys.startDate);
    await p.remove(PrefKeys.successCount);
    await p.remove(PrefKeys.lastCheckDate);
  }
}
