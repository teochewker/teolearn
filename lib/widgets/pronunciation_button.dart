import 'package:flutter/material.dart';

/// Pronunciation button — shows a language label; tap to speak.
class PronunciationButton extends StatelessWidget {
  final String label;
  final String romanized;
  final String chinese;
  final String languageKey;
  final Color color;
  final VoidCallback onTap;

  const PronunciationButton({
    super.key,
    required this.label,
    required this.romanized,
    required this.chinese,
    required this.languageKey,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasChinese = chinese.isNotEmpty;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withValues(alpha: 0.4), width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.volume_up, color: color, size: 22),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: color.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                romanized,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              if (hasChinese) ...[
                const SizedBox(height: 4),
                Text(
                  chinese,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
