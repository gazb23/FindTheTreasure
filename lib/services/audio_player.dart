import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';

class AudioPlayer {
 
 final player = AudioCache(prefix: 'assets/sounds/');
  void loadAllSounds() {
    player.loadAll([
      'coin.mp3',
      'purchaseQuest.mp3',
      'answerIncorrect.mp3',
      'diamondsIncrease.mp3',
      'intro.mp3'
    ]);
  }

   void playSound({@required String path, bool loop = false}) {
    !loop ? player.play(path) :
    player.loop(path);
  }

  
}