import 'dart:io';                                       // Handle files
import 'package:path/path.dart' as p;                   // Path files
import 'package:sqflite/sqflite.dart';                  // SQLite
import 'package:path_provider/path_provider.dart';      // Get system files
import 'package:flutter/services.dart' show rootBundle; // Read .sql files

class UpDatabase {
  UpDatabase._(); //private constructor
  static const String _databaseName = 'music.db';
  static final UpDatabase instance = UpDatabase._(); 

  Database? _db; //db reference

  //return the db if is already up, otherwise create it
  Future<Database> get database async {
    _db ??= await _open();
    return _db!;
  }
  
  Future<Database> _open() async {
    final dir = await getApplicationDocumentsDirectory(); //get a valid 'Documents' dir depending on the SO
    final path = p.join(dir.path, _databaseName); //put the file music.db on the users Documents dir
    
    if (!File(path).existsSync()) {
      print('New database created on: $path');
    } else {
      print('Database found at: $path');
    }
    
    return await openDatabase(
      path,
      version: 1,
      onCreate: _applySchema,
    );
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
