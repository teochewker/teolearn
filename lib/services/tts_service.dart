import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:audioplayers/audioplayers.dart';
import 'dart:convert';

/// Audio service — plays real recorded audio files for all 4 languages.
/// Teochew: Fish Audio TTS (full phrase, natural pronunciation)
/// Cantonese: Google Translate TTS (yue)
/// Mandarin: Google Translate TTS (zh-CN)
/// English: Google Translate TTS (en-US)
class TtsService extends ChangeNotifier {
  AudioPlayer? _audioPlayer;
  bool _initialized = false;
  bool _isSpeaking = false;

  // Map: phrase ID → {language → audio filename}
  static final Map<String, Map<String, String>> _audioMap = {};

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

  Future<void> loadAudioMapping() async {
    if (!_initialized) await init();
    try {
      final jsonString = await rootBundle.loadString('assets/audio/audio_mapping.json');
      final map = jsonDecode(jsonString) as Map<String, dynamic>;
      for (final entry in map.entries) {
        final id = entry.key;
        final data = entry.value as Map<String, dynamic>;
        _audioMap[id] = {
          'teochew': data['teochew_audio'] as String? ?? '',
          'mandarin': data['mandarin_audio'] as String? ?? '',
          'cantonese': data['cantonese_audio'] as String? ?? '',
          'english': data['english_audio'] as String? ?? '',
        };
      }
      debugPrint('Loaded ${_audioMap.length} audio entries');
    } catch (e) {
      debugPrint('Could not load audio mapping: $e');
    }
  }

  Future<void> speak(String text, String language, {String? chineseChars, String? phraseId}) async {
    if (!_initialized) await init();
    if (_audioPlayer == null) return;

    await _audioPlayer!.stop();

    if (phraseId == null || !_audioMap.containsKey(phraseId)) {
      debugPrint('No audio for phraseId=$phraseId ($language)');
      return;
    }

    final fileName = _audioMap[phraseId]?[language] ?? '';
    if (fileName.isEmpty) {
      debugPrint('No $language audio for $phraseId');
      return;
    }

    _isSpeaking = true;
    notifyListeners();

    try {
      await _audioPlayer!.play(AssetSource('audio/$language/$fileName'));
    } catch (e) {
      debugPrint('Error playing audio: $e');
    }

    _isSpeaking = false;
    notifyListeners();
  }

  Future<void> stop() async {
    if (_audioPlayer != null) await _audioPlayer!.stop();
    _isSpeaking = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _audioPlayer?.dispose();
    super.dispose();
  }
}
