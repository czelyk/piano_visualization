import 'package:flutter/material.dart';

class NoteDisplay extends StatelessWidget {
  final String note;
  final bool isActive;
  final int velocity;

  const NoteDisplay({
    super.key,
    required this.note,
    required this.isActive,
    required this.velocity,
  });

  /// Nota ismine göre renk döndürür (her nota farklı renk)
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
        return Colors.white70;
    }
  }

  @override
  Widget build(BuildContext context) {
    final noteColor = _getNoteColor(note);
    final velocityPercent = (velocity / 127).clamp(0.0, 1.0);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Bağlantı durumu göstergesi
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive ? const Color(0xFF00E676) : Colors.grey.shade700,
              boxShadow: isActive
                  ? [
                      BoxShadow(
                        color: const Color(0xFF00E676).withOpacity(0.6),
                        blurRadius: 12,
                        spreadRadius: 2,
                      )
                    ]
                  : [],
            ),
          ),

          // Nota ismi — büyük animasyonlu gösterim
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: TextStyle(
              fontSize: isActive ? 96 : 64,
              fontWeight: FontWeight.w800,
              color: isActive ? noteColor : Colors.grey.shade700,
              shadows: isActive
                  ? [
                      Shadow(
                        color: noteColor.withOpacity(0.5),
                        blurRadius: 40,
                      ),
                      Shadow(
                        color: noteColor.withOpacity(0.3),
                        blurRadius: 80,
                      ),
                    ]
                  : [],
              letterSpacing: 4,
            ),
            child: Text(note == '-' ? '♪' : note),
          ),

          const SizedBox(height: 16),

          // Durum etiketi
          AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: isActive ? 1.0 : 0.4,
            child: Text(
              isActive ? 'ŞİMDİ ÇALIYOR' : 'BEKLENİYOR',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isActive ? noteColor.withOpacity(0.8) : Colors.grey.shade600,
                letterSpacing: 6,
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Velocity bar
          if (isActive) ...[
            Text(
              'ŞİDDET',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade500,
                letterSpacing: 4,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: 200,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 6,
                  child: LinearProgressIndicator(
                    value: velocityPercent,
                    backgroundColor: Colors.grey.shade800,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      noteColor.withOpacity(0.8),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '$velocity',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
