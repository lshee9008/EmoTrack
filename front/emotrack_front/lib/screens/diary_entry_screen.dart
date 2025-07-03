import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../providers/diary_provider.dart';
import '../screens/diary_detail_screen.dart';

class DiaryEntryScreen extends StatefulWidget {
  const DiaryEntryScreen({super.key});

  @override
  _DiaryEntryScreenState createState() => _DiaryEntryScreenState();
}

class _DiaryEntryScreenState extends State<DiaryEntryScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _diaryController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  final _dateFormatter = DateFormat('yyyy-MM-dd');
  late AnimationController _controller;
  late Animation<double> _cardFadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _cardFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();
  }

  @override
  void dispose() {
    _diaryController.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: Colors.blue.shade800,
              onPrimary: Colors.white,
              surface: Colors.blue.shade50,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue.shade800,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '일기 작성',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: Colors.white,
            letterSpacing: 1.0,
          ),
        ),
        backgroundColor: Colors.blue.shade800,
        elevation: 4,
        shadowColor: Colors.blue.shade400.withOpacity(0.6),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 24),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 28.0),
          child: FadeTransition(
            opacity: _cardFadeAnimation,
            child: AnimationLimiter(
              child: Hero(
                tag: 'diary_${_dateFormatter.format(_selectedDate)}',
                child: Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: AnimationConfiguration.toStaggeredList(
                          duration: const Duration(milliseconds: 900),
                          childAnimationBuilder: (widget) => SlideAnimation(
                            verticalOffset: 60.0,
                            curve: Curves.bounceOut,
                            child: FadeInAnimation(child: widget),
                          ),
                          children: [
                            // Diary Entry Input
                            Text(
                              'Diary Entry',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: Colors.blue.shade900,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.blue.shade200.withOpacity(0.5),
                                ),
                                borderRadius: BorderRadius.circular(14.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.blue.shade100.withOpacity(
                                      0.3,
                                    ),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: TextFormField(
                                controller: _diaryController,
                                decoration: InputDecoration(
                                  hintText: 'Write about your day...',
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.all(16.0),
                                  filled: true,
                                  fillColor: Colors.blue.shade50.withOpacity(
                                    0.2,
                                  ),
                                ),
                                maxLines: 8,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Please write something in your diary';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(height: 24),
                            // Date Picker
                            Text(
                              'Date',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: Colors.blue.shade900,
                              ),
                            ),
                            const SizedBox(height: 16),
                            GestureDetector(
                              onTap: () => _selectDate(context),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14.0,
                                  horizontal: 16.0,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.blue.shade200.withOpacity(
                                      0.5,
                                    ),
                                  ),
                                  borderRadius: BorderRadius.circular(14.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.blue.shade100.withOpacity(
                                        0.3,
                                      ),
                                      blurRadius: 10,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                  color: Colors.blue.shade50.withOpacity(0.2),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      _dateFormatter.format(_selectedDate),
                                      style: theme.textTheme.bodyLarge
                                          ?.copyWith(
                                            color: Colors.blue.shade900,
                                          ),
                                    ),
                                    Icon(
                                      Icons.calendar_today,
                                      color: Colors.blue.shade800,
                                      size: 24,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 28),
                            // Submit Button
                            Center(
                              child: Consumer<DiaryProvider>(
                                builder: (context, provider, child) {
                                  return ElevatedButton(
                                    style:
                                        ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 32.0,
                                            vertical: 16.0,
                                          ),
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              14.0,
                                            ),
                                          ),
                                          elevation: 3,
                                        ).copyWith(
                                          backgroundColor:
                                              MaterialStateProperty.resolveWith(
                                                (states) {
                                                  if (states.contains(
                                                    MaterialState.pressed,
                                                  )) {
                                                    return Colors.blue.shade700;
                                                  }
                                                  return Colors.blue.shade800;
                                                },
                                              ),
                                        ),
                                    onPressed: provider.isLoading
                                        ? null
                                        : () async {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              try {
                                                final entry = await provider
                                                    .analyzeDiary(
                                                      _diaryController.text,
                                                      _dateFormatter.format(
                                                        _selectedDate,
                                                      ),
                                                    );
                                                if (!mounted) return;
                                                Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        DiaryDetailScreen(
                                                          diary: entry,
                                                        ),
                                                  ),
                                                );
                                              } catch (e) {
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    content: Text('Error: $e'),
                                                    backgroundColor:
                                                        theme.colorScheme.error,
                                                  ),
                                                );
                                              }
                                            }
                                          },
                                    child: provider.isLoading
                                        ? SizedBox(
                                            width: 24,
                                            height: 24,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2.5,
                                            ),
                                          )
                                        : Text(
                                            'Analyze Diary',
                                            style: theme.textTheme.labelLarge
                                                ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                          ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
