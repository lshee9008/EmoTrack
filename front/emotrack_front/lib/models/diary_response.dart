class DiaryResponse {
  final String summary;
  final String emotion;
  final String weather;
  final Map<String, dynamic> song;

  DiaryResponse({
    required this.summary,
    required this.emotion,
    required this.weather,
    required this.song,
  });

  factory DiaryResponse.fromJson(Map<String, dynamic> json) {
    return DiaryResponse(
      summary: json['summary'],
      emotion: json['emotion'],
      weather: json['weather'],
      song: json['song'],
    );
  }
}
