class NoteModel {
  final String note;
  final int velocity;
  final int timestamp;
  final bool active;

  NoteModel({
    required this.note,
    required this.velocity,
    required this.timestamp,
    required this.active,
  });

  /// Firebase Realtime Database'den gelen Map'i NoteModel'e çevirir
  factory NoteModel.fromMap(Map<dynamic, dynamic> map) {
    return NoteModel(
      note: (map['note'] ?? 'C4').toString(),
      velocity: (map['velocity'] ?? 0) is int
          ? map['velocity']
          : int.tryParse(map['velocity'].toString()) ?? 0,
      timestamp: (map['timestamp'] ?? 0) is int
          ? map['timestamp']
          : int.tryParse(map['timestamp'].toString()) ?? 0,
      active: map['active'] == true || map['active'] == 1,
    );
  }

  /// Nota isminden oktav numarasını çıkarır (örn. "C4" → 4)
  int get octave {
    final match = RegExp(r'(-?\d+)$').firstMatch(note);
    return match != null ? int.parse(match.group(1)!) : 4;
  }

  /// Nota isminden sadece nota harfini çıkarır (örn. "C#4" → "C#")
  String get noteName {
    return note.replaceAll(RegExp(r'-?\d+$'), '');
  }

  /// Bu nota bir siyah tuş mu?
  bool get isBlackKey {
    final name = noteName.toUpperCase();
    return name.contains('#') || name.contains('B') && name.length > 1;
  }

  @override
  String toString() => 'NoteModel(note: $note, velocity: $velocity, active: $active)';
}
