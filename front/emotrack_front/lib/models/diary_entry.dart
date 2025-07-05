import 'dart:convert';

class DiaryEntry {
  final int? id;
  final String diary;
  final String date;
  final String summary;
  final String emotion;
  final String weather;
  final Map<String, dynamic> song;
  final String? youtube_url;

  DiaryEntry({
    this.id,
    required this.diary,
    required this.date,
    required this.summary,
    required this.emotion,
    required this.weather,
    required this.song,
    this.youtube_url,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'diary': diary,
      'date': date,
      'summary': summary,
      'emotion': emotion,
      'weather': weather,
      'song': jsonEncode(song),
      'youtube_url': youtube_url,
    };
  }

  factory DiaryEntry.fromMap(Map<String, dynamic> map) {
    return DiaryEntry(
      id: map['id'],
      diary: map['diary'] ?? '',
      date: map['date'] ?? '',
      summary: map['summary'] ?? '',
      emotion: map['emotion'] ?? '',
      weather: map['weather'] ?? '',
      song: map['song'] != null
          ? jsonDecode(map['song'])
          : {'title': 'Unknown', 'artist': 'Unknown'},
      youtube_url: map['youtube_url'],
    );
  }
}
