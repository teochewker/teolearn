import 'dart:math' show pi;
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import '../models/flow.dart';
import '../models/flashcard.dart';
import 'flashcard_screen.dart';
import 'flow_selection_screen.dart';
import 'home_screen.dart';

/// Results screen — shows score, accuracy, missed phrases, and actions.
class ResultsScreen extends StatefulWidget {
  final VocabFlow flow;
  final List<Flashcard> gotItCards;
  final List<Flashcard> missedCards;

  const ResultsScreen({
    super.key,
    required this.flow,
    required this.gotItCards,
    required this.missedCards,
  });

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_accuracy >= 0.7) {
        _confettiController.play();
      }
    });
  }

  int get _score => widget.gotItCards.length;
  int get _total => widget.flow.totalCards;
  double get _accuracy => _total > 0 ? _score / _total : 0.0;
  int get _stars {
    if (_accuracy >= 0.9) return 3;
    if (_accuracy >= 0.7) return 2;
    if (_accuracy >= 0.5) return 1;
    return 0;
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  widget.flow.color.withValues(alpha: 0.3),
                  Colors.white,
                ],
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      // Confetti
                      Align(
                        alignment: Alignment.topCenter,
                        child: ConfettiWidget(
                          confettiController: _confettiController,
                          blastDirection: pi / 2,
                          maxBlastForce: 0.1,
                          minBlastForce: 0.05,
                          numberOfParticles: 30,
                          gravity: 0.2,
                          shouldLoop: false,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Stars
                      _starsWidget(),
                      const SizedBox(height: 16),
                      // Title
                      Text(
                        _titleText,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: widget.flow.color,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Score card
                      _scoreCard(),
                      const SizedBox(height: 20),
                      // Missed phrases
                      if (widget.missedCards.isNotEmpty) ...[
                        _missedSection(),
                        const SizedBox(height: 20),
                      ],
                      // Buttons
                      _actionButtons(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String get _titleText {
    if (_stars == 3) return 'Amazing! 🎉';
    if (_stars == 2) return 'Great Job! 👏';
    if (_stars == 1) return 'Good Try! 💪';
    return 'Keep Practicing! 📚';
  }

  Widget _starsWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Icon(
            i < _stars ? Icons.star : Icons.star_border,
            size: 60,
            color: i < _stars ? const Color(0xFFFFD700) : Colors.grey.shade300,
          ),
        );
      }),
    );
  }

  Widget _scoreCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _statBlock('Score', '$_score/$_total'),
            _statBlock('Accuracy', '${(_accuracy * 100).round()}%'),
          ],
        ),
      ),
    );
  }

  Widget _statBlock(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.w900,
            color: Color(0xFF333333),
          ),
        ),
      ],
    );
  }

  Widget _missedSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Review these phrases:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 12),
            ...widget.missedCards.map((c) => _missedPhrase(c)),
          ],
        ),
      ),
    );
  }

  Widget _missedPhrase(Flashcard card) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          if (card.emoji != null)
            Text(card.emoji!, style: const TextStyle(fontSize: 24)),
          if (card.emoji != null) const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  card.english,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '${card.teochewRomanized} · ${card.teochewChinese}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButtons() {
    return Column(
      children: [
        if (widget.missedCards.isNotEmpty)
          _bigButton('Retry Missed', Icons.refresh, 0xFFE17076, () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => FlashcardScreen(
                  flow: widget.flow,
                  customCards: List.from(widget.missedCards),
                ),
              ),
            );
          }),
        const SizedBox(height: 12),
        _bigButton('Retry All', Icons.replay, 0xFFF2C14E, () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => FlashcardScreen(flow: widget.flow),
            ),
          );
        }),
        const SizedBox(height: 12),
        _bigButton('Next Flow', Icons.arrow_forward, 0xFF6C5CEC, () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const VocabFlowSelectionScreen()),
            (route) => false,
          );
        }),
        const SizedBox(height: 12),
        _bigButton('Home', Icons.home, 0xFF5CB85C, () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const HomeScreen()),
            (route) => false,
          );
        }),
      ],
    );
  }

  Widget _bigButton(String label, IconData icon, int color, VoidCallback onTap) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 24),
        label: Text(
          label,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(color),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 4,
        ),
      ),
    );
  }
}
