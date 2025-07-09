import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/diary_entry.dart';

class DiaryDetailScreen extends StatefulWidget {
  final DiaryEntry diary;

  const DiaryDetailScreen({super.key, required this.diary});

  @override
  State<DiaryDetailScreen> createState() => _DiaryDetailScreenState();
}

class _DiaryDetailScreenState extends State<DiaryDetailScreen> {
  @override
  Widget build(BuildContext context) {
    print(widget.diary.summary);
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
          tag: 'diary_${widget.diary.date}',
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
                  Center(child: Text(widget.diary.date, style: dateStyle)),
                  const SizedBox(height: 32),
                  Text('📖 내용', style: sectionTitleStyle),
                  const SizedBox(height: 12),
                  Text(widget.diary.diary, style: contentStyle),
                  const SizedBox(height: 28),
                  Text('✍️ 요약', style: sectionTitleStyle),
                  const SizedBox(height: 12),
                  Text(widget.diary.summary, style: contentStyle),
                  const SizedBox(height: 28),
                  Text('🧠 감정', style: sectionTitleStyle),
                  const SizedBox(height: 12),
                  Chip(
                    label: Text(
                      widget.diary.emotion,
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
                  Text('🌤 날씨', style: sectionTitleStyle),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        _getWeatherIcon(widget.diary.weather),
                        color: Colors.brown.shade700,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          widget.diary.weather,
                          style: contentStyle,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),
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
                        widget.diary.song['title'] ?? 'Unknown Title',
                        style: contentStyle.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.diary.song['artist'] ?? 'Unknown Artist',
                            style: contentStyle.copyWith(fontSize: 18),
                          ),
                          GestureDetector(
                            onTap: () async {
                              final url =
                                  widget.diary.youtube_url ??
                                  'https://www.youtube.com';
                              if (await canLaunchUrl(Uri.parse(url))) {
                                await launchUrl(Uri.parse(url));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('링크를 열 수 없습니다.')),
                                );
                              }
                            },
                            child: Text(
                              'YouTube에서 듣기',
                              style: contentStyle.copyWith(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
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
