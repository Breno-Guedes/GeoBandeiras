import 'package:audioplayers/audioplayers.dart';

class AudioService {
  // Instância do player
  final AudioPlayer _audioPlayer = AudioPlayer();
  static final AudioContext _mixingAudioContext = AudioContextConfig(
    focus: AudioContextConfigFocus.mixWithOthers,
  ).build();

  // Tocar som de resposta correta
  Future<void> playCorrectSound() async {
    try {
      await _audioPlayer.setAudioContext(_mixingAudioContext);
      await _audioPlayer.play(AssetSource('audio/correto.mp3'));
    } catch (e) {
      print("Erro ao reproduzir áudio: $e");
    }
  }

  // Tocar som de resposta incorreta
  Future<void> playWrongSound() async {
    try {
      await _audioPlayer.setAudioContext(_mixingAudioContext);
      await _audioPlayer.play(AssetSource('audio/errado.mp3'));
    } catch (e) {
      print("Erro ao reproduzir áudio: $e");
    }
  }
}
