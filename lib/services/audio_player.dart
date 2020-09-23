import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class AudioPlayerService {
  AudioCache cache = AudioCache(prefix: 'assets/sounds/');
  AudioPlayer player = AudioPlayer(playerId: 'FTT', mode: PlayerMode.LOW_LATENCY);

  
  void loadAllSounds() async {
    await cache.loadAll([
      'coin.mp3',
      'purchaseQuest.mp3',
      'answerIncorrect.mp3',
      'diamondsIncrease.mp3',
      'intro.mp3'
    ]);
  }

  void playSound({@required String path, bool loop = false}) async {
    player = loop ? await cache.loop(path) : await cache.play(path);
  }

  void stopSound() async {
    await player?.stop();
  }

  void disposePlayer() async {
    print('dispose audio player');
    await player.dispose();
  }
}
