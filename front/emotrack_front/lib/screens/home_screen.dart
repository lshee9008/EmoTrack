import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:shimmer/shimmer.dart';
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

  Future<bool?> _showDeleteDialog(BuildContext context, ThemeData theme) {
    return showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.4),
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28.0),
        ),
        backgroundColor: theme.colorScheme.surface.withOpacity(0.85),
        elevation: 12,
        child: Container(
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28.0),
            border: Border.all(
              color: Colors.blue.shade200.withOpacity(0.3),
              width: 2.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 25,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Delete Diary Entry',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Colors.blue.shade800,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Are you sure you want to delete this entry? This action is permanent.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.85),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  AnimatedScale(
                    scale: 1.0,
                    duration: const Duration(milliseconds: 200),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        backgroundColor: Colors.blue.shade100.withOpacity(0.2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context, false),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.blue.shade600,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  AnimatedScale(
                    scale: 1.0,
                    duration: const Duration(milliseconds: 200),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        backgroundColor: theme.colorScheme.error.withOpacity(
                          0.2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context, true),
                      child: Text(
                        'Delete',
                        style: TextStyle(
                          color: theme.colorScheme.error,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade50.withOpacity(0.9),
              Colors.blue.shade100.withOpacity(0.7),
              Colors.amber.shade100.withOpacity(0.8),
            ],
            stops: const [0.0, 0.6, 1.0],
          ),
        ),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: Text(
                'My Diary',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 0.6,
                ),
              ),
              backgroundColor: Colors.transparent,
              elevation: 4,
              shadowColor: Colors.blue.shade400.withOpacity(0.5),
              floating: true,
              snap: true,
              pinned: true,
              toolbarHeight: 56.0, // Compact height
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.blue.shade700.withOpacity(0.9),
                      Colors.blue.shade500.withOpacity(0.7),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.shade300.withOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: RefreshIndicator(
                onRefresh: () async {
                  await context.read<DiaryProvider>().fetchDiaries();
                },
                color: Colors.white,
                backgroundColor: Colors.blue.shade600,
                displacement: 20.0,
                child: Consumer<DiaryProvider>(
                  builder: (context, provider, child) {
                    if (provider.isLoading) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height - 100,
                        child: Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.blue.shade600,
                            ),
                            strokeWidth: 3.0,
                            backgroundColor: Colors.blue.shade100.withOpacity(
                              0.3,
                            ),
                          ),
                        ),
                      );
                    }
                    if (provider.diaries.isEmpty) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height - 100,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Shimmer.fromColors(
                                baseColor: Colors.blue.shade600,
                                highlightColor: Colors.amber.shade200,
                                child: Container(
                                  padding: const EdgeInsets.all(24.0),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.amber.shade100.withOpacity(
                                      0.4,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.blue.shade200.withOpacity(
                                          0.4,
                                        ),
                                        blurRadius: 20,
                                        spreadRadius: 6,
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.book_rounded,
                                    size: 100,
                                    color: Colors.blue.shade600,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),
                              FadeTransition(
                                opacity:
                                    _fabAnimation, // Reusing FAB animation for simplicity
                                child: Text(
                                  'Start Your Journey!',
                                  style: theme.textTheme.headlineMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue.shade800,
                                        letterSpacing: 0.8,
                                      ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              FadeTransition(
                                opacity: _fabAnimation,
                                child: Text(
                                  'Pen your thoughts and cherish your moments.',
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    color: Colors.blue.shade600.withOpacity(
                                      0.85,
                                    ),
                                    fontStyle: FontStyle.italic,
                                    height: 1.5,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    return AnimationLimiter(
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 20.0,
                        ),
                        itemCount: provider.diaries.length,
                        itemBuilder: (context, index) {
                          final diary = provider.diaries[index];
                          return AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 700),
                            child: SlideAnimation(
                              verticalOffset: 50.0,
                              curve: Curves.easeInOutSine,
                              child: FadeInAnimation(
                                child: ScaleAnimation(
                                  scale: 0.92,
                                  child: Transform.rotate(
                                    angle: index % 2 == 0
                                        ? 0.005
                                        : -0.005, // Subtle tilt
                                    child: BounceAnimation(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 16.0,
                                        ),
                                        child: DiaryCard(
                                          diary: diary,
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              PageRouteBuilder(
                                                pageBuilder:
                                                    (
                                                      context,
                                                      animation,
                                                      secondaryAnimation,
                                                    ) => DiaryDetailScreen(
                                                      diary: diary,
                                                    ),
                                                transitionsBuilder:
                                                    (
                                                      context,
                                                      animation,
                                                      secondaryAnimation,
                                                      child,
                                                    ) {
                                                      const begin = Offset(
                                                        1.0,
                                                        0.0,
                                                      );
                                                      const end = Offset.zero;
                                                      const curve =
                                                          Curves.easeInOutSine;
                                                      var tween =
                                                          Tween(
                                                            begin: begin,
                                                            end: end,
                                                          ).chain(
                                                            CurveTween(
                                                              curve: curve,
                                                            ),
                                                          );
                                                      var offsetAnimation =
                                                          animation.drive(
                                                            tween,
                                                          );
                                                      return SlideTransition(
                                                        position:
                                                            offsetAnimation,
                                                        child: FadeTransition(
                                                          opacity: animation,
                                                          child: child,
                                                        ),
                                                      );
                                                    },
                                              ),
                                            );
                                          },
                                          onDelete: () async {
                                            final shouldDelete =
                                                await _showDeleteDialog(
                                                  context,
                                                  theme,
                                                );
                                            if (shouldDelete == true) {
                                              try {
                                                await provider.deleteDiary(
                                                  diary.id!,
                                                );
                                                if (!context.mounted) return;
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    content: const Text(
                                                      'Diary deleted successfully',
                                                    ),
                                                    backgroundColor:
                                                        Colors.blue.shade600,
                                                    duration: const Duration(
                                                      seconds: 2,
                                                    ),
                                                    behavior: SnackBarBehavior
                                                        .floating,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            12.0,
                                                          ),
                                                    ),
                                                    elevation: 8,
                                                    margin:
                                                        const EdgeInsets.all(
                                                          16.0,
                                                        ),
                                                  ),
                                                );
                                              } catch (e) {
                                                if (!context.mounted) return;
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    content: Text('Error: $e'),
                                                    backgroundColor:
                                                        theme.colorScheme.error,
                                                    duration: const Duration(
                                                      seconds: 3,
                                                    ),
                                                    behavior: SnackBarBehavior
                                                        .floating,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            12.0,
                                                          ),
                                                    ),
                                                    elevation: 8,
                                                    margin:
                                                        const EdgeInsets.all(
                                                          16.0,
                                                        ),
                                                  ),
                                                );
                                              }
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: AnimatedBuilder(
        animation: _fabShadowAnimation,
        builder: (context, child) {
          return ScaleTransition(
            scale: _fabAnimation,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const DiaryEntryScreen(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                          const begin = Offset(0.0, 1.0);
                          const end = Offset.zero;
                          const curve = Curves.easeInOutSine;
                          var tween = Tween(
                            begin: begin,
                            end: end,
                          ).chain(CurveTween(curve: curve));
                          var offsetAnimation = animation.drive(tween);
                          return SlideTransition(
                            position: offsetAnimation,
                            child: FadeTransition(
                              opacity: animation,
                              child: child,
                            ),
                          );
                        },
                  ),
                );
              },
              backgroundColor: Colors.blue.shade600,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32.0),
                side: BorderSide(
                  color: Colors.amber.shade200.withOpacity(0.5),
                  width: 2.0,
                ),
              ),
              elevation: _fabShadowAnimation.value,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.shade400.withOpacity(0.5),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: const Icon(Icons.edit, size: 36),
              ),
              tooltip: 'Create New Diary Entry',
            ),
          );
        },
      ),
    );
  }
}

class BounceAnimation extends StatefulWidget {
  final Widget child;

  const BounceAnimation({required this.child, super.key});

  @override
  _BounceAnimationState createState() => _BounceAnimationState();
}

class _BounceAnimationState extends State<BounceAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _animation = Tween<double>(begin: 0.97, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutBack),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(scale: _animation, child: widget.child);
  }
}
