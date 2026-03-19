import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AudioService extends ChangeNotifier {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  
  AudioService._internal() {
    _initAudio();
    _loadMusicPreference();
  }

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isMusicEnabled = true;
  bool _isPlaying = false;

  bool get isMusicEnabled => _isMusicEnabled;
  bool get isPlaying => _isPlaying;

  Future<void> _initAudio() async {
    // Configurar el player para reproducir en loop
    await _audioPlayer.setReleaseMode(ReleaseMode.loop);
    
    // Configurar volumen máximo
    await _audioPlayer.setVolume(1.0);
    
    // Escuchar cambios de estado
    _audioPlayer.onPlayerStateChanged.listen((state) {
      _isPlaying = state == PlayerState.playing;
      notifyListeners();
    });
  }

  Future<void> _loadMusicPreference() async {
    final prefs = await SharedPreferences.getInstance();
    _isMusicEnabled = prefs.getBool('music_enabled') ?? true;
    notifyListeners();
  }

  Future<void> _saveMusicPreference() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('music_enabled', _isMusicEnabled);
  }

  Future<void> playBackgroundMusic() async {
    if (!_isMusicEnabled || _isPlaying) return;
    
    try {
      debugPrint('Iniciando música de fondo...');
      await _audioPlayer.play(AssetSource('audio/MusicaFondo.mp3'));
      debugPrint('Música iniciada correctamente');
    } catch (e) {
      debugPrint('Error al reproducir música: $e');
    }
  }

  Future<void> pauseMusic() async {
    await _audioPlayer.pause();
  }

  Future<void> resumeMusic() async {
    if (_isMusicEnabled && !_isPlaying) {
      await _audioPlayer.resume();
    }
  }

  Future<void> stopMusic() async {
    await _audioPlayer.stop();
  }

  Future<void> setMusicEnabled(bool enabled) async {
    _isMusicEnabled = enabled;
    await _saveMusicPreference();
    
    if (enabled) {
      await playBackgroundMusic();
    } else {
      await stopMusic();
    }
    
    notifyListeners();
  }

  Future<void> toggleMusic() async {
    await setMusicEnabled(!_isMusicEnabled);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}