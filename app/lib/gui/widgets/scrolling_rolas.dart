import 'package:flutter/material.dart';
import 'package:music_database/gui/widgets/rola_row.dart';
import 'package:music_database/gui/widgets/fake_data.dart';

class ScrollingRolas extends StatelessWidget {
  const ScrollingRolas({super.key});

  @override
  Widget build(BuildContext context) {
    final rolas = fakeRolas(); //call miner_controller

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: rolas.length,
      itemBuilder: (context, index) {
        return RolaRow(
          data: rolas[index],
          onPlay: () {
            //call player
          },
        );
      },
    );
  }
}
