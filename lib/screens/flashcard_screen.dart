import 'package:flutter/material.dart';
import 'package:appinio_swiper/appinio_swiper.dart';
import '../models/flow.dart';
import '../models/flashcard.dart' show Flashcard;
import '../services/tts_service.dart';
import '../services/progress_service.dart';
import '../widgets/swipe_card.dart';
import 'results_screen.dart';

/// Flashcard screen — Tinder-style swipe cards.
/// Swipe right = "got it", swipe left = "review again".
/// Pass [customCards] to override the flow's full card list (e.g. retry only missed cards).
class FlashcardScreen extends StatefulWidget {
  final VocabFlow flow;
  final List<Flashcard>? customCards;

  const FlashcardScreen({
    super.key,
    required this.flow,
    this.customCards,
  });

  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> {
  late AppinioSwiperController _controller;
  final TtsService _tts = TtsService();
  late List<Flashcard> _cards;
  final List<Flashcard> _missedCards = [];
  final List<Flashcard> _gotItCards = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = AppinioSwiperController();
    _cards = widget.customCards ?? List.from(widget.flow.cards);
    _initTts();
  }

  Future<void> _initTts() async {
    await _tts.init();
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _speak(String text, String language, String? chineseChars, String? phraseId) {
    _tts.speak(text, language, chineseChars: chineseChars, phraseId: phraseId);
  }

  void _onSwipeEnd(int previousIndex, int targetIndex, SwiperActivity activity) {
    final card = _cards[previousIndex];
    if (activity.direction == AxisDirection.right) {
      _gotItCards.add(card);
      ProgressService.recordPhraseLearned(
        phraseId: card.id,
        flowId: widget.flow.id,
      );
    } else if (activity.direction == AxisDirection.left) {
      _missedCards.add(card);
    }
    if (mounted) setState(() {});
  }

  void _onEnd() {
    if (!mounted) return;
    ProgressService.recordFlowCompletion(
      flowId: widget.flow.id,
      flowTitle: widget.flow.title,
      score: _gotItCards.length,
      totalCards: _cards.length,
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ResultsScreen(
          flow: widget.flow,
          gotItCards: List.from(_gotItCards),
          missedCards: List.from(_missedCards),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tts.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final totalCards = _cards.length;
    final completed = _gotItCards.length + _missedCards.length;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.flow.emoji} ${widget.flow.title}',
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        backgroundColor: widget.flow.color,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    widget.flow.color.withValues(alpha: 0.1),
                    Colors.white,
                  ],
                ),
              ),
              child: Column(
                children: [
                  // Progress indicator
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Card ${completed + 1}/$totalCards',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Row(
                          children: [
                            _badge('Got it: ${_gotItCards.length}', 0xFF5CB85C),
                            const SizedBox(width: 8),
                            _badge('Review: ${_missedCards.length}', 0xFFE17076),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Swiper
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      child: AppinioSwiper(
                        controller: _controller,
                        cardCount: totalCards,
                        cardBuilder: (context, index) {
                          return SwipeCard(
                            card: _cards[index],
                            accentColor: widget.flow.color,
                            onSpeak: _speak,
                          );
                        },
                        onSwipeEnd: _onSwipeEnd,
                        onEnd: _onEnd,
                        swipeOptions:
                            const SwipeOptions.only(left: true, right: true),
                      ),
                    ),
                  ),
                  // Control buttons
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Swipe left button
                        _controlButton(
                          'Review Again',
                          Icons.refresh,
                          0xFFE17076,
                          () {
                            _controller.swipeLeft();
                          },
                        ),
                        // Swipe right button
                        _controlButton(
                          'Got It!',
                          Icons.check,
                          0xFF5CB85C,
                          () {
                            _controller.swipeRight();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _badge(String text, int color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
      decoration: BoxDecoration(
        color: Color(color).withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Color(color),
        ),
      ),
    );
  }

  Widget _controlButton(
    String label,
    IconData icon,
    int color,
    VoidCallback onTap,
  ) {
    return SizedBox(
      width: 160,
      height: 60,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 28),
        label: Text(
          label,
          style: const TextStyle(
            fontSize: 18,
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
