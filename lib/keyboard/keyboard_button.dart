import 'package:flutter/material.dart';
import 'package:soundfont_player/player_info.dart';
import 'package:provider/provider.dart';
import 'package:soundfont_player/player_state.dart';

class KeyboardButton extends StatelessWidget {
  final int value;

  const KeyboardButton(this.value);

  String get name => PlayerInfo.sounds[value];

  @override
  Widget build(BuildContext context) {
    return Consumer<PlayerState>(builder: (context, player, child) {
      return ElevatedButton(
        onPressed: () {
          player.setPiano("assets/" + name + ".sf2");
        },
        child: FittedBox(
            fit: BoxFit.contain, child: Text(name)),
        style: ElevatedButton.styleFrom(
          backgroundColor: (player.piano == name)
              ? Colors.blue.withOpacity(0.5)
              : Colors.blue,
          fixedSize: Size(60.0, 40.0),
        ),
      );
    });
  }
}
