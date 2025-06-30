import 'package:flutter/material.dart';

class RolaInfo extends StatelessWidget {
  const RolaInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Select a song to play',
        style: Theme.of(context).textTheme.titleLarge,
        textAlign: TextAlign.center,
      ),
    );
  }
}
