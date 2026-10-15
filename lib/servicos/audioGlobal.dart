import 'package:audioplayers/audioplayers.dart';

class AudioGlobal {
  static final AudioGlobal _instance = AudioGlobal._internal();
  factory AudioGlobal() => _instance;
  AudioGlobal._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  double _volume = 0.5;

  double get volume => _volume;

  Future<void> setVolume(double volume) async {
    _volume = volume.clamp(0.0, 1.0).toDouble();
    await _audioPlayer.setVolume(_volume);
  }

  Future<void> playBackgroundMusic(String filePath) async {
    if (_isPlaying) return;

    try {
      await _audioPlayer.setReleaseMode(ReleaseMode.loop);
      await _audioPlayer.setVolume(_volume);
      await _audioPlayer.play(AssetSource(filePath));
      _isPlaying = true;
    } catch (e) {
      _isPlaying = false;
      print('Erro ao reproduzir música global: $e');
    }
  }

  Future<void> stopMusic() async {
    await _audioPlayer.stop();
    _isPlaying = false;
  }
}
