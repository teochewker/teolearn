import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:convert';
import 'dart:async';

/// TTS service — handles pronunciation for 4 languages.
/// Teochew: plays real recorded audio files from teochewspot.com
/// Cantonese: zh-HK TTS
/// Mandarin: zh-CN TTS
/// English: en-US TTS
class TtsService extends ChangeNotifier {
  FlutterTts? _tts;
  AudioPlayer? _audioPlayer;
  bool _initialized = false;
  bool _isSpeaking = false;

  // Map of Chinese characters → list of audio file names
  static Map<String, List<String>> _teochewAudioMap = {};
  // Reverse map: Chinese phrase → audio files for that phrase
  static Map<String, List<String>> _phraseAudioMap = {};

  bool get isInitialized => _initialized;
  bool get isSpeaking => _isSpeaking;

  Future<void> init() async {
    if (_initialized) return;
    _tts = FlutterTts();
    await _tts!.setSpeechRate(0.4);
    await _tts!.setVolume(1.0);
    await _tts!.setPitch(1.0);
    _tts!.setStartHandler(() {
      _isSpeaking = true;
      notifyListeners();
    });
    _tts!.setCompletionHandler(() {
      _isSpeaking = false;
      notifyListeners();
    });
    _tts!.setErrorHandler((msg) {
      _isSpeaking = false;
      notifyListeners();
    });
    _audioPlayer = AudioPlayer();
    _initialized = true;
  }

  /// Load the audio mapping from bundled assets
  Future<void> loadAudioMapping() async {
    if (!_initialized) await init();
    // The audio mapping is loaded from assets/audio/teochew/audio_mapping.json
    // This is done by the app at startup — see main.dart
  }

  /// Set the Teochew audio mapping (called from main.dart after loading JSON)
  void setTeochewAudioMap(Map<String, dynamic> mapping) {
    _phraseAudioMap.clear();
    for (final entry in mapping.entries) {
      final chars = entry.key;
      final data = entry.value as Map<String, dynamic>;
      final audioFiles = (data['audio_files'] as List?)?.cast<String>() ?? [];
      if (audioFiles.isNotEmpty) {
        _phraseAudioMap[chars] = audioFiles;
      }
    }
  }

  /// Speak [text] in [language]. Supported: 'teochew', 'cantonese', 'mandarin', 'english'.
  /// For Teochew, plays real recorded audio files if available.
  /// [chineseChars] is the Chinese characters for the phrase (used to look up Teochew audio).
  Future<void> speak(String text, String language, {String? chineseChars}) async {
    if (!_initialized) await init();
    if (_tts == null) return;

    await _tts!.stop();
    if (_audioPlayer != null) await _audioPlayer!.stop();

    if (language == 'teochew') {
      // Try to play real Teochew audio
      final lookupChars = chineseChars ?? text;
      if (_phraseAudioMap.containsKey(lookupChars)) {
        final audioFiles = _phraseAudioMap[lookupChars]!;
        await _playTeochewAudioFiles(audioFiles);
        return;
      }
      // Fallback: use zh-CN TTS (Mandarin pronunciation of Chinese chars)
      try {
        await _tts!.setLanguage('zh-CN');
        await _tts!.speak(lookupChars);
      } catch (_) {
        await _tts!.setLanguage('en-US');
        await _tts!.speak(text);
      }
      return;
    }

    final langCode = _getLanguageCode(language);
    try {
      await _tts!.setLanguage(langCode);
    } catch (_) {
      await _tts!.setLanguage('en-US');
    }
    await _tts!.speak(text);
  }

  /// Play Teochew audio files sequentially
  Future<void> _playTeochewAudioFiles(List<String> audioFiles) async {
    if (_audioPlayer == null) return;
    _isSpeaking = true;
    notifyListeners();

    for (final fileName in audioFiles) {
      try {
        await _audioPlayer!.play(AssetSource('audio/teochew/$fileName'));
        // Wait for each audio to finish
        await _audioPlayer!.onPlayerComplete.first;
      } catch (e) {
        debugPrint('Error playing Teochew audio $fileName: $e');
      }
    }

    _isSpeaking = false;
    notifyListeners();
  }

  String _getLanguageCode(String language) {
    switch (language) {
      case 'teochew':
        return 'zh-CN'; // Fallback only — real audio used when available
      case 'cantonese':
        return 'zh-HK';
      case 'mandarin':
        return 'zh-CN';
      case 'english':
        return 'en-US';
      default:
        return 'en-US';
    }
  }

  Future<void> stop() async {
    if (_tts != null) {
      await _tts!.stop();
    }
    if (_audioPlayer != null) {
      await _audioPlayer!.stop();
    }
    _isSpeaking = false;
    notifyListeners();
  }

  Future<List<dynamic>> getAvailableLanguages() async {
    if (!_initialized) await init();
    if (_tts == null) return [];
    try {
      final langs = await _tts!.getLanguages;
      return langs ?? [];
    } catch (_) {
      return [];
    }
  }

  @override
  void dispose() {
    _tts?.stop();
    _audioPlayer?.dispose();
    super.dispose();
  }
}
