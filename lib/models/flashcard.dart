/// Flashcard model — represents a single phrase in 4 languages.
class Flashcard {
  final String id;
  final String teochewRomanized;
  final String teochewChinese;
  final String cantoneseRomanized;
  final String cantoneseChinese;
  final String mandarinRomanized;
  final String mandarinChinese;
  final String english;
  final String? emoji;

  const Flashcard({
    required this.id,
    required this.teochewRomanized,
    required this.teochewChinese,
    required this.cantoneseRomanized,
    required this.cantoneseChinese,
    required this.mandarinRomanized,
    required this.mandarinChinese,
    required this.english,
    this.emoji,
  });

  /// Language tag for TTS engine selection.
  /// 'te' → zh-CN (closest approximation for Teochew)
  /// 'yue' → zh-HK (Cantonese)
  /// 'zh' → zh-CN (Mandarin)
  /// 'en' → en-US (English)
  static const Map<String, String> ttsLanguageMap = {
    'teochew': 'zh-CN',
    'cantonese': 'zh-HK',
    'mandarin': 'zh-CN',
    'english': 'en-US',
  };

  Map<String, (String, String)> get languageEntries => {
        'teochew': (teochewRomanized, teochewChinese),
        'cantonese': (cantoneseRomanized, cantoneseChinese),
        'mandarin': (mandarinRomanized, mandarinChinese),
        'english': (english, ''),
      };

  factory Flashcard.fromMap(Map<String, dynamic> map) {
    return Flashcard(
      id: map['id'] as String,
      teochewRomanized: map['teochewRomanized'] as String,
      teochewChinese: map['teochewChinese'] as String,
      cantoneseRomanized: map['cantoneseRomanized'] as String,
      cantoneseChinese: map['cantoneseChinese'] as String,
      mandarinRomanized: map['mandarinRomanized'] as String,
      mandarinChinese: map['mandarinChinese'] as String,
      english: map['english'] as String,
      emoji: map['emoji'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'teochewRomanized': teochewRomanized,
      'teochewChinese': teochewChinese,
      'cantoneseRomanized': cantoneseRomanized,
      'cantoneseChinese': cantoneseChinese,
      'mandarinRomanized': mandarinRomanized,
      'mandarinChinese': mandarinChinese,
      'english': english,
      'emoji': emoji,
    };
  }
}
