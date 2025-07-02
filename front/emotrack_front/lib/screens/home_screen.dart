import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/diary_provider.dart';
import '../screens/diary_entry_screen.dart';
import '../screens/diary_detail_screen.dart';
import '../widgets/diary_card.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Diary')),
      body: Consumer<DiaryProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (provider.diaries.isEmpty) {
            return Center(child: Text('No diaries yet. Write one!'));
          }
          return ListView.builder(
            itemCount: provider.diaries.length,
            itemBuilder: (context, index) {
              final diary = provider.diaries[index];
              return DiaryCard(
                diary: diary,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DiaryDetailScreen(diary: diary),
                    ),
                  );
                },
                onDelete: () {
                  provider.deleteDiary(diary.id!);
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DiaryEntryScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
