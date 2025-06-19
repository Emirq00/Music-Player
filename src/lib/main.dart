import 'package:window_manager/window_manager.dart';
import 'package:flutter/material.dart';
import 'gui/home.dart';

void main() async {
 WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  windowManager.waitUntilReadyToShow().then((_) async {
    await windowManager.setTitle('Application');
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Application',
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
