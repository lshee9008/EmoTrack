class DiaryEntry {
  final int? id;
  final String diary;
  final String date;
  final String summary;
  final String emotion;
  final String weather;
  final String song;

  DiaryEntry({
    this.id,
    required this.diary,
    required this.date,
    required this.summary,
    required this.emotion,
    required this.weather,
    required this.song,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'diary': diary,
      'date': date,
      'summary': summary,
      'emotion': emotion,
      'weather': weather,
      'song': song,
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
      song: map['song'],
    );
  }
}
