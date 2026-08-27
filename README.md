# TeoLearn — Teochew Language Learning App for Kids

A Flutter cross-platform (iOS + Android) app for children to learn Teochew in tandem with Cantonese, Mandarin, and English.

## Features
- Swipe flash cards (Tinder-style) with phrases in 4 languages
- Voice playback (TTS) for pronunciation in each language
- Multiple vocabulary flows: Greetings, Food, Family, Numbers, Colors, Festivals, Traditions, Tea Culture, Jade, School
- End-of-flow grading: score, accuracy, missed phrases, retry option
- Progress tracking with local SQLite storage
- Child-friendly UI with colorful design and animations

## Tech
- Flutter (Dart) — single codebase for iOS + Android
- flutter_tts for voice playback
- sqflite for local progress tracking
- Swipe card animations
- No backend — all data local

## Structure
```
lib/
  main.dart
  models/
    flashcard.dart
    flow.dart
    progress.dart
  screens/
    home_screen.dart
    flow_selection_screen.dart
    flashcard_screen.dart
    results_screen.dart
    progress_screen.dart
  widgets/
    swipe_card.dart
    language_selector.dart
    pronunciation_button.dart
  data/
    vocab_data.dart
  services/
    tts_service.dart
    progress_service.dart
```
