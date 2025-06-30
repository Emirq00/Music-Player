import 'dart:async';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'gui/home_page.dart';
import 'package:music_database/core/database/up_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  
  await windowManager.ensureInitialized();  
  windowManager.waitUntilReadyToShow().then((_) async {
      await windowManager.setTitle('Music-Database');
      await windowManager.show();
      await windowManager.focus();
  });

  unawaited(UpDatabase.instance.database);
    
  runApp(MusicApp());
}

class MusicApp extends StatelessWidget {
  const MusicApp({super.key});
    
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music-Database',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(useMaterial3: true),
      home: HomePage(),
    );
  }
}
