import 'dart:io';
import 'package:flutter/material.dart';
import 'package:music_database/core/models/rola_data.dart';
import 'package:music_database/core/models/miner_controller.dart';
import 'package:music_database/gui/widgets/scrolling_rolas.dart';
import 'package:music_database/gui/widgets/rola_info.dart';
import 'package:music_database/gui/widgets/rola_row.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            // Rolas list (60 %)
            const Expanded(
              flex: 6,
              child: ScrollingRolas(),
            ),
            // Rola info (40 %)
            Expanded(
              flex: 4,
              child: Container(
                decoration: const BoxDecoration(
                  color: const Color(0x1A9E9E9E),
                  //border: Border(left: BorderSide(color: Color(0x4D9E9E9E), width: 1
                ),
                child: const RolaInfo(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
