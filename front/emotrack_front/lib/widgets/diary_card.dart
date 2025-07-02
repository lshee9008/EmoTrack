import 'package:flutter/material.dart';
import '../models/diary_entry.dart';

class DiaryCard extends StatelessWidget {
  final DiaryEntry diary;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  DiaryCard({required this.diary, required this.onTap, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(diary.date),
        subtitle: Text(
          diary.diary.length > 50
              ? '${diary.diary.substring(0, 50)}...'
              : diary.diary,
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: onDelete,
        ),
        onTap: onTap,
      ),
    );
  }
}
