import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:shimmer/shimmer.dart';
import '../models/diary_entry.dart';

class DiaryDetailScreen extends StatefulWidget {
  final DiaryEntry diary;

  const DiaryDetailScreen({required this.diary, super.key});

  @override
  _DiaryDetailScreenState createState() => _DiaryDetailScreenState();
}

class _DiaryDetailScreenState extends State<DiaryDetailScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _appBarAnimation;
  late Animation<double> _cardAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    _appBarAnimation = Tween<double>(begin: 0.75, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutQuad),
    );
    _cardAnimation = Tween<double>(
      begin: 0.95,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: FadeTransition(
              opacity: _appBarAnimation,
              child: Text(
                'EmoTrack',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 6,
            shadowColor: Colors.blue.shade400.withOpacity(0.7),
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 24),
              onPressed: () => Navigator.of(context).pop(),
            ),
            floating: true,
            snap: true,
            pinned: true,
            toolbarHeight: 48.0,
            flexibleSpace: Shimmer.fromColors(
              baseColor: Colors.blue.shade800.withOpacity(0.9),
              highlightColor: Colors.blue.shade400.withOpacity(0.8),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.blue.shade800.withOpacity(0.9),
                      Colors.blue.shade600.withOpacity(0.7),
                    ],
                  ),
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.amber.shade200.withOpacity(0.4),
                      width: 1.5,
                    ),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.shade300.withOpacity(0.5),
                      blurRadius: 14,
                      spreadRadius: 4,
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 28.0,
              ),
              child: AnimationLimiter(
                child: ScaleTransition(
                  scale: _cardAnimation,
                  child: Hero(
                    tag: 'diary_${widget.diary.date}',
                    child: Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24.0),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.blue.shade50.withOpacity(0.9),
                              Colors.amber.shade100.withOpacity(0.8),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(24.0),
                          border: Border.all(
                            color: Colors.amber.shade200.withOpacity(0.4),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.shade200.withOpacity(0.4),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(28.0),
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
                                // Date Section
                                Shimmer.fromColors(
                                  baseColor: Colors.blue.shade800,
                                  highlightColor: Colors.amber.shade400,
                                  child: Text(
                                    '${widget.diary.date}',
                                    style: theme.textTheme.headlineSmall
                                        ?.copyWith(
                                          fontWeight: FontWeight.w800,
                                          color: Colors.blue.shade900,
                                          letterSpacing: 1.0,
                                        ),
                                  ),
                                ),
                                const SizedBox(height: 28),
                                // Diary Content
                                _buildSectionTitle(theme, '내용'),
                                const SizedBox(height: 16),
                                Text(
                                  widget.diary.diary,
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    height: 1.7,
                                    color: theme.colorScheme.onSurface
                                        .withOpacity(0.95),
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const SizedBox(height: 28),
                                // Summary
                                _buildSectionTitle(theme, '요약'),
                                const SizedBox(height: 16),
                                Text(
                                  widget.diary.summary,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.onSurface
                                        .withOpacity(0.85),
                                    height: 1.6,
                                  ),
                                ),
                                const SizedBox(height: 28),
                                // Emotion
                                _buildSectionTitle(theme, '감정'),
                                const SizedBox(height: 16),
                                Chip(
                                  label: Text(
                                    widget.diary.emotion,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: Colors.blue.shade800,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  backgroundColor: Colors.amber.shade100
                                      .withOpacity(0.4),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 18,
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                    side: BorderSide(
                                      color: Colors.blue.shade200.withOpacity(
                                        0.5,
                                      ),
                                      width: 2.0,
                                    ),
                                  ),
                                  elevation: 3,
                                  shadowColor: Colors.blue.shade200.withOpacity(
                                    0.3,
                                  ),
                                ),
                                const SizedBox(height: 28),
                                // Weather
                                _buildSectionTitle(theme, '날씨'),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    AnimatedScale(
                                      scale: _appBarAnimation.value,
                                      duration: const Duration(
                                        milliseconds: 900,
                                      ),
                                      curve: Curves.easeInOutQuad,
                                      child: Icon(
                                        _getWeatherIcon(widget.diary.weather),
                                        color: Colors.blue.shade800,
                                        size: 30,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      widget.diary.weather,
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(
                                            color: Colors.blue.shade900,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 0.5,
                                          ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 28),
                                // Recommended Song
                                _buildSectionTitle(theme, '오늘의 추천 곡'),
                                const SizedBox(height: 16),
                                Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(20.0),
                                    onTap: () {
                                      // Add song interaction logic here (e.g., open music player)
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.blue.shade100.withOpacity(
                                              0.3,
                                            ),
                                            Colors.amber.shade100.withOpacity(
                                              0.3,
                                            ),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          20.0,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.blue.shade200
                                                .withOpacity(0.3),
                                            blurRadius: 12,
                                            spreadRadius: 3,
                                          ),
                                        ],
                                      ),
                                      child: ListTile(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              horizontal: 16.0,
                                              vertical: 10.0,
                                            ),
                                        leading: AnimatedScale(
                                          scale: _appBarAnimation.value,
                                          duration: const Duration(
                                            milliseconds: 900,
                                          ),
                                          curve: Curves.easeInOutQuad,
                                          child: Icon(
                                            Icons.music_note,
                                            color: Colors.blue.shade800,
                                            size: 30,
                                          ),
                                        ),
                                        title: Text(
                                          widget.diary.song['title'] ??
                                              'Unknown Title',
                                          style: theme.textTheme.bodyLarge
                                              ?.copyWith(
                                                fontWeight: FontWeight.w700,
                                                color: Colors.blue.shade900,
                                                letterSpacing: 0.5,
                                              ),
                                        ),
                                        subtitle: Text(
                                          widget.diary.song['artist'] ??
                                              'Unknown Artist',
                                          style: theme.textTheme.bodyMedium
                                              ?.copyWith(
                                                color: Colors.blue.shade700
                                                    .withOpacity(0.8),
                                                letterSpacing: 0.3,
                                              ),
                                        ),
                                      ),
                                    ),
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
        ],
      ),
    );
  }

  Widget _buildSectionTitle(ThemeData theme, String title) {
    return Shimmer.fromColors(
      baseColor: Colors.blue.shade800,
      highlightColor: Colors.amber.shade400,
      period: const Duration(milliseconds: 1200),
      child: Text(
        title,
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w900,
          color: Colors.blue.shade900,
          letterSpacing: 1.2,
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
        return Icons.wb_sunny;
    }
  }
}
