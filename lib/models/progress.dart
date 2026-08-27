/// Progress model — tracks per-flow and overall learning progress.
class FlowProgress {
  final String flowId;
  final String flowTitle;
  final int bestScore;
  final int totalCards;
  final int timesCompleted;
  final DateTime lastCompleted;

  FlowProgress({
    required this.flowId,
    required this.flowTitle,
    required this.bestScore,
    required this.totalCards,
    required this.timesCompleted,
    required this.lastCompleted,
  });

  double get accuracy => totalCards > 0 ? bestScore / totalCards : 0.0;
  int get stars {
    final pct = accuracy;
    if (pct >= 0.9) return 3;
    if (pct >= 0.7) return 2;
    if (pct >= 0.5) return 1;
    return 0;
  }

  Map<String, dynamic> toMap() {
    return {
      'flowId': flowId,
      'flowTitle': flowTitle,
      'bestScore': bestScore,
      'totalCards': totalCards,
      'timesCompleted': timesCompleted,
      'lastCompleted': lastCompleted.toIso8601String(),
    };
  }

  factory FlowProgress.fromMap(Map<String, dynamic> map) {
    return FlowProgress(
      flowId: map['flowId'] as String,
      flowTitle: map['flowTitle'] as String,
      bestScore: map['bestScore'] as int,
      totalCards: map['totalCards'] as int,
      timesCompleted: map['timesCompleted'] as int,
      lastCompleted: DateTime.parse(map['lastCompleted'] as String),
    );
  }
}

/// Overall stats across all flows.
class OverallProgress {
  final int flowsCompleted;
  final int totalPhrasesLearned;
  final double averageAccuracy;

  OverallProgress({
    required this.flowsCompleted,
    required this.totalPhrasesLearned,
    required this.averageAccuracy,
  });
}
