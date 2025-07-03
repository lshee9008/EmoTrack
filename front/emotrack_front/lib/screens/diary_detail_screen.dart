import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/diary_entry.dart';

class DiaryDetailScreen extends StatelessWidget {
  final DiaryEntry diary;

  const DiaryDetailScreen({super.key, required this.diary});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateStyle = GoogleFonts.nanumPenScript(
      fontSize: 24,
      color: Colors.brown.shade700,
      fontWeight: FontWeight.bold,
    );
    final sectionTitleStyle = GoogleFonts.nanumPenScript(
      fontSize: 22,
      color: Colors.brown.shade800,
      fontWeight: FontWeight.bold,
    );
    final contentStyle = GoogleFonts.nanumPenScript(
      fontSize: 20,
      height: 1.6,
      color: Colors.brown.shade900,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFFFFBEA),
      appBar: AppBar(
        backgroundColor: Colors.brown.shade100,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.brown.shade700),
        title: Text(
          '일기 상세',
          style: GoogleFonts.nanumPenScript(
            fontSize: 28,
            color: Colors.brown.shade800,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Hero(
          tag: 'diary_${diary.date}',
          child: Card(
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            color: Colors.brown.shade50,
            child: Container(
              padding: const EdgeInsets.all(28.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.brown.shade200, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.brown.shade100.withOpacity(0.3),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 날짜
                  Center(child: Text(diary.date, style: dateStyle)),
                  const SizedBox(height: 32),
                  // 내용
                  Text('📖 내용', style: sectionTitleStyle),
                  const SizedBox(height: 12),
                  Text(diary.diary, style: contentStyle),
                  const SizedBox(height: 28),
                  // 요약
                  Text('✍️ 요약', style: sectionTitleStyle),
                  const SizedBox(height: 12),
                  Text(diary.summary, style: contentStyle),
                  const SizedBox(height: 28),
                  // 감정
                  Text('🧠 감정', style: sectionTitleStyle),
                  const SizedBox(height: 12),
                  Chip(
                    label: Text(
                      diary.emotion,
                      style: GoogleFonts.nanumPenScript(
                        fontSize: 20,
                        color: Colors.brown.shade800,
                      ),
                    ),
                    backgroundColor: Colors.amber.shade100.withOpacity(0.4),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 10.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: BorderSide(
                        color: Colors.brown.shade200,
                        width: 1.5,
                      ),
                    ),
                    elevation: 2,
                  ),
                  const SizedBox(height: 28),
                  // 날씨
                  Text('🌤 날씨', style: sectionTitleStyle),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        _getWeatherIcon(diary.weather),
                        color: Colors.brown.shade700,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Text(diary.weather, style: contentStyle),
                    ],
                  ),
                  const SizedBox(height: 28),
                  // 노래
                  Text('🎵 오늘의 추천 곡', style: sectionTitleStyle),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.brown.shade100.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      leading: Icon(
                        Icons.music_note,
                        color: Colors.brown.shade600,
                      ),
                      title: Text(
                        diary.song['title'] ?? 'Unknown Title',
                        style: contentStyle.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        diary.song['artist'] ?? 'Unknown Artist',
                        style: contentStyle.copyWith(fontSize: 18),
                      ),
                      onTap: () {
                        // 음악 재생 처리 가능
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  IconData _getWeatherIcon(String weather) {
    switch (weather.toLowerCase()) {
      case 'sunny':
        return Icons.wb_sunny;
      case 'cloudy':
        return Icons.cloud;
      case 'rainy':
        return Icons.umbrella;
      case 'snowy':
        return Icons.ac_unit;
      default:
        return Icons.wb_cloudy;
    }
  }
}
