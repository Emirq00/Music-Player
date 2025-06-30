import 'dart:io';
import 'dart:typed_data';
import 'package:id3/id3.dart';
import 'package:crypto/crypto.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:music_database/core/models/rola_data.dart';

class Miner {
  
  Future<List<RolaData>> mineDirectory({required String customPath}) async {
    final root = Directory(customPath);
    final files = await _scanDir(root);
    final mined = <RolaData>[];
    for (final f in files) {
      final data = await _mineFile(f);
      if (data != null) {
        mined.add(data);
      }
    }
    return mined;
  }

  ///I think its not necessarily
  /*
  /// Find all the mp3 files in the given path, if null, we use Music dir by default
  Future<List<File>> _getMp3s({String? customPath}) async {
    late final Directory root;

    if (customPath != null) {
      root = Directory(customPath);
    } else if (Platform.isAndroid) {
      if (!(await Permission.storage.request()).isGranted) {
        throw Exception('Access deneid.');
      }
      root = Directory('/storage/emulated/0/Music');
    } else if (Platform.isIOS) {
      root = await getApplicationDocumentsDirectory();
    } else { // Linux / macOS / Windows
      final home = Platform.environment['HOME'] ?? '.';
      root = Directory(p.join(home, 'Music'));
    }

    return _scanDir(root);
  } */

  Future<List<File>> _scanDir(Directory dir, {List<String> exts = const ['.mp3']}) async {
    final matches = <File>[];
    if (!await dir.exists()) {
      return matches;
    }
    await for (final entity in dir.list(recursive: true, followLinks: false)) {
      if (entity is File && exts.contains(p.extension(entity.path).toLowerCase())) {
        matches.add(entity);
      }
    }
    return matches;
  }

  Future<RolaData?> _mineFile(File file) async {
    final Uint8List bytes = await file.readAsBytes();
    final mp3 = MP3Instance(bytes)..parseTagsSync();
    final Map<String, dynamic> tags = mp3.getMetaTags() ?? {};
    String _tag(String key, String def) => tags[key] ?? def;
    int _year() {   
      final raw = _tag('TDRC', '');
      final value = int.tryParse(raw.replaceAll(RegExp(r'\D'), ''));
      return (value == null || value < 1900) ? file.statSync().modified.year : value;
    }
    int _track() {
      final raw = _tag('TRCK', '1');
      return int.tryParse(raw.split('/').first) ?? 1;
    }
    Uint8List? _cover() {
      final apic = tags['APIC'];
      return apic is Uint8List ? apic : null;
    }
    return RolaData(
      path: file.path,
      title      : _tag('TIT2', p.basenameWithoutExtension(file.path)),
      performer  : _tag('TPE1', 'UNKNOWN'),
      album      : _tag('TALB', p.basename(p.dirname(file.path))),
      year       : _year(),
      genre      : _tag('TCON', 'UNKNOWN'),
      track      : _track(),
      audioHash  : sha256.convert(bytes).toString(),
      audioBytes : bytes,
      coverBytes : _cover(),
    );
  }
}
