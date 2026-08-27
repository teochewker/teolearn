import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import '../models/progress.dart';

/// Progress service — sqflite-backed local storage for flow progress.
class ProgressService {
  static Database? _db;
  static const String _dbName = 'teolearn.db';
  static const int _dbVersion = 1;

  static Future<Database> _getDatabase() async {
    if (_db != null) return _db!;
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, _dbName);
    _db = await openDatabase(
      path,
      version: _dbVersion,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE flow_progress (
            flowId TEXT PRIMARY KEY,
            flowTitle TEXT NOT NULL,
            bestScore INTEGER NOT NULL,
            totalCards INTEGER NOT NULL,
            timesCompleted INTEGER NOT NULL DEFAULT 1,
            lastCompleted TEXT NOT NULL
          )
        ''');
        await db.execute('''
          CREATE TABLE phrase_learned (
            phraseId TEXT PRIMARY KEY,
            flowId TEXT NOT NULL,
            learnedAt TEXT NOT NULL
          )
        ''');
      },
    );
    return _db!;
  }

  /// Record a completed flow. Updates best score if improved.
  static Future<void> recordFlowCompletion({
    required String flowId,
    required String flowTitle,
    required int score,
    required int totalCards,
  }) async {
    final db = await _getDatabase();
    final now = DateTime.now().toIso8601String();

    final existing = await db.query(
      'flow_progress',
      where: 'flowId = ?',
      whereArgs: [flowId],
    );

    if (existing.isEmpty) {
      await db.insert('flow_progress', {
        'flowId': flowId,
        'flowTitle': flowTitle,
        'bestScore': score,
        'totalCards': totalCards,
        'timesCompleted': 1,
        'lastCompleted': now,
      });
    } else {
      final row = existing.first;
      final bestScore = row['bestScore'] as int;
      final newBest = score > bestScore ? score : bestScore;
      final timesCompleted = (row['timesCompleted'] as int) + 1;
      await db.update(
        'flow_progress',
        {
          'bestScore': newBest,
          'timesCompleted': timesCompleted,
          'lastCompleted': now,
        },
        where: 'flowId = ?',
        whereArgs: [flowId],
      );
    }
  }

  /// Record a learned phrase (got it = swiped right).
  static Future<void> recordPhraseLearned({
    required String phraseId,
    required String flowId,
  }) async {
    final db = await _getDatabase();
    final now = DateTime.now().toIso8601String();
    await db.insert(
      'phrase_learned',
      {
        'phraseId': phraseId,
        'flowId': flowId,
        'learnedAt': now,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Get progress for a specific flow.
  static Future<FlowProgress?> getFlowProgress(String flowId) async {
    final db = await _getDatabase();
    final results = await db.query(
      'flow_progress',
      where: 'flowId = ?',
      whereArgs: [flowId],
    );
    if (results.isEmpty) return null;
    return FlowProgress.fromMap(results.first);
  }

  /// Get all flow progress entries.
  static Future<List<FlowProgress>> getAllFlowProgress() async {
    final db = await _getDatabase();
    final results = await db.query('flow_progress', orderBy: 'lastCompleted DESC');
    return results.map(FlowProgress.fromMap).toList();
  }

  /// Get overall statistics.
  static Future<OverallProgress> getOverallProgress() async {
    final db = await _getDatabase();
    final flowResults = await db.query('flow_progress');
    int flowsCompleted = flowResults.length;
    int bestScoreSum = 0;
    int totalCardsSum = 0;
    for (final r in flowResults) {
      bestScoreSum += (r['bestScore'] as int);
      totalCardsSum += (r['totalCards'] as int);
    }
    final phraseResults = await db.query('phrase_learned');
    int totalPhrasesLearned = phraseResults.length;
    // Count distinct phrase IDs
    final distinctIds = <String>{};
    for (final r in phraseResults) {
      distinctIds.add(r['phraseId'] as String);
    }
    totalPhrasesLearned = distinctIds.length;

    double averageAccuracy = 0.0;
    if (totalCardsSum > 0) {
      averageAccuracy = bestScoreSum / totalCardsSum;
    }

    return OverallProgress(
      flowsCompleted: flowsCompleted,
      totalPhrasesLearned: totalPhrasesLearned,
      averageAccuracy: averageAccuracy,
    );
  }

  /// Get total distinct phrases learned count.
  static Future<int> getTotalPhrasesLearned() async {
    final db = await _getDatabase();
    final results = await db.rawQuery(
      'SELECT COUNT(DISTINCT phraseId) as count FROM phrase_learned',
    );
    if (results.isEmpty) return 0;
    return results.first['count'] as int? ?? 0;
  }
}
