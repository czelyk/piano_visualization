import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import '../models/note_model.dart';

class FirebaseService {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  /// Firebase Realtime Database'deki "notes" düğümünü dinler
  /// Görseldeki yapı: { A: 0/1, B: 0/1, ... }
  Stream<Map<String, int>> listenToNotes() {
    return _dbRef.child('notes').onValue.map((event) {
      final data = event.snapshot.value;
      if (data != null && data is Map) {
        return Map<String, int>.from(data);
      }
      return {};
    });
  }

  /// Bağlantı durumunu kontrol eder
  Stream<bool> listenToConnection() {
    return _dbRef
        .child('.info/connected')
        .onValue
        .map((event) => event.snapshot.value == true);
  }

  /// Test amaçlı: Manuel nota durumu gönder
  Future<void> sendTestNote(String note, int value) async {
    await _dbRef.child('notes').update({
      note: value,
    });
  }
}
