import 'package:audioplayers/audioplayers.dart';

class SoundService {
  SoundService._();
  static final SoundService instance = SoundService._();

  bool _enabled = true;
  AudioPlayer? _player;

  bool get enabled => _enabled;

  void setEnabled(bool value) {
    _enabled = value;
  }

  Future<void> _play(String assetName, {double volume = 0.65}) async {
    if (!_enabled) return;
    try {
      _player ??= AudioPlayer();
      await _player!.stop();
      await _player!.play(
        AssetSource('sounds/$assetName'),
        volume: volume,
      );
    } catch (_) {
      // Gracefully ignore audio errors in headless/test environments
    }
  }

  Future<void> playTap() => _play('tap.wav', volume: 0.45);
  Future<void> playCorrect() => _play('correct.wav', volume: 0.65);
  Future<void> playWrong() => _play('wrong.wav', volume: 0.65);
  Future<void> playUnlock() => _play('unlock.wav', volume: 0.75);
  Future<void> playCaseSolved() => _play('case_solved.wav', volume: 0.85);
}
