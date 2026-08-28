import 'package:flutter/material.dart';
import '../models/flashcard.dart';
import 'pronunciation_button.dart';

/// SwipeCard — a single flashcard shown in the swiper.
/// Displays the phrase in 4 languages; tap any to hear TTS.
class SwipeCard extends StatelessWidget {
  final Flashcard card;
  final Color accentColor;

  /// Called with (text, languageKey, chineseChars, phraseId) when a language is tapped.
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
              // Top label: English in large text
              Container(
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  card.english,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: accentColor,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // 4 language buttons in 2x2 grid
              Row(
                children: [
                  PronunciationButton(
                    label: 'Teochew',
                    romanized: card.teochewRomanized,
                    chinese: card.teochewChinese,
                    languageKey: 'teochew',
                    color: const Color(0xFFE17076),
                    onTap: () =>
                        onSpeak(card.teochewRomanized, 'teochew', card.teochewChinese, card.id),
                  ),
                  PronunciationButton(
                    label: 'Cantonese',
                    romanized: card.cantoneseRomanized,
                    chinese: card.cantoneseChinese,
                    languageKey: 'cantonese',
                    color: const Color(0xFF6CACE4),
                    onTap: () =>
                        onSpeak(card.cantoneseRomanized, 'cantonese', null, card.id),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  PronunciationButton(
                    label: 'Mandarin',
                    romanized: card.mandarinRomanized,
                    chinese: card.mandarinChinese,
                    languageKey: 'mandarin',
                    color: const Color(0xFFE8932C),
                    onTap: () =>
                        onSpeak(card.mandarinRomanized, 'mandarin', null, card.id),
                  ),
                  PronunciationButton(
                    label: 'English',
                    romanized: card.english,
                    chinese: '',
                    languageKey: 'english',
                    color: const Color(0xFF5CB85C),
                    onTap: () => onSpeak(card.english, 'english', null, card.id),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Hint text
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
