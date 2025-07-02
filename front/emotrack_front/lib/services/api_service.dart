import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/diary_request.dart';
import '../models/diary_response.dart';

class ApiService {
  static const String baseUrl =
      'http://localhost:8000'; // Replace with your API URL

  Future<DiaryResponse> analyzeDiary(DiaryRequest request) async {
    final response = await http.post(
      Uri.parse('$baseUrl/analyze'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    print(response);

    if (response.statusCode == 200) {
      return DiaryResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to analyze diary: ${response.statusCode}');
    }
  }
}
