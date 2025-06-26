import 'package:src/mining/getData.dart';
import 'package:window_manager/window_manager.dart';
import 'package:flutter/material.dart';
import 'gui/home.dart';
import 'package:path_provider/path_provider.dart';

void main() async {



 WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  windowManager.waitUntilReadyToShow().then((_) async {
    await windowManager.setTitle('Application');
    await windowManager.show();
    await windowManager.focus();
  });
  try{
    final files=await scanFiles(extensions: ['.mp3']);
    print("Encontré ${files.length} archivos");
    for(var ola in files){
      print(ola.path);
    }
  }
  catch(e){
    print("No se pudo D:");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Application',
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
