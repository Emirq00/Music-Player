import 'dart:io';                                       // Handle files
import 'package:path/path.dart' as p;                   // Path files
import 'package:sqflite/sqflite.dart';                  // SQLite
import 'package:path_provider/path_provider.dart';      // Get system files
import 'package:file_selector/file_selector.dart';      // File selector
import 'package:flutter/services.dart' show rootBundle; // Read .sql files

class UpDatabase {
  static const String _databaseName = 'music.db';
  static final Database instance = UpDatabase._(); 

  UpDatabase._(); //private constructor

  Database? _db; //db reference

  //return the db if is already up, otherwise create it
  Future<Database> get database async {
    if (_db != null)
       return _db!;
       
    _db = await _initDatabase();
    return _db;
  }
  
  Future<Database> _initDatabase() async {
    final Directory dir = await getApplicationDocumentsDirectory(); //get a valid 'Documents' dir depending on the SO
    final String path = p.join(dir.path, _databaseName); //put the file music.db on the users Documents dir
    
    if (!File(path).existsSync()) {
      print('New database created on: $path');
    } else {
      print('Database found at: $path');
    }
    
    return await openDatabase(
      path,
      version: 1,
      applySchema: _applySchema); //open or create the db
  }

  Future<void> _applySchema(Database db, int version) async {
    String sql = await rootBundle.loadString('assets/database/schema.sql'); //read db sql schema

    List<String> statements = sql.split(';'); //read and run each line

    for (String statement in statements) {
      if (statement.trim().isNotEmpty) {
        await db.execute(statement);
      }
    }
  }
}
