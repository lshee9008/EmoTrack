import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/diary_provider.dart';
import '../screens/diary_entry_screen.dart';
import '../screens/diary_detail_screen.dart';
import '../widgets/diary_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fabController;
  late Animation<double> _fabAnimation;
  late Animation<double> _fabShadowAnimation;

  @override
  void initState() {
    super.initState();
    _fabController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _fabAnimation = Tween<double>(
      begin: 0.92,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fabController, curve: Curves.easeInOut));
    _fabShadowAnimation = Tween<double>(
      begin: 8.0,
      end: 12.0,
    ).animate(CurvedAnimation(parent: _fabController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _fabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = GoogleFonts.nanumPenScriptTextTheme(theme.textTheme);

    return Scaffold(
      backgroundColor: const Color(0xFFFFFBEA),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 178, 130, 113),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.brown.shade700),
        title: Text(
          '감성 일기장',
          style: GoogleFonts.nanumPenScript(
            fontSize: 38,
            color: Colors.brown.shade800,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Consumer<DiaryProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.diaries.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.menu_book_rounded,
                    size: 80,
                    color: Colors.brown.shade300,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '아직 작성된 일기가 없어요!',
                    style: textTheme.headlineSmall?.copyWith(
                      color: Colors.brown.shade600,
                    ),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: provider.diaries.length,
            itemBuilder: (context, index) {
              final diary = provider.diaries[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: DiaryCard(
                  diary: diary,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DiaryDetailScreen(diary: diary),
                    ),
                  ),
                  onDelete: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        title: Text(
                          '일기 삭제',
                          style: textTheme.titleLarge?.copyWith(
                            color: Colors.brown.shade800,
                          ),
                        ),
                        content: Text(
                          '이 일기를 삭제하시겠습니까?',
                          style: textTheme.bodyLarge,
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: Text('취소', style: textTheme.bodyLarge),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: Text(
                              '삭제',
                              style: textTheme.bodyLarge?.copyWith(
                                color: Colors.red.shade400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                    if (confirm == true) {
                      await provider.deleteDiary(diary.id!);
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('삭제 완료!', style: textTheme.bodyLarge),
                        ),
                      );
                    }
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const DiaryEntryScreen()),
        ),
        backgroundColor: Colors.brown.shade300,
        child: const Icon(Icons.edit, color: Colors.white),
      ),
    );
  }
}
