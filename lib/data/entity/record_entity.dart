import '../../presentation/utils/duration_helper.dart';

class RecordEntity {
  final String title;

  final DateTime createdAt;

  final Duration duration;

  final String path;

  final int id;

  RecordEntity({
    required this.title,
    required this.createdAt,
    required this.duration,
    required this.path,
    required this.id,
  });

  factory RecordEntity.fromJson(Map<String, dynamic> json) {
    return RecordEntity(
      title: json['title'],
      createdAt: DateTime.parse(json['createdAt']),
      duration: DurationHelper().parseDurationFromString(json['duration']),
      path: json['path'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'createdAt': createdAt.toString(),
      'duration': duration.toString(),
      'path': path,
      'id': id
    };
  }
}
