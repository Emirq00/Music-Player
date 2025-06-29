import 'dart:typed_data';

class RolaData {
  final String path;
  final String title;
  final String performer;
  final String album;
  final int    year;
  final String genre;
  final int    track;
  final String audioHash;
  final Uint8List audioBytes;
  final Uint8List? coverBytes;

  const RolaData({
    required this.path,
    required this.title,
    required this.performer,
    required this.album,
    required this.year,
    required this.genre,
    required this.track,
    required this.audioHash,
    required this.audioBytes,
    this.coverBytes,
  });
}
