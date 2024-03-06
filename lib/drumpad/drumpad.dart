// Code snippet adapted from flutter-drum-machine-demo
// Link: https://github.com/kenreilly/flutter-drum-machine-demo
// Author: Kenneth Reilly
// License: MIT License

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soundfont_player/drumpad/pad.dart';
import 'package:soundfont_player/player_info.dart';
import 'package:soundfont_player/player_state.dart';

class DrumPad extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    //double padBankHeight = (size.height / 3 );
    double padHeight = size.height / 9;
    double padWidth = size.width / 2;
    var isDarkmode = Theme.of(context).brightness == Brightness.dark;

    return Consumer<PlayerState>(builder: (context, player, child) {
      return Container(
          color: (isDarkmode)
              ? Theme.of(context).focusColor
              : Colors.white, //Colors.black38,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List<Widget>.generate(
                  8,
                  (i) => Padding(
                      padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List<Widget>.generate(
                              2,
                              (j) => Pad(
                                    height: padHeight,
                                    width: padWidth,
                                    value: 2 * i + j,
                                    onTapDown: (details) {
                                      player.playNote(
                                          PlayerInfo.drumNotes[2 * i + j]);
                                    },
                                  )))))));
    });
  }
}
