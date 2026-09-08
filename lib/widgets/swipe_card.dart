import 'package:flutter/material.dart';
import '../models/flashcard.dart';
import 'pronunciation_button.dart';

/// SwipeCard — a single flashcard shown in the swiper.
/// Displays the phrase in 3 languages: Teochew, Mandarin, English.
class SwipeCard extends StatelessWidget {
  final Flashcard card;
  final Color accentColor;

  final void Function(String text, String language, String? chineseChars, String? phraseId) onSpeak;

  const SwipeCard({
    super.key,
    required this.card,
    required this.accentColor,
    required this.onSpeak,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: accentColor.withValues(alpha: 0.3), width: 3),
      ),
      color: Colors.white,
      child: Container(
        width: size.width * 0.85,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (card.emoji != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    card.emoji!,
                    style: const TextStyle(fontSize: 40),
                  ),
                ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  card.english,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: accentColor,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // 3 language buttons
              PronunciationButton(
                label: 'Teochew (潮汕话)',
                romanized: card.teochewChinese,
                chinese: card.teochewChinese,
                languageKey: 'teochew',
                color: const Color(0xFFE17076),
                onTap: () =>
                    onSpeak(card.teochewChinese, 'teochew', card.teochewChinese, card.id),
              ),
              const SizedBox(height: 8),
              PronunciationButton(
                label: 'Mandarin (普通话)',
                romanized: card.mandarinChinese,
                chinese: card.mandarinChinese,
                languageKey: 'mandarin',
                color: const Color(0xFFE8932C),
                onTap: () =>
                    onSpeak(card.mandarinChinese, 'mandarin', null, card.id),
              ),
              const SizedBox(height: 8),
              PronunciationButton(
                label: 'English',
                romanized: card.english,
                chinese: '',
                languageKey: 'english',
                color: const Color(0xFF5CB85C),
                onTap: () => onSpeak(card.english, 'english', null, card.id),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _hintBadge('👈 Review', 0xFFE17076),
                  _hintBadge('Got it 👉', 0xFF5CB85C),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _hintBadge(String text, int color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
      decoration: BoxDecoration(
        color: Color(color).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
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
}
