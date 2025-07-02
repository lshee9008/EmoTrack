import 'dart:convert';

import 'package:flutter/material.dart';
import '../models/diary_entry.dart';
import '../services/api_service.dart';
import '../services/database_service.dart';
import '../models/diary_request.dart';
import '../models/diary_response.dart';

class DiaryProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final DatabaseService _databaseService = DatabaseService();
  List<DiaryEntry> _diaries = [];
  bool _isLoading = false;

  List<DiaryEntry> get diaries => _diaries;
  bool get isLoading => _isLoading;

  Future<void> fetchDiaries() async {
    _isLoading = true;
    notifyListeners();
    _diaries = await _databaseService.getDiaries();
    _isLoading = false;
    notifyListeners();
  }

  Future<DiaryEntry> analyzeDiary(String diary, String date) async {
    _isLoading = true;
    notifyListeners();
    try {
      final request = DiaryRequest(diary: diary, date: date);
      final response = await _apiService.analyzeDiary(request);
      final entry = DiaryEntry(
        diary: diary,
        date: date,
        summary: response.summary,
        emotion: response.emotion,
        weather: response.weather,
        song: response.song,
      );
      await _databaseService.insertDiary(entry);
      await fetchDiaries();
      return entry;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateDiary(DiaryEntry entry) async {
    await _databaseService.updateDiary(entry);
    await fetchDiaries();
  }

  Future<void> deleteDiary(int id) async {
    await _databaseService.deleteDiary(id);
    await fetchDiaries();
  }
}
