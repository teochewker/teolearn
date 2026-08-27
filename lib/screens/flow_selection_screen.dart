import 'package:flutter/material.dart';
import '../data/vocab_data.dart';
import '../models/flow.dart';
import 'flashcard_screen.dart';

/// VocabFlow selection screen — pick a vocabulary flow to start.
class VocabFlowSelectionScreen extends StatelessWidget {
  const VocabFlowSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pick a Flow',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        backgroundColor: const Color(0xFFE17076),
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFF5E6),
              Color(0xFFFFE0B2),
            ],
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(24),
          itemCount: allVocabFlows.length,
          itemBuilder: (context, index) {
            final flow = allVocabFlows[index];
            return _VocabFlowCard(flow: flow);
          },
        ),
      ),
    );
  }
}

class _VocabFlowCard extends StatelessWidget {
  final VocabFlow flow;
  const _VocabFlowCard({required this.flow});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => FlashcardScreen(flow: flow),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [
                flow.color,
                flow.color.withValues(alpha: 0.7),
              ],
            ),
          ),
          child: Row(
            children: [
              Text(
                flow.emoji,
                style: const TextStyle(fontSize: 48),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      flow.title,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${flow.totalCards} phrases',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withValues(alpha: 0.85),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
                size: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
