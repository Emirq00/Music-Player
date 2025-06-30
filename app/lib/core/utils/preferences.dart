import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static const _keyMusicPath = 'music_path';

  /// Return kept dir path or Music/ default dir
  static Future<String> getPath() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_keyMusicPath);
    if (stored != null && Directory(stored).existsSync()) {
      return stored;
    }
    // Fallback
    if (Platform.isAndroid) {
      return '/storage/emulated/0/Music';
    }
    if (Platform.isIOS) {
      return (await getApplicationDocumentsDirectory()).path;
    }
    return p.join(Platform.environment['HOME'] ?? '.', 'Music');
  }

  /// Set the new path
  static Future<void> setPath(String path) async {
    if (!Directory(path).existsSync()) {
      throw Exception('Invalid path');
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyMusicPath, path);
  }
}
