class DiaryRequest {
  final String diary;
  final String date;

  DiaryRequest({required this.diary, required this.date});

  Map<String, dynamic> toJson() => {'diary': diary, 'date': date};
}
