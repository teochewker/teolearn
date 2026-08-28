import 'package:flutter/material.dart';
import 'flow_selection_screen.dart';
import 'progress_screen.dart';

/// Home screen — welcome page with title and big buttons.
/// Navigation is primarily handled by the bottom nav, but these
/// buttons offer quick access.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE17076),
              Color(0xFFF2C14E),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('🔮', style: TextStyle(fontSize: 80)),
                  const SizedBox(height: 16),
                  const Text(
                    'TeoLearn',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Learn Teochew with fun flashcards!',
                    style: TextStyle(fontSize: 18, color: Colors.white70),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '潮州话 · 潮語 · Teochew',
                    style: TextStyle(fontSize: 16, color: Colors.white60),
                  ),
                  const SizedBox(height: 48),
                  _bigButton(
                    context,
                    'Start Learning!',
                    '📚',
                    Colors.white,
                    0xFFE17076,
                    () => _navigateTo(context, const VocabFlowSelectionScreen()),
                  ),
                  const SizedBox(height: 16),
                  _bigButton(
                    context,
                    'My Progress',
                    '🏆',
                    Colors.white,
                    0xFF6C5CEC,
                    () => _navigateTo(context, const ProgressScreen()),
                  ),
                  const SizedBox(height: 32),
                  // Feature highlights
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _featureIcon('Swipe', Icons.swipe),
                        _featureIcon('TTS', Icons.volume_up),
                        _featureIcon('4 Langs', Icons.language),
                      ],
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

  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  Widget _featureIcon(String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 28),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white70,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _bigButton(
    BuildContext context,
    String label,
    String emoji,
    Color textColor,
    int bgColor,
    VoidCallback onTap,
  ) {
    return SizedBox(
      width: 280,
      height: 70,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(bgColor),
          foregroundColor: textColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(35),
          ),
          elevation: 6,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
