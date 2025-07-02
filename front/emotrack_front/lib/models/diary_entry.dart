// DiaryEntry 모델 수정
import 'dart:convert';

class DiaryEntry {
  final int? id;
  final String diary;
  final String date;
  final String summary;
  final String emotion;
  final String weather;
  final Map<String, dynamic> song; // ✅ 변경됨

  DiaryEntry({
    this.id,
    required this.diary,
    required this.date,
    required this.summary,
    required this.emotion,
    required this.weather,
    required this.song, // ✅ Map
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'diary': diary,
      'date': date,
      'summary': summary,
      'emotion': emotion,
      'weather': weather,
      'song': jsonEncode(song), // ✅ DB 저장시 문자열로
    };
  }

  factory DiaryEntry.fromMap(Map<String, dynamic> map) {
    return DiaryEntry(
      id: map['id'],
      diary: map['diary'],
      date: map['date'],
      summary: map['summary'],
      emotion: map['emotion'],
      weather: map['weather'],
      song: jsonDecode(map['song']), // ✅ DB에서 불러올 때 다시 Map으로
    );
  }
}
