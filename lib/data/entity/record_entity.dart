class RecordEntity {
  final String title;
  final DateTime createdAt;
  final Duration duration;
  final String path;
  final int index;

  RecordEntity({
    required this.title,
    required this.createdAt,
    required this.duration,
    required this.path,
    required this.index,
  });
}
