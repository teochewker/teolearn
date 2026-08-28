import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:audioplayers/audioplayers.dart';
import 'dart:convert';
import 'dart:async';

/// Audio service — plays real recorded audio files for all 4 languages.
class TtsService extends ChangeNotifier {
  AudioPlayer? _audioPlayer;
  bool _initialized = false;
  bool _isSpeaking = false;

  // Map: Chinese characters → Teochew audio file name (Level 1)
  static final Map<String, String> _teochewAudioByChars = {};
  // Map: phrase ID → audio file name for each language (Level 2)
  static final Map<String, Map<String, String>> _phraseAudioMap = {};

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
    
    // Load Teochew audio mapping (Chinese chars → audio file)
    try {
      final jsonString = await rootBundle.loadString('assets/audio/teochew/audio_mapping.json');
      final teochewMap = jsonDecode(jsonString) as Map<String, dynamic>;
      for (final entry in teochewMap.entries) {
        final chars = entry.key;
        final data = entry.value as Map<String, dynamic>;
        final audioFile = data['audio_file'] as String?;
        if (audioFile != null && audioFile.isNotEmpty) {
          _teochewAudioByChars[chars] = audioFile;
        }
      }
      debugPrint('Loaded ${_teochewAudioByChars.length} Teochew audio entries');
    } catch (e) {
      debugPrint('Could not load Teochew audio mapping: $e');
    }
    
    // Load main audio mapping (phrase IDs → all language files)
    try {
      final jsonString = await rootBundle.loadString('assets/audio/audio_mapping.json');
      final mainMap = jsonDecode(jsonString) as Map<String, dynamic>;
      for (final entry in mainMap.entries) {
        final id = entry.key;
        final data = entry.value as Map<String, dynamic>;
        _phraseAudioMap[id] = {
          'mandarin': data['mandarin_audio'] as String? ?? '',
          'cantonese': data['cantonese_audio'] as String? ?? '',
          'english': data['english_audio'] as String? ?? '',
          'teochew': data['teochew_audio'] as String? ?? '',
        };
      }
      debugPrint('Loaded ${_phraseAudioMap.length} phrase audio entries');
    } catch (e) {
      debugPrint('Could not load main audio mapping: $e');
    }
  }

  Future<void> speak(String text, String language, {String? chineseChars, String? phraseId}) async {
    if (!_initialized) await init();
    if (_audioPlayer == null) return;

    await _audioPlayer!.stop();

    _isSpeaking = true;
    notifyListeners();

    try {
      String? audioPath;

      if (language == 'teochew') {
        // First try phrase ID lookup (Level 2)
        if (phraseId != null && _phraseAudioMap.containsKey(phraseId)) {
          final teochewFile = _phraseAudioMap[phraseId]?['teochew'] ?? '';
          if (teochewFile.isNotEmpty) {
            audioPath = 'assets/audio/teochew/$teochewFile';
          }
        }
        // Fallback: look up by Chinese characters (Level 1)
        if (audioPath == null) {
          final lookupChars = chineseChars ?? text;
          if (_teochewAudioByChars.containsKey(lookupChars)) {
            audioPath = 'assets/audio/teochew/${_teochewAudioByChars[lookupChars]}';
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
        await _audioPlayer!.play(AssetSource('audio/${audioPath.split('audio/')[1]}'));
      } else {
        debugPrint('No audio for: $text ($language, id=$phraseId)');
      }
    } catch (e) {
      debugPrint('Error playing audio: $e');
    }

    _isSpeaking = false;
    notifyListeners();
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
