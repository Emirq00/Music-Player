import 'dart:io';                                       // Handle files
import 'package:path/path.dart' as p;                   // Path files
import 'package:sqflite/sqflite.dart';                  // SQLite
import 'package:path_provider/path_provider.dart';      // Get system files
import 'package:sqflite_common_ffi/sqflite_ffi.dart';   // SQLite for desktop
import 'package:flutter/services.dart' show rootBundle; // Read .sql files

class UpDatabase {
  UpDatabase._(); //private constructor
  static final UpDatabase instance = UpDatabase._();
  static const String _databaseName = 'music.db';

  Database? _db; //db reference

  //return the db if is already up, otherwise create it
  Future<Database> get database async =>
    _db ??= await _open();
  
  Future<Database> _open() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = p.join(dir.path, _databaseName);
    
    print(File(path).existsSync() ? 'Database found at: $path' : 'New database created on: $path');
    
    if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
      return databaseFactoryFfi.openDatabase(
        path,
        options: OpenDatabaseOptions(
          version: 1,
          onCreate: _applySchema,
        ),
      );
    } else {
      return await openDatabase(path, version: 1, onCreate: _applySchema);
    }
  }

  Future<void> _applySchema(Database db, int version) async {
    final sql = await rootBundle.loadString('assets/database/schema.sql'); //read db sql schema
    List<String> statements = sql.split(';'); //read and run each line

    for (String statement in statements) {
      if (statement.trim().isNotEmpty) {
        await db.execute(statement);
      }
    }
  }
}
