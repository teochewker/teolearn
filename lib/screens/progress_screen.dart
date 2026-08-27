import 'package:flutter/material.dart';
import '../services/progress_service.dart';
import '../models/progress.dart';

/// Progress screen — shows overall and per-flow progress from sqflite.
class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  List<FlowProgress> _flowProgress = [];
  OverallProgress? _overall;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final flowProgress = await ProgressService.getAllFlowProgress();
    final overall = await ProgressService.getOverallProgress();
    if (mounted) {
      setState(() {
        _flowProgress = flowProgress;
        _overall = overall;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Progress',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        backgroundColor: const Color(0xFF6C5CEC),
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFF0F0FF),
                    Colors.white,
                  ],
                ),
              ),
              child: _overall == null || _overall!.flowsCompleted == 0
                  ? _emptyState()
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Overall stats card
                          _overallCard(),
                          const SizedBox(height: 24),
                          // Per-flow progress
                          const Text(
                            'Flow Progress',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ..._flowProgress.map((p) => _flowCard(p)),
                        ],
                      ),
                    ),
            ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🏆', style: TextStyle(fontSize: 80)),
          const SizedBox(height: 16),
          const Text(
            'No progress yet!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Color(0xFF6C5CEC),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Complete a flow to see your progress here.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _overallCard() {
    final o = _overall!;
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: const LinearGradient(
            colors: [
              Color(0xFF6C5CEC),
              Color(0xFF8E7BFF),
            ],
          ),
        ),
        child: Column(
          children: [
            const Text(
              '🏆 Overall Progress',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _bigStat('Flows', '${o.flowsCompleted}'),
                _bigStat('Phrases', '${o.totalPhrasesLearned}'),
                _bigStat('Avg', '${(o.averageAccuracy * 100).round()}%'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _bigStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white.withValues(alpha: 0.8),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _flowCard(FlowProgress p) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  p.flowTitle,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Row(
                  children: List.generate(3, (i) {
                    return Icon(
                      i < p.stars ? Icons.star : Icons.star_border,
                      size: 24,
                      color: i < p.stars
                          ? const Color(0xFFFFD700)
                          : Colors.grey.shade300,
                    );
                  }),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _miniStat('Best', '${p.bestScore}/${p.totalCards}'),
                const SizedBox(width: 16),
                _miniStat('Times', '${p.timesCompleted}'),
                const SizedBox(width: 16),
                _miniStat('Accuracy', '${(p.accuracy * 100).round()}%'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _miniStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade500,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
