import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


// C Major pentatonic scale
final scale = [48, 50, 52, 55, 57];

class PlayerInfo{
  static final int size = 8;
  static final double width = 400;
  static final double height = 400;
  static final double buttonWidth = 40;
  static final double buttonHeight = 40;

  static final int nSounds = 8;
  static final int nButtons = 8;
  
  static get divisionWidth => width / size;
  static get divisionHeight => height / size;

  static List<int> pianoNotes = List.generate(nSounds, (sound) {
  return scale[sound % 5] + 12 * (sound / 5).floor();
  });

  static List<int> drumNotes = List.generate(16, (sound) {
    return 36 + sound;
  });

  static List<Color> colors = [
    Colors.amber,
    Colors.orange,
    Colors.red,
    Colors.brown,
    Colors.redAccent,
    Colors.blue,
    Colors.blueGrey,
    Colors.blueAccent,
    Colors.teal,
    Colors.deepPurple,
    Colors.green,
    Colors.purpleAccent,
    Colors.pink,
    Colors.indigo,
    Colors.pinkAccent,
    Colors.indigoAccent
  ];

  static Map<int, String> samples = const {
    0: 'Deep Kick',
    1: 'Rim Shot',
    2: 'Snare 1',
    3: 'Hand Clap',
    4: 'Snare 2',
    5: 'Low Tom 1',
    6: 'Closed Hi-Hat',
    7: 'Low Tom 2',
    8: 'Pedal Hi-Hat',
    9: 'Medium Tom 1',
    10: 'Open Hi-Hat',
    11: 'Medium Tom 2',
    12: 'High Tom 1',
    13: 'Crash Cymbal',
    14: 'High Tom 2',
    15: 'Ride Cymbal',
  };

  static Map<int, String> sounds = const {
    0: 'Piano',
    1: 'Synth',
    2: 'Square',
    3: 'Pulse',
    4: 'Saw',
    5: 'Beeper',
  };
}
