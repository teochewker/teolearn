import '../models/flow.dart';
import '../models/flashcard.dart';

/// Vocabulary data — 29 phrases across 3 flows.
/// Teochew + Mandarin audio: native speaker from YouTube @villagestory99
/// English audio: Google Translate TTS

final List<VocabFlow> allFlows = [
  VocabFlow(
    id: 'greetings',
    title: 'Greetings',
    emoji: '👋',
    colorValue: 0xFFE17076,
    cards: [
      Flashcard(id: 'greetings_1', teochewRomanized: '', teochewChinese: '你好', cantoneseRomanized: '', cantoneseChinese: '你好', mandarinRomanized: 'nǐ hǎo', mandarinChinese: '你好', english: 'How to greet', emoji: '👋'),
      Flashcard(id: 'greetings_2', teochewRomanized: '', teochewChinese: '对不起', cantoneseRomanized: '', cantoneseChinese: '對不起', mandarinRomanized: 'duì bù qǐ', mandarinChinese: '对不起', english: 'Sorry', emoji: '😔'),
      Flashcard(id: 'greetings_3', teochewRomanized: '', teochewChinese: '没事', cantoneseRomanized: '', cantoneseChinese: '沒事', mandarinRomanized: 'méi shì', mandarinChinese: '没事', english: 'No problem', emoji: '😊'),
      Flashcard(id: 'greetings_4', teochewRomanized: '', teochewChinese: '你要去哪里', cantoneseRomanized: '', cantoneseChinese: '你要去哪裡', mandarinRomanized: 'nǐ yào qù nǎ lǐ', mandarinChinese: '你要去哪里', english: 'Where are you going?', emoji: '🤔'),
      Flashcard(id: 'greetings_5', teochewRomanized: '', teochewChinese: '你住哪里', cantoneseRomanized: '', cantoneseChinese: '你住哪裡', mandarinRomanized: 'nǐ zhù nǎ lǐ', mandarinChinese: '你住哪里', english: 'Where do you live?', emoji: '🏠'),
      Flashcard(id: 'greetings_6', teochewRomanized: '', teochewChinese: '生日快乐', cantoneseRomanized: '', cantoneseChinese: '生日快樂', mandarinRomanized: 'shēng rì kuài lè', mandarinChinese: '生日快乐', english: 'Happy birthday', emoji: '🎂'),
      Flashcard(id: 'greetings_7', teochewRomanized: '', teochewChinese: '开心', cantoneseRomanized: '', cantoneseChinese: '開心', mandarinRomanized: 'kāi xīn', mandarinChinese: '开心', english: 'Happy', emoji: '😄'),
      Flashcard(id: 'greetings_9', teochewRomanized: '', teochewChinese: '好了没', cantoneseRomanized: '', cantoneseChinese: '好了未', mandarinRomanized: 'hǎo le méi', mandarinChinese: '好了没', english: 'Done yet?', emoji: '⏳'),
      Flashcard(id: 'greetings_10', teochewRomanized: '', teochewChinese: '干嘛', cantoneseRomanized: '', cantoneseChinese: '做乜', mandarinRomanized: 'gàn má', mandarinChinese: '干嘛', english: 'What are you doing?', emoji: '🤷'),
    ],
  ),
  VocabFlow(
    id: 'food',
    title: 'Food',
    emoji: '🍜',
    colorValue: 0xFFF2C14E,
    cards: [
      Flashcard(id: 'food_1', teochewRomanized: '', teochewChinese: '今晚吃什么', cantoneseRomanized: '', cantoneseChinese: '今晚食咩', mandarinRomanized: 'jīn wǎn chī shén me', mandarinChinese: '今晚吃什么', english: 'What to eat tonight?', emoji: '🌙'),
      Flashcard(id: 'food_2', teochewRomanized: '', teochewChinese: '中午吃什么', cantoneseRomanized: '', cantoneseChinese: '中午食咩', mandarinRomanized: 'zhōng wǔ chī shén me', mandarinChinese: '中午吃什么', english: 'What to eat for lunch?', emoji: '☀️'),
      Flashcard(id: 'food_3', teochewRomanized: '', teochewChinese: '多喝热水', cantoneseRomanized: '', cantoneseChinese: '多飲熱水', mandarinRomanized: 'duō hē rè shuǐ', mandarinChinese: '多喝热水', english: 'Drink more hot water', emoji: '💧'),
      Flashcard(id: 'food_4', teochewRomanized: '', teochewChinese: '买菜', cantoneseRomanized: '', cantoneseChinese: '買餸', mandarinRomanized: 'mǎi cài', mandarinChinese: '买菜', english: 'Buying food', emoji: '🛒'),
      Flashcard(id: 'food_5', teochewRomanized: '', teochewChinese: '这些肉', cantoneseRomanized: '', cantoneseChinese: '呢啲肉', mandarinRomanized: 'zhè xiē ròu', mandarinChinese: '这些肉', english: 'These meats', emoji: '🥩'),
      Flashcard(id: 'food_6', teochewRomanized: '', teochewChinese: '这些海鲜', cantoneseRomanized: '', cantoneseChinese: '呢啲海鮮', mandarinRomanized: 'zhè xiē hǎi xiān', mandarinChinese: '这些海鲜', english: 'These seafoods', emoji: '🦐'),
      Flashcard(id: 'food_7', teochewRomanized: '', teochewChinese: '水果', cantoneseRomanized: '', cantoneseChinese: '水果', mandarinRomanized: 'shuǐ guǒ', mandarinChinese: '水果', english: 'Fruits', emoji: '🍉'),
      Flashcard(id: 'food_8', teochewRomanized: '', teochewChinese: '不要', cantoneseRomanized: '', cantoneseChinese: '唔要', mandarinRomanized: 'bù yào', mandarinChinese: '不要', english: "Don't want", emoji: '🙅'),
      Flashcard(id: 'food_9', teochewRomanized: '', teochewChinese: '多少', cantoneseRomanized: '', cantoneseChinese: '幾多', mandarinRomanized: 'duō shǎo', mandarinChinese: '多少', english: 'How much?', emoji: '💰'),
      Flashcard(id: 'food_10', teochewRomanized: '', teochewChinese: '枸杞', cantoneseRomanized: '', cantoneseChinese: '枸杞', mandarinRomanized: 'gǒu qǐ', mandarinChinese: '枸杞', english: 'Goji berry', emoji: '🔴'),
    ],
  ),
  VocabFlow(
    id: 'daily',
    title: 'Daily Life',
    emoji: '🏠',
    colorValue: 0xFF6CACE4,
    cards: [
      Flashcard(id: 'daily_1', teochewRomanized: '', teochewChinese: '快点', cantoneseRomanized: '', cantoneseChinese: '快啲', mandarinRomanized: 'kuài diǎn', mandarinChinese: '快点', english: 'Hurry up', emoji: '🏃'),
      Flashcard(id: 'daily_2', teochewRomanized: '', teochewChinese: '可不可以', cantoneseRomanized: '', cantoneseChinese: '可唔可以', mandarinRomanized: 'kě bù kě yǐ', mandarinChinese: '可不可以', english: 'Can or not?', emoji: '🤔'),
      Flashcard(id: 'daily_3', teochewRomanized: '', teochewChinese: '什么时候', cantoneseRomanized: '', cantoneseChinese: '幾時', mandarinRomanized: 'shén me shí hòu', mandarinChinese: '什么时候', english: 'When?', emoji: '📅'),
      Flashcard(id: 'daily_4', teochewRomanized: '', teochewChinese: '这里那里哪里', cantoneseRomanized: '', cantoneseChinese: '呢度嗰度邊度', mandarinRomanized: 'zhè lǐ nà lǐ nǎ lǐ', mandarinChinese: '这里那里哪里', english: 'Here, there, where', emoji: '📍'),
      Flashcard(id: 'daily_5', teochewRomanized: '', teochewChinese: '带手机', cantoneseRomanized: '', cantoneseChinese: '帶手機', mandarinRomanized: 'dài shǒu jī', mandarinChinese: '带手机', english: 'Bring phone', emoji: '📱'),
      Flashcard(id: 'daily_6', teochewRomanized: '', teochewChinese: '衣服', cantoneseRomanized: '', cantoneseChinese: '衫', mandarinRomanized: 'yī fú', mandarinChinese: '衣服', english: 'Clothes', emoji: '👕'),
      Flashcard(id: 'daily_7', teochewRomanized: '', teochewChinese: '天气好热', cantoneseRomanized: '', cantoneseChinese: '天氣好熱', mandarinRomanized: 'tiān qì hǎo rè', mandarinChinese: '天气好热', english: 'So hot today', emoji: '🥵'),
      Flashcard(id: 'daily_8', teochewRomanized: '', teochewChinese: '今天不用上班', cantoneseRomanized: '', cantoneseChinese: '今日唔使返工', mandarinRomanized: 'jīn tiān bù yòng shàng bān', mandarinChinese: '今天不用上班', english: 'No work today', emoji: '🏖️'),
      Flashcard(id: 'daily_9', teochewRomanized: '', teochewChinese: '我会听不会讲', cantoneseRomanized: '', cantoneseChinese: '我識聽唔識講', mandarinRomanized: 'wǒ huì tīng bù huì jiǎng', mandarinChinese: '我会听不会讲', english: "I can hear but can't speak", emoji: '👂'),
      Flashcard(id: 'daily_10', teochewRomanized: '', teochewChinese: '没空', cantoneseRomanized: '', cantoneseChinese: '冇空', mandarinRomanized: 'méi kòng', mandarinChinese: '没空', english: 'No time', emoji: '⏰'),
    ],
  ),
];

VocabFlow? getFlowById(String id) {
  for (final f in allFlows) {
    if (f.id == id) return f;
  }
  return null;
}
