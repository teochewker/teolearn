import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:audioplayers/audioplayers.dart';
import 'dart:convert';
import 'dart:async';

/// Audio service — plays real recorded audio files for all 4 languages.
/// Teochew: real Teochew recordings from teochewspot.com
/// Cantonese: Google Translate TTS (zh-HK)
/// Mandarin: Google Translate TTS (zh-CN)
/// English: Google Translate TTS (en-US)
class TtsService extends ChangeNotifier {
  AudioPlayer? _audioPlayer;
  bool _initialized = false;
  bool _isSpeaking = false;

  // Map: phrase ID → audio file names for each language
  static final Map<String, Map<String, String>> _phraseAudioMap = {};
  // Map: Chinese characters → phrase ID (for Teochew lookup)
  static final Map<String, String> _charsToId = {};

  bool get isInitialized => _initialized;
  bool get isSpeaking => _isSpeaking;

  Future<void> init() async {
    if (_initialized) return;
    _audioPlayer = AudioPlayer();
    _audioPlayer!.onPlayerComplete.listen((_) {
      _isSpeaking = false;
      notifyListeners();
    });
    _initialized = true;
  }

  /// Load the audio mapping from bundled assets JSON
  Future<void> loadAudioMapping() async {
    if (!_initialized) await init();
    try {
      final jsonString = await rootBundle.loadString('assets/audio/teochew/audio_mapping.json');
      final teochewMap = jsonDecode(jsonString) as Map<String, dynamic>;
      
      // Build chars → audio files mapping for Teochew
      for (final entry in teochewMap.entries) {
        final chars = entry.key;
        final data = entry.value as Map<String, dynamic>;
        final audioFiles = (data['audio_files'] as List?)?.cast<String>() ?? [];
        if (audioFiles.isNotEmpty) {
          _charsToId[chars] = audioFiles.join(',');
        }
      }
      
      // Load the main audio mapping (mandarin, cantonese, english)
      try {
        final mainJson = await rootBundle.loadString('assets/audio/audio_mapping.json');
        final mainMap = jsonDecode(mainJson) as Map<String, dynamic>;
        for (final entry in mainMap.entries) {
          final id = entry.key;
          final data = entry.value as Map<String, dynamic>;
          _phraseAudioMap[id] = {
            'mandarin': data['mandarin_audio'] as String? ?? '',
            'cantonese': data['cantonese_audio'] as String? ?? '',
            'english': data['english_audio'] as String? ?? '',
          };
        }
      } catch (e) {
        debugPrint('Could not load main audio mapping: $e');
      }
    } catch (e) {
      debugPrint('Could not load Teochew audio mapping: $e');
    }
  }

  /// Set the Teochew audio mapping (called from main.dart)
  void setTeochewAudioMap(Map<String, dynamic> mapping) {
    for (final entry in mapping.entries) {
      final chars = entry.key;
      final data = entry.value as Map<String, dynamic>;
      final audioFiles = (data['audio_files'] as List?)?.cast<String>() ?? [];
      if (audioFiles.isNotEmpty) {
        _charsToId[chars] = audioFiles.join(',');
      }
    }
  }

  /// Play audio for [phraseId] in [language].
  /// [chineseChars] is used for Teochew audio lookup.
  Future<void> speak(String text, String language, {String? chineseChars, String? phraseId}) async {
    if (!_initialized) await init();
    if (_audioPlayer == null) return;

    await _audioPlayer!.stop();

    String? audioPath;

    if (language == 'teochew') {
      // Look up Teochew audio by Chinese characters
      final lookupChars = chineseChars ?? text;
      if (_charsToId.containsKey(lookupChars)) {
        final audioFiles = _charsToId[lookupChars]!.split(',');
        if (audioFiles.isNotEmpty) {
          audioPath = 'assets/audio/teochew/${audioFiles[0]}';
        }
      }
    } else if (phraseId != null && _phraseAudioMap.containsKey(phraseId)) {
      final langAudio = _phraseAudioMap[phraseId]!;
      final fileName = langAudio[language] ?? '';
      if (fileName.isNotEmpty) {
        audioPath = 'assets/audio/$language/$fileName';
      }
    }

    if (audioPath != null) {
      _isSpeaking = true;
      notifyListeners();
      try {
        await _audioPlayer!.play(AssetSource('audio/$language/${audioPath.split('/').last}'));
      } catch (e) {
        debugPrint('Error playing audio: $e');
        _isSpeaking = false;
        notifyListeners();
      }
    } else {
      debugPrint('No audio file found for: $text ($language)');
    }
  }

  Future<void> stop() async {
    if (_audioPlayer != null) {
      await _audioPlayer!.stop();
    }
    _isSpeaking = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _audioPlayer?.dispose();
    super.dispose();
  }
}
