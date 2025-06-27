import 'package:sqflite/sqflite.dart';
import 'package:lib/core/database/UpDatabase.dart';

class HandleDatabase {
  static final HandleDatabase _instance = HandleDatabase._();
  factory HandleDatabase() => _instance; //ensure the class to always return instance

  HandleDatabase._(); //private constructor

  Future<Database> get _db async => await UpDatabase().instance.database;

  Future<void> insertPerformer({ required int idType, required String name }) async {
    final db = await _db;
    await db.insert('performers', { 'id_type': idType, 'name': name });
  }

  Future<void> insertAlbum({ required String path, required String name, required int year }) async {
    final db = await _db;
    await db.insert('albums', { 'path': path, 'name': name, 'year': year });
  }

  Future<void> insertRola({ required int idPerformer,
                            required int idAlbum,
                            required String path,
                            required String title,
                            required int track,
                            required int year,
                            required String genre }) async {
    final db = await _db;
    await db.insert('rolas', { 'id_performer': idPerformer,
                               'id_album': idAlbum,
                               'path': path,
                               'title': title,
                               'track': track,
                               'year': year,
                               'genre': genre });
  }
}
