import 'dart:io';
import 'file_data.dart';
import 'package:id3/id3.dart';
import 'package:crypto/crypto.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';


class Miner {
  Future<List<FileData>> mineDirectory({String? customPath}) async {
    final files = await getMp3s(customPath: customPath);
    final List<FileData> mined = [];
    for (final f in files) {
      final data = await _mineFile(f);
      if (data != null) {
        mined.add(data);
      }
    }
    return mined;
  }

  /// Find all the mp3 files in the given path, if null, we use Music dir by default
  Future<List<File>> _getMp3s({String? customPath}) async {
    Directory root;

    if (customPath != null) {
      root = Directory(customPath);
    } else if (Platform.isAndroid) {
      final status = await Permission.storage.request();
      if (!status.isGranted) {
        throw Exception('Access deneid.');
      }
      // Suele ser /storage/emulated/0/Music
      root = Directory('/storage/emulated/0/Music');
    } else if (Platform.isIOS) {
      root = await getApplicationDocumentsDirectory();
    } else {
      // Linux / macOS / Windows
      final home = (await getHomeDirectory()).path;
      root = Directory(p.join(home, 'Music'));
    }

    return _scanDir(root);
  }

  Future<List<File>> _scanDir(Directory root, {List<String> exts = const ['.mp3']}) async {
    final List<File> matches = [];
    if (!await root.exists()) {
      return matches;
    }
    await for (final entity in root.list(recursive: true, followLinks: false)) {
      if (entity is File && extensions.contains(p.extension(entity.path).toLowerCase())) {
        matches.add(entity);
      }
    }
    return matches;
  }

  Future<SongData?> _mineFile(File file) async {
    final Uint8List? bytes = await file.readAsBytes();
    final id3 = MP3Instance(bytes);

    if (!id3.parseTagsSync()) {
      return null;  // no ID3
    }

    // Default values
    String performer() => tags['TPE1'] ?? 'UNKNOWN';
    String title()     => tags['TIT2'] ?? p.basenameWithoutExtension(file.path);
    String album()     => tags['TALB'] ?? p.basename(p.dirname(file.path));
    String genre()     => tags['TCON'] ?? 'UNKNOWN';

    int year() {   
      final str = tags['TDRC'] ?? '';
      final value = int.tryParse(str.replaceAll(RegExp(r'\D'), ''));
      if (value != null && value >= 1900 && value <= DateTime.now().year) {
        return value;
      }
      //fallback
      return (file.statSync().modified).year;
    }

    int track() {
      final raw = tags['TRCK'];
      if (raw == null) {
        return 1;
      }
      final first = raw.split('/').first;
      return int.tryParse(first) ?? 1;
    }

    Uint8List?? cover() {
      // id3: APIC → bytes
      final apic = tags['APIC'];
      if (apic is Uint8List) {
        return apic;
      }
      return null;
    }
    
    String audioHash() => sha256.convert(bytes).toString();

    return FileData(
      path: file.path,
      title: title(),
      performer: performer(),
      album: album(),
      year: year(),
      genre: genre(),
      track: track(),
      audioHash: audioHash(),
      audioBytes: bytes,
      coverBytes: cover(),
    );
  }
}
