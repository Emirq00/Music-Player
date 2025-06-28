import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:path/path.dart' as p;

import '../core/miner/miner.dart';
import '../core/models/file_data.dart';
import '../core/database/handle_database.dart';
import '../core/utils/preferences.dart';

class _FileCache {
  final Set<String> hashes = {};
  final Map<String, int> _albumIds = {};
}

class MinerController {
  final Miner          _miner = Miner();
  final HandleDatabase _db    = HandleDatabase();
  final _FileCache     _cache = _FileCache();

  int? _unknownPerformerId;

  /// Mine the selected dir and return the mined songs
  Future<List<FileData>> mineAndSave({String? customPath}) async {
    // get dir
    final musicPath = customPath ?? await Preferences.getPath();
    // get the unique hashes from each song
    _cache.hashes
      ..clear()
      ..addAll(await _db.getAllAudioHashes());
    // mine
    final songs = await _miner.mineDirectory(customPath: musicPath);
    
    await _ensureUnknownPerformer();

    final inserted = <FileData>[];
    for (final s in songs) {
      if (_cache.hashes.contains(s.audioHash)) {
        continue; // ya estaba
      }

      String? coverHash;
      if (s.coverBytes != null) {
        coverHash = sha256.convert(s.coverBytes!).toString();
        await _db.insertCover(hash: coverHash, bytes: s.coverBytes!);
      }

      final albumId = await _getOrInsertAlbum(s, coverHash);
      final performerId = s.performer.trim().toUpperCase() == 'UNKNOWN'
          ? _unknownPerformerId!
          : await _db.insertPerformer(idType: 0, name: s.performer);
      
      await _db.insertAudio(hash: s.audioHash, bytes: s.audioBytes);

      await _db.insertRola(
        idPerformer: performerId!,
        idAlbum    : albumId!,
        path       : s.path,
        title      : s.title,
        track      : s.track,
        year       : s.year,
        genre      : s.genre,
        audioHash  : s.audioHash,
        coverHash  : coverHash
      );

      _cache.hashes.add(s.audioHash);
      inserted.add(s);
    }
    return inserted; // for th GUI
  }

  Future<void> _ensureUnknownPerformer() async {
    if (_unknownPerformerId != null) {
      return _unknownPerformerId!;
    }

    _unknownPerformerId =
        await _db.insertPerformer(idType: 2, name: 'UNKNOWN');
  }

  Future<int> _getOrInsertAlbum(FileData song, String? coverHash) async {
    final key = '${song.album}-${song.year}';

    if (_cache.albumIds.containsKey(key)) {
      return _cache.albumIds[key]!;
    }

    final id = await _db.insertAlbum(
      path : p.dirname(song.path),
      name : song.album,
      year : song.year,
      coverHash: coverHash,
    );

    _cache.albumIds[key] = id;

    if (coverHash != null) {
      await _db.updateAlbumCover(albumId: id, coverHash: coverHash);
    }

    return id;
  }
}
