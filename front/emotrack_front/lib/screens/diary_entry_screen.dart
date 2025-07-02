import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/diary_provider.dart';
import '../screens/diary_detail_screen.dart';

class DiaryEntryScreen extends StatefulWidget {
  @override
  _DiaryEntryScreenState createState() => _DiaryEntryScreenState();
}

class _DiaryEntryScreenState extends State<DiaryEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _diaryController = TextEditingController();
  String _date = DateFormat('yyyy-MM-dd').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Write Diary')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _diaryController,
                decoration: InputDecoration(labelText: 'Diary Entry'),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your diary';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              Text('Date: $_date'),
              SizedBox(height: 16),
              Consumer<DiaryProvider>(
                builder: (context, provider, child) {
                  return ElevatedButton(
                    onPressed: provider.isLoading
                        ? null
                        : () async {
                            if (_formKey.currentState!.validate()) {
                              final entry = await provider.analyzeDiary(
                                _diaryController.text,
                                _date,
                              );
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DiaryDetailScreen(diary: entry),
                                ),
                              );
                            }
                          },
                    child: provider.isLoading
                        ? CircularProgressIndicator()
                        : Text('Analyze Diary'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
