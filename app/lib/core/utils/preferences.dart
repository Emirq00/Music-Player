import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static const _keyMusicPath = 'music_path';

  /// Devuelve el path actual o, si no hay guardado,
  /// el Music predeterminado del sistema.
  static Future<String> getPath() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_keyMusicPath);
    if (stored != null && await Directory(stored).exists()) {
      return stored;
    }
    // Fallback por plataforma
    if (Platform.isAndroid) return '/storage/emulated/0/Music';
    if (Platform.isIOS)    return (await getApplicationDocumentsDirectory()).path;
    final home = (await getHomeDirectory()).path;
    return p.join(home, 'Music');
  }

  /// Set the new path
  static Future<void> setPath(String newPath) async {
    final dir = Directory(newPath);
    if (!await dir.exists()) {
      throw Exception('El directorio no existe: $newPath');
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyMusicPath, dir.path);
  }
}
