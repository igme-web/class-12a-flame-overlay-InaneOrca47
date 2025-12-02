import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flame/game.dart';

class GameProvider extends ChangeNotifier {
  // Private variables for settings
  double _musicVolume = 1.0;
  double _sfxVolume = 1.0;
  int _score = 0;
  int _lastScore = 0;
  bool _inGame = false;
  FlameGame? _game;

  // Audio players
  AudioPlayer musicPlayer = AudioPlayer();
  AudioPlayer sfxPlayer = AudioPlayer();

  final AudioContext audioContext = AudioContextConfig(
    focus: AudioContextConfigFocus.mixWithOthers,
  ).build();

  // Getters to access private variables
  double get musicVolume => _musicVolume;
  double get sfxVolume => _sfxVolume;
  int get score => _score;
  int get lastScore => _lastScore;
  bool get inGame => _inGame;
  FlameGame? get game => _game;

  // Setters with notifyListeners
  void setMusicVolume(double value) {
    _musicVolume = value;
    musicPlayer.setVolume(_musicVolume); // Apply volume to player
    notifyListeners();
  }

  void setSfxVolume(double value) {
    _sfxVolume = value;
    sfxPlayer.setVolume(_sfxVolume); // Apply volume to player
    notifyListeners();
  }

  void incrementScore(int value) {
    _score += value;
    notifyListeners();
  }

  void setLastScore(int value) {
    _lastScore = value;
    notifyListeners();
  }

  set game(FlameGame? value) {
  _game = value;
  // NO notifyListeners() here!
}

  Future<void> playBgm(String url) async {
    // Set audio context to allow mixing
    musicPlayer.setAudioContext(audioContext);

    // Set to loop when finished
    musicPlayer.setReleaseMode(ReleaseMode.loop);

    await musicPlayer.play(AssetSource(url));
  }

  // Play sound effect
  Future<void> playSfx(String url) async {
    await sfxPlayer.play(AssetSource(url));
  }

  @override
  void dispose() {
    musicPlayer.dispose();
    sfxPlayer.dispose();
    super.dispose();
  }
}
