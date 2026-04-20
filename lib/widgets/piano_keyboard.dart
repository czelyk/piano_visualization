import 'package:flutter/material.dart';

/// Tek bir piyano tuşu bilgisi
class _PianoKey {
  final String note;
  final bool isBlack;
  final int midiNumber;

  _PianoKey({required this.note, required this.isBlack, required this.midiNumber});
}

class PianoKeyboard extends StatelessWidget {
  final List<String> activeNotes;
  final bool isActive;

  const PianoKeyboard({
    super.key,
    required this.activeNotes,
    required this.isActive,
  });

  /// 2 oktavlık (C3-B4) piyano tuşlarını oluşturur
  List<_PianoKey> _buildKeys() {
    final noteNames = ['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B'];
    final keys = <_PianoKey>[];

    for (int octave = 3; octave <= 5; octave++) {
      for (int i = 0; i < noteNames.length; i++) {
        final noteName = noteNames[i];
        final isBlack = noteName.contains('#');
        keys.add(_PianoKey(
          note: '$noteName$octave',
          isBlack: isBlack,
          midiNumber: (octave + 1) * 12 + i,
        ));
      }
    }
    return keys;
  }

  /// Nota ismine göre renk döndürür
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
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    final keys = _buildKeys();
    final whiteKeys = keys.where((k) => !k.isBlack).toList();
    final blackKeys = keys.where((k) => k.isBlack).toList();

    return Container(
      height: 140,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final whiteKeyWidth = constraints.maxWidth / whiteKeys.length;
          final blackKeyWidth = whiteKeyWidth * 0.6;

          return Stack(
            children: [
              // Beyaz tuşlar
              Row(
                children: whiteKeys.map((key) {
                  final isPressed = isActive &&
                      activeNotes.any((n) => n.toUpperCase() == key.note.toUpperCase());

                  return Expanded(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 100),
                      margin: const EdgeInsets.symmetric(horizontal: 0.5),
                      decoration: BoxDecoration(
                        color: isPressed
                            ? _getNoteColor(key.note)
                            : const Color(0xFFF0F0F0),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(6),
                          bottomRight: Radius.circular(6),
                        ),
                        border: Border.all(
                          color: Colors.grey.shade400,
                          width: 0.5,
                        ),
                        boxShadow: isPressed
                            ? [
                                BoxShadow(
                                  color: _getNoteColor(key.note).withOpacity(0.6),
                                  blurRadius: 16,
                                  spreadRadius: 2,
                                ),
                              ]
                            : [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  blurRadius: 2,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                      ),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Text(
                            key.note,
                            style: TextStyle(
                              fontSize: 7,
                              fontWeight: FontWeight.w600,
                              color: isPressed
                                  ? Colors.white
                                  : Colors.grey.shade500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              // Siyah tuşlar
              ...blackKeys.map((key) {
                final isPressed = isActive &&
                    activeNotes.any((n) => n.toUpperCase() == key.note.toUpperCase());

                // Siyah tuşun beyaz tuşlar arasındaki pozisyonunu hesapla
                final noteIndex = keys.indexOf(key);
                // Öncesindeki beyaz tuş sayısı
                int whiteKeysBefore = keys
                    .sublist(0, noteIndex)
                    .where((k) => !k.isBlack)
                    .length;

                final leftPosition =
                    (whiteKeysBefore * whiteKeyWidth) - (blackKeyWidth / 2);

                return Positioned(
                  left: leftPosition,
                  top: 0,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    width: blackKeyWidth,
                    height: 85,
                    decoration: BoxDecoration(
                      color: isPressed
                          ? _getNoteColor(key.note)
                          : const Color(0xFF1A1A2E),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(4),
                        bottomRight: Radius.circular(4),
                      ),
                      boxShadow: isPressed
                          ? [
                              BoxShadow(
                                color: _getNoteColor(key.note).withOpacity(0.6),
                                blurRadius: 16,
                                spreadRadius: 2,
                              ),
                            ]
                          : [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.4),
                                blurRadius: 3,
                                offset: const Offset(0, 3),
                              ),
                            ],
                    ),
                  ),
                );
              }).toList(),
            ],
          );
        },
      ),
    );
  }
}
