import 'dart:async';
import 'package:flutter/material.dart';
import '../models/note_model.dart';
import '../services/firebase_service.dart';
import '../widgets/note_display.dart';
import '../widgets/piano_keyboard.dart';
import '../widgets/note_history.dart';

class PianoScreen extends StatefulWidget {
  const PianoScreen({super.key});

  @override
  State<PianoScreen> createState() => _PianoScreenState();
}

class _PianoScreenState extends State<PianoScreen> with TickerProviderStateMixin {
  final FirebaseService _firebaseService = FirebaseService();
  StreamSubscription? _noteSubscription;
  StreamSubscription? _connectionSubscription;

  String _currentNote = '-';
  int _currentVelocity = 0;
  bool _isActive = false;
  bool _isConnected = false;
  final List<String> _noteHistory = [];
  final List<String> _activeNotes = [];

  // Firebase anahtarlarını piyano notalarına eşle
  final Map<String, String> _fbToNote = {
    'A': 'A4',
    'B': 'B4',
    'C': 'C4',
    'C2': 'C5',
    'D': 'D4',
    'E': 'E4',
    'F': 'F4',
    'G': 'G4',
  };

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    // Arka plan pulse animasyonu
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _startListening();
  }

  void _startListening() {
    // Nota stream'ini dinle
    _noteSubscription = _firebaseService.listenToNotes().listen(
      (notesState) {
        setState(() {
          _activeNotes.clear();
          String lastActivated = '-';
          
          notesState.forEach((key, value) {
            if (value == 1) {
              final mappedNote = _fbToNote[key] ?? key;
              _activeNotes.add(mappedNote);
              lastActivated = mappedNote;
            }
          });

          _isActive = _activeNotes.isNotEmpty;
          
          if (_isActive) {
            _currentNote = lastActivated;
            _currentVelocity = 127; // Görselde şiddet yok, aktifse full gösteriyoruz

            // Eğer yeni bir nota ise geçmişe ekle (basit kontrol)
            if (!_noteHistory.contains(_currentNote) || _noteHistory.last != _currentNote) {
              _noteHistory.add(_currentNote);
              if (_noteHistory.length > 50) {
                _noteHistory.removeAt(0);
              }
            }
          }
        });
      },
      onError: (e) {
        print('Firebase yayın hatası: $e');
      },
    );

    // Bağlantı durumunu dinle
    _connectionSubscription = _firebaseService.listenToConnection().listen(
      (connected) {
        setState(() {
          _isConnected = connected;
        });
      },
    );
  }

  @override
  void dispose() {
    _noteSubscription?.cancel();
    _connectionSubscription?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0F),
      body: SafeArea(
        child: Column(
          children: [
            // Üst bar — başlık ve bağlantı durumu
            _buildTopBar(),

            // Ana nota gösterimi
            Expanded(
              flex: 3,
              child: Center(
                child: AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Container(
                      decoration: _isActive
                          ? BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: _getNoteColor(_currentNote)
                                      .withOpacity(0.05 * _pulseAnimation.value),
                                  blurRadius: 120,
                                  spreadRadius: 60,
                                ),
                              ],
                            )
                          : null,
                      child: child,
                    );
                  },
                  child: NoteDisplay(
                    note: _currentNote,
                    isActive: _isActive,
                    velocity: _currentVelocity,
                  ),
                ),
              ),
            ),

            // Piyano klavyesi
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: PianoKeyboard(
                activeNotes: _activeNotes,
                isActive: _isActive,
              ),
            ),

            const SizedBox(height: 16),

            // Nota geçmişi
            NoteHistory(history: _noteHistory),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          // Logo / Başlık
          Row(
            children: [
              Icon(
                Icons.piano,
                color: Colors.white.withOpacity(0.9),
                size: 22,
              ),
              const SizedBox(width: 10),
              Text(
                'PİYANO',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Colors.white.withOpacity(0.9),
                  letterSpacing: 6,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                'CANLI',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  color: Colors.white.withOpacity(0.5),
                  letterSpacing: 6,
                ),
              ),
            ],
          ),

          const Spacer(),

          // Bağlantı durumu
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _isConnected
                  ? const Color(0xFF00E676).withOpacity(0.1)
                  : Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _isConnected
                    ? const Color(0xFF00E676).withOpacity(0.3)
                    : Colors.red.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _isConnected
                        ? const Color(0xFF00E676)
                        : Colors.red,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  _isConnected ? 'CANLI' : 'BAĞLI DEĞİL',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: _isConnected
                        ? const Color(0xFF00E676)
                        : Colors.red,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

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
}
