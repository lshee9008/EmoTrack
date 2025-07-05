class DiaryResponse {
  final String summary;
  final String emotion;
  final String weather;
  final Map<String, dynamic> song;
  final String youtube_url;

  DiaryResponse({
    required this.summary,
    required this.emotion,
    required this.weather,
    required this.song,
    required this.youtube_url,
  });

  factory DiaryResponse.fromJson(Map<String, dynamic> json) {
    return DiaryResponse(
      summary: json['summary'] ?? '',
      emotion: json['emotion'] ?? 'unknown',
      weather: json['weather'] ?? 'unknown',
      song: json['song'] is Map<String, dynamic>
          ? json['song']
          : {'title': 'Unknown', 'artist': 'Unknown'},
      youtube_url: json['youtube_url'] ?? 'https://www.youtube.com',
    );
  }
}
