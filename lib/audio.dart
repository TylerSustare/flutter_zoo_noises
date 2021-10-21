import 'dart:io';
import 'package:audioplayers/audioplayers.dart';

class Audio {
  static Future<void> play({required String animalName}) {
    if (Platform.isAndroid || Platform.isIOS) {
      return _playMobileAudio(animalName: animalName);
    }
    return _playAudio(animalName: animalName);
  }

  static Future<void> _playMobileAudio({required String animalName}) {
    if (animalName.contains('dragon')) {
      var file = File('audio/dragon.mp3');
      return AudioCache().play(file.path);
    }
    var file = File('audio/$animalName.mp3');
    return AudioCache().play(file.path);
  }

  static Future<void> _playAudio({required String animalName}) {
    if (animalName.contains('dragon')) {
      var file = File('audio/dragon.mp3');
      return AudioPlayer().play(file.path, isLocal: true);
    }
    var file = File('audio/$animalName.mp3');
    return AudioPlayer().play(file.path, isLocal: true);
  }
}
