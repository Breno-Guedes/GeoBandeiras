import 'package:audioplayers/audioplayers.dart';

class AudioGlobal {
  static final AudioGlobal _instance = AudioGlobal._internal();
  static final AudioContext _mixingAudioContext = AudioContextConfig(
    focus: AudioContextConfigFocus.mixWithOthers,
  ).build();

  factory AudioGlobal() => _instance;
  AudioGlobal._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  bool _pausedForLifecycle = false;
  bool _inGame = false;
  double _volume = 0.5;
  static const double _gameVolumeFactor = 0.6;

  double get volume => _volume;

  Future<void> setVolume(double volume) async {
    _volume = volume.clamp(0.0, 1.0).toDouble();
    await _aplicarVolume();
  }

  Future<void> setInGame(bool inGame) async {
    _inGame = inGame;
    await _aplicarVolume();
  }

  Future<void> _aplicarVolume() async {
    final volumeEfetivo = _inGame ? _volume * _gameVolumeFactor : _volume;
    await _audioPlayer.setVolume(volumeEfetivo);
  }

  Future<void> playBackgroundMusic(String filePath) async {
    if (_isPlaying) return;

    try {
      await _audioPlayer.setAudioContext(_mixingAudioContext);
      await _audioPlayer.setReleaseMode(ReleaseMode.loop);
      await _aplicarVolume();
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
    _pausedForLifecycle = false;
  }

  Future<void> pauseMusic() async {
    if (!_isPlaying || _pausedForLifecycle) return;
    _pausedForLifecycle = true;
    await _audioPlayer.pause();
  }

  Future<void> resumeMusic() async {
    if (!_isPlaying || !_pausedForLifecycle) return;
    _pausedForLifecycle = false;
    await _aplicarVolume();
    await _audioPlayer.resume();
  }
}
