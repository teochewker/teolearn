import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:audioplayers/audioplayers.dart';
import 'dart:convert';
import 'dart:async';

/// Audio service — plays real recorded audio files for all 4 languages.
/// Teochew: real Teochew recordings from teochewspot.com (merged syllables)
/// Cantonese: Google Translate TTS (yue/Cantonese)
/// Mandarin: Google Translate TTS (zh-CN)
/// English: Google Translate TTS (en-US)
class TtsService extends ChangeNotifier {
  AudioPlayer? _audioPlayer;
  bool _initialized = false;
  bool _isSpeaking = false;

  // Map: Chinese characters → single merged Teochew audio file name
  static final Map<String, String> _teochewAudioFile = {};
  // Map: phrase ID → audio file name for each language
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

  /// Load all audio mappings from bundled assets
  Future<void> loadAudioMapping() async {
    if (!_initialized) await init();
    
    // Load Teochew audio mapping (Chinese chars → single merged audio file)
    try {
      final jsonString = await rootBundle.loadString('assets/audio/teochew/audio_mapping.json');
      final teochewMap = jsonDecode(jsonString) as Map<String, dynamic>;
      for (final entry in teochewMap.entries) {
        final chars = entry.key;
        final data = entry.value as Map<String, dynamic>;
        final audioFile = data['audio_file'] as String?;
        if (audioFile != null && audioFile.isNotEmpty) {
          _teochewAudioFile[chars] = audioFile;
        }
      }
      debugPrint('Loaded ${_teochewAudioFile.length} Teochew audio entries');
    } catch (e) {
      debugPrint('Could not load Teochew audio mapping: $e');
    }
    
    // Load main audio mapping (phrase IDs → mandarin/cantonese/english files)
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
        };
      }
      debugPrint('Loaded ${_phraseAudioMap.length} phrase audio entries');
    } catch (e) {
      debugPrint('Could not load main audio mapping: $e');
    }
  }

  /// Play audio for a phrase in a specific language.
  Future<void> speak(String text, String language, {String? chineseChars, String? phraseId}) async {
    if (!_initialized) await init();
    if (_audioPlayer == null) return;

    await _audioPlayer!.stop();

    _isSpeaking = true;
    notifyListeners();

    try {
      if (language == 'teochew') {
        // Look up Teochew audio by Chinese characters — single merged file
        final lookupChars = chineseChars ?? text;
        if (_teochewAudioFile.containsKey(lookupChars)) {
          final fileName = _teochewAudioFile[lookupChars]!;
          await _audioPlayer!.play(AssetSource('audio/teochew/$fileName'));
        } else {
          debugPrint('No Teochew audio for: $lookupChars');
        }
      } else if (phraseId != null && _phraseAudioMap.containsKey(phraseId)) {
        final langAudio = _phraseAudioMap[phraseId]!;
        final fileName = langAudio[language] ?? '';
        if (fileName.isNotEmpty) {
          await _audioPlayer!.play(AssetSource('audio/$language/$fileName'));
        }
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
