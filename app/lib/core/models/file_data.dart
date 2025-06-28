class FileData {
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

  const FileData({
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

  Map<String, Object?>
  toRolaRow(int idAlbum, int idPerformer) => {
    'path'      : path,
    'title'     : title,
    'track'     : track,
    'year'      : year,
    'genre'     : genre,
    'id_album'  : idAlbum,
    'id_performer': idPerformer,
    'audio_hash': audioHash,
  };
}
