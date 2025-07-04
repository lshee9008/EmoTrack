import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/diary_entry.dart';

class DiaryCard extends StatelessWidget {
  final DiaryEntry diary;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  DiaryCard({required this.diary, required this.onTap, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(255, 255, 234, 177),
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ListTile(
        title: Text(
          diary.date,
          style: GoogleFonts.nanumPenScript(
            fontSize: 28,
            color: Colors.brown.shade800,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          diary.diary.length > 50
              ? '${diary.diary.substring(0, 50)}...'
              : diary.diary,
          style: GoogleFonts.nanumPenScript(
            fontSize: 20,
            color: Colors.brown.shade800,
          ),
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
