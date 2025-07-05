import 'package:flutter/material.dart';
import '../models/diary_entry.dart';
import '../models/diary_request.dart';
import '../services/api_service.dart';
import '../services/database_service.dart';

class DiaryProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final DatabaseService _databaseService = DatabaseService();
  List<DiaryEntry> _diaries = [];
  bool _isLoading = false;

  List<DiaryEntry> get diaries => _diaries;
  bool get isLoading => _isLoading;

  DiaryProvider() {
    _loadDiaries();
  }

  Future<void> _loadDiaries() async {
    _diaries = await _databaseService.getDiaries();
    notifyListeners();
  }

  Future<DiaryEntry> analyzeDiary(String diaryText, String date) async {
    _isLoading = true;
    notifyListeners();

    try {
      final request = DiaryRequest(diary: diaryText, date: date);
      final response = await _apiService.analyzeDiary(request);
      final entry = DiaryEntry(
        diary: diaryText,
        date: date,
        summary: response.summary,
        emotion: response.emotion,
        weather: response.weather,
        song: response.song,
        youtube_url: response.youtube_url,
      );
      await _databaseService.insertDiary(entry);
      await _loadDiaries();
      return entry;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteDiary(int id) async {
    await _databaseService.deleteDiary(id);
    await _loadDiaries();
  }
}
