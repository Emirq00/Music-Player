import 'package:sqflite/sqflite.dart';
import 'package:lib/core/database/up_database.dart';

class HandleDatabase {
  static final HandleDatabase _instance = HandleDatabase._();
  factory HandleDatabase() => _instance; //ensure the class to always return instance

  HandleDatabase._(); //private constructor

  Future<Database> get _db async => await UpDatabase().instance.database;

  /// -- GETTER -- ///
  Future<Map<String, int>> getAllPerformers() async {
    final rows = await (await _db).query('performers', columns: ['id_performer', 'name']);
    return { for (final r in rows) r['name'] as String : r['id_performer'] as int };
  }

  Future<Map<String, int>> getAllAlbums() async {
    final rows = await (await _db).query('albums', columns: ['id_album', 'name', 'year']);
    return {
      for (final r in rows)
        '${r['name'] as String}-${r['year'] as int}' : r['id_album'] as int
    };
  }
  
  Future<Set<String>> getAllAudioHashes() async {
    final rows = await (await _db).query('audios', columns: ['hash']);
    return rows.map((r) => r['hash'] as String).toSet();
  }

  Future<Set<String>> getAllCoverHashes() async {
    final rows = await (await _db).query('covers', columns: ['hash']);
    return rows.map((r) => r['hash'] as String).toSet();
  }
  
  ///  -- INSERTERS -- ///
  
  Future<int> insertPerformer({required int idType, required String name}) async {
    final db = await _db;

    // 1 — existe?
    final row = await db.query(
      'performers',
      columns: ['id_performer'],
      where: 'name = ?',
      whereArgs: [name],
      limit: 1,
    );
    if (row.isNotEmpty) return row.first['id_performer'] as int;

    // 2 — insertar
    final id = await db.insert(
      'performers',
      { 'id_type': idType, 'name': name },
    );
    return id;
  }

  Future<int> insertAlbum({
    required String path,
    required String name,
    required int    year,
    String?         coverHash,
  }) async {
    final db = await _db;
    final keyRow = await db.query(
      'albums',
      columns: ['id_album'],
      where: 'name = ? AND year = ?',
      whereArgs: [name, year],
      limit: 1,
    );
    if (keyRow.isNotEmpty) return keyRow.first['id_album'] as int;

    final id = await db.insert(
      'albums',
      { 'path': path, 'name': name, 'year': year, 'cover_hash': coverHash },
    );
    return id;
  }

  Future<void> insertAudio({required String hash, required Uint8List bytes}) async {
    await (await _db).insert(
      'audios',
      { 'hash': hash, 'bytes': bytes },
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<void> insertCover({required String hash, required Uint8List bytes}) async {
    await (await _db).insert(
      'covers',
      { 'hash': hash, 'picture': bytes },
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }
  
  Future<void> insertRola({
    required int    idPerformer,
    required int    idAlbum,
    required String path,
    required String title,
    required int    track,
    required int    year,
    required String genre,
    String?         coverHash,
    required String audioHash,
  }) async {
    await (await _db).insert(
      'rolas',
      {
        'id_performer' : idPerformer,
        'id_album'     : idAlbum,
        'path'         : path,
        'title'        : title,
        'track'        : track,
        'year'         : year,
        'genre'        : genre,
        'cover_hash'   : coverHash,
        'audioHash'    : audioHash,
      },
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }
}
