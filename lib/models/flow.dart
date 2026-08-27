import 'dart:ui' show Color;
import 'flashcard.dart';

/// VocabFlow model — a collection of flashcards grouped by theme.
/// (Renamed from Flow to avoid conflict with Flutter's Flow widget.)
class VocabFlow {
  final String id;
  final String title;
  final String emoji;
  final int colorValue;
  final List<Flashcard> cards;

  const VocabFlow({
    required this.id,
    required this.title,
    required this.emoji,
    required this.colorValue,
    required this.cards,
  });

  Color get color => Color(colorValue);
  int get totalCards => cards.length;
}
