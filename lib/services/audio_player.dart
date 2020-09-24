import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class AudioPlayerService {
  AudioCache cache = AudioCache(prefix: 'assets/sounds/');
  AudioPlayer player = AudioPlayer(playerId: 'FTT');

  void loadAllSounds() async {
    try {
      await cache.loadAll([
        'answer_incorrect.mp3',
        'location_discovered.mp3',
        'location_not_discovered.mp3',
        'answer_correct.mp3',
        'intro.ogg',
        'quest_purchased.mp3'
      ]);
    } catch (e) {
      print(e.toString());
    }
  }

  void playSound({@required String path, bool loop = false}) async {
    try {
      player = loop
          ? await cache.loop(path, mode: PlayerMode.MEDIA_PLAYER)
          : await cache.play(path, mode: PlayerMode.LOW_LATENCY);
    } catch (e) {
      print(e.toString());
    }
  }

  void stopSound() async {
    try {
      await player?.stop();
    } catch (e) {
      print(e.toString());
    }
  }

  void disposePlayer() async {
    try {
      await player.dispose();
    } catch (e) {
      print(e.toString());
    }
  }
}
