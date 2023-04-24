import 'package:malango_pod/models/episode.dart';

class PlayerPositionModel {
  Duration position;
  Duration length;
  int percentage;
  Episode episode;
  bool buffering;

  PlayerPositionModel(this.position, this.length, this.percentage, this.episode, [this.buffering = false]);

}