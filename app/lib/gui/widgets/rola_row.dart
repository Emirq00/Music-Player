import 'package:flutter/material.dart';
import 'package:music_database/core/models/rola_data.dart';

class RolaRow extends StatelessWidget {
  final RolaData data;
  final VoidCallback? onPlay;

  const RolaRow({
      super.key,
      required this.data,
      this.onPlay,
  });
  
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      child: SizedBox( //Padding(
        height: 80, //padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            // Cover
            ClipRRect(
              borderRadius: BorderRadius.horizontal(left: Radius.circular(12)),
              child: data.coverBytes != null
              ? Image.memory(
                data.coverBytes!,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              )
              : Image.asset(
                'assets/covers/empty_cover.jpg',
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 2),
            
            // Text and button
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    // Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${data.title} · ${data.performer}',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 20),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${data.album}(${data.year}) · ${data.track}',
                            style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(fontSize: 16, color: Colors.grey[600]),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    
                    // Play Button
                    IconButton(
                      icon: const Icon(Icons.play_arrow),
                      onPressed: onPlay ?? () {},
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
