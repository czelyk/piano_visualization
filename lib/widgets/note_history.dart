import 'package:flutter/material.dart';

class NoteHistory extends StatelessWidget {
  final List<String> history;

  const NoteHistory({
    super.key,
    required this.history,
  });

  Color _getNoteColor(String noteName) {
    final base = noteName.replaceAll(RegExp(r'[#b\d-]'), '').toUpperCase();
    switch (base) {
      case 'C':
        return const Color(0xFFFF6B6B);
      case 'D':
        return const Color(0xFFFFAB76);
      case 'E':
        return const Color(0xFFFFD93D);
      case 'F':
        return const Color(0xFF6BCB77);
      case 'G':
        return const Color(0xFF4D96FF);
      case 'A':
        return const Color(0xFF9B59B6);
      case 'B':
        return const Color(0xFFFF6BAE);
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (history.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(24.0),
        child: Text(
          'Henüz nota basılmadı...',
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 14,
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Row(
            children: [
              Icon(Icons.history, color: Colors.grey.shade500, size: 16),
              const SizedBox(width: 8),
              Text(
                'SON NOTALAR',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade500,
                  letterSpacing: 4,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            reverse: true,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: history.length,
            itemBuilder: (context, index) {
              final note = history[history.length - 1 - index];
              final opacity = 1.0 - (index * 0.08).clamp(0.0, 0.7);
              final color = _getNoteColor(note);

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: opacity,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: color.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        note,
                        style: TextStyle(
                          color: color,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
