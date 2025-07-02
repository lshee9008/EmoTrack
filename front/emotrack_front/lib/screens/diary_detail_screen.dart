import 'package:flutter/material.dart';
import '../models/diary_entry.dart';

class DiaryDetailScreen extends StatelessWidget {
  final DiaryEntry diary;

  DiaryDetailScreen({required this.diary});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Diary Analysis')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text('Date: ${diary.date}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 16),
            Text('Diary:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(diary.diary),
            SizedBox(height: 16),
            Text('Summary:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(diary.summary),
            SizedBox(height: 16),
            Text('Emotion:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(diary.emotion),
            SizedBox(height: 16),
            Text('Weather:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(diary.weather),
            SizedBox(height: 16),
            Text(
              'Recommended Song:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('Title: ${diary.song['title']}'),
            Text('Artist: ${diary.song['artist']}'),
          ],
        ),
      ),
    );
  }
}
