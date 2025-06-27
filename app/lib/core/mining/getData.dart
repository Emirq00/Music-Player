import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

Future<List<File>> _scanDir(Directory root, List<String> extensions) async {
  final List<File> matches = [];
  if (!await root.exists()) return matches;
  await for (var entity in root.list(recursive: true, followLinks: false)) {
    if (entity is File && extensions.contains(p.extension(entity.path).toLowerCase())) {
      matches.add(entity);
    }
  }
  return matches;
}

Future<List<File>> scanFiles({List<String> extensions = const ['.mp3']}) async {
  Directory root;
  if (Platform.isAndroid) {
    final status = await Permission.storage.request();
    if (!status.isGranted) throw Exception('Permiso denegado');
    root = (await getExternalStorageDirectory())!;
  } else {
    root = await getApplicationDocumentsDirectory();
  }
  return _scanDir(root, extensions.map((e) => e.toLowerCase()).toList());
}
