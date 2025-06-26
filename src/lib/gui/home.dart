import 'package:flutter/material.dart';
import 'package:src/mining/getData.dart';
// import 'gui/home.dart';
import 'dart:io';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<File>> _filesFuture;

  @override
  void initState() {
    super.initState();
    _filesFuture = scanFiles(extensions: ['.mp3']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Archivos encontrados')),
      body: FutureBuilder<List<File>>(
        future: _filesFuture,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState != ConnectionState.done)
            return Center(child: CircularProgressIndicator());
          if (snapshot.hasError)
            return Center(child: Text('Error: ${snapshot.error}'));
          final files = snapshot.data!;
          return ListView.builder(
            itemCount: files.length,
            itemBuilder: (_, i) => ListTile(
              title: Text(files[i].path.split(Platform.pathSeparator).last),
              subtitle: Text(files[i].path),
            ),
          );
        },
      ),
    );
  }
}
